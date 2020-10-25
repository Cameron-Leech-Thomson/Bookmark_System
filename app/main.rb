require 'sinatra'
require 'sinatra/reloader'

##############  Settings for the sinatra  ##################
set :bind, '0.0.0.0'
enable :sessions  # enable cookie based sessions
set :views, settings.root + '/../views' # Change the default views setting, set it to the correct position
set :public_folder, settings.views + '/public'

#######################  Basic setup before every HTTP request  #####################
before do
end

##############  Relative file  ##################
require_relative './index.rb'
require_relative './user.rb'
require_relative './error_handling.rb'



