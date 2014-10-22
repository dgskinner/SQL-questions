class Reply
  attr_accessor :id, :subject_question_id, :parent_reply_id, 
                :user_id, :body, :author_id
                
  def initialize(options = {})
    @id = options['id']
    @subject_question_id = options['subject_question_id']
    @parent_reply_id = options['parent_reply_id']
    @user_id = options['user_id']
    @body = options['body']
    @author_id = options['author_id']
  end
  
  def self.find_by_id(id)
    query = <<-SQL
    SELECT 
      *
    FROM 
      replies
    WHERE
      replies.id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, id)
    results.map{|hash| Reply.new hash }.first
  end
  
  def self.find_by_question_id(question_id)
    
    query = <<-SQL
    SELECT
      *
    FROM 
      replies
    WHERE 
      replies.question_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, question_id)
    results.map{ |hash| Reply.new hash }
  end
  
  def self.find_by_user_id(user_id)
    query = <<-SQL
    SELECT
      *
    FROM 
      replies
    WHERE 
      replies.user_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, user_id)
    results.map{ |hash| Reply.new hash }
  end

  def author
    query = <<-SQL
    SELECT
      *
    FROM 
      users
    WHERE 
      users.id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, @user_id)
    results.map{ |hash| User.new hash }.first
  end
  
  def question
    query = <<-SQL
    SELECT
      *
    FROM 
      questions
    WHERE 
      questions.id = ?
    SQL
    results = QuestionsDatabase.instance.execute(query, @subject_question_id)
    results.map{ |hash| Question.new hash }.first
  end
  
  def parent_reply
    query = <<-SQL
    SELECT
      *
    FROM 
      replies
    WHERE 
      replies.id = ?
    SQL
    results = QuestionsDatabase.instance.execute(query, @parent_reply_id)
    results.map{ |hash| Reply.new hash }.first
  end
  
  def child_replies
    query = <<-SQL
    SELECT
      *
    FROM 
      replies
    WHERE 
      replies.parent_reply_id = ?
    SQL
    results = QuestionsDatabase.instance.execute(query, @id)
    results.map{ |hash| Reply.new hash }
  end
  
end
