class QuestionFollower
  attr_accessor :id, :question_id, :user_id
  
  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    query = <<-SQL
    SELECT 
      *
    FROM 
      question_likes
    WHERE
      question_likes.id = ?
    SQL
 
    results = QuestionsDatabase.instance.execute(query, id)
    results.map{|hash| QuestionFollower.new hash }.first
  end
  
  def self.followers_for_question_id(question_id)
    query =<<-SQL
    SELECT 
      *
    FROM 
      question_followers 
    JOIN 
      users 
    ON 
      question_followers.user_id = users.id
    WHERE 
      question_followers.question_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, question_id)
    results.map{|hash| User.new hash }
  end
  
  def self.followed_questions_for_user_id(user_id)
    query =<<-SQL
    SELECT 
      *
    FROM 
      question_followers 
    JOIN 
      questions 
    ON 
      question_followers.question_id = questions.id
    WHERE 
      question_followers.user_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, user_id)
    results.map{|hash| Question.new hash }
  end
  
  def self.most_followed_questions(n)
    query =<<-SQL
    SELECT questions.*
    FROM question_followers 
    JOIN questions
    ON question_followers.question_id = questions.id
    GROUP BY questions.id
    ORDER BY COUNT(question_followers.id) DESC
    LIMIT ?
    SQL
    results = QuestionsDatabase.instance.execute(query, n)
    results.map{|hash| Question.new hash }
  end
  

end

