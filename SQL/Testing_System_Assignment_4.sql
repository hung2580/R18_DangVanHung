use testingsystem;
-- q1  Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
select a.*,d.departmentname
from `Account` a
join Department d
on a.departmentid=d.departmentid
order by a.accountid;

-- q2  Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010 
select*from `Account` where createdate>'2020-03-07';

-- q3 Viết lệnh để lấy ra tất cả các developer 
 select a.*,p.positionname
from `Account` a
join Position p
on a.positionid=p.positionid where p.positionname='dev'
order by a.accountid;

-- q4  Viết lệnh để lấy ra danh sách các phòng ban có >2 nhân viên
select*from `Account`;
INSERT INTO `Account`(Email								, Username			, FullName				, DepartmentID	, PositionID, CreateDate)
VALUES 				('account10@gmail.com'				, 'account10'		,'Nguyễn aa'				,   '1'			,   '1'		,'2020-03-05'),
					('account11@gmail.com'				, 'account11'		,'Nguyễn bb'				,   '1'			,   '2'		,'2020-03-07'),
                    ('account12@gmail.com'				, 'account12'		,'Nguyễn cc'				,   '2'			,   '3'		,'2020-03-09'),
                    ('account13@gmail.com'				, 'account13'		,'Nguyễn dd'				,   '3'			,   '4'		,'2020-03-10'),
                    ('account14@gmail.com'				, 'account14'		,'Nguyễn ee'				,   '4'			,   '4'		,'2020-03-28'),
                    ('account15@gmail.com'				, 'account15'		,'Nguyễn ff'				,   '8'			,   '3'		,'2020-04-06'),
                    ('account16@gmail.com'				, 'account16'		,'Nguyễn gg'				,   '7'			,   '2'		,'2020-04-07'),
                    ('account17@gmail.com'				, 'account17'		,'Nguyễn hh'				,   '8'			,   '1'		,'2020-04-08'),
                    ('account18@gmail.com'				, 'account18'		,'Nguyễn jj'				,   '1'			,   '2'		,'2020-04-09'),
                    ('account19@gmail.com'				, 'account19'		,'Nguyễn kk'				,   '8'			,   '1'		,'2020-04-10');
-- join bảng department với  1 bảng ảo có số nhân viên lớn hơn 3
select d.*,a.b as 'so nhan vien'
from department d
join (select departmentid,count(departmentid) as b  from `account` group by departmentid having  count(departmentid)>3) as a on d.departmentid=a.departmentid ;
-- gom nhóm và dùng điều kiện
select d.*,count(a.departmentid) as 'so nhan vien'
from department d
join `account` a on d.departmentid=a.departmentid
group by a.departmentid
having count(a.departmentid)>3;

-- q5 Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
select q.questionid,q.content,count(e.questionid) as 'so lan'
from question q
join examquestion e on q.questionid=e.questionid 
group by e.questionid
having count(e.questionid)=(select max(b) 
							from (select count(questionid) as b 
								  from examquestion group by questionid) as questionid_no);
/* chọn id có lần xuất hiện nhiều nhất
join 2 bảng question và examquestion theo trường questionid và questionid đấy nhiều nhất trong đề thi(examquestion)
truy vấn con trong from:trong bảng examquestion gom theo questionid và số lần xuất hiện tương ứng
truy vấn con trong select:lấy ra số lần xuất hiện nhiều nhất ứng với questionid trong bảng questionid_no
*/

-- q6  Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
select cq.*,count(q.categoryid) as 'so lan su dung'
from question q
join categoryquestion cq on q.categoryid=cq.categoryid
group by cq.categoryname;

-- q7  Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
select q.*,count(eq.questionid) as 'so lan su dung'
from question q
join examquestion eq on q.questionid=eq.questionid 
group by q.questionid ;

-- q8  Lấy ra Question có nhiều câu trả lời nhất
select q.questionid,q.content,count(a.answerid) as 'so cau tra loi'
from question q
join answer a on q.questionid=a.questionid
group by q.questionid
having count(a.answerid)=(select max(b)
						  from (select count(answerid) as b 
								from answer
								group by questionid) as demSoAnswer);
/* 
join 2 bảng question và answer theo cùng questionid và questionid đấy có nhiều câu trả lời nhất
truy vấn con trong from:gom theo questionid với số câu trả lời tương ứng trong bảng answer
truy vấn con select:lấy ra câu trả lời nhiều nhất trong bảng ảo demSoAnswer 
*/
-- q9  Thống kê số lượng account trong mỗi group 
select g.groupid,g.groupname,count(ga.accountid) as 'so luong account'
from `group` g
join groupaccount ga on ga.groupid=g.groupid
group by g.groupid
having count(ga.accountid)>5 ;

