/*
Not case sensitive
drop FUNCTION if exists instead_of_delete_points_of_interest;
INSERT INTO PointsOfInterestTombstone(PointOfInterestID)
VALUES(OLD.PointOfInterestID);
*/

drop table if exists Users cascade;
drop table if exists PointsOfInterest cascade;
drop table if exists Quizzes cascade;
drop table if exists PointsOfInterestQuizzes cascade;
drop table if exists Questions cascade;
drop table if exists WrongAnswers cascade;
drop table if exists PointsOfInterestChangeRequests cascade;
drop table if exists QuizzesChangeRequests cascade;
drop table if exists QuestionsChangeRequests cascade;
drop table if exists WrongAnswersChangeRequests cascade;
drop table if exists PointsOfInterestTombstone cascade;
drop table if exists QuizzesTombstone cascade;
drop table if exists QuestionsTombstone cascade;
drop table if exists WrongAnswersTombstone cascade;
drop table if exists PointsOfInterestChangeRequestsTombstone cascade;
drop table if exists QuizzesChangeRequestsTombstone cascade;
drop table if exists QuestionsChangeRequestsTombstone cascade;

drop trigger if exists delete_point_of_interest on PointsOfInterestTombstone;
drop trigger if exists update_point_of_interest on PointsOfInterest;
drop trigger if exists delete_quiz on QuizzesTombstone;
drop trigger if exists update_quiz On Quizzes;
drop trigger if exists delete_question on QuestionsTombstone;
drop trigger if exists update_question on Questions;
drop trigger if exists delete_wrong_answer on WrongAnswersTombstone;
drop trigger if exists update_wrong_answer on WrongAnswers;
drop trigger if exists insert_user on Users;
drop trigger if exists delete_point_of_interest_change_request on PointsOfInterestChangeRequestsTombstone;
drop trigger if exists delete_quiz_change_request on QuizzesChangeRequestsTombstone;
drop trigger if exists delete_question_change_request on QuestionsChangeRequestsTombstone;

create extension if not exists pgcrypto;

create table Users (
  UserID serial primary key,
  username varchar(20) unique not null,
  password text not null,
  firstName varchar(20) not null,
  lastName varchar(20) not null,
  email varchar(255) unique not null,
  isBanned boolean default false,
  isAdministrator boolean default false
);

/*
user trigger before insert uses
*/

CREATE OR REPLACE FUNCTION before_insert_into_users()
  RETURNS trigger AS
$$
BEGIN
        NEW.password = crypt(NEW.password, gen_salt('bf', 8));
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER insert_user
  before insert
  ON Users
  FOR EACH ROW
  EXECUTE PROCEDURE before_insert_into_users();

insert into Users (username, password, firstName, lastName, email, isAdministrator) values
  ('testUserName1', 'password', 'bob', 'smith', 'bob@gmail.com',true);

insert into Users (username, password, firstName, lastName, email) values
  ('testUserName2', 'password2', 'steve', 'adams', 'steve@gmail.com'),
  ('testUserName3', 'password3', 'susie', 'q', 'susie@gmail.com'),
  ('testUserName4', 'password4', 'clive', 'roberts', 'clive@gmail.com');

create table PointsOfInterest (
  PointOfInterestID serial primary key,
  UserID serial references Users(UserID),
  title varchar(255) unique not null,
  latitude double precision unique not null,
  longitude double precision unique not null,
  isDeleted boolean default false,
  updateTimestamp timestamp,
  dateCreatedOnDeviceTimestamp timestamp
);

CREATE OR REPLACE FUNCTION after_update_point_of_interest()
    RETURNS trigger AS
    $$
    BEGIN
        IF pg_trigger_depth() <> 1 THEN
        RETURN NEW;
        END IF;
        UPDATE PointsOfInterest SET updateTimestamp = now() WHERE PointOfInterestID = OLD.PointOfInterestID;
      RETURN NEW;
    END;
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_point_of_interest
    after update
    ON PointsOfInterest
    FOR EACH ROW
    EXECUTE PROCEDURE after_update_point_of_interest();


insert into PointsOfInterest (UserID, title, latitude, longitude) values
  (1,'Park', 53.2,-4.055 ),
  (1,'Library', 51.2,-4.1002 ),
  (2,'Aberystwyth University', 52.415577,-4.064260 );

