use testingsystem;
-- Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo
-- trước 1 năm trước
drop trigger if exists doNotAllowUserUpdateWrongCreatedate;
DELIMITER $$
CREATE TRIGGER doNotAllowUserUpdateWrongCreatedate
BEFORE INSERT ON `Account` 
FOR EACH ROW
BEGIN
	if  new.createdate< date_sub(curdate(),interval 1 year) then
    signal sqlstate'12345'
    set message_text='createdate da qua 1 nam';
    end if;
END $$
DELIMITER ;
select*from `Account`;
INSERT INTO `Account`(Email								, Username			, FullName				, DepartmentID	, PositionID, CreateDate)
VALUES 				('account29@gmail.com'				, 'account29'		,'Nguyễn văn minh c'	,   '2'			,   '1'		,'2020-03-05');
/*
Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào 
 department "Sale" nữa, khi thêm thì hiện ra thông báo "Department
 "Sale" cannot add more user"

*/
drop trigger if exists doNotAllowUpdateNewUserInSale;
DELIMITER $$
CREATE TRIGGER doNotAllowUpdateNewUserInSale
BEFORE INSERT ON `account`
FOR EACH ROW
BEGIN
	declare b tinyint unsigned;
    select departmentid into b
    from department
    where departmentname='sale';
	if new.departmentid=b then
    signal sqlstate'12345'
    set message_text='khong duoc them user moi cho department sale';
    end if;
END $$
DELIMITER ;

-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user
drop trigger if exists maxUserOf1Group;
DELIMITER $$
CREATE TRIGGER maxUserOf1Group
BEFORE INSERT ON groupaccount
FOR EACH ROW
BEGIN
	-- so sánh id mới nhập vào với tất cả id trong bảng ảo nơi có count(id)
	if new.groupid in (select groupid from (select groupid,count(groupid) as count_groupid 
											from groupaccount 
											group by groupid
                                            having count_groupid=5)as x) then
    signal sqlstate'12345'
    set message_text='khong duoc them user moi cho department sale';
    end if;
END $$
DELIMITER ;
-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question
-- làm giống bài 3 với bảng examquestion 

/*
uestion 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là 
 admin@gmail.com (đây là tài khoản admin, không cho phép user xóa), 
 còn lại các tài khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông 
 tin liên quan tới user đó

if new.email='admin@gmail.com' then
signal sqlstate'12345'
set message_text='khong duoc them user moi cho department sale';
*/
/*Question 6: Không sử dụng cấu hình default cho field DepartmentID của table 
 Account, hãy tạo trigger cho phép người dùng khi tạo account không điền 
 vào departmentID thì sẽ được phân vào phòng ban "waiting Department"*/
 DROP TRIGGER IF EXISTS before_accounts_insert;
DELIMITER $$
CREATE TRIGGER before_accounts_insert 
BEFORE INSERT ON `account`
FOR EACH ROW
BEGIN
	DECLARE v_department_id INT;
    
    SELECT departmentid INTO v_department_id 
    FROM department
    WHERE departmentname = 'Waiting Room';
    
    IF NEW.departmentid IS NULL THEN
		SET NEW.departmentid = v_departmentid;
	END IF;
END$$
DELIMITER ; 
/*Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi 
 question, trong đó có tối đa 2 đáp án đúng.*/
 DROP TRIGGER IF EXISTS before_insert_answer;
DELIMITER $$
CREATE TRIGGER before_insert_answer
BEFORE INSERT ON answer
FOR EACH ROW
BEGIN
	DECLARE v_number_of_answers TINYINT;
	DECLARE v_number_of_correct_answers TINYINT;

	SELECT COUNT(a.answerid) INTO v_number_of_answers
    FROM answer a 
    JOIN question q ON a.questionid = q.questionid
    WHERE a.questionid = NEW.questionid;
    
    SELECT COUNT(a.answerid) INTO v_number_of_correct_answers
    FROM answer a 
    JOIN question q ON a.questionid = q.questionid
    WHERE a.questionid = NEW.questionid AND a.iscorrect = 1;
    
    IF v_number_of_answers = 4 THEN
		SIGNAL SQLSTATE '12345' -- disallow insert this record
		SET MESSAGE_TEXT = 'One question has a maximum of 4 answers!';
	END IF;
    
    IF v_number_of_correct_answers = 2 THEN
		SIGNAL SQLSTATE '12345' -- disallow insert this record
		SET MESSAGE_TEXT = 'One question has a maximum of 2 correct answers!';
	END IF;
