use testingsystem;
-- Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó
drop procedure if exists accountOfDepartment;
delimiter $$
create procedure accountOfDepartment(in department_name NVARCHAR(30)) 
begin 
	select a.*
    from `account` a
    join department d on d.departmentid=a.departmentid
    where d.departmentname=department_name;
end$$
delimiter ;
call accountOfDepartment('Sale');

-- Question 2: Tạo store để in ra số lượng account trong mỗi group
drop procedure if exists quantityAccountOfGroup;
delimiter $$
create procedure quantityAccountOfGroup(in group_id tinyint unsigned ) 
begin 
	select ga.groupid,g.groupname,count(ga.accountid)
    from groupaccount ga
    join `group` g on g.groupid=ga.groupid
    where ga.groupid=group_id
    group by ga.groupid;
end$$
delimiter ;
call quantityAccountOfGroup(1);

-- Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
drop procedure if exists typequestion_quantityQuestionOfMonth;
delimiter $$
create procedure typequestion_quantityQuestionOfMonth() 
begin 
	select tq.typename,count(q.questionid)
    from question q
    join typequestion tq on q.typeid=tq.typeid
    where month(q.createdate)=month(now())
    group by tq.typeid;
end$$
delimiter ;
call typequestion_quantityQuestionOfMonth();

-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
drop procedure if exists id_typequestion_max_question;
delimiter $$
create procedure id_typequestion_max_question() 
begin 
	select tq.typeid
    from question q
    join typequestion tq on q.typeid=tq.typeid
    group by tq.typeid
    having count(q.questionid)=(select max(b) from (select count(questionid) as b from question group by typeid) as xxx) ;
end$$
delimiter ;
call id_typequestion_max_question();

-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question
drop procedure if exists find_typename_from_id;
delimiter $$
create procedure find_typename_from_id() 
begin 
	select tq.typename
    from question q
    join typequestion tq on q.typeid=tq.typeid
    group by tq.typeid
    having count(q.questionid)=(select max(b) from (select count(questionid) as b from question group by typeid) as xxx) ;
end$$
delimiter ;
call find_typename_from_id() ;

/*
Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và
trong store sẽ tự động gán:

username sẽ giống email nhưng bỏ phần @..mail đi
positionID: sẽ có default là developer
departmentID: sẽ được cho vào 1 phòng chờ

Sau đó in ra kết quả tạo thành công
*/

-- -------------------nhập thông tin đầu vào để thêm dữ liệu mới vào bảng `account` sau đó in ra thông tin account đó---------------------------------
drop procedure if exists taoThongTinNewUser;
delimiter $$
create procedure taoThongTinNewUser(in full_name VARCHAR(50),in email_user VARCHAR(50)) 
begin
		
		INSERT INTO `Account`(Email						, Username									, FullName				, DepartmentID	, PositionID,CreateDate)
		VALUES 				 (email_user				, substring_index(email_user,'@',1)			, full_name				,   '5'			,'1'		,date(now()));
        select *
        from `account` 
        where username=substring_index(email_user,'@',1)	;
end$$
delimiter ;

select*from `account`;
delete from `account` where accountid in (21,23,24);
-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice
-- để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
-- cách làm chọn ra content dài nhất ứng với typename người dùng nhập bằng kết nối and và truy vấn con tìm chuỗi dài nhất tương ứng
drop procedure if exists typeOfQuestion_essay_or_MultipleChoice;
delimiter $$
create procedure typeOfQuestion_essay_or_MultipleChoice(in typeChoice ENUM('Essay', 'Multiple-Choice')) 
begin
        select   q.content
        from question q
        join typequestion tq on q.typeid=tq.typeid
        where tq.typename=typeChoice and length(q.content) =(select max(b) from (select length(content) as b from question group by typeid) as xxx);
end$$
delimiter ;
 call typeOfQuestion_essay_or_MultipleChoice('essay');
 
 -- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
 drop procedure if exists delete_exam;
