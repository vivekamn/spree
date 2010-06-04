class OrderMailer < ActionMailer::QueueMailer
  helper "spree/base"
  default_url_options[:host] = Spree::Config[:site_url]
  @url= default_url_options[:host]
  def confirm(order, resend = false)
    content_type "text/html"
    @subject    = (resend ? "[RESEND] " : "") 
    @subject    += 'Thanks for your order at Masthi Deals'
    @body       = {"order" => order , "url" => default_url_options[:host] }
    @recipients = order.email
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
  end
  
  def placed(order,user, resend = false)
    content_type "text/html"
    @subject    = (resend ? "[RESEND] " : "") 
    @subject    += 'Thanks for buying at Masthi Deals, Order Confirmation:' + order.number 
    @body       = {"order" => order,"user" => user, "url" => default_url_options[:host]}
    @recipients = order.email
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
  end
  
  
  def cancel(order)
    content_type "text/html"
    @subject    = '[CANCEL]' + Spree::Config[:site_name] + ' Order Confirmation #' + order.number
    @body       = {"order" => order}
    @recipients = order.email
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
  end  
  
  def credit_owed(order)
    content_type "text/html"
    @subject = Spree::Config[:site_name] + 'Order cancelled and amount not debited' + order.number
    @body = {"order" => order}
    @recipients = order.email
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
  end
  
  def voucher(order,product,recipients)
    content_type "text/html"
    @subject    = get_subject(order)
    @body       = {"product" => product,"order" => order}
    @recipients = recipients
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
  end
  
    def gift_voucher(order,product)
    content_type "text/html"
    @subject    = 'Voucher For your Deal at Masthi Deals'
    @body       = {"product" => product,"order" => order}
    @recipients = order.giftee_email
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
  end

  def gift_notification(order, product, variant)
    content_type "text/html"
    @subject    = "#{ order.bill_address.name } has sent you a nice gift"
    @body       = {"product" => product,"order" => order, "variant" => variant}
    @recipients = order.giftee_email
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
  end
  
  
  def notify_admin(product)
    content_type "text/html"
    @subject    = 'Masthideals: Minimum Number Reached for #{ product.name }'
    @body       = {"product" => product}
    @recipients = 'akvsaran@gmail.com'
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
  end
  
  private
  def get_subject(order)
    if order.gift?
      "Gift sent to #{order.giftee_name}"
    else
      'Voucher For your Deal at Masthi Deals'
    end
  end
  def order_bcc
      bcc = [Spree::Config[:order_bcc] || "", Spree::Config[:mail_bcc] || ""]
      bcc = bcc.inject([]){|array, config_string| array + config_string.split(",")}
      bcc = bcc.collect{|email| email.strip}
      bcc = bcc.uniq
      bcc
  end
end
