not_found do
  @title = '404'
  @message = 'You shouldn\'t be here!'
  erb :general_error
end

error do
  @title = 'Sorry, something went wrong!'
  @message = 'Please try again!'
  erb :general_error
end
