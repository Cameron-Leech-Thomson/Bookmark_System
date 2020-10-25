require 'sqlite3'
require_relative '../models/user.rb'
require_relative '../models/tag.rb'

#= Bookmark
# A module used to retrieve data about bookmarks:
module Bookmark

  DB = SQLite3::Database.new '../models/bookmark_project.sqlite'

  # Find all the bookmarks:
  def Bookmark.all()
    query = 'SELECT * FROM bookmark;'
    result = DB.execute query
    return result
  end
  
  # Add a new bookmark:
  def Bookmark.newBookmark(btitle, bdescript, bcreated_by, burl, bpublic,tags,create_tags)
    query = "INSERT INTO bookmark (title, description, create_by, date_created, url, public) 
      VALUES (?,?,?,datetime('now'),?,?);"
    begin 
      if create_tags.length != 0
        tags += Tag.addBatch(create_tags)
      end
      DB.execute query, btitle, bdescript, bcreated_by, burl, bpublic
      query = 'SELECT last_insert_rowid()'
      bid = DB.execute query
      self.attachTags(bid,tags)
      result = true
      rescue SQLite3::ConstraintException
    end
    return result
  end

  # Associate a bookmark and tags
  def Bookmark.attachTags(bid,tids)
    result = false
    query = 'INSERT INTO bookmark_tag (bookmark_id,tag_id) VALUES (?,?);'
    begin
      tids.each do |tid|
      DB.execute query, bid,tid
      end
      result = true
    end
    return result
  end

  # Search for bookmark in both description and title
  def Bookmark.fuzzySearch(query)
    q2d = 'SELECT * FROM bookmark WHERE title LIKE ? OR description LIKE ? ORDER BY date_created DESC;' # LIMIT 20 OFFSET ?'
    query = '%'+query+'%'
    result = []
    rows = DB.execute q2d, query, query
    rows.each do |row|
      result.push({
        id: row[0],
        title: row[1],
        url: row[2],
        description: row[3],
        created_by: row[4],
        created_by_name: User.findName(row[4]),
        date_created: row[5],
        pub: row[6]})
    end
    return result;
  end

  # Query user_id using email, return user_id
  def Bookmark.findBookmark(url)
    result = []
    if url
      query = "SELECT bookmark_id FROM bookmark WHERE url IS ?;" # Question mark means that the variable we will use will be specified below
      rows = DB.execute query, url
      rows.each do |row|
        result.push({bookmark_id: row[0]})
      end
    end
    return result
  end

  # Search function:
  def Bookmark.search(searchTerm, via) 
    query = "SELECT * FROM bookmark WHERE ? LIKE ?;"
    result = DB.execute query, via, searchTerm
    return result
  end

  def Bookmark.findTitle(search)
    result = this.search(search,'title')
    return result
    end

    # Find bookmark by id
    def Bookmark.getBookmark(id)
      result = []
      query = 'SELECT * FROM bookmark WHERE bookmark_id IS ?'
        db = SQLite3::Database.new '../models/bookmark_project.sqlite'
        rows = db.execute query,id
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

    # Retrieve the most recent entries, with an argument restricting the range.
    # When the argument passed in is 1, the function will return the first 20 records, when
    # is 2, the 20th - 40th records will be returned.
    def Bookmark.selectRecent(page)
      result = []
      query = "SELECT * FROM bookmark ORDER BY date_created DESC LIMIT 20 OFFSET #{ (page.to_i-1)*20 }"
        db = SQLite3::Database.new '../models/bookmark_project.sqlite'
        rows = db.execute query
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

    # List bookmarks that belongs to specific user
    def Bookmark.selectUserBookmark(id)
      result = []
      query = "SELECT bookmark_id,title,date_created,public FROM bookmark WHERE create_by = ? ORDER BY date_created DESC"
        rows = DB.execute query, id
        rows.each do |row|
            result.push({
              id: row[0],
              title: row[1],
              date_created: row[2],
              pub: row[3]})
        end
        return result
    end


    # Count the total number of bookmarks in the database
    def Bookmark.countBookmark
      query = 'SELECT COUNT(*) FROM bookmark'
      db = SQLite3::Database.new '../models/bookmark_project.sqlite'
      num = db.execute query
      return num[0][0]
    end

  def Bookmark.findURL(search)
      result = this.search(search,'url')
      return result
  end

  def Bookmark.findDesc(search)
      result = this.search(search,'description')
      return result
  end

  def Bookmark.findCreatedBy(search)
      result = this.search(search,'create_by')
      return result
  end

  def Bookmark.findDate(search)
      result = this.search(search,'date_created')
      return result
  end

  def Bookmark.findTags(search)
      result = this.search(search,'tags')
      return result
  end
    
  # Delete a bookmark:   
  def Bookmark.delete(bid)
    query = "DELETE FROM bookmark WHERE bookmark_id IS ?;"
    begin 
        DB.execute query, bid
        result = true
        rescue SQLite3::ConstraintException
    end
    return result
  end  
  
  # Edit description:
  def Bookmark.updateBookmark(id,title,url,description,public,tags,create_tags)
    query = 'UPDATE bookmark SET title = ?, url = ?,description = ?, public = ? WHERE bookmark_id = ?;'
    begin 
      if create_tags.length != 0
        tags += Tag.addBatch(create_tags)
      end
      self.attachTags(id,tags)
      DB.execute query,title,url,description,public,id
      result = true
      rescue SQLite3::ConstraintException
    end
    return result
  end

  # Edit: Only Admins unless it's your own: To be left until iteration 2.
    
end
