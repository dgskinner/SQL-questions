CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  subject_question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  FOREIGN KEY(subject_question_id) REFERENCES questions(id),
  FOREIGN KEY(parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Albert','Einstein'), ('Kurt', 'Godel');
  
INSERT INTO 
  questions(title, body, author_id)
VALUES
  ('What does e equal?', "kajsdhflkuhf", (SELECT id FROM users WHERE fname = 'Kurt')),
  ('bad q1', "ksjn", 2),
  ('bad q2', "lkjdf", 2),
  ('bad q3', "lghjkjklugikjdf", 2),
  ('Math?', "khfhdfo", (SELECT id FROM users WHERE fname = 'Albert')),
  ('dlkfh?', "kjsdf", (SELECT id FROM users WHERE fname = 'Albert'));
  
INSERT INTO 
  replies(subject_question_id, parent_reply_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = 'What does e equal?'), 
    NULL, 
  (SELECT id FROM users WHERE fname = 'Albert'),
  "mc^2" ),
  ((SELECT id FROM questions WHERE title = 'What does e equal?'),
   1,
   2,
   "Thanks brah");
  
  
INSERT INTO 
  question_likes(user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Kurt'), 
  (SELECT id FROM questions WHERE title = 'What does e equal?')),
  ((SELECT id FROM users WHERE fname = 'Albert'), 
  (SELECT id FROM questions WHERE title = 'What does e equal?')),
  (1,(SELECT id FROM questions WHERE title = 'dlkfh?'));
 
INSERT INTO
question_followers(question_id, user_id)
VALUES
(1, 1),
(1, 2),
(2, 1);

  
  
  
   