-- q10 Tìm chức vụ có ít người nhất
select p.*,count(a.accountid) as 'so nguoi'
from position p
join `account` a on a.positionid = p.positionid 
group by p.positionid 
having count(a.accountid)=(select min(b)
							from (select count(accountid) as b
								  from `account` 
                                  group by positionid )as demSoNguoi);
                                  
-- q11 : Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
/* 
tạo ra 4 cột ảo số lượng dev test, scrum master, PM của mỗi phòng ban thông qua truy vấn con
4 truy vấn con:dùng join để tìm ra số nhân viên là dev và có departmentid trong 
truy vấn con khớp với departmentid trùng với outerquery đang xét bên ngoài
*/
select d1.*,(select count(a.accountid) 							
			from department d
			join `account` a on a.departmentid=d.departmentid
			where a.positionid=1 and d1.departmentid=d.departmentid
			group by d.departmentid) as dev_no					,
            
            (select count(a.accountid) 
			from department d
			join `account` a on a.departmentid=d.departmentid
			where a.positionid=2 and d1.departmentid=d.departmentid
			group by d.departmentid) as test_no,
            
            (select count(a.accountid) 
			from department d
			join `account` a on a.departmentid=d.departmentid
			where a.positionid=3 and d1.departmentid=d.departmentid
			group by d.departmentid) as scrum_master_no,
            
            (select count(a.accountid) 
			from department d
			join `account` a on a.departmentid=d.departmentid
			where a.positionid=4 and d1.departmentid=d.departmentid
			group by d.departmentid) as PM_no
from department d1
join `account` a1 on a1.departmentid=d1.departmentid
group by d1.departmentid;


-- q12 : Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của 
--  question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, …
select t.typename,q.content,q.creatorid,ac.fullname as 'nguoi tao cau hoi',a.content
from answer a 
join question q on q.questionid=a.questionid
join typequestion t on t.typeid=q.typeid
join `account` ac on ac.accountid=q.creatorid;

-- q13 : Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
select		t.typename as 'loai cau hoi', count(q.typeid) as 'so luong'
from		question q 
join 		typequestion t on q.typeid=t.typeid
group by	q.typeid;

-- q14 :Lấy ra group không có account nào
select  g.groupname
from `group` g
left join groupaccount ga on g.groupid=ga.groupid
where ga.accountid is null;

 -- q16 Lấy ra question không có answer nào
select  q.questionid
from question q
left join answer a on q.questionid=a.questionid
where a.answerid is null;


-- Exercise 2: Union
--  Question 17:
-- a,Lấy các account thuộc nhóm thứ 1
SELECT 		a.*
FROM 		`account` a
JOIN 		groupaccount ga ON a.accountid = ga.accountid
WHERE 		ga.groupid = 1;

-- b) Lấy các account thuộc nhóm thứ 3
SELECT 		a.*
FROM 		`account` a
JOIN 		groupaccount ga ON a.accountid = ga.accountid
WHERE 		ga.groupid = 3;
-- c,
SELECT 		a.*
FROM 		`account` a
JOIN 		groupaccount ga ON a.accountid = ga.accountid
WHERE 		ga.groupid = 1
UNION
SELECT 		a.*
FROM 		`account` a
JOIN 		groupaccount ga ON a.accountid = ga.accountid
WHERE 		ga.groupid = 3;

-- q18
-- a Lấy các group có lớn hơn 5 thành viên
select g.groupid,g.groupname,count(ga.accountid) as 'so luong account'
from `group` g
join groupaccount ga on ga.groupid=g.groupid
group by g.groupid
having count(ga.accountid)>5 ;
-- b,Lấy các group có nhỏ hơn 7 thành viên
select g.groupid,g.groupname,count(ga.accountid) as 'so luong account'
from `group` g
join groupaccount ga on ga.groupid=g.groupid
group by g.groupid
having count(ga.accountid)<7 ;
-- c
select g.groupid,g.groupname,count(ga.accountid) as 'so luong account'
from `group` g
join groupaccount ga on ga.groupid=g.groupid
group by g.groupid
having count(ga.accountid)>5 
union
select g.groupid,g.groupname,count(ga.accountid) as 'so luong account'
from `group` g
join groupaccount ga on ga.groupid=g.groupid
group by g.groupid
having count(ga.accountid)<7 ;