END$$
DELIMITER ;
/*Question 8: Viết trigger sửa lại dữ liệu cho đúng: 
 Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác địhn*/
DROP TRIGGER IF EXISTS before_insert_account_reset_gender;
DELIMITER $$
CREATE TRIGGER before_insert_account_reset_gender
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
	IF NEW.gender = 'Male' THEN
		SET NEW.gender = 'M';
	ELSEIF NEW.gender = 'Female' THEN
		SET NEW.gender = 'F';
	ELSEIF NEW.gender = 'Unknown' THEN
		SET NEW.gender = 'U';
	END IF;
END$$
DELIMITER ;

-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
DROP TRIGGER IF EXISTS before_delete_exam;
DELIMITER $$
CREATE TRIGGER before_delete_exam
BEFORE DELETE ON exam
FOR EACH ROW
BEGIN
    IF OLD.examid IN (SELECT examid
					   FROM exam
                       WHERE DAY(NOW()) - DAY(create_date) = 2) THEN
		SIGNAL SQLSTATE '12345' -- disallow delete this record
		SET MESSAGE_TEXT = 'This exam was created 2 days ago, you can not delete!';
	END IF;
    
    DELETE FROM examquestion
    WHERE examid = OLD.examid;
END$$
DELIMITER ;

DELETE FROM exam
WHERE examid = 2;



/*
Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các 
 question khi question đó chưa nằm trong exam nào
 */
 drop trigger if exists beforeUpdateQuestion;
DELIMITER $$
CREATE TRIGGER beforeUpdateQuestion
BEFORE INSERT ON question
FOR EACH ROW
BEGIN
	if new.questionid in (select distinct questionid from examquestion)
	or new.questionid in (select distinct questionid from answer) then
    signal sqlstate'12345'
    set message_text='khong duoc them user moi cho department sale';
    end if;
END $$
DELIMITER ;

/*Question 12: Lấy ra thông tin exam trong đó:
Duration <= 30 thì sẽ đổi thành giá trị "Short time"
30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
Duration > 60 thì sẽ đổi thành giá trị "Long time"
*/
SELECT `code`, title, duration,
CASE 
	WHEN duration <= 30 THEN 'Short time'
    WHEN 30 < duration <= 60 THEN 'Medium time'
    ELSE 'Long time'
END AS duration_text -- tên bảng ảo t4
FROM exam;

-- Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa 
-- có tên là the_number_user_amount và mang giá trị được quy định như sau:
-- Nếu số lượng user trong group <= 5 thì sẽ có giá trị là few
-- Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher
SELECT g.groupname, COUNT(ga.accountid) AS number_of_accounts,
CASE 
	WHEN COUNT(ga.accountid) <= 5 THEN 'few'
    WHEN 5 < COUNT(ga.accountid) <= 20 THEN 'normal'
    ELSE 'higher'
END AS the_number_user_amount
FROM `group` g
JOIN groupaccount ga ON g.groupid = ga.groupid
GROUP BY g.groupid;

-- Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, 
-- nếu phòng ban nào không có user thì sẽ thay đổi giá trị 0 thành "Không có user nào" 
SELECT d.departmentname, IF(COUNT(a.accountid) = 0, 'Không có user nào', COUNT(a.accountid)) AS number_of_accounts
FROM department d
LEFT JOIN account a ON d.departmentid = a.departmentid
GROUP BY d.departmentid;