require 'sqlite3'

module Tag

  DB = SQLite3::Database.new '../models/bookmark_project.sqlite'

  # Create a new tag with name, return id
  def Tag.new(tag_name)
    addresult = false
    query = "INSERT INTO tag (tag_name) VALUES (?);"
    begin
      DB.execute query,tag_name
      addresult = true
    rescue SQLite3::ConstraintException
    end
    if addresult
      query = 'SELECT last_insert_rowid();'
      result = DB.execute query
    end
    return result
  end

  # Create multiple tags at one time
  def Tag.addBatch(list)
    result = []
    list.each do |tag_name|
       execute = false
      begin
        id = self.new(tag_name)
        execute = true
      end
      if execute
        result.push id
      end
    end
    return result
  end

  # Find all the tags related to a bookmark
  def Tag.findRelatedTags(bid)
    result = []
    query = 'SELECT tag_id FROM bookmark_tag WHERE bookmark_id IS ?'
    rows = DB.execute query, bid
    rows.each do |row|
      result.push(row[0])
    end
    return result
  end

  # Find tag name by id
  def Tag.findName(tid)
    result = ""
    query = 'SELECT tag_name FROM tag WHERE tag_id = ?'
    rows = DB.execute query, tid
    if rows.length != 0
      result = rows[0][0]
    end
    return result
  end

  def Tag.all()
    result = []
    query = 'SELECT * FROM tag;'
    rows = DB.execute query
    if rows.length != 0
      rows.each do | row |
        result.push({
        id: row[0],
        name: row[1]
      })
      end
    end
    return result
  end

=begin
  def Tag.search(searchTerm, via)
    query = "SELECT * FROM tags WHERE ? LIKE ?;"
    result = DB.execute query, via, searchTerm
    return result
  end

  def Tag.findID(search)
    result = this.search(search,id)
    return result
  end

  def Tag.findName(search)
    result = this.search(search,tag_name)
    return result
  end

  def Tag.findCreator(search)
    result = this.search(search,created_by)
    return result
  end
=end

  def Tag.delete(id)
    query = "DELETE FROM tags WHERE id = ?;"
    begin 
      DB.execute query, bid
      result = true
    rescue SQLite3::ConstraintException
    end
    return result
  end
end
