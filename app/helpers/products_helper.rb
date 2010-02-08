module ProductsHelper
  # returns the formatted change in price (from the master price) for the specified variant (or simply return
  # the variant price if no master price was supplied)
  def variant_price_diff(variant)
    return product_price(variant) unless variant.priced && variant.product.master.price
    diff = product_price(variant, :format_as_currency => false) - product_price(variant.product, :format_as_currency => false)
    return nil if diff == 0
    if diff > 0
      "(#{t("add")}: #{format_price diff.abs})"
    else
      "(#{t("subtract")}: #{format_price diff.abs})"
    end
  end

  # returns the price of the product to show for display purposes
  def product_price(product_or_variant, options={})
    options.assert_valid_keys(:format_as_currency, :show_vat_text, :currency)
    options.reverse_merge! :format_as_currency => true, :show_vat_text => Spree::Config[:show_price_inc_vat]

    if session.key? :currency
      @currency = Currency.find(:first, :conditions => {:code => session[:currency]})
    else

      if session.key? :locale
        @locale ||= Locale.find(:first, :include => :currencies, :conditions => {:code => session[:locale]})
        @currency = @locale.currencies.first
      else
        @currency ||= Currency.find(:first, :conditions => {:default => true})
      end
    end

    options.reverse_merge!  :format_as_currency => true,
                            :show_vat_text => Spree::Config[:show_price_inc_vat],
                            :currency => @currency

    if product_or_variant.is_a? LineItem
      amount = product_or_variant.price
    else
      amount = product_or_variant.price(options[:currency])
      return t('not_priced') unless product_or_variant.priced
    end

    amount += Calculator::Vat.calculate_tax_on(product_or_variant) if options[:show_price_inc_vat]
    options.delete(:format_as_currency) ? format_price(amount, options) : ("%0.2f" % amount).to_f
  end

  def format_price(price, options={})
    options.assert_valid_keys(:show_vat_text, :currency)

    if session.key? :currency
      @currrency = Currency.find(:first, :conditions => {:code => session[:currency]})
    else
      if session.key? :locale
        @locale ||= Locale.find(:first, :include => :currencies, :conditions => {:code => session[:locale]})
        @currrency = @locale.currencies.first
      else
        @currrency ||= Currency.find(:first, :conditions => {:default => true})
      end
    end

    options.reverse_merge!  :show_vat_text => Spree::Config[:show_price_inc_vat],
                            :currency => @default_currency

    formatted_price = number_to_currency(price, :currency => options[:currency])

    if options[:show_vat_text]
      I18n.t(:price_with_vat_included, :price => formatted_price)
    else
      formatted_price
    end
  end

  # converts line breaks in product description into <p> tags (for html display purposes)
  def product_description(product)
    product.description.gsub(/^(.*)$/, '<p>\1</p>')
  end

  # generates nested url to product based on supplied taxon
  def seo_url(taxon, product = nil)
    return '/t/' + taxon.permalink if product.nil?
    warn "DEPRECATION: the /t/taxon-permalink/p/product-permalink urls are "+
      "not used anymore. Use product_url instead. (called from #{caller[0]})"
    return product_url(product)
  end

  # Generate taxon breadcrumbs for searching related products
  def taxon_crumbs(taxon, separator="&nbsp;&raquo;&nbsp;")
    crumbs = []

    crumbs << taxon.ancestors.collect { |ancestor|
      content_tag(:li, link_to(ancestor.name , seo_url(ancestor)) + separator)
    } unless taxon.ancestors.empty?

    crumbs << content_tag(:li, link_to(taxon.name , seo_url(taxon)))
    crumb_list = content_tag(:ul, crumbs)
    content_tag(:div, crumb_list + content_tag(:br, nil, :class => 'clear'), :class => 'breadcrumbs')
  end
end
