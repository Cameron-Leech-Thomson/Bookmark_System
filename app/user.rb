require_relative '../models/user.rb'
require_relative '../models/admins.rb'

#################  Duplicate Email Error  ##############
get '/general_error' do
    @title = 'Failed to Create User'
    @message = 'Email already in use, please try another valid email address.'
    erb :general_error
end

#################  Create User  ##############
get '/new_user' do
  @title = 'New User'
  @css = [ 'login' ]
  erb :new_user
end

post '/new_user' do

  if User.findUser(params[:em]) != User.findUser("...nnxichasc.chjdbhc..cnacndj.cdnamklcd....")
    # Let the user know that their email is already in use:  
    redirect '/general_error'
  end

  result = User.newUser(params[:fname],params[:lname],params[:dp],params[:suspended],params[:em],params[:date_joined],params[:pwd])

  if result
    @title = 'Success!'
    @message = 'created your account!<br><a href="/">Go back to homepage</a>'
    id = User.findUser(params[:em])
    session[:user] = { :id => id, :name => params[:fname] + " " + params[:lname] }
    erb :success
  else
    @title = 'Failed to create user'
    @message = "Sorry, something went wrong!"
    @css = [ 'login' ]
    erb :new_user
  end
end

#################  Login  ################
get '/login' do
  @title = 'Login'
  @css = [ 'login' ]
  erb :login 
end

post '/login' do
  @email = params[:em]
  @password = params[:pwd]
  @user = User.findUser @email
  @message = 'Sorry, wrong email or password.'
  @title = 'Login'
  @css = [ 'login' ]
  if (@user.length == 1 && User.validId(@user[0][:user_id], @password))
    if (Admin.search @user[0][:user_id] ).length == 1
        session[:admin] = true 
    end
    session[:user] = { :id => @user[0][:user_id], :name => User.findName(@user[0][:user_id]) }
    if ( Admin.search(session[:user][:id]) != '')
      session[:user][:admin] = true
    else
      session[:user][:admin] = false
    end
    redirect '/'
  else
    erb :login
  end
end

####################  Logout  #################
get '/logout' do
  session.clear
  redirect '/'
end


#################  Change password  ###########

get '/change_password' do
  # Check if user is logged in
  if session[:user] == nil
    @title = "Haven't login!"
    erb :not_logged_in
  else
    @title = 'Change password'
    erb :change_password
  end
end

post '/change_password' do
  @new_pwd1 = params[:new_pwd1]
  @new_pwd2 = params[:new_pwd2]

  # Check if the user type in the same password
  if !@new_pwd1.eql?@new_pwd2
    @message = 'The new passwords are different! Please try again.'
    @title = 'Change password'
    erb :change_password
  else
    @user_id = session[:user][:id]
    @old_pwd = params[:old_pwd]
    # Check if user type in the corrent old password
    if User.validId(@user_id, @old_pwd)
      # If the password is correct update password
      if User.updatePwd(@user_id, @new_pwd1)
        @message = 'changed the password.'
        @title = 'Success!'
        erb :success
      else
        erb :general_error
      end
    else
      @message = 'You type in the wrong password! Please check again.'
      @title = 'Change password'
      erb :change_password
    end
  end
end

###########  User Profile  #############

### Display profile ###
get '/profile' do
  if session[:user].nil? then redirect '/loginrequired' end
  erb :user_detail
end

### Update profile ###
get '/update_profile' do
  # Error page if the logged in user and update user not the same
  if session[:user].nil?
    redirect '/loginrequired'
  elsif session[:user][:id].to_i == params[:uid].to_i
    erb :update_profile
  elsif  session[:user][:admin] == true
    erb :update_profile_admin
  elsif session[:user][:id].to_i != params[:uid].to_i
    @title = 'You cannot perform such action!'
    @message = 'You cannot modify other\'s profile!'
    erb :general_error
  end
end

post '/update_profile' do
  if session[:user].nil?
    redirect '/loginrequired'
  elsif session[:user][:id].to_i == params[:uid].to_i
    @fname = params[:fname]
    @lname = params[:lname]
    @department = params[:department]
    @email = params[:em]
    @suspended = params[:suspended]==nil ? 0 : 1
    result = User.updateDetail(params[:uid],@fname,@lname,@department,@email,@suspended)
    if result
      @message = 'updated the profile!'
      # update info in session
      session[:user][:name] = User.findName(session[:user][:id])
      erb :success
    else
      @title = 'Something\'s wrong!'
      @message = 'Please try again.'
      erb :general_error
    end
  elsif session[:user][:admin] == true
    @fname = params[:fname]
    @lname = params[:lname]
    @department = params[:department]
    @email = params[:em]
    @suspended = params[:suspended]==nil ? 0 : 1
    @admin= params[:admin]==nil ? 0 : 1
    result = User.updateDetail(params[:uid],@fname,@lname,@department,@email,@suspended)
    if @admin == 1
      adminresult = Admin.newAdmin(params[:uid])
    end
    if result
      @message = 'updated the profile!'
      # update info in session
      session[:user][:name] = User.findName(session[:user][:id])
      erb :success
    else
      @title = 'Something\'s wrong!'
      @message = 'Please try again.'
      erb :general_error
    end
  elsif session[:user][:id].to_i != params[:uid].to_i
    @title = 'You cannot perform such action!'
    @message = 'You cannot modify other\'s profile!'
    erb :general_error
  end
end


############## Favourite bookmark ##############
get '/favourite' do
  #Make sure user is logged in
  if session[:user].nil?
    redirect '/loginrequired'
  else
    @title = 'My favourite'
    erb :favorite
  end
end

post '/favorite' do
  if session[:user].nil?
    redirect '/loginrequired'
  else
    #Add favorite with reference to user and bookmark
    result = User.toggleFavorite(session[:user][:id],params[:bid])
    if result
      redirect '/'
    else
      @title = 'Failed to favorite.'
      @message = 'Please try again!'
      erb :general_error
    end
  end
end
