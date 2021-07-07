class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  # creates the Students table
  # heredoc to set sql variable equal to SQL statement
  # execute method executes the SQL query
  def self.create_table
    sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade TEXT
        )
        SQL
    DB[:conn].execute(sql) 
  end

  # drops the Students table
  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  # saves attributes describing 
  # a given student to the students table in database
  # grab the ID of the last inserted row 
  # (i.e the newly created row)
  # and assign it to be the value of the @id attribute
  def save
    sql = <<-SQL
    INSERT INTO students (name,grade)
    VALUES (?,?)
    SQL
    DB[:conn].execute(sql,self.name,self.grade)
    @id = DB[:conn].execute(
      "SELECT last_insert_rowid() FROM students")[0][0]
  end

  # this class method does the following:
  # 1. instantiate a new Student object with name,grade
  # 2. save that new student object via student.save
  # 3. the create method returns the student object it creates
  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
end








  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

