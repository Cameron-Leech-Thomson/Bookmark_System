require 'sqlite3'

#= Department
# A module used to retrieve data about department
module Department

    DB = SQLite3::Database.new '../models/bookmark_project.sqlite'

    # Find all the department
    def Department.allDepartment()
	query = 'SELECT * FROM department;'
	result = DB.execute query
	return result
    end

    # Find the name of the department by name
    def Department.findName(id)
      result = []
      query = 'SELECT department FROM department WHERE department_id = ?'
      rows = DB.execute query, id
      rows.each do | row |
        result.push({
        department: row[0]
      });
      end
      return result
    end
end
