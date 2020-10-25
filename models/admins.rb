require 'sqlite3'

module Admin

    DB = SQLite3::Database.new '../models/bookmark_project.sqlite'

    # Create new entry:
    def Admin.newAdmin(id)
        query = "INSERT INTO admin (user_id) VALUES (?);"
        begin
            DB.execute query,id
            result = true
        rescue SQLite3::ContraintException
        end
        return result
    end

    def Admin.all()
        query = 'SELECT * FROM admin;'
        result = DB.execute query
    end

    # Search function:
    def Admin.search(id) 
        query = "SELECT * FROM admin WHERE user_id = ?;"
        result = DB.execute query, id
        return result.join
      end

    # Delete an entry:
    def Admin.delete(id)
        query "DELETE FROM admin WHERE user_id = ?;"
        begin
            DB.execute query, id
            result = true
        rescue SQLite3::ContraintException
        end
    end
end