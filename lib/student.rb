require 'pry'

# This class is responsible for interfacing with the student roster database and manipulating models.
class Student
  attr_accessor :id, :name, :grade

  def initialize(attributes = [])
    @id = attributes[0]
    @name = attributes[1]
    @grade = attributes[2]
  end

  def self.new_from_db(row)
    Student.new(row)
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students;
    SQL
    studArray = DB[:conn].execute(sql)
    studArray.map { |studbus| new_from_db(studbus) }
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?;
    SQL
    dbInfo = DB[:conn].execute(sql, name).flatten
    new_from_db(dbInfo)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    DB[:conn].execute(<<-SQL)
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
  end

  def self.drop_table
    sql = 'DROP TABLE IF EXISTS students'
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?;
    SQL
    DB[:conn].execute(sql, "9")
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students WHERE NOT grade = ?;
    SQL
    DB[:conn].execute(sql, "12")
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = "10" LIMIT ?;
    SQL
    DB[:conn].execute(sql, num)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students WHERE grade = "10" LIMIT 1;
    SQL
    Student.new_from_db(DB[:conn].execute(sql).flatten)
  end

  def self.all_students_in_grade_X(num)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?;
    SQL
    DB[:conn].execute(sql, num.to_s)
  end
end
