drop database if exists testingsystem;
create database testingsystem;
use testingsystem;

drop table if exists Department; 
CREATE TABLE Department (
    DepartmentID TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    DepartmentName NVARCHAR(30) NOT NULL UNIQUE KEY
);
/*
insert into Department values(1,'Sale');
insert into Department values(2,'Marketing');
select*from Department;
*/

drop TABLE IF EXISTS Position;
CREATE TABLE Position (
    PositionID TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    PositionName ENUM('Dev', 'Test', 'Scrum Master', 'PM') NOT NULL UNIQUE KEY
);
/*
alter table question
drop foreign key  question_ibfk_3;
alter table exam
drop foreign key  exam_ibfk_2;
*/
drop table if exists `Account`;
CREATE TABLE `Account` (
    AccountID TINYINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Email VARCHAR(50) UNIQUE KEY,
    Username VARCHAR(50) NOT NULL UNIQUE KEY CHECK (LENGTH(Username) >= 4),
    FullName NVARCHAR(50) NOT NULL UNIQUE KEY,
    DepartmentID TINYINT UNSIGNED NOT NULL,
    PositionID TINYINT UNSIGNED NOT NULL,
    CreateDate DATE,
    Age TINYINT UNSIGNED CHECK (Age >= 15 AND Age <= 40),
    FOREIGN KEY (DepartmentID)
        REFERENCES Department (DepartmentID),
    FOREIGN KEY (PositionID)
        REFERENCES `Position` (PositionID)
);

drop table if exists `Group`;
CREATE TABLE `Group` (
    GroupID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    GroupName NVARCHAR(50) NOT NULL UNIQUE KEY,
    CreatorID TINYINT UNSIGNED NOT NULL,
    CreateDate DATE
);

drop table if exists GroupAccount; 
CREATE TABLE GroupAccount (
    GroupID TINYINT UNSIGNED NOT NULL ,
    AccountID TINYINT UNSIGNED NOT NULL ,
    JoinDate date,
    foreign key(GroupID) references `Group`(GroupID),
    foreign key(AccountID) references `Account`(AccountID),
    PRIMARY KEY (GroupID,AccountID)
);
/*
alter table GroupAccount
drop foreign key groupaccount_ibfk_1;
alter table GroupAccount
drop foreign key groupaccount_ibfk_2;
alter table GroupAccount
drop column JoinDate;
alter table GroupAccount
add column JoinDate date;
*/
drop table if exists TypeQuestion;
CREATE TABLE TypeQuestion (
    TypeID TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    TypeName ENUM('Essay', 'Multiple-Choice') NOT NULL UNIQUE KEY
);

drop table if exists CategoryQuestion;
CREATE TABLE CategoryQuestion (
    CategoryID TINYINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(30) NOT NULL UNIQUE KEY
);
/*
alter table answer
drop foreign key answer_ibfk_1;
alter table examquestion
drop foreign key examquestion_ibfk_1;
drop table if exists Question;
*/
drop table if exists Question;
CREATE TABLE Question (
    QuestionID TINYINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Content NVARCHAR(100) NOT NULL,
    CategoryID TINYINT UNSIGNED NOT NULL,
    TypeID TINYINT UNSIGNED NOT NULL,
    CreatorID TINYINT UNSIGNED NOT NULL ,
    CreateDate DATE,
    FOREIGN KEY (CategoryID)
        REFERENCES CategoryQuestion (CategoryID) on delete cascade
        ,
    FOREIGN KEY (TypeID)
        REFERENCES TypeQuestion (TypeID) on delete cascade
       ,
    FOREIGN KEY (CreatorID)
        REFERENCES `Account` (AccountId) on delete cascade
        
);

drop table if exists Answer;
CREATE TABLE Answer (
    AnswerID TINYINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Content NVARCHAR(100) NOT NULL,
    QuestionID TINYINT UNSIGNED NOT NULL,
    isCorrect ENUM('true', 'fault'),
    FOREIGN KEY (QuestionID)
        REFERENCES Question (QuestionID) 
        
);

drop table if exists Exam;
CREATE TABLE Exam (
    ExamID TINYINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `Code` VARCHAR(20) NOT NULL,
    Title NVARCHAR(50) NOT NULL,
    CategoryID TINYINT UNSIGNED NOT NULL,
    Duration INT UNSIGNED NOT NULL,
    CreatorID TINYINT UNSIGNED NOT NULL,
    CreateDate DATE,
    FOREIGN KEY (CategoryID)
        REFERENCES CategoryQuestion (CategoryID)
       ,
    FOREIGN KEY (CreatorID)
        REFERENCES `Account` (AccountId)
        
);

drop table if exists ExamQuestion;
CREATE TABLE ExamQuestion (
    ExamID TINYINT UNSIGNED NOT NULL,
    QuestionID TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY (QuestionID)
        REFERENCES Question (QuestionID) on delete cascade
       ,
    FOREIGN KEY (ExamID)
        REFERENCES Exam (ExamID) on delete cascade
        ,
    PRIMARY KEY (ExamID , QuestionID)
);