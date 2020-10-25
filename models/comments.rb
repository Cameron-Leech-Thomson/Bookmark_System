require 'sqlite3'

module Comment

    DB = SQLite3::Database.new '../models/bookmark_project.sqlite'

    # Create a new entry:
    def Comment.new(comment,user,bookmarkID)
        result = false
        query = "INSERT INTO comments (comment_body,created_by,bookmark_id) VALUES (?,?,?);"
        begin
          DB.execute query,comment,user,bookmarkID
          result = true
          rescue SQLite3::ConstraintException
        end
        return result
    end

    def Comment.all()
        query = 'SELECT * FROM comments;'
        result = DB.execute query
        return result
      end
    
      
    # Find all the comments related to a bookmark
    def Comment.findRelatedComments(bid)
        result = []
        query = 'SELECT comment_id FROM comments WHERE bookmark_id IS ?'
        rows = DB.execute query, bid
        rows.each do |row|
            result.push(row[0])
        end
        return result
    end
    
    # Find comment body by id:
    def Comment.findName(cid)
        result = []
        query = 'SELECT * FROM comments WHERE comment_id = ?'
        rows = DB.execute query, cid
        if rows.length != 0
            rows.each do |row|
                result.push({
                    comment_id: row[0],
                    bookmark_id: row[1],
                    comment_body: row[2],
                    created_by: row[3]
                    })
            end
        end
        return result
     end
    
    # Format result from search:
    def Comment.formatResult(comment) 
        commentBody = ""
        userName = ""
        
        # Make sure comment is a string (avoids a headache):
        comment = comment.join("")
        
        # Get the starting & ending indexes of the body:
        startBody = comment.index("comment_body") + 15
        endBody = comment.index("created_by") - 5
        
        # Set commentBody to the correct content:
        commentBody = comment[startBody..endBody]
        
        # Get the starting & ending indexes of the userName:
        startUser = comment.index("created_by") + 12
        endUser = comment.length - 2
        
        # Set the userName to the correct content:
        userName = comment[startUser..endUser]
        userName = User.findName(userName.to_i)
        
        outString = userName + ": " + commentBody
        
        return outString
    end

    # Delete a comment.
    def Comment.delete(id)
        query = "DELETE FROM comments WHERE comment_id IS ?;"
        begin
            DB.execute query, id
            result = true
            rescue SQLite3::ConstraintException
        end
        return result
    end

end