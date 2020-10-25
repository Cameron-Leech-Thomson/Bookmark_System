require_relative './helper/auth.rb'
require_relative '../models/bookmarks.rb'
require_relative '../models/admins.rb'
require_relative '../models/comments.rb'
########################  Bookmarks  ##############################

# Home page
get '/' do
  @title = 'Bookmarks'
  erb :index
end

# Search result
get '/s' do
  @title = 'Search result'
  erb :search_result
end

# Create bookmark
get '/create_bookmark' do
  if session[:user] == nil
    redirect '/loginrequired'
  end
  #AuthHelper.auth_user
  @title = 'Create bookmark'
  @css = ['create_bookmark']
  erb :create_bookmark
end

get '/loginrequired' do
  erb :not_logged_in
end

post '/create_bookmark' do
  #AuthHelper.auth_user
  if session[:user].nil? then redirect '/loginrequired' end
  @title = params[:title]
  pub = params[:pub].nil? ? 1:0;
  tags = params[:tags].split(",");
  create_tags = params[:createTags].split(",")
  convertedURL = urlConversion(params[:url])     
  
  if Bookmark.findBookmark(convertedURL) != Bookmark.findBookmark("bhvsbheijvb.....kvugbfsivbdndkv,svdjmdbfufdkdsm")
    redirect '/duplicate_bookmark'
  end 
      
  result = Bookmark.newBookmark(params[:title],params[:description],session[:user][:id],convertedURL,params[:pub].to_i,tags,create_tags)
  if result 
    @title = 'Success!'
    @message = 'Created your bookmark'
    erb :success
  else 
    @title = 'Failed to create bookmark'
    @message = 'Sorry, something went wrong'
    erb :create_bookmark
  end
end

# Used in above page ^
# Removes the https:// before storing url in database
def urlConversion(userInput)
  userInput = userInput.downcase
  if userInput[0..7] == "https://"
    return userInput[8..(userInput.length - 1)]
  elsif userInput[0..6] == "http://"
    return userInput[7..(userInput.length - 1)]
  else 
    return userInput
  end
end

# Bookmark details
get '/details' do
  # Get the bookmark details from database
  @bookmark = Bookmark.getBookmark(params[:id])[0]
  @css = [ 'bookmark_detail' ]
  @title = @bookmark[:title]
  erb :bookmark_details
end

# Update details when a new comment is added:
post '/details' do
    # Get the bookmark details from the database:
    @bookmark = Bookmark.getBookmark(params[:bookmarkID])[0]
    @css = [ 'bookmark_detail' ]
    
    # Make sure the user is logged in:
    if session[:user] == nil
        redirect '/loginrequired'
    end
    
    # Add the comment and attribute it to the bookmark:
    result = Comment.new(params[:comment],session[:user][:id],@bookmark[:id])
    if result
        @title = 'Success!'
        @message = 'added your comment.'
        erb :success
    else 
        @title = 'Failed to add comment.'
        @message = 'sorry, something went wrong!'
        erb :general_error
    end
end

# Employee details
get '/employees' do
    @title = 'Users'
    if session[:user] == nil
      redirect '/loginrequired'
    else
        if session[:user][:admin] == true
          erb :admin
        else
          redirect '/adminrequired'
        end
    end  
end

# Delete a bookmark
get '/delete_bookmark' do
  # Make sure the user is logged in.
  if session[:user] == nil
    redirect '/adminrequired'
  end 

  # Make sure the user is an admin.
  result = Admin.search(session[:user][:id])
  if result == ''
    redirect '/adminrequired'
  end    

  # Run the delete function.
  result = Bookmark.delete(params[:id])
  if result
    @title = 'Success!'
    @message = 'deleted the bookmark.'
    erb :success
  else 
    @message = 'Sorry, something went wrong. We could not delete the bookmark.'
    erb :bookmark_details
  end
end

# Update bookmark
get '/update_bookmark' do
  if session[:user] == nil
    redirect '/loginrequired'
  end
  @bookmark = Bookmark.getBookmark(params[:id])[0]
  if session[:user][:id] !=  @bookmark[:created_by]
    @title = 'You cannot perform such action!'
    @message = 'You cannot modify other\'s profile!'
    erb :general_error
  else
    #AuthHelper.auth_user
    @title = 'Update bookmark'
    @css = [ 'create_bookmark' ]
    erb :update_bookmark
  end
end 

post '/update_bookmark' do
  # Make sure the user is an admin or the user that created the bookmark
  if session[:user].nil? then redirect '/loginrequired' end
  @bookmark = Bookmark.getBookmark(params[:id])
  if @bookmark.length == 0
    @title = 'No such bookmark'
    @message = 'Sorry, cannot find the bookmark.'
    erb :general_error
  else
    @bookmark = @bookmark[0]
    if session[:user][:id] !=  @bookmark[:created_by]
      @title = 'You cannot perform such action!'
      @message = 'You cannot modify other\'s profile!'
      erb :general_error
    else
      pub = params[:pub].nil? ? 1:0;
      tags = params[:tags].split(",");
      create_tags = params[:createTags].split(",")
      result = Bookmark.updateBookmark(params[:id],params[:title],urlConversion(params[:url]),params[:description],pub,tags,create_tags)
      if result
        @title = 'Success!'
        @message = 'Updated this bookmark'
        erb :success
      else 
        @title = 'Failed to update bookmark'
        @message = 'Sorry, something went wrong'
        erb :update_bookmark
      end
    end
  end
end
    
get '/delete_comment' do
    # Get the comment's details from the database:
    @comment = Comment.findName(params[:id])[0]
    
    # Make sure the user is logged in:
    if session[:user] == nil
        redirect '/loginrequired'
    end
    
    # Make sure the user is the author of the comment, or an admin:
    if (session[:user][:id] != @comment[:created_by]) && (Admin.search(session[:user][:id]) == '')
        redirect '/loginrequired'
    end
    
    # Run the delete function:
    result = Comment.delete(params[:id])
    if result
        @title = 'Success!'
        @message = 'deleted the comment.'
        erb :success
    else
        @message = 'Sorry, something went wrong. We could not delete the comment.'
        erb :bookmark_details
    end 
end

get '/adminrequired' do
  erb :adminrequired
end

get '/confirmDelete' do
  @bookmark = Bookmark.getBookmark(params[:id])[0]
  erb :confirmDelete
end

get '/deleteComment' do 
    @comment = Comment.findName(params[:id])[0]
    erb :deleteComment
end 

get '/duplicate_bookmark' do
    @title = 'Failed to create bookmark.'
    @message = 'Duplicate URL: To save database memory, duplicates are not allowed. Please try another.'
    erb :general_error
end

