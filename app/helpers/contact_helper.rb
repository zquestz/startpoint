module ContactHelper
  
  # Get the contact name, if they are logged in autofill it for them.
  def get_contact_name
    if params['contact'] 
      return params['contact'][:name] 
    else
      return (current_user ? "#{current_user.first_name} #{current_user.last_name}" : '')
    end
  end
  
  # Get the contact email, if they are logged in autofil it for them.
  def get_contact_email
    if params['contact'] 
      return params['contact'][:email] 
    else
      return (current_user ? current_user.email : '')
    end
  end

end
