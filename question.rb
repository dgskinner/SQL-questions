class Question
  attr_accessor :id, :title, :body, :author_id
  
  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
  
  def self.find_by_id(id)
    query = <<-SQL
    SELECT 
      *
    FROM 
      questions
    WHERE
      questions.id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, id)
    results.map{|hash| Question.new hash }.first
  end
  
  def self.find_by_author(author_id)
    query = <<-SQL
    SELECT 
      *
    FROM 
      questions
    WHERE
    questions.author_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, author_id)
    results.map { |hash| Question.new hash }
  end
  
  def author
    query = <<-SQL
    SELECT
      *
    FROM
      questions
    WHERE questions.author_id = ?
    SQL
    
    results = QuestionsDatabase.instance.execute(query, author_id)
    results.map { |hash| Question.new hash }.first
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
  
  def followers
    QuestionFollower.followers_for_question_id(@id)
  end
  
  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n) 
  end
  
  def likers
    QuestionLike.likers_for_questions_id(@id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
  
  def self.most_likes(n)
    QuestionLike.most_liked_questions(n)
  end
end