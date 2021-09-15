-- 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
create view danhSachNV as
select d.departmentname,a.accountid 
from department d 
join `account` a on a.departmentid=d.departmentid
where a.departmentid=2;
select*from danhSachNV;
drop view danhSachNV;

-- 2 Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
create view thongTin as
select a.accountid,count(ga.groupid) as 'so group'
from groupaccount ga
join `account` a on a.accountid=ga.accountid
group by ga.accountid
having count(groupid)=(select max(b) 
							from (select count(groupid) as b 
								  from groupaccount group by accountid) as soGroupTheoAccount);
select*from thongTin;

-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ được coi là quá dài) và xóa nó đi
create view contentDai as
select content
from question 
where length(content)> 20
;

select*from contentDai;
delete from contentDai;

-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
create view phongBannhieuNVN as
select d.departmentname,count(a.accountid) as 'so nhan vien'
from department d
join `account` a on d.departmentid=a.departmentid
group by d.departmentid
having count(a.accountid)=(select max(b) 
							from (select count(accountid) as b 
								  from `account` group by departmentid) as accountOfDepartment);
select*from phongBannhieuNVN;
drop view phongBannhieuNVN;

with maxAccountOfDepartment as (
select max(b) 
from (select count(accountid) as b 
from `account` group by departmentid) as accountOfDepartment)
select d.departmentname,count(a.accountid) as 'so nhan vien'
from department d
join `account` a on d.departmentid=a.departmentid
group by d.departmentid
having count(a.accountid)=(select*from maxAccountOfDepartment);
-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo
create view questionOfNguyen as
select q.content,a.fullname
from question q
join `account` a on q.creatorid=a.accountid
where a.fullname like('Nguyễn%');
select*from questionOfNguyen;

drop view questionOfNguyen;










