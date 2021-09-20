DROP DATABASE IF EXISTS finalExamTest;
CREATE DATABASE finalExamTest;
USE finalExamTest;

-- create table
drop table if exists customer;
create table customer(
	customerid tinyint unsigned primary key auto_increment,
    fullName nvarchar(50) not null,
    phone varchar(50) not null ,
    email varchar(50),
    address nvarchar(100),
    note nvarchar(100)
);
drop table if exists car;
create table car(
		carid tinyint unsigned not null primary key auto_increment,
        marker enum('HONDA','TOYOTA','NISSAN'), -- tên hãng
        model varchar(50), -- tên mẫu xe
        yearManufacture date,
        color varchar(20),
        note nvarchar(100)

);
drop table if exists carOrder;
create table carOrder(
	 orderid tinyint unsigned not null primary key auto_increment,
     customerid tinyint unsigned not null ,
     carid tinyint unsigned not null,
     amount tinyint unsigned  default 1,
     saleprice decimal(10,2) NOT NULL,
     orderdate date,  -- ngay dat hang
     deliverydate date, -- ngay giao hang
     deliveryaddress nvarchar(100), -- dia chi nhan hang
     statusorder enum('0','1','2'), -- trang thai da dat hang,da giao hang,da huy
     note nvarchar(100),
     foreign key (customerid) references customer(customerid),
     foreign key (carid) references car(carid)
);

-- insert values
insert into customer(fullName		,phone			,email					,address)
values 				('đặng a'		,'144-493-7480'	,'email1@gmail.com'		,'ha noi,viet nam'),
					('đặng b'		,'622-949-6655'	,'email2@gmail.com'		,'quang tri,viet nam'),
                    ('đặng c'		,'384-515-7755'	,'email3@gmail.com'		,'ho chi minh,viet nam'),
                    ('đặng d'		,'169-828-6261'	,'email4@gmail.com'		,'ha noi,viet nam'),
                    ('đặng e'		,'186-205-5976'	,'email5@gmail.com'		,'da nang,viet nam'),
                    ('đặng f'		,'512-362-4541'	,'email6@gmail.com'		,'hue,viet nam'),
                    ('đặng g'		,'417-359-3391'	,'email7@gmail.com'		,'ha noi,viet nam'),
                    ('đặng h'		,'516-429-8114'	,'email8@gmail.com'		,'quang ninh,viet nam'),
                    ('đặng m'		,'543-848-8187'	,'email9@gmail.com'		,'hai phong,viet nam');

insert into car (marker		,model					,yearmanufacture			,color)
values 		 	('HONDA'	,'HONDA CRV'			,'2021-01-01'				,'black'),
				('HONDA'	,'HONDA CITY'			,'2021-01-01'				,'red'),
                ('HONDA'	,'HONDA LEGEND'			,'2021-01-01'				,'blue'),
                ('TOYOTA'	,'Toyota Corolla Altis'	,'2020-01-01'				,'black'),
                ('TOYOTA'	,'Toyota Fortuner'		,'2021-01-01'				,'black'),
                ('NISSAN'	,'Nissan GT-R.'			,'2021-01-01'				,'black'),
                ('NISSAN'	,'Nissan Terra'			,'2020-01-01'				,'blue');
insert into carOrder(customerid	,carid	,amount	,saleprice	,orderdate		,deliverydate	,statusorder)
values 				('1'		,'1'	,'1'	,'130.00'	,'2021-05-03'	,'2021-06-06'	,'1'),
					('3'		,'1'	,'1'	,'130.00'	,'2021-05-03'	,'2021-06-06'	,'1'),
                    ('5'		,'1'	,'1'	,'130.00'	,'2021-05-03'	,'2021-06-06'	,'1'),
					('1'		,'4'	,'1'	,'100.00'	,'2020-05-03'	,null			,'2'),
                    ('1'		,'4'	,'2'	,'100.00'	,'2021-06-03'	,'2021-09-20'	,'1'),
                    ('3'		,'7'	,'1'	,'150.00'	,'2021-07-03'	,'2021-01-01'	,'0'),
                    ('4'		,'6'	,'1'	,'90.00'	,'2021-01-01'	,'2021-09-20'	,'1'),
                    ('5'		,'1'	,'1'	,'130.00'	,'2021-05-03'	,'2021-10-06'	,'0');
