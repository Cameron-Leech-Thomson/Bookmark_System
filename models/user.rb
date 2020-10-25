require 'sqlite3'
require 'bcrypt'
require_relative '../models/department_info.rb'

#= User
module User
  DB = SQLite3::Database.new '../models/bookmark_project.sqlite'

  # Query user_id using email, return user_id
  def User.findUser(email)
    result = []
    if email
      query = "SELECT user_id FROM user_email WHERE email IS ?;" # Question mark means that the variable we will use will be specified below
      rows = DB.execute query, email
      rows.each do |row|
        result.push({user_id: row[0]})
      end
    end
    return result
  end

    # Find user email from id
    def User.findEmail(id)
      result = []
      if id
        query = "SELECT email FROM user_email WHERE user_id IS ?;" 
        rows = DB.execute query, id
        rows.each do |row|
          result.push({email: row[0]})
        end
      end
      return result
    end

    # Query user password using user_id
    def User.validId(id,password)
      result = false
      if ( id )
        query = "SELECT password FROM user_password WHERE user_id IS ?;"
        rows = DB.execute query, id
        if (rows.length == 1)
          hash_check = BCrypt::Password.new(rows[0][0])
          result = hash_check.is_password?(password)
        end
        return result
      end
    end

    # Query user name using user_id
    def User.findName(id)
      query = 'SELECT firstname,lastname FROM user WHERE user_id = ?;'
      result = DB.execute query, id
      if result.length == 1
        return "#{result[0][0]} #{result[0][1]}"
      else return 'User not found'
      end
    end

    # Valid user using email and password
    def User.validUser(email,password)
      users = findUser email
      return false if users.length != 1
      return true if validId(users[:user_id],password) 
      return false
    end

    # Create new password
    def User.newPassword(id, password)
      result = false
      query = "INSERT INTO user_password (user_id, password) VALUES (?, ?);"
      begin 
        DB.execute query, id,  BCrypt::Password.create(password)
        result = true
      rescue SQLite3::ConstraintException
        #  puts "Failed to insert"
      end
      return result
    end

    # Create new user
    def User.newUser(fname, lname, dp, suspended,em,date_joined,pwd)
      query = 'INSERT INTO user_email (user_id, email) VALUES ( NULL,? )'
      begin
        DB.execute query,em
      end
      users = findUser(em)
      return false if users.length != 1
      return false if !User.newPassword(users[0][:user_id],pwd)
      query = "INSERT INTO user (user_id,firstname,lastname,department,date_joined, suspended) VALUES (?,?,?,?,?,?);"
      begin
        DB.execute query, users[0][:user_id],fname, lname, dp, date_joined, suspended
        result = true
      rescue SQLite3::ConstraintException

      end
      return result
    end

    #  Find all user entries, order by date joined
    def User.selectAll(page)
      result = []
      query = "SELECT * FROM user ORDER BY date_joined DESC LIMIT 20 OFFSET #{ (page.to_i-1)*20 }"
      db = SQLite3::Database.new '../models/bookmark_project.sqlite'
      rows = db.execute query
      rows.each do |row|
        result.push({
          user_id: row[0],
          firstname: row[1],
          lastname: row[2],
          em: row[3],
          date_joined: row[4],
          suspended: row[5]})
      end
      return result
    end

    # Count amount of users in the database
    def User.countUser
      query = 'SELECT COUNT(*) FROM user'
      num = DB.execute query
      return num[0][0]
    end

    # Update password
    def User.updatePwd(user_id,newPwd)
      result = false
      query = 'UPDATE user_password SET password = ? WHERE user_id IS ?'
      begin
        DB.execute query, BCrypt::Password.create(newPwd), user_id
        result = true
      rescue SQLite3::Exception

      end
      return result
    end

    # Find user details
    def User.findDetail(id)
      result = []
      if id
        query = "SELECT firstname,lastname,department,date_joined,suspended FROM user WHERE user_id IS ?" 
        rows = DB.execute query,id
        if rows.length == 1
          rows.each do |row|
            result.push({
              email: self.findEmail(id)[0][:email],
              firstname: row[0],
              lastname: row[1],
              department: Department.findName(row[2])[0][:department],
              date_joined: row[3],
              suspended: row[4]})
          end
        end
      end
      return result
    end

    # Update user detail
    def User.updateDetail(id,firstname,lastname,department,email,suspended)
      result = false
      if id
        query = 'UPDATE OR ABORT user SET (firstname, lastname, department, suspended) = (?,?,?,?) WHERE user_id IS ?'
        changeEmail = 'UPDATE OR ABORT user_email SET email = ? WHERE user_id IS ?'
        begin
          DB.execute query,firstname,lastname,department,suspended,id
          DB.execute changeEmail,email,id
          result = true
          # rescue SQLite3::ConstraintException
        end
      end
      return result
    end

    ###################  Favorite  ###################
    # List all the favorite bookmark id of specific user
    def User.listFavorite(user_id)
      query = 'SELECT bookmark_id FROM user_favorite WHERE user_id = ?'
      result = []
      rows = DB.execute query, user_id
      if rows.length != 0
        rows.each do |row|
          result.push(row[0])
        end
      end
      return result
    end

    # Add or delete favorite for a user
    def User.toggleFavorite(user_id,bookmark_id)
      result = false
      check = 'SELECT COUNT(*) FROM user_favorite WHERE user_id = ? AND bookmark_id = ?'
      #make sure user and bookmark ID are accessible
      if user_id && bookmark_id
        number = DB.execute(check,user_id,bookmark_id)[0][0]
        #If favorite is being added, adjust table
        if number.to_i == 0
          query = 'INSERT INTO user_favorite (user_id,bookmark_id) VALUES (?,?)'
        #If favorite is being deleted, adjust table
        elsif number.to_i == 1
          query = 'DELETE FROM user_favorite WHERE user_id = ? AND bookmark_id = ?'
        end
        begin
          DB.execute query,user_id,bookmark_id
          result = true
        end
      end
      return result
    end

    # List the bookmark detail of user favorite bookmark detail
    def User.listFavoriteDetail(user_id)
      result = []
      query = 'SELECT * FROM bookmark WHERE bookmark_id IN (SELECT bookmark_id FROM user_favorite WHERE user_id = ?);'
      rows = DB.execute query,user_id
      rows.each do |row|
        result.push({
          id: row[0],
          title: row[1],
          url: row[2],
          description: row[3],
          created_by: row[4],
          date_created: row[5],
          pub: row[6]})
      end
      return result
    end
end
