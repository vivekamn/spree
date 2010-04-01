class OrderMailer < ActionMailer::QueueMailer
  helper "spree/base"
  default_url_options[:host] = Spree::Config[:site_url]
  @url= default_url_options[:host]
  def confirm(order, resend = false)
    @subject    = (resend ? "[RESEND] " : "") 
    @subject    += 'Thanks for your order at Masthi Deals'
    @body       = {"order" => order}
    @recipients = order.email
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
  end
  
  def placed(order, resend = false)
    @subject    = (resend ? "[RESEND] " : "") 
    @subject    += 'Thanks for your order at Masthi Deals'
    @body       = {"order" => order}
    @recipients = order.email
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
  end
  
  
  def cancel(order)
    @subject    = '[CANCEL]' + Spree::Config[:site_name] + ' Order Confirmation #' + order.number
    @body       = {"order" => order}
    @recipients = order.email
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
  end  
  
  def credit_owed(order)
    @subject = Spree::Config[:site_name] + 'Order cancelled and amount not debited' + order.number
    @body = {"order" => order}
    @recipients = order.email
    @from       = Spree::Config[:order_from]
    @bcc        = order_bcc
    @sent_on    = Time.now
  end
  
  private
  def order_bcc
      bcc = [Spree::Config[:order_bcc] || "", Spree::Config[:mail_bcc] || ""]
      bcc = bcc.inject([]){|array, config_string| array + config_string.split(",")}
      bcc = bcc.collect{|email| email.strip}
      bcc = bcc.uniq
      bcc
  end
end
