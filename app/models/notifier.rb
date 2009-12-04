class Notifier < ActionMailer::Base
  default_url_options[:host] = "localhost"
  smtp_settings = { :enable_starttls_auto => false }
  delivery_method = :smtp

  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          EMAIL_FROM
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
    headers       'Precedence' => 'bulk'
  end

  def invitation_to_judge(u, s, i)
    subject       "Invitation to judge"
    from          EMAIL_FROM
    recipients    i.email
    sent_on       Time.now
    headers       'Precedence' => 'bulk'
    body          :user => u, :section => s, :invite => i
  end

  def acceptance_to_judge(u, name, competition)
    subject       u.name + ' has accepted to judge ' + name
    from          EMAIL_FROM
    recipients    competition.user.email
    sent_on       Time.now
    headers       'Precedence' => 'bulk'
    body          :name => name, :u => u
  end

  def refusal_to_judge(email, name, competition)
    subject       email + ' has refused to judge ' + name
    from          EMAIL_FROM
    recipients    competition.user.email
    sent_on       Time.now
    headers       'Precedence' => 'bulk'
    body          :name => name, :email => email
  end
end