-- select *from customer;
 select c.marker,sum(amount)as maxamount
 from carorder co
 join car c on co.carid=c.carid
 where co.statusorder='1' and year(co.orderdate)=year(now())
 group by c.marker;
 
-- 2. Viết lệnh lấy ra thông tin của khách hàng: tên, số lượng oto khách hàng đã
--    mua và sắp sếp tăng dần theo số lượng oto đã mua.
select 	c.fullname,
		count(co.customerid)   as quantityBuyCar
from customer c
join carOrder co on c.customerid=co.customerid
where co.statusorder='1' 
group by co.customerid
order by count(co.customerid);

-- 3. Viết hàm (không có parameter) trả về tên hãng sản xuất đã bán được nhiều
 -- oto nhất trong năm nay.
 
 drop function if exists markerMostSold;
 delimiter $$
 create function markerMostSold() returns enum('HONDA','TOYOTA','NISSAN')
 DETERMINISTIC
begin
	declare v_marker enum('HONDA','TOYOTA','NISSAN');
    select c.marker
    into v_marker
    from carorder co
    join car c on c.carid=co.carid
    group by c.marker
    having 	 c.marker=( select marker
						from ( select c.marker,sum(co.amount) as b 
							   from car c
							   join carorder co on c.carid=co.carid
							   where co.statusorder='1' and year(orderdate)=year(now())
							   group by c.marker) as x
						having max(b));-- tạo ra bảng ảo nơi tổng amount bán đc đc của 3 hãng là lớn nhất->để tìm ra marker tương ứng
return v_marker;
end$$
delimiter ;

-- 4. Viết 1 thủ tục (không có parameter) để xóa các đơn hàng đã bị hủy của
--   những năm trước. In ra số lượng bản ghi đã bị xóa.
drop procedure if exists orderCancel;
delimiter $$
create procedure orderCancel()
begin
	select count(orderid) from carorder
    where statusorder='2' and year(orderdate)<year(now());
	delete from carorder
    where statusorder='2' and year(orderdate)<year(now());
end$$
delimiter ;
-- 5. Viết 1 thủ tục (có CustomerID parameter) để in ra thông tin của các đơn
-- hàng đã đặt hàng bao gồm: tên của khách hàng, mã đơn hàng, số lượng oto
-- và tên hãng sản xuất.
drop procedure if exists infoOrder;
delimiter $$
create procedure infoOrder(in customer_id tinyint unsigned)
begin
	select cu.fullname,co.orderid,co.amount,c.marker,co.statusorder 
    from car c
    join carorder co on c.carid=co.carid
    join customer cu on cu.customerid=co.customerid
    where co.statusorder='0' ;
	
end$$
delimiter ;

-- 6. Viết trigger để tránh trường hợp người dụng nhập thông tin không hợp lệ
-- vào database (DeliveryDate < OrderDate + 15).
drop trigger if exists checkDeliveryDate;
DELIMITER $$
CREATE TRIGGER checkDeliveryDate
BEFORE INSERT ON carorder
FOR EACH ROW
BEGIN
	if  new.deliverydate< (new.orderdate+15 )then
    signal sqlstate'12345'
    set message_text='deliverydate khong hop le';
    end if;
END $$
DELIMITER ;
insert into carOrder(customerid	,carid	,amount	,saleprice	,orderdate		,deliverydate	,statusorder)
values 				('1'		,'2'	,'1'	,'110.00'	,'2021-05-03'	,'2021-05-05'	,'0');


