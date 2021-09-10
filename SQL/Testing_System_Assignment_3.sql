-- Q1: Thêm ít nhất 10 record vào mỗi table
delete  from Department;
select*from Department order by DepartmentID;
INSERT INTO Department(DepartmentName) 
VALUES
						(N'Marketing'	),
						(N'Sale'		),
						(N'Bảo vệ'		),
						(N'Nhân sự'		),
						(N'Kỹ thuật'	),
						(N'Tài chính'	),
						(N'Phó giám đốc'),
						(N'Giám đốc'	),
						(N'Thư kí'		),
						(N'Bán hàng'	);
    
delete  from Position;
select*from Position;
INSERT INTO Position	(PositionName	) 
VALUES 					('Dev'			),
						('Test'			),
						('Scrum Master'	),
						('PM'			); 


delete  from `Account`;
select*from `Account`;
INSERT INTO `Account`(Email								, Username			, FullName				, DepartmentID	, PositionID, CreateDate)
VALUES 				('account0@gmail.com'				, 'account0'		,'Nguyễn a'				,   '5'			,   '1'		,'2020-03-05'),
					('account1@gmail.com'				, 'account1'		,'Nguyễn b'				,   '1'			,   '2'		,'2020-03-07'),
                    ('account2@gmail.com'				, 'account2'		,'Nguyễn c'				,   '2'			,   '3'		,'2020-03-09'),
                    ('account3@gmail.com'				, 'account3'		,'Nguyễn d'				,   '3'			,   '4'		,'2020-03-10'),
                    ('account4@gmail.com'				, 'account4'		,'Nguyễn e'				,   '4'			,   '4'		,'2020-03-28'),
                    ('account5@gmail.com'				, 'account5'		,'Nguyễn f'				,   '6'			,   '3'		,'2020-04-06'),
                    ('account6@gmail.com'				, 'account6'		,'Nguyễn g'				,   '7'			,   '2'		,'2020-04-07'),
                    ('account7@gmail.com'				, 'account7'		,'Nguyễn h'				,   '8'			,   '1'		,'2020-04-08'),
                    ('account8@gmail.com'				, 'account8'		,'Nguyễn j'				,   '9'			,   '2'		,'2020-04-09'),
                    ('account9@gmail.com'				, 'account9'		,'Nguyễn k'				,   '10'		,   '1'		,'2020-04-10');

delete  from `Group`;
select*from `Group`;
INSERT INTO `Group`	(  GroupName			, CreatorID		, CreateDate)
VALUES 				('Group0'				,   5			,'2020-03-05'),
					('Group1'				,   1			,'2020-03-07'),
                    ('Group2'				,   2			,'2020-03-09'),
                    ('Group3'				,   3			,'2020-03-10'),
                    ('Group4'				,   4			,'2020-03-28'),
                    ('Group5'				,   6			,'2020-04-06'),
                    ('Group6'				,   7			,'2020-04-07'),
                    ('Group7'				,   8			,'2020-04-08'),
                    ('Group8'				,   9			,'2020-04-09'),
                    ('Group9'				,   10			,'2020-04-10');

delete  from GroupAccount;
select*from GroupAccount;
INSERT INTO GroupAccount	(  GroupID	, AccountID	, JoinDate	 )
VALUES 						(	1		,    1		,'2020-03-05'),
							(	2		,    2		,'2020-03-07'),
							(	3		,    3		,'2020-03-09'),
							(	4		,    4		,'2020-03-10'),
							(	5		,    5		,'2020-03-28'),
							(	6		,    6		,'2020-04-06'),
							(	7		,    7		,'2020-04-07'),
							(	8		,    8		,'2020-04-08'),
							(	9		,    9		,'2020-04-09'),
							(	10		,    10		,'2020-04-10');


delete  from TypeQuestion;
select*from  TypeQuestion;
INSERT INTO TypeQuestion	(TypeName			) 
VALUES 						('Essay'			), 
							('Multiple-Choice'	); 


delete  from CategoryQuestion;
select*from  CategoryQuestion;
INSERT INTO CategoryQuestion		(CategoryName	)
VALUES 								('Java'			),
									('ASP.NET'		),
									('ADO.NET'		),
									('SQL'			),
									('Postman'		),
									('Ruby'			),
									('Python'		),
									('C++'			),
									('C Sharp'		),
									('PHP'			);
													
delete  from Question;
select*from  Question;
INSERT INTO Question	(QuestionID,Content			, CategoryID, TypeID		, CreatorID	, CreateDate )
VALUES 					(1,N'Câu hỏi về Java '		,	1		,   '1'			,   '1'		,'2020-04-05'),
						(2,N'Câu Hỏi về PHP'		,	10		,   '2'			,   '2'		,'2020-04-05'),
						(3,N'Hỏi về C#'				,	9		,   '2'			,   '3'		,'2020-04-06'),
						(4,N'Hỏi về Ruby'			,	6		,   '1'			,   '4'		,'2020-04-06'),
						(5,N'Hỏi về Postman'		,	5		,   '1'			,   '5'		,'2020-04-06'),
						(6,N'Hỏi về ADO.NET'		,	3		,   '2'			,   '6'		,'2020-04-06'),
						(7,N'Hỏi về ASP.NET'		,	2		,   '1'			,   '7'		,'2020-04-06'),
						(8,N'Hỏi về C++'			,	8		,   '1'			,   '8'		,'2020-04-07'),
						(9,N'Hỏi về SQL'			,	4		,   '2'			,   '9'		,'2020-04-07'),
						(10,N'Hỏi về Python'		,	7		,   '1'			,   '10'	,'2020-04-07');

