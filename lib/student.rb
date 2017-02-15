class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    all_rows = "SELECT * FROM students"
    DB[:conn].execute(all_rows).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
      name_search =
      "SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1"

      DB[:conn].execute(name_search, name).map do |row|
        self.new_from_db(row)
      end.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

   def self.count_all_students_in_grade_9
     grade_9_array = "SELECT * FROM students WHERE grade = '9'"
     DB[:conn].execute(grade_9_array)
   end

   def self.students_below_12th_grade
     below_twelve = "SELECT * FROM students WHERE grade != '12' "
     DB[:conn].execute(below_twelve)
   end

   def self.first_x_students_in_grade_10 (num)
     student_list = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
     DB[:conn].execute(student_list, num)
   end

  def self.first_student_in_grade_10
    first_student = "SELECT * FROM students WHERE grade = 10 ORDER BY id LIMIT 1"
    DB[:conn].execute(first_student).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_x (grade_num)
    student_list = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(student_list, grade_num)
  end

end