delimiter $$
create procedure delete_exam(in id_exam tinyint unsigned )
begin
        delete 
        from exam
        where examid=id_exam ;
end$$
delimiter ;
select*from exam;

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi, sau đó in số lượng record đã remove từ các table liên quan
-- trong khi removing
-- b1 đếm examid trong examquestion sẽ bị xóa cùng khi bảng cha exam bị xóa
-- b2 xóa thông tin exam với time 3 năm trc
-- lần gọi lệnh thứ 2 sẽ k còn dữ liệu in ra do lần 1 đã xóa hết dữ liệu
-- chỉ có bảng examquestion có khóa khóa ngoại chỉ đến khóa chính trong bảng exam bị ảnh hưởng 
-- dữ liệu của examid=1 ứng với time năm2018 đã bị xóa,nên lần gọi t2 sẽ k còn dữ liệu
drop procedure if exists delete_exam_3_years_ago;
delimiter $$
create procedure delete_exam_3_years_ago()
begin 
		select count(eq.examid) as record_delete_of_table_examquestion
        from exam e
        join examquestion eq on e.examid=eq.examid
        where year(e.createdate)=( year(now())-3)
        group by e.examid;
		delete
        from exam
        where year(createdate)=( year(now())-3);
end$$
delimiter ;
call testingsystem.delete_exam_3_years_ago();
select*from  Exam;

-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng
-- nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được chuyển về phòng
-- ban default là phòng ban chờ việc
-- b1 tạo phòng ban chờ việc có id là 11
-- tạo procedure trong đó:
-- b2 đổi departmentid trong bảng bảng account thành 11 ứng với phòng ban 11
-- b3 xóa departmentid tương ứng với departmentname đc yêu cầu
INSERT INTO Department(departmentid,DepartmentName) 
VALUES
						(11,N'Chờ Việc'	);   
select*from department;
drop procedure if  exists deleteDepartmentName;
delimiter $$
create procedure deleteDepartmentName(in name_department nvarchar(30))
begin
		update `account`
        set departmentid=11
        where departmentid=(select departmentid from department where departmentname=name_department);
		delete
        from department
        where departmentname=name_department;
end$$
delimiter ;
call testingsystem.deleteDepartmentName('Marketing');
select*from `account`;

-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nhập vào
drop procedure if  exists count_question_each_month_of_year;
delimiter $$
create procedure count_question_each_month_of_year(in year_in year)
begin
		select (select count(questionid) from question where month(createdate)='1' and year(createdate)=year_in) as t1,
				(select count(questionid) from question where month(createdate)='2' and year(createdate)=year_in) as t2,
                (select count(questionid) from question where month(createdate)='3' and year(createdate)=year_in) as t3,
                (select count(questionid) from question where month(createdate)='4' and year(createdate)=year_in) as t4,
                (select count(questionid) from question where month(createdate)='5' and year(createdate)=year_in) as t5,
                (select count(questionid) from question where month(createdate)='6' and year(createdate)=year_in) as t6,
                (select count(questionid) from question where month(createdate)='7' and year(createdate)=year_in) as t7,
                (select count(questionid) from question where month(createdate)='8' and year(createdate)=year_in) as t8,
                (select count(questionid) from question where month(createdate)='9' and year(createdate)=year_in) as t9,
                (select count(questionid) from question where month(createdate)='10' and year(createdate)=year_in) as t10,
                (select count(questionid) from question where month(createdate)='11' and year(createdate)=year_in) as t11,
                (select count(questionid) from question where month(createdate)='12' and year(createdate)=year_in) as t12
        from question
        limit 1;
end$$
delimiter ;

 select*from question;       
select count(questionid) from question where month(createdate)='4' and year(createdate)='2020';     

-- Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6
-- tháng gần đây nhất (nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào
-- trong tháng")
        
        
        
        
        
        
        
        