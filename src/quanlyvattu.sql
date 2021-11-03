create database quanlyvattu;
use quanlyvattu;
create table vattu
(
    id_vattu   int primary key not null,
    code_vattu varchar(20),
    name_vattu varchar(20),
    dvi_tinh   varchar(10),
    giatien    float
);
create table tonkho
(
    id_tonkho       int primary key not null,
    id_vattu        int,
    foreign key (id_vattu) references vattu (id_vattu),
    soluongdau      float,
    tongsoluongnhap float,
    tongsoluongxuat float
);
create table nhacungcap
(
    id_nhacungcap   int primary key not null,
    code_nhacungcap varchar(20),
    name_nhacungcap varchar(20),
    add_nhacungcap  varchar(20),
    sdt_nhacungcap  varchar(20)
);
create table dondathang
(
    id_dondathang   int primary key not null,
    code_dondathang varchar(20),
    ngaydathang     date,
    id_nhacungcap   int,
    foreign key (id_nhacungcap) references nhacungcap (id_nhacungcap)
);
create table phieunhap
(
    id_phieunhap   int primary key not null,
    code_phieunhap varchar(20),
    ngaynhap       date,
    id_donhang     int,
    foreign key (id_donhang) references dondathang (id_dondathang)
);

create table phieuxuat
(
    id_phieuxuat   int primary key not null,
    code_phieuxuat varchar(20),
    ngayxuat       date,
    tenkhachhang   varchar(20)
);
create table chitietdonhang
(
    id_chitietdonhang int primary key not null,
    id_donhang        int,
    foreign key (id_donhang) references dondathang (id_dondathang),
    id_vattu          int,
    foreign key (id_vattu) references vattu (id_vattu),
    soluongnhap       int,
    dongianhap        float,
    ghichu            varchar(20)
);
create table chitietphieuxuat
(
    id_chitietphieuxuat int primary key not null,
    id_phieuxuat        int,
    foreign key (id_phieuxuat) references phieuxuat (id_phieuxuat),
    id_vattu            int,
    foreign key (id_vattu) references vattu (id_vattu),
    soluongxuat         int,
    dongiaxuat          float,
    ghichu              varchar(20)
);

# cau1
create view vw_CTPNHAP as
select id_phieunhap, code_vattu, sum(soluongnhap), dongianhap, SUM(soluongnhap * dongianhap) as thanhtiennhap
from chitietphieunhap
         inner join quanlyvattu.vattu v on v.id_vattu = chitietphieunhap.id_vattu
group by code_vattu;

# cau2
create view vw_CTPNHAP_VT as
select id_phieunhap,
       name_vattu,
       code_vattu,
       sum(soluongnhap),
       dongianhap,
       SUM(soluongnhap * dongianhap) as thanhtiennhap
from chitietphieunhap
         join quanlyvattu.vattu v on v.id_vattu = chitietphieunhap.id_vattu
group by name_vattu, code_vattu;

# cau3
create view vw_CTPNHAP_VT_PN as
select phieunhap.id_phieunhap,
       phieunhap.ngaynhap,
       d.id_dondathang
                                        code_vattu,
       name_vattu,
       sum(soluongnhap),
       dongianhap,
       SUM(soluongnhap * dongianhap) as thanhtiennhap
from phieunhap
         inner join chitietphieunhap c on phieunhap.id_phieunhap = c.id_phieunhap
         inner join quanlyvattu.vattu v on c.id_vattu = v.id_vattu
         inner join dondathang d on d.id_dondathang = phieunhap.id_donhang
group by code_vattu;

# cau4
create view vw_CTPNHAP_VT_PN_DN as
select c.id_phieunhap,
       ngaynhap,
       d.id_dondathang,
       v.id_vattu,
       v.name_vattu,
       sum(soluongnhap),
       c.dongianhap,
       sum(soluongnhap * dongianhap)
from phieunhap
        join dondathang d on d.id_dondathang = phieunhap.id_donhang
    join chitietphieunhap c on phieunhap.id_phieunhap = c.id_phieunhap
    join quanlyvattu.vattu v on c.id_vattu = v.id_vattu
group by code_vattu;

