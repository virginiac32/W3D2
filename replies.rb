require_relative 'questions.rb'

class Reply
  attr_accessor :id, :body, :parent_id, :user_id, :question_id

  def self.find_by_user_id(user_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    return nil if reply.empty?
    reply.map { |rep| Reply.new(rep) }
  end

  def self.find_by_question_id(question_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    return nil if reply.empty?
    reply.map { |rep| Reply.new(rep) }
  end

  def self.find_by_parent_id(parent_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL
    return nil if reply.empty?
    reply.map { |rep| Reply.new(rep) }
  end

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    return nil if reply.empty?
    Reply.new(reply.first)
  end


  def initialize(options)
    @question_id = options['question_id']
    @user_id = options['user_id']
    @parent_id = options['parent_id']
    @body = options['body']
    @id = options['id']

  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_id)
  end

  def child_replies
    Reply.find_by_parent_id(@id)
  end

  def save
    if @id
      QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id, @parent_id, @body, @id)
        UPDATE
          replies
        SET
          question_id = ?, user_id = ?, parent_id = ?, body = ?
        WHERE
           id = ?
      SQL
    else
      QuestionsDatabase.instance.execute(<<-SQL, @question_id, @user_id, @parent_id, @body)
        INSERT INTO
          replies (question_id, user_id, parent_id, body)
        VALUES
          (?, ?, ?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    end
  end

end
