require_relative 'replies.rb'

class QuestionFollow
  attr_accessor :user_id, :question_id

  def self.find_by_user_id(user_id)
    q_follow = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        user_id = ?
    SQL
    return nil if q_follow.empty?
    q_follow.map { |q| QuestionFollow.new(q) }
  end

  def self.find_by_question_id(question_id)
    q_follow = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_id = ?
    SQL
    return nil if q_follow.empty?
    q_follow.map { |q| QuestionFollow.new(q) }
  end

  def self.followers_for_question_id(qid)
    q_follow = QuestionsDatabase.instance.execute(<<-SQL, qid)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.user_id
      WHERE
        question_follows.question_id = ?
    SQL
    return nil if q_follow.empty?
    q_follow.map { |q| User.new(q) }
  end

  def self.followed_questions_for_user_id(uid)
    q_follow = QuestionsDatabase.instance.execute(<<-SQL, uid)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      WHERE
        question_follows.user_id = ?
    SQL
    return nil if q_follow.empty?
    q_follow.map { |q| Question.new(q) }
  end

  def self.most_followed_questions(n)
    q_follow = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      GROUP BY
        question_follows.question_id
      ORDER BY
        COUNT(question_follows.user_id) DESC
      LIMIT ?
    SQL
    return nil if q_follow.empty?
    q_follow.map { |q| Question.new(q) }
  end

  def initialize(options)
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

end


class QuestionLike
  attr_accessor :user_id, :question_id

  def self.find_by_user_id(user_id)
    q_like = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        user_id = ?
    SQL
    return nil if q_like.empty?
    q_like.map { |q| QuestionLike.new(q)}
  end

  def self.find_by_question_id(question_id)
    q_like = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL
    return nil if q_like.empty?
    q_like.map { |q| QuestionLike.new(q)}
  end

  def self.likers_for_question_id(qid)
    q_like = QuestionsDatabase.instance.execute(<<-SQL, qid)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL
    return nil if q_like.empty?
    q_like.map { |q| User.new(q) }
  end

  def self.num_likes_for_question_id(qid)
    q_like = QuestionsDatabase.instance.execute(<<-SQL, qid)
      SELECT
        COUNT(users.id) AS count
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL
    q_like.first["count"]
  end

  def self.liked_questions_for_user_id(uid)
    q_like = QuestionsDatabase.instance.execute(<<-SQL, uid)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = ?
    SQL
    return nil if q_like.empty?
    q_like.map { |q| Question.new(q) }
  end

  def self.most_liked_questions(n)
    q_like = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      GROUP BY
        question_likes.question_id
      ORDER BY
        COUNT(question_likes.user_id) DESC
      LIMIT ?
    SQL
    return nil if q_like.empty?
    q_like.map { |q| Question.new(q) }
  end

  def initialize(options)
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

end