# cau5
create view vw_CTPNHAP_loc as
    select c.id_phieunhap,
           code_vattu,
           sum(soluongnhap) soluongnhap,
           dongianhap,
           sum(soluongnhap*dongianhap) thanhtiennhap
           from phieunhap
join dondathang d on d.id_dondathang = phieunhap.id_donhang
join chitietphieunhap c on phieunhap.id_phieunhap = c.id_phieunhap
join quanlyvattu.vattu v on c.id_vattu = v.id_vattu
where soluongnhap> 5
group by code_vattu;

# cau6
create view vw_CTPNHAP_VT_loc as
select c.id_phieunhap,
       code_vattu,
       name_vattu,
       sum(soluongnhap) soluongnhap,
       dongianhap,
       sum(soluongnhap*dongianhap) thanhtiennhap
from phieunhap
         join dondathang d on d.id_dondathang = phieunhap.id_donhang
         join chitietphieunhap c on phieunhap.id_phieunhap = c.id_phieunhap
         join quanlyvattu.vattu v on c.id_vattu = v.id_vattu
where v.dvi_tinh like 'cai'
group by code_vattu;

# cau7
create view vw_CTPXUAT as
    select c.id_phieuxuat,
           code_vattu,
           sum(soluongxuat)soluongxuat,
           dongiaxuat,
           sum(soluongxuat*dongiaxuat) as thanhtienxuat
from phieuxuat
join quanlyvattu.chitietphieuxuat c on phieuxuat.id_phieuxuat = c.id_phieuxuat
join quanlyvattu.vattu v on c.id_vattu = v.id_vattu
group by code_vattu;

# cau8
create view vw_CTPXUAT_VT as
select c.id_phieuxuat,
       code_vattu,
       name_vattu,
       sum(soluongxuat)soluongxuat,
       dongiaxuat
from phieuxuat
         join quanlyvattu.chitietphieuxuat c on phieuxuat.id_phieuxuat = c.id_phieuxuat
         join quanlyvattu.vattu v on c.id_vattu = v.id_vattu
group by code_vattu;

# cau9
create view  vw_CTPXUAT_VT_PX as
select c.id_phieuxuat,
       tenkhachhang
       code_vattu,
       name_vattu,
       sum(soluongxuat)soluongxuat,
       dongiaxuat
from phieuxuat
         join quanlyvattu.chitietphieuxuat c on phieuxuat.id_phieuxuat = c.id_phieuxuat
         join quanlyvattu.vattu v on c.id_vattu = v.id_vattu
group by code_vattu;


# stored procedure

# cau1: Tạo Stored procedure (SP) cho biết tổng số lượng cuối của vật tư với mã vật tư là tham số vào.

create procedure sumOfAmount(
in code_vattu int
)
begin
    select sum(soluongdau+tongsoluongnhap-tongsoluongxuat) as soluongcuoi from tonkho
        where id_vattu = code_vattu;
end;

call sumOfAmount(1);

# cau2: Tạo SP cho biết tổng tiền xuất của vật tư với mã vật tư là tham số vào.

create procedure sumOfOutputMoney(
    in code_vattu varchar(20)
)
begin
    select sum(thanhtienxuat) tongtienxuat from vw_CTPXUAT
    where code_vattu like code_vattu;
end;

call sumOfOutputMoney(1);

# cau3: Tạo SP cho biết tổng số lượng đặt theo số đơn hàng với số đơn hàng là tham số vào

create procedure sumOfOrder(in maDonHang int)
begin
    select id_donhang,sum(soluongdat) from chitietdonhang
    where id_donhang = maDonHang
    group by id_donhang;
end;

call sumOfOrder(1);

# cau4: Tạo SP dùng để thêm một đơn đặt hàng.

create procedure addNewOrder(
in id_donhang int,
in code_donhang varchar(20),
in ngaydat date,
in id_ncc int
)
begin
    insert into dondathang value (id_donhang,code_donhang,ngaydat,id_ncc);
end;

call addNewOrder(4,'DH4',2020/1/2,2);

# cau5: Tạo SP dùng để thêm một chi tiết đơn đặt hàng.

create procedure newOrderDetail(
in id_orderDetail int,
in iddonhang int,
in idvattu int,
in soluong int
)
begin
    insert into chitietdonhang value (id_orderDetail,iddonhang,idvattu,soluong);
end;

call newOrderDetail(7,4,3,100);