delete  from Answer;
select*from  Answer;
INSERT INTO Answer	(  Content		, QuestionID	, isCorrect	)
VALUES 				(N'Trả lời 01'	,   5			,	'fault'	),
					(N'Trả lời 02'	,   1			,	'true'	),
                    (N'Trả lời 03'	,   5			,	'fault'	),
                    (N'Trả lời 04'	,   1			,	'true'	),
                    (N'Trả lời 05'	,   2			,	'true'	),
                    (N'Trả lời 06'	,   4			,	'true'	),
                    (N'Trả lời 07'	,   5			,	'fault'	),
                    (N'Trả lời 08'	,   10			,	'fault'	),
                    (N'Trả lời 09'	,   5			,	'true'	),
                    (N'Trả lời 10'	,   8			,	'true'  );
	
delete  from Exam;
select*from  Exam;
INSERT INTO Exam	(`Code`			, Title					, CategoryID	, Duration	, CreatorID		, CreateDate )
VALUES 				('VTIQ001'		, N'Đề thi C#'			,	1			,	60		,   '5'			,'2019-04-05'),
					('VTIQ002'		, N'Đề thi PHP'			,	10			,	60		,   '2'			,'2019-04-05'),
                    ('VTIQ003'		, N'Đề thi C++'			,	9			,	120		,   '2'			,'2019-04-07'),
                    ('VTIQ004'		, N'Đề thi Java'		,	6			,	60		,   '3'			,'2020-04-08'),
                    ('VTIQ005'		, N'Đề thi Ruby'		,	5			,	120		,   '4'			,'2020-04-10'),
                    ('VTIQ006'		, N'Đề thi Postman'		,	3			,	60		,   '6'			,'2020-04-05'),
                    ('VTIQ007'		, N'Đề thi SQL'			,	2			,	60		,   '7'			,'2020-04-05'),
                    ('VTIQ008'		, N'Đề thi Python'		,	8			,	60		,   '8'			,'2020-04-07'),
                    ('VTIQ009'		, N'Đề thi ADO.NET'		,	4			,	90		,   '9'			,'2020-04-07'),
                    ('VTIQ010'		, N'Đề thi ASP.NET'		,	7			,	90		,   '10'		,'2020-04-08');
                 
                    
delete  from ExamQuestion;
select*from  ExamQuestion;
INSERT INTO ExamQuestion(ExamID	, QuestionID	) 
VALUES 					(	1	,		5		),
						(	2	,		10		), 
						(	3	,		4		), 
						(	4	,		3		), 
						(	5	,		7		), 
						(	6	,		10		), 
						(	7	,		2		), 
						(	8	,		10		), 
						(	9	,		9		), 
						(	10	,		8		); 


-- q2:lấy ra tất cả phòng ban
select*from department;

-- q3:lấy ra id của phòng ban sale
select departmentid from department where departmentname='sale';

-- q4:lấy ra account có fullname dài nhất
update `Account` set FullName='Nguyễn abc' where accountid=1;
select * from `Account` where length(FullName)=(select max(length(FullName)) from `Account`);

-- q5:lấy ra account có fullname dài nhất và thuộc phòng ban 3
select * from `Account` group by departmentid having departmentid=3 and max(length(FullName)) ;

-- q6 lấy ra tên group đã tham gia trước ngày 7/3/2020
select groupname from `group` where createdate<'2020-03-07';

-- q7 lấy ra id của question có >=4 câu trả lời
select questionid from Answer group by questionid  having count(questionid)>=4;

-- q8  Lấy ra các mã đề thi có thời gian thi >= 60 phút và được tạo trước ngày 7/3/2020
select * from exam where duration>=60 and createdate<'2020-03-07';

-- q9  Lấy ra 5 group được tạo gần đây nhất 
select*from `group` order by createdate limit 5;

-- q10 : Đếm số nhân viên thuộc department có id = 2
select count(accountid) as 'so nhan vien phong 2' from `Account` where departmentid=2;

-- q11 Lấy ra nhân viên có tên bắt đầu bằng chữ "n" và kết thúc bằng chữ "c"
select * from `Account` where fullname like('n%c');

-- q12 Xóa tất cả các exam được tạo trước ngày 20/12/2019
delete from exam where createdate<'2019-12-20';

-- q13 Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi"
delete from question  where substring_index(content,' ',2) ='Câu hỏi';

-- q14 : Update thông tin của account có id = 5 thành tên "Nguyễn Bá Lộc" và email thành loc.nguyenba@vti.com.vn
update `Account` 
set 	fullname='Nguyễn Bá Lộc',
		email='loc.nguyenba@vti.com.vn'
where accountid=5;

-- q15 update account có id = 5 sẽ thuộc group có id = 4

commit;

update GroupAccount
set groupid=4
where accountid=5;
select*from GroupAccount;        
rollback;
