class User
  
  attr_accessor :id, :fname, :lname
  
  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
  
  def self.find_by_id(id)
    query = <<-SQL
    SELECT 
      *
    FROM 
      users
    WHERE
      users.id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, id)
    results.map{ |hash| User.new hash }.first
  end
  
  def self.find_by_name(fname, lname)
    query = <<-SQL
    SELECT 
      *
    FROM 
      users
    WHERE users.fname = ? AND users.lname = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, fname, lname)
    results.map{ |hash| User.new hash }.first
  end
  
  def authored_questions
    Question.find_by_author(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
  
  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
  
  def average_karma
    query = <<-SQL
    SELECT CAST(COUNT(DISTINCT(questions.id)) AS FLOAT), 
    COUNT(question_likes.id)
    FROM questions
    LEFT OUTER JOIN question_likes 
    ON questions.id = question_likes.question_id 
    WHERE questions.author_id = ? 
    SQL
    result = QuestionsDatabase.instance.execute(query, @id)
    total_questions_asked = result.first.values[0]
    total_number_likes = result.first.values[1]
    total_number_likes / total_questions_asked
  end
  
  def save
    if @id.nil?
      insert = <<-SQL
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
      SQL
      QuestionsDatabase.instance.execute(insert, @fname, @lname)
      @id = QuestionsDatabase.instance.last_insert_row_id 
    else
      update = <<-SQL
      UPDATE
        users 
      SET
        fname = ?, lname = ?  
      WHERE 
       users.id = ?
        
      SQL
      QuestionsDatabase.instance.execute(update, @fname, @lname, @id)
    end
  end
  
end

