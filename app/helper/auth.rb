module AuthHelper

  # Redirect user to login page if not logged in.
  def auth_user
    put 'test'
    p session
  end
    
  # Returns true if the user is logged in, and false if not:
  def loginAuth
      if (session[:user] == nil)
          return false
      else 
          return true
      end
  end

end
