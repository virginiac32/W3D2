DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body VARCHAR(255) NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(parent_id) REFERENCES replies(id)

);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);


INSERT INTO
  users (fname,lname)
VALUES
  ('Spencer','Chan'),
  ('Virginia','Chen'),
  ('Kelly','Chung'),
  ('Aaron','Wayne'),
  ('Dallas','Hall');

INSERT INTO
  questions(title,body,user_id)
VALUES
  ('What is that?','I''m looking at a photo and don''t know what that is', (SELECT id FROM users WHERE fname = 'Spencer' AND lname = 'Chan')),
  ('Help please','I don''t understand SQL', (SELECT id FROM users WHERE fname = 'Virginia' AND lname = 'Chen')),
  ('Who are you?','I''d like to get to know you', (SELECT id FROM users WHERE fname = 'Dallas' AND lname = 'Hall'));

INSERT INTO
  question_follows (user_id,question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Spencer' AND lname = 'Chan'),(SELECT id FROM questions WHERE id = 1)),
  ((SELECT id FROM users WHERE fname = 'Aaron' AND lname = 'Wayne'),(SELECT id FROM questions WHERE id = 2)),
  ((SELECT id FROM users WHERE fname = 'Virginia' AND lname = 'Chen'),(SELECT id FROM questions WHERE id = 2)),
  ((SELECT id FROM users WHERE fname = 'Kelly' AND lname = 'Chung'),(SELECT id FROM questions WHERE id = 2)),
  ((SELECT id FROM users WHERE fname = 'Spencer' AND lname = 'Chan'),(SELECT id FROM questions WHERE id = 2)),
  ((SELECT id FROM users WHERE fname = 'Virginia' AND lname = 'Chen'),(SELECT id FROM questions WHERE id = 1)),
  ((SELECT id FROM users WHERE fname = 'Virginia' AND lname = 'Chen'),(SELECT id FROM questions WHERE id = 3));

INSERT INTO
  replies (question_id,user_id,parent_id,body)
VALUES
  ((SELECT id FROM questions WHERE id = 1),(SELECT id FROM users WHERE fname = 'Spencer' AND lname = 'Chan'),NULL,'I think it is a boat'),
  ((SELECT id FROM questions WHERE id = 1),(SELECT id FROM users WHERE fname = 'Virginia' AND lname = 'Chen'),1,'No it''s a dog');

INSERT INTO
  question_likes (user_id,question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Spencer' AND lname = 'Chan'),(SELECT id FROM questions WHERE id = 1)),
  ((SELECT id FROM users WHERE fname = 'Aaron' AND lname = 'Wayne'),(SELECT id FROM questions WHERE id = 2)),
  ((SELECT id FROM users WHERE fname = 'Virginia' AND lname = 'Chen'),(SELECT id FROM questions WHERE id = 2));