create table PointsOfInterestTombstone (
  PointOfInterestTombstoneID serial primary key,
  PointOfInterestID serial references PointsOfInterest(PointOfInterestID) not null
);

create table Quizzes (
  QuizID serial primary key,
  UserID serial references Users(UserID),
  name varchar(255) not null,
  isDeleted boolean default false,
  updateTimestamp timestamp,
  dateCreatedOnDeviceTimestamp timestamp
);

insert into Quizzes (UserID, name, dateCreatedOnDeviceTimestamp) values
  (1,'The Park Quiz','2017-05-21 17:52:09.076'),
  (1,'The Library Quiz','2018-04-13 14:30:18.001'),
  (1,'The Aberystwyth University Quiz','2018-06-23 18:52:08.067');

create table QuizzesTombstone (
  QuizTombstoneID serial primary key,
  QuizID integer references Quizzes(QuizID) not null
);

create table PointsOfInterestQuizzes (
  PointOfInterestID integer references PointsOfInterest(PointOfInterestID),
  QuizID integer references Quizzes(QuizID)
);

insert into PointsOfInterestQuizzes (PointOfInterestID, QuizID) values
  (1,1),
  (2,2),
  (3,3);

create table Questions (
  QuestionID serial primary key,
  QuizID serial references Quizzes(QuizID),
  UserID serial references Users(UserID),
  question varchar(255) not null,
  answer varchar(255) not null,
  isDeleted boolean default false,
  updateTimestamp timestamp,
  dateCreatedOnDeviceTimestamp timestamp
);

create table WrongAnswers (
  WrongAnswerID serial primary key,
  UserID serial references Users(UserID),
  QuestionID serial references Questions(QuestionID),
  wrongAnswer varchar(255) not null,
  isDeleted boolean default false,
  updateTimestamp timestamp,
  dateCreatedOnDeviceTimestamp timestamp
);

create table WrongAnswersTombstone (
  WrongAnswerTombstoneID serial primary key,
  WrongAnswerID serial references WrongAnswers(WrongAnswerID) not null
);

create table QuestionsTombstone (
  QuestionTombstoneID serial primary key,
  QuestionID serial references Questions(QuestionID) not null
);

insert into Questions(QuizID, UserID, question, answer, dateCreatedOnDeviceTimestamp) values
(3, 1, 'What year was Aberystwyth University founded?', '1872','2017-05-13 17:22:28.045'),
(3, 1, 'What year was the Computer Science department founded?', '1970', '2018-04-13 14:33:12.033'),
(3, 1, 'What is the Motto in english?', 'A world without knowledge is no world at all', '2018-04-13 14:33:22.133'),
(3, 1, 'What is the Motto in welsh?', 'Nid Byd, Byd Heb Wybodaeth', '2018-04-13 14:33:52.429'),

(2, 1, 'Who laid the foundation stone of the National Library of Wales', 'King George V and Queen Mary', '2018-05-12 19:58:55.088'),
(2, 1, 'Who was the architect who won a competition in 1909 to design the building', 'Sidney Greenslade','2018-06-25 20:11:44.077');

insert into WrongAnswers (UserID, QuestionID, wrongAnswer, dateCreatedOnDeviceTimestamp) values
  (1,1,'1905','2018-06-25 20:11:44.077'),
  (1,1,'1894','2018-06-25 20:11:44.077'),
  (1,1,'1774','2018-06-25 20:11:44.077'),

  (1,2,'1965','2018-02-15 15:29:29.132'),
  (1,2,'1980','2018-02-15 15:30:11.116'),
  (1,2,'1985','2018-02-15 15:35:22.525'),

  (1,3,'Let us learn all things from everybody','2018-02-15 15:29:29.132'),
  (1,3,'We aim for better things','2018-02-15 15:30:11.116'),
  (1,3,'Together Aspire, Together Achieve','2018-02-15 15:35:22.525'),

  (1,4,'Gadewch inni ddysgu popeth o bawb','2018-02-15 15:29:29.132'),
  (1,4,'Ein nod yw gwneud pethau gwell','2018-02-15 15:30:11.116'),
  (1,4,'Gyda''n Gilydd Aspire, Cyflawnwch Gyda''n Gilydd','2018-02-15 15:37:22.323'),

  (1,5,'Dolores and Teddy','2018-02-15 15:29:29.132'),
  (1,5,'King Edward VII and Queen Alexandra','2018-02-15 15:30:11.116'),
  (1,5,'Martha and Clark','2018-02-15 15:36:22.355'),

  (1,6,'Tom Clancy','2018-03-16 17:31:20.579'),
  (1,6,'Marcus Teak','2018-03-16 17:32:15.432'),
  (1,6,'Norman Hughes','2018-03-16 17:34:42.161');

