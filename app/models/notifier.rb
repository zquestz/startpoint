class Notifier < ActionMailer::Base
  helper :application
  
  def password_reset_instructions(user)
    subject      Setting.app_name + ' - ' + t(:password_reset_instructions)
    from         Setting.mailer_email
    recipients   user.email
    content_type 'text/html'
    sent_on      Time.now
    body         :edit_password_reset_url => edit_password_reset_url(user.perishable_token, :host => Setting.hostname)
  end
  
  def activation_instructions(user)
    subject       Setting.app_name + ' - ' + t(:activation_instructions)
    from          Setting.mailer_email
    recipients    user.email
    content_type 'text/html'
    sent_on       Time.now
    body          :account_activation_url => activate_url(user.perishable_token, :host => Setting.hostname)
  end

  def welcome(user)
    subject       I18n.translate(:welcome_email_subject, :app_name => Setting.app_name)
    from          Setting.mailer_email
    recipients    user.email
    content_type 'text/html'
    sent_on       Time.now
    body          :root_url => root_url(:host => Setting.hostname)
  end
  
  def contact_email(contact)
    subject       t(:contact_message_subject) + " - #{Setting.app_name}"
    from          Setting.mailer_email
    recipients    Setting.support_email
    content_type 'text/html'
    sent_on       Time.now
    body          :contact => contact
  end
end