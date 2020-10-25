require 'sqlite3'

module Rating

    DB = SQLite3::Database.new '../models/bookmark_project.sqlite'

    def Rating.new(bookmark,upvotes,downvotes,rating)
        query = "INSERT INTO ratings VALUES (?,?,?,?);"
        begin
            DB.execute query,bookmark,upvotes,downvotes,rating
            result = true
        rescue SQLite3::ConstraintException
        return result
    end

    def Rating.all()
        query = 'SELECT * FROM ratings;'
        result = DB.execute query
        return result
      end

    def Rating.search(searchTerm, via)
        query = "SELECT * FROM ratings WHERE ? LIKE ?;"
        result = DB.execute query, via, searchTerm
        return result
    end

    def Rating.findID(search)
        result = this.search(search,bookmark)
        return result
    end

    def Rating.findUpvotes(search)
        result = this.search(search,upvotes)
        return result
    end

    def Rating.findDownvotes(search)
        result = this.search(search,downvotes)
        return result
    end

    def Rating.findAvgRating(search)
        result = this.search(search,rating)
    end

    def Rating.delete(id)
        query = "DELETE FROM ratings WHERE id = ?;"
        begin 
            DB.execute query, id
            result = true
            rescue SQLite3::ConstraintException
        end
        return result
    end
end