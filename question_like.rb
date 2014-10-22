
class QuestionLike
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
    results.map{|hash| QuestionLike.new hash }.first
  end
  
  def self.likers_for_question_id(question_id)
    query =<<-SQL
    SELECT 
      users.*
    FROM 
      question_likes 
    JOIN 
      users 
    ON 
      question_likes.user_id = users.id
    WHERE 
      question_likes.question_id = ?
    SQL
    results = QuestionsDatabase.instance.execute(query, question_id)
    results.map{ |hash| User.new hash }
  end
  
  def self.num_likes_for_question_id(question_id)
    query =<<-SQL
    SELECT COUNT(question_id)
    FROM question_likes
    WHERE question_likes.question_id = ?
    SQL
    
    array_of_hash = QuestionsDatabase.instance.execute(query, question_id)
    array_of_hash.first.values[0]
  end
  
  def self.liked_questions_for_user_id(user_id)
    query =<<-SQL
    SELECT questions.*
    FROM question_likes
    JOIN questions ON questions.id = question_likes.question_id
    WHERE question_likes.user_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, user_id)
    results.map{ |hash| Question.new hash }
  end
  
  def self.most_liked_questions(n)
    
    query =<<-SQL
    SELECT 
      questions.*
    FROM 
      questions 
    JOIN 
      question_likes 
    ON 
      questions.id = question_likes.question_id
    GROUP BY questions.id
    ORDER BY COUNT(question_likes.id) DESC 
    LIMIT ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, n)
    results.map{|hash| Question.new hash }
  end
  
end