create table PointsOfInterestChangeRequests (
  PointOfInterestChangeRequestID serial primary key,
  UserID integer references Users(UserID),
  PointOfInterestID serial references PointsOfInterest(PointOfInterestID) not null,
  message varchar(255) not null,
  isDeleted boolean default false,
  dateCreatedOnDeviceTimestamp timestamp
);

create table PointsOfInterestChangeRequestsTombstone (
  PointOfInterestChangeRequestTombstoneID serial primary key,
  PointOfInterestChangeRequestID integer references PointsOfInterestChangeRequests(PointOfInterestChangeRequestID) not null
);

create table QuizzesChangeRequests (
  QuizChangeRequestID serial primary key,
  UserID integer references Users(UserID),
  QuizID integer references Quizzes(QuizID) not null,
  message varchar(255) not null,
  isDeleted boolean default false,
  dateCreatedOnDeviceTimestamp timestamp
);

create table QuizzesChangeRequestsTombstone (
  QuizChangeRequestTombstoneID serial primary key,
  QuizChangeRequestID integer references QuizzesChangeRequests(QuizChangeRequestID) not null
);

create table QuestionsChangeRequests (
  QuestionChangeRequestID serial primary key,
  UserID integer references Users(UserID),
  QuestionID serial references Questions(QuestionID) not null,
  message varchar(255) not null,
  isDeleted boolean default false,
  dateCreatedOnDeviceTimestamp timestamp
);

create table QuestionsChangeRequestsTombstone (
  QuestionsChangeRequestTombstoneID serial primary key,
  QuestionChangeRequestID integer references QuestionsChangeRequests(QuestionChangeRequestID) not null
);

create table WrongAnswersChangeRequests (
  UserID integer references Users(UserID),
  WrongAnswerID serial references WrongAnswers(WrongAnswerID),
  message varchar(255)
);

CREATE OR REPLACE FUNCTION after_insert_point_of_interest_into_tombstone()
  RETURNS trigger AS
$$
BEGIN
         UPDATE PointsOfInterest SET isDeleted = true WHERE PointOfInterestID = NEW.PointOfInterestID;
         DELETE FROM PointsOfInterestQuizzes WHERE PointOfInterestID = NEW.PointOfInterestID;
         DELETE FROM PointsOfInterestChangeRequests WHERE PointOfInterestID = NEW.PointOfInterestID;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER delete_point_of_interest
  after insert
  ON PointsOfInterestTombstone
  FOR EACH ROW
  EXECUTE PROCEDURE after_insert_point_of_interest_into_tombstone();

  -- point of interest change_requests tomb
  CREATE OR REPLACE FUNCTION after_insert_point_of_interest_change_request_into_tombstone()
    RETURNS trigger AS
  $$
  BEGIN
           UPDATE PointsOfInterestChangeRequests SET isDeleted = true WHERE PointOfInterestChangeRequestID = NEW.PointOfInterestChangeRequestID;
      RETURN NEW;
  END;
  $$ LANGUAGE 'plpgsql';

  CREATE TRIGGER delete_point_of_interest_change_request
    after insert
    ON PointsOfInterestChangeRequestsTombstone
    FOR EACH ROW
    EXECUTE PROCEDURE after_insert_point_of_interest_change_request_into_tombstone();
  -- -----

  -- quiz change_requests tomb
  CREATE OR REPLACE FUNCTION after_insert_quiz_change_request_into_tombstone()
    RETURNS trigger AS
  $$
  BEGIN
           UPDATE QuizzesChangeRequests SET isDeleted = true WHERE QuizChangeRequestID = NEW.QuizChangeRequestID;
      RETURN NEW;
  END;
  $$ LANGUAGE 'plpgsql';

  CREATE TRIGGER delete_quiz_change_request
    after insert
    ON QuizzesChangeRequestsTombstone
    FOR EACH ROW
    EXECUTE PROCEDURE after_insert_quiz_change_request_into_tombstone();
  -- -----

  -- question change_requests tomb
  CREATE OR REPLACE FUNCTION after_insert_question_change_request_into_tombstone()
    RETURNS trigger AS
  $$
  BEGIN
           UPDATE QuestionsChangeRequests SET isDeleted = true WHERE QuestionChangeRequestID = NEW.QuestionChangeRequestID;
      RETURN NEW;
  END;
  $$ LANGUAGE 'plpgsql';

  CREATE TRIGGER delete_question_change_request
    after insert
    ON QuestionsChangeRequestsTombstone
    FOR EACH ROW
    EXECUTE PROCEDURE after_insert_question_change_request_into_tombstone();
  -- -----

