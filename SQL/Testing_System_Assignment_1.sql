DROP DATABASE IF EXISTS TestingSystem;
CREATE DATABASE TestingSystem;
USE TestingSystem;

CREATE TABLE Department (
    DepartmentID TINYINT,
    DepartmentName VARCHAR(50)
);


DROP TABLE IF EXISTS `Position`;
CREATE TABLE `Position` (
    PositionID TINYINT,
    PositionName VARCHAR(50)
);


CREATE TABLE `Account` (
    AccountID TINYINT,
    Email VARCHAR(50),
    Username VARCHAR(50),
    FullName CHAR(50),
    DepartmentID TINYINT,
    PositionID TINYINT,
    CreateDATE DATE
);


CREATE TABLE `Group` (
    GroupID TINYINT,
    GroupName VARCHAR(50),
    CreatorID TINYINT,
    CreateDATE DATE
);


CREATE TABLE GroupAccount (
    GroupID TINYINT,
    AccountID VARCHAR(50),
    JoinDATE DATE
);


CREATE TABLE TypeQuestion (
    TypeID TINYINT,
    TypeName VARCHAR(50)
);


CREATE TABLE CategoryQuestion (
    CategoryID TINYINT,
    CategoryName VARCHAR(50)
);


CREATE TABLE Question (
    QuestionID TINYINT,
    Content VARCHAR(50),
    CategoryID TINYINT,
    TypeID TINYINT,
    CreatorID TINYINT,
    CreateDATE DATE
);


CREATE TABLE Answer (
    Answers TINYINT,
    Content VARCHAR(50),
    QuestionID TINYINT,
    isCorrect ENUM('true', 'fault')
);


CREATE TABLE Exam (
    ExamID TINYINT,
    `Code` VARCHAR(10),
    Title VARCHAR(50),
    CategoryID TINYINT,
    Duration TINYINT,
    CreatorID TINYINT,
    CreateDATE DATE
);


CREATE TABLE ExamQuestion (
    ExamID TINYINT,
    QuestionID TINYINT
);