CREATE OR REPLACE FUNCTION after_insert_quiz_into_tombstone()
    RETURNS trigger AS
  $$
  BEGIN
           UPDATE Quizzes SET isDeleted = true WHERE QuizID = NEW.QuizID;
           DELETE FROM PointsOfInterestQuizzes WHERE QuizID = NEW.QuizID;
           DELETE FROM QuizzesChangeRequests WHERE QuizID = NEW.QuizID;
           -- UPDATE Questions SET isDeleted = true WHERE QuizID = NEW.QuizID;
           -- INSERT INTO QuestionsTombstone (QuestionID) SELECT QuestionID FROM Questions WHERE QuizID = NEW.QuizID;
      RETURN NEW;
  END;
  $$ LANGUAGE 'plpgsql';

CREATE TRIGGER delete_quiz
    after insert
    ON QuizzesTombstone
    FOR EACH ROW
    EXECUTE PROCEDURE after_insert_quiz_into_tombstone();

CREATE OR REPLACE FUNCTION after_insert_question_into_tombstone()
    RETURNS trigger AS
    $$
    BEGIN
             UPDATE Questions SET isDeleted = true WHERE QuestionID = NEW.QuestionID;
             DELETE FROM QuestionsChangeRequests WHERE QuestionID = NEW.QuestionID;
             INSERT INTO WrongAnswersTombstone (WrongAnswerID) SELECT WrongAnswerID FROM WrongAnswers WHERE QuestionID = NEW.QuestionID;
      RETURN NEW;
    END;
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER delete_question
    after insert
    ON QuestionsTombstone
    FOR EACH ROW
    EXECUTE PROCEDURE after_insert_question_into_tombstone();


CREATE OR REPLACE FUNCTION after_insert_wrong_answer_into_tombstone()
    RETURNS trigger AS
    $$
    BEGIN
             UPDATE WrongAnswers SET isDeleted = true WHERE WrongAnswerID = NEW.WrongAnswerID;
             DELETE FROM WrongAnswersChangeRequests WHERE WrongAnswerID = NEW.WrongAnswerID;
      RETURN NEW;
    END;
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER delete_wrong_answer
    after insert
    ON WrongAnswersTombstone
    FOR EACH ROW
    EXECUTE PROCEDURE after_insert_wrong_answer_into_tombstone();

CREATE OR REPLACE FUNCTION after_update_wrong_answer()
    RETURNS trigger AS
    $$
    BEGIN
        IF pg_trigger_depth() <> 1 THEN
        RETURN NEW;
        END IF;
        UPDATE WrongAnswers SET updateTimestamp = now() WHERE WrongAnswerID = OLD.WrongAnswerID;
        RETURN NEW;
        END;
        $$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_wrong_answer
        after update
        ON WrongAnswers
        FOR EACH ROW
        EXECUTE PROCEDURE after_update_wrong_answer();


CREATE OR REPLACE FUNCTION after_update_quiz()
        RETURNS trigger AS
        $$
        BEGIN
            IF pg_trigger_depth() <> 1 THEN
            RETURN NEW;
            END IF;
            UPDATE Quizzes SET updateTimestamp = now() WHERE QuizID = OLD.QuizID;
          RETURN NEW;
        END;
        $$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_quiz
        after update
        ON Quizzes
        FOR EACH ROW
        EXECUTE PROCEDURE after_update_quiz();

CREATE OR REPLACE FUNCTION after_update_question()
        RETURNS trigger AS
        $$
        BEGIN
            IF pg_trigger_depth() <> 1 THEN
            RETURN NEW;
            END IF;
            UPDATE Questions SET updateTimestamp = now() WHERE QuestionID = OLD.QuestionID;
            RETURN NEW;
        END;
        $$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_question
        after update
        ON Questions
        FOR EACH ROW
        EXECUTE PROCEDURE after_update_question();
