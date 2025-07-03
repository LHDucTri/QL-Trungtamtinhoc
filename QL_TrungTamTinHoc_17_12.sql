create database QL_TrungTamTinHoc
GO

use QL_TrungTamTinHoc
GO


-- 1. B?ng H?c Viên 
CREATE TABLE HocVien
(
    MaHV VARCHAR(30) PRIMARY KEY,
    HoTen NVARCHAR(50) NOT NULL,
	Anh VARCHAR(20) NOT NULL DEFAULT 'noimage.jpg',
    NgaySinh DATE NOT NULL,
    GioiTinh NVARCHAR(10) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    SoDT VARCHAR(11) NOT NULL,
    DiaChi NVARCHAR(100) NOT NULL
);
GO



-- 2. B?ng Giáo Viên
CREATE TABLE GiaoVien
(
    MaGV VARCHAR(30) PRIMARY KEY,
    HoTen NVARCHAR(50) NOT NULL,
	Anh VARCHAR(20) NOT NULL DEFAULT 'noimage.jpg',
    NgayVaoLam DATE NOT NULL DEFAULT GETDATE(),
    BangCapGV NVARCHAR(100) NOT NULL DEFAULT N'Chưa cập nhật',
    LinhVucDaoTao NVARCHAR(100) NOT NULL DEFAULT N'Chưa cập nhật',
    Email VARCHAR(50) NOT NULL UNIQUE,
    SoDT VARCHAR(11) NOT NULL,
    DiaChi NVARCHAR(100) NOT NULL,
    Luong FLOAT NOT NULL
);
GO

-- 3. Bảng chương trình học
CREATE TABLE ChuongTrinhHoc
(
	MaChuongTrinh VARCHAR(30) PRIMARY KEY,
	TenChuongTrinh NVARCHAR(50) NOT NULL DEFAULT N'Chưa xác định',
);
GO


-- 4. B?ng Khóa H?c
CREATE TABLE KhoaHoc
(
    MaKH VARCHAR(30) PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
	MoTa NVARCHAR(MAX),
	Anh VARCHAR(20) NOT NULL DEFAULT 'noimage.jpg',
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NULL,
	Sobuoihoc int NOT NULL,
	MaChuongTrinh VARCHAR(30) NOT NULL,
    HocPhi FLOAT NOT NULL,
    LoaiKH NVARCHAR(20) NOT NULL DEFAULT 'Offline',
	FOREIGN KEY (MaChuongTrinh) REFERENCES ChuongTrinhHoc(MaChuongTrinh)
);
GO

-- 5. Bảng lớp học
CREATE TABLE LopHoc
(
    MaLH VARCHAR(30) PRIMARY KEY,
    TenPhong NVARCHAR(100) NOT NULL,
    MaKH VARCHAR(30) NOT NULL,
    SiSo INT NOT NULL,
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
	MaGV VARCHAR(30) NOT NULL,
	TrangThai BIT NOT NULL DEFAULT 0, -- 0 là chưa mở lớp, 1 là đã mở lớp
	ThuHoc VARCHAR(30) NOT NULL,
	FOREIGN KEY (MaGV) REFERENCES GiaoVien(MaGV),
    FOREIGN KEY (MaKH) REFERENCES KhoaHoc(MaKH),
);
GO

-- 6. Bảng chi tiết học viên và lớp học
CREATE TABLE ChiTiet_HocVien_LopHoc
(
	id int identity(1,1),
	MaLH VARCHAR(30),
	MaHV VARCHAR(30),
	DiemKiemTraLan1 FLOAT DEFAULT 0,
	DiemKiemTraLan2 FLOAT DEFAULT 0,
	DiemKiemTraLan3 FLOAT DEFAULT 0,
	DiemTrungBinh AS ( 
        CASE 
            WHEN (DiemKiemTraLan1 + DiemKiemTraLan2 + DiemKiemTraLan3) = 0 THEN NULL
            ELSE (DiemKiemTraLan1 + DiemKiemTraLan2 + DiemKiemTraLan3) / 3 
        END
    ) PERSISTED,
	Sobuoivang INT NOT NULL DEFAULT 0,
	KetQua NVARCHAR(20) NULL,
	ChoPhepNhapDiem BIT DEFAULT 0,
	PRIMARY KEY(id),
    FOREIGN KEY (MaHV) REFERENCES HocVien(MaHV),
    FOREIGN KEY (MaLH) REFERENCES LopHoc(MaLH)
);
GO

CREATE TRIGGER trg_UpdateKetQua
ON ChiTiet_HocVien_LopHoc
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE ChiTiet_HocVien_LopHoc
    SET KetQua = 
        CASE 
			WHEN Sobuoivang > 3 THEN N'Rớt'
            WHEN DiemTrungBinh IS NULL THEN N'Chưa có kết quả'
            WHEN DiemTrungBinh > 7 THEN N'Đậu'
            ELSE N'Rớt'
        END
    WHERE id IN (SELECT id FROM inserted);
END;
GO

-- 7. B?ng Phuong th?c thanh toán
CREATE TABLE PhuongThucThanhToan
(
    MaPT INT PRIMARY KEY,
    TenPT NVARCHAR(100) NOT NULL
);
GO

-- 8. B?ng Tài Kho?n
CREATE TABLE TaiKhoan
(
    MaTK INT IDENTITY(1,1) PRIMARY KEY,
    TenDangNhap VARCHAR(50) NOT NULL UNIQUE,
    MatKhau VARCHAR(max) NOT NULL,
    QuyenHan NVARCHAR(20) NOT NULL,
    MaHV VARCHAR(30) NULL,
    MaGV VARCHAR(30) NULL,
    FOREIGN KEY (MaHV) REFERENCES HocVien(MaHV),
    FOREIGN KEY (MaGV) REFERENCES GiaoVien(MaGV)
);
GO


-- 9. B?ng Giao d?ch h?c phí
CREATE TABLE GiaoDichHocPhi
(
    MaGD INT IDENTITY(1,1) PRIMARY KEY,
    MaHV VARCHAR(30) NULL,
    MaKH VARCHAR(30) NULL,
	MaLH VARCHAR(30) NULL,
    MaPT INT NULL,
    NgayGD DATETIME NULL DEFAULT GETDATE(),
    SoTien FLOAT NULL,
	SoDT VARCHAR(11) NULL,
	Email VARCHAR(50) NULL,
	TrangThai NVARCHAR(50) NULL,
    FOREIGN KEY (MaHV) REFERENCES HocVien(MaHV),
    FOREIGN KEY (MaKH) REFERENCES KhoaHoc(MaKH),
    FOREIGN KEY (MaPT) REFERENCES PhuongThucThanhToan(MaPT),
	FOREIGN KEY (MaLH) REFERENCES LopHoc(MaLH)
);
GO

-- 10. Bảng giảng dạy
CREATE TABLE LichDay
(
    MaLichDay VARCHAR(30) PRIMARY KEY,
    MaGV VARCHAR(30) NOT NULL,
    MaLH VARCHAR(30) NOT NULL,
    NgayDay DATE NOT NULL,
	GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    FOREIGN KEY (MaGV) REFERENCES GiaoVien(MaGV),
    FOREIGN KEY (MaLH) REFERENCES LopHoc(MaLH),
);
GO

-- 11. Bảng giảng dạy
CREATE TABLE LichHoc
(
    MaLichHoc VARCHAR(30) PRIMARY KEY,
    MaHV VARCHAR(30) NOT NULL,
    MaLH VARCHAR(30) NOT NULL,
    NgayHoc DATE NOT NULL,
	DiemDanh BIT NOT NULL DEFAULT 0, -- 0 là có học, 1 là vắng
	GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    FOREIGN KEY (MaHV) REFERENCES HocVien(MaHV),
    FOREIGN KEY (MaLH) REFERENCES LopHoc(MaLH)
);
GO

-- 15. Bảng bình luận khóa học
CREATE TABLE BinhLuanKhoaHoc
(
    MaHV VARCHAR(30) NOT NULL,
    MaKH VARCHAR(30) NOT NULL,
    NoiDung NVARCHAR(MAX),
    NgayBinhLuan DATETIME NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY(MaKH, MaHV, NgayBinhLuan),
    FOREIGN KEY (MaHV) REFERENCES HocVien(MaHV),
    FOREIGN KEY (MaKH) REFERENCES KhoaHoc(MaKH)
);
GO

-- 16. Bảng Tin tức thông báo
CREATE TABLE TinTucThongBao (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Anh NVARCHAR(255) NULL,
    TieuDe NVARCHAR(155) NOT NULL,
    NoiDung NVARCHAR(MAX) NOT NULL,
    LoaiTin NVARCHAR(20) NOT NULL,
    NgayTao DATETIME DEFAULT GETDATE(),
    TrangThai BIT DEFAULT 1, -- 0 là ẩn, 1 là hiện
);

-- 8. Thêm dữ liệu vào Bảng Tài Khoản
INSERT INTO TaiKhoan (TenDangNhap, MatKhau, QuyenHan, MaHV, MaGV) VALUES
('admin', '$2a$12$teqbQ8ZWoEczPWJ8LFm4x.uGXZEEljQBj5MdpWb.M3LfNF5jb0z5q', N'Quản lý', NULL, NULL)


-- 1. Thêm dữ liệu vào Bảng Học Viên
INSERT INTO HocVien (MaHV, HoTen, Anh, NgaySinh, GioiTinh, Email, SoDT, DiaChi) VALUES
('HV001', N'Nguyễn Thị Vân Anh', 'image1.jpg', '2000-01-01', N'Nữ', 'nguyen.vananh@example.com', '0123456789', N'Hà Nội'),
('HV002', N'Dương Ngọc Thủy Trúc', 'image2.jpg', '2001-02-02', N'Nữ', 'duong.thtruc@example.com', '0987654321', N'Đà Nẵng'),
('HV003', N'Huỳnh Tuấn Chí', 'image3.jpg', '1999-03-03', N'Nam', 'huynh.chi@example.com', '0912345678', N'TP Hồ Chí Minh'),
('HV004', N'Đỗ Thanh Ngân', 'image4.jpg', '2002-04-04', N'Nữ', 'do.thngan@example.com', '0981234567', N'Cần Thơ'),
('HV005', N'Đoàn Ngọc Quang', 'image5.jpg', '2003-05-05', N'Nam', 'doan.ngocquang@example.com', '0976543210', N'Hải Phòng'),
('HV006', N'Nguyễn Đỗ Huy', 'image6.jpg', '2003-05-05', N'Nam', 'nguyen.dohuy@example.com', '0976543210', N'Hải Phòng'),
('HV007', N'Bùi Khánh Duy', 'image7.jpg', '2003-08-13', N'Nam', 'e.duy@example.com', '0585089691', N'TP Hồ Chí Minh'),
('HV008', N'Trần Vạn', 'image8.jpg', '2003-01-01', N'Nam', 'tran.van@example.com', '0987000001', N'Hà Nội'),
('HV009', N'Lê Minh Nguyệt', 'image9.jpg', '2002-12-15', N'Nữ', 'le.nguyet@example.com', '0987000002', N'TP Hồ Chí Minh'),
('HV010', N'Đỗ Thanh Lâm', 'image10.jpg', '2001-07-10', N'Nam', 'do.lam@example.com', '0987000003', N'Đà Nẵng'),
('HV011', N'Nguyễn Ngọc Anh Thư', 'image11.jpg', '2000-03-25', N'Nữ', 'nguyen.anhthu@example.com', '0987000004', N'Cần Thơ'),
('HV012', N'Phạm Minh Bảo', 'image12.jpg', '1999-09-09', N'Nam', 'pham.bao@example.com', '0987000005', N'Hải Dương'),
('HV013', N'Vũ Nhật Quỳnh', 'image13.jpg', '1998-05-20', N'Nữ', 'vu.quynh@example.com', '0987000006', N'Hải Phòng'),
('HV014', N'Lê Minh Khôi', 'image14.jpg', '1997-11-30', N'Nam', 'le.mkhoi@example.com', '0987000007', N'Quảng Ninh'),
('HV015', N'Phạm Văn Nam', 'image15.jpg', '1995-01-01', N'Nam', 'pham.vannam@example.com', '0123456781', N'Hà Nội'),
('HV016', N'Nguyễn Thị Thanh Hương', 'image16.jpg', '1996-02-02', N'Nữ', 'nguyen.th.huong@example.com', '0123456782', N'TP Hồ Chí Minh'),
('HV017', N'Võ Minh Tuấn', 'image17.jpg', '1997-03-03', N'Nam', 'vo.minhtuan@example.com', '0123456783', N'Cần Thơ'),
('HV018', N'Lê Ngọc Bảo', 'image18.jpg', '1998-04-04', N'Nam', 'le.ngocbao@example.com', '0123456784', N'Hải Phòng'),
('HV019', N'Trần Thanh Hoa', 'image19.jpg', '1999-05-05', N'Nữ', 'tran.thanhhoa@example.com', '0123456785', N'Đà Nẵng'),
('HV020', N'Đặng Thùy Linh', 'image20.jpg', '2000-06-06', N'Nữ', 'dang.thuylinh@example.com', '0123456786', N'Hà Nội'),
('HV021', N'Phan Nhật Quân', 'image21.jpg', '2001-07-07', N'Nam', 'phan.nhatquan@example.com', '0123456787', N'TP Hồ Chí Minh'),
('HV022', N'Nguyễn Văn Hùng', 'image22.jpg', '2002-08-08', N'Nam', 'nguyen.vanhung@example.com', '0123456788', N'Hải Phòng'),
('HV023', N'Trịnh Xuân Hải', 'image23.jpg', '2003-09-09', N'Nam', 'trinh.xuanhai@example.com', '0123456789', N'Đà Nẵng'),
('HV024', N'Lê Thanh Tùng', 'image24.jpg', '2004-10-10', N'Nam', 'le.thanhtung@example.com', '0987000008', N'Cần Thơ'),
('HV025', N'Nguyễn Thị Mai', 'image25.jpg', '1995-01-01', N'Nữ', 'nguyen.thimai@example.com', '0987000009', N'Hải Phòng'),
('HV026', N'Trương Văn Phúc', 'image26.jpg', '1996-02-02', N'Nam', 'truong.vanphuc@example.com', '0987000010', N'TP Hồ Chí Minh'),
('HV027', N'Lê Hoàng Mai', 'image27.jpg', '1997-03-03', N'Nữ', 'le.hoangmai@example.com', '0987000011', N'Đà Nẵng'),
('HV028', N'Phạm Quốc Huy', 'image28.jpg', '1998-04-04', N'Nam', 'pham.quochoan@example.com', '0987000012', N'Cần Thơ'),
('HV029', N'Trần Xuân Hòa', 'image29.jpg', '1999-05-05', N'Nữ', 'tran.xuanhoa@example.com', '0987000013', N'Hà Nội'),
('HV030', N'Nguyễn Minh Hà', 'image30.jpg', '2000-06-06', N'Nam', 'nguyen.minhha@example.com', '0987000014', N'TP Hồ Chí Minh'),
('HV031', N'Trịnh Văn Cường', 'image31.jpg', '2001-07-07', N'Nam', 'trinh.vancuong@example.com', '0987000015', N'Hải Phòng'),
('HV032', N'Vũ Hải Anh', 'image32.jpg', '2002-08-08', N'Nữ', 'vu.haianh@example.com', '0987000016', N'Đà Nẵng'),
('HV033', N'Nguyễn Hữu Tài', 'image33.jpg', '2003-09-09', N'Nam', 'nguyen.huutai@example.com', '0987000017', N'Cần Thơ'),
('HV034', N'Phạm Quang Minh', 'image34.jpg', '1995-01-01', N'Nam', 'pham.quangminh@example.com', '0987000018', N'Hà Nội'),
('HV035', N'Trần Bảo Khánh', 'image35.jpg', '1996-02-02', N'Nữ', 'tran.baokhanh@example.com', '0987000019', N'TP Hồ Chí Minh'),
('HV036', N'Nguyễn Thị Quỳnh', 'image36.jpg', '1997-03-03', N'Nữ', 'nguyen.thiquynh@example.com', '0987000020', N'Hải Phòng'),
('HV037', N'Lê Quốc Cường', 'image37.jpg', '1998-04-04', N'Nam', 'le.quoccuong@example.com', '0987000021', N'Cần Thơ'),
('HV038', N'Vũ Thị Anh Đào', 'image38.jpg', '1999-05-05', N'Nữ', 'vu.thianhdao@example.com', '0987000022', N'Đà Nẵng'),
('HV039', N'Nguyễn Đình Toàn', 'image39.jpg', '2000-06-06', N'Nam', 'nguyen.dinhtoan@example.com', '0987000023', N'TP Hồ Chí Minh'),
('HV040', N'Lê Quang Phát', 'image40.jpg', '2001-07-07', N'Nam', 'le.quangphat@example.com', '0987000024', N'Hà Nội'),
('HV041', N'Trịnh Thanh Bình', 'image41.jpg', '2002-08-08', N'Nữ', 'trinh.thanhbinh@example.com', '0987000025', N'Hải Phòng'),
('HV042', N'Phạm Quốc Toàn', 'image42.jpg', '2003-09-09', N'Nam', 'pham.quoctoan@example.com', '0987000026', N'Cần Thơ'),
('HV043', N'Trương Thị Minh', 'image43.jpg', '1995-01-01', N'Nữ', 'truong.thiminh@example.com', '0987000027', N'Hải Dương'),
('HV044', N'Nguyễn Thế Anh', 'image44.jpg', '1996-02-02', N'Nam', 'nguyen.theanh@example.com', '0987000028', N'TP Hồ Chí Minh'),
('HV045', N'Phạm Thuỳ Dung', 'image45.jpg', '1997-03-03', N'Nữ', 'pham.thuydung@example.com', '0987000029', N'Hà Nội'),
('HV046', N'Trần Đình Nam', 'image46.jpg', '1998-04-04', N'Nam', 'tran.dinhnam@example.com', '0987000030', N'TP Hồ Chí Minh'),
('HV047', N'Nguyễn Thanh Trúc', 'image47.jpg', '1999-05-05', N'Nữ', 'nguyen.thanhtruc@example.com', '0987000031', N'Cần Thơ'),
('HV048', N'Lê Quang Khải', 'image48.jpg', '2000-06-06', N'Nam', 'le.quangkhai@example.com', '0987000032', N'Hà Nội'),
('HV049', N'Phan Hữu Phước', 'image49.jpg', '2001-07-07', N'Nam', 'phan.huuphuoc@example.com', '0987000033', N'TP Hồ Chí Minh'),
('HV050', N'Trương Văn Phát', 'image50.jpg', '2002-08-08', N'Nam', 'truong.vanphat@example.com', '0987000034', N'Đà Nẵng');
GO

-- 2. Thêm dữ liệu vào Bảng Giáo Viên
INSERT INTO GiaoVien (MaGV, HoTen, Anh, NgayVaoLam, BangCapGV, LinhVucDaoTao, Email, SoDT, DiaChi, Luong) VALUES
('GV001', N'Nguyễn Minh Trung', 'image6.jpg', '2020-01-01', N'Tin học', N'Thạc sĩ', 'nguyen.trung@example.com', '0123456789', N'Hà Nội', 10000),
('GV002', N'Nguyễn Xuân Hạnh', 'image7.jpg', '2019-02-02', N'Ngoại ngữ', N'Tiến sĩ', 'nguyen.hanh@example.com', '0987654321', N'Đà Nẵng', 15000),
('GV003', N'Lê Minh Thành', 'image8.jpg', '2021-03-03',  N'Toán học', N'Thạc sĩ', 'h.le@example.com', '0912345678', N'TP Hồ Chí Minh', 12000),
('GV004', N'Nguyễn Kim Long', 'image9.jpg', '2018-04-04',  N'Lập trình', N'Thạc sĩ', 'nguyen.long@example.com', '0981234567', N'Cần Thơ', 13000),
('GV005', N'Trần Thị Minh Ngọc', 'image10.jpg', '2022-05-05',  N'Lập trình', N'Tiến sĩ', 'tran.minhngoc@example.com', '0976543210', N'Hải Phòng', 11000),
('GV006', N'Đào Duy Thanh', 'image11.jpg', '2021-07-25',  N'Thiết kế', N'Tiến sĩ', 'dao.thanh@example.com', '0987991872', N'Nha Trang', 9000),
('GV007', N'Phạm Minh Nhật', 'image12.jpg', '2020-06-14',  N'Dữ liệu', N'Tiến sĩ', 'pham.nhat@example.com', '0987691285', N'Quảng Nam', 11500),
('GV008', N'Trần Thị Thu', 'image13.jpg', '2022-09-11',  N'Ngoại ngữ', N'Tiến sĩ', 'tran.thithu@example.com', '0985719205', N'Quy Nhơn', 7000),
('GV009', N'Hoàng Văn Bảo', 'image14.jpg', '2020-07-15', N'Tin học', N'Tiến sĩ', 'hoang.bao@example.com', '0912233445', N'Bình Dương', 10500),
('GV010', N'Nguyễn Hồng Lan', 'image15.jpg', '2021-01-18', N'Thiết kế', N'Thạc sĩ', 'nguyen.lan@example.com', '0983234567', N'Hà Nội', 11000),
('GV011', N'Phạm Quang Hưng', 'image16.jpg', '2020-03-10', N'Toán học', N'Tiến sĩ', 'pham.hung@example.com', '0972233445', N'Bắc Ninh', 12000),
('GV012', N'Lê Thị Minh Anh', 'image17.jpg', '2019-04-22', N'Dữ liệu', N'Thạc sĩ', 'le.minhanh@example.com', '0912345678', N'Hồ Chí Minh', 13000),
('GV013', N'Trương Văn Hải', 'image18.jpg', '2022-05-12', N'Lập trình', N'Thạc sĩ', 'truong.hai@example.com', '0965654343', N'Đồng Nai', 9500),
('GV014', N'Trần Thị Thuỷ', 'image19.jpg', '2020-09-10', N'Ngoại ngữ', N'Tiến sĩ', 'tran.thuy@example.com', '0911122334', N'Hà Tĩnh', 9000),
('GV015', N'Nguyễn Văn An', 'image20.jpg', '2021-11-15', N'Thiết kế', N'Thạc sĩ', 'nguyen.an@example.com', '0909876543', N'Huế', 9800),
('GV016', N'Vũ Thị Hương', 'image21.jpg', '2023-02-22', N'Ngoại ngữ', N'Thạc sĩ', 'vu.huong@example.com', '0912123456', N'Bình Thuận', 10200),
('GV017', N'Hoàng Minh Triết', 'image22.jpg', '2020-06-30', N'Toán học', N'Thạc sĩ', 'hoang.triet@example.com', '0988887766', N'Quảng Ninh', 10400),
('GV018', N'Trịnh Thị Hà', 'image23.jpg', '2020-08-18', N'Dữ liệu', N'Thạc sĩ', 'trinh.ha@example.com', '0912348789', N'Hải Phòng', 11700),
('GV019', N'Phan Quang Vinh', 'image24.jpg', '2021-03-19', N'Tin học', N'Thạc sĩ', 'phan.vinh@example.com', '0909777732', N'Hải Dương', 11500),
('GV020', N'Ngô Thanh Hà', 'image25.jpg', '2022-05-07', N'Lập trình', N'Tiến sĩ', 'ngo.ha@example.com', '0977432123', N'Quảng Nam', 11000),
('GV021', N'Trần Văn Kiệt', 'image26.jpg', '2021-06-20', N'Toán học', N'Thạc sĩ', 'tran.kiet@example.com', '0912324232', N'Nha Trang', 11500),
('GV022', N'Nguyễn Văn Bình', 'image27.jpg', '2022-10-12', N'Tin học', N'Thạc sĩ', 'nguyen.binh@example.com', '0914543231', N'Hà Giang', 10700),
('GV023', N'Trương Thị Hương Giang', 'image28.jpg', '2020-11-17', N'Thiết kế', N'Thạc sĩ', 'truong.giang@example.com', '0977655432', N'Lạng Sơn', 9800);


-- 3. Thêm dữ liệu vào Bảng Chương Trình Học
INSERT INTO ChuongTrinhHoc (MaChuongTrinh, TenChuongTrinh) VALUES
('CT001', N'Thiết kế'),
('CT002', N'Lập trình cơ bản'),
('CT003', N'Data Analytics'),
('CT004', N'Trí tuệ nhân tạo'),
('CT005', N'Tin học văn phòng'),
('CT006', N'Kiểm định phần mềm');

--=====================================================================================================================================
--=================================== Chạy TinhNgayKetThuc trước rồi mới thêm dữ liệu =================================================
--=====================================================================================================================================

-- Tính ngày kết thúc của khóa học dựa vào ngày bắt đầu và số buổi học
CREATE FUNCTION TinhNgayKetThuc(@NgayBatDau DATE, @SoBuoiHoc INT, @ThuHoc NVARCHAR(10))
RETURNS DATE
AS
BEGIN
    DECLARE @Buoi INT = 0
    DECLARE @NgayHienTai DATE = @NgayBatDau
    DECLARE @ThuHocs TABLE (Thu INT)
    
    IF @ThuHoc = '2-4-6'
        INSERT INTO @ThuHocs VALUES (2), (4), (6)
    ELSE IF @ThuHoc = '3-5-7'
        INSERT INTO @ThuHocs VALUES (3), (5), (7)

    WHILE @Buoi < @SoBuoiHoc
    BEGIN
        IF EXISTS (SELECT 1 FROM @ThuHocs WHERE Thu = DATEPART(WEEKDAY, @NgayHienTai))
        BEGIN
            SET @Buoi += 1
        END

        SET @NgayHienTai = DATEADD(DAY, 1, @NgayHienTai)
    END

    RETURN DATEADD(DAY, -1, @NgayHienTai)
END
GO


-- 4. Thêm dữ liệu vào Bảng Khóa Học
INSERT INTO KhoaHoc (MaKH, TenKH, MoTa, Anh, NgayBatDau, NgayKetThuc, Sobuoihoc, MaChuongTrinh, HocPhi, LoaiKH) VALUES
('KH001', N'Chuyên viên Thiết kế Đồ họa và Web', N'Khóa học Chuyên viên Thiết kế Đồ họa và Web là một chương trình đào tạo toàn diện, trang bị cho bạn những kiến thức và kỹ năng cần thiết để trở thành một nhà thiết kế đa năng, có thể hoạt động linh hoạt trong cả hai lĩnh vực đồ họa và thiết kế web.', 'kh1.jpg', '2024-01-01', NULL, 10, 'CT001', 5530000, 'Offline'),
('KH002', N'Chuyên viên Thiết kế Đồ họa và Nội thất', N'Khóa học Chuyên viên Thiết kế Đồ họa và Nội thất là một chương trình đào tạo toàn diện, trang bị cho bạn những kiến thức và kỹ năng cần thiết để trở thành một nhà thiết kế đa năng, có thể hoạt động linh hoạt trong cả hai lĩnh vực đồ họa và nội thất.', 'kh2.jpg', '2024-02-01', NULL, 10, 'CT001', 5700000, 'Offline'),
('KH003', N'Chuyên viên Thiết kế Đồ họa và Motion Graphic', N'Khóa học Chuyên viên Thiết kế Đồ họa và Motion Graphic là một chương trình đào tạo chuyên sâu, giúp bạn trang bị đầy đủ kiến thức và kỹ năng để trở thành một nhà thiết kế đồ họa đa năng. Khóa học kết hợp cả hai lĩnh vực thiết kế đồ họa tĩnh và động, mở ra cho bạn những cơ hội nghề nghiệp rộng mở trong ngành sáng tạo.', 'kh3.jpg', '2024-03-01', NULL, 15, 'CT001', 7890000, 'Offline'),
('KH004', N'Chuyên viên Thiết kế Đồ họa và Digital Painting', N'Khóa học Chuyên viên Thiết kế Đồ họa và Digital Painting sẽ trang bị cho bạn những kiến thức và kỹ năng toàn diện để trở thành một nhà thiết kế đồ họa chuyên nghiệp. Bạn sẽ được học cách sử dụng các phần mềm đồ họa chuyên dụng, rèn luyện khả năng sáng tạo và kỹ năng giải quyết vấn đề để tạo ra những tác phẩm thiết kế ấn tượng và độc đáo.	', 'kh4.jpg', '2024-04-01', NULL, 10, 'CT001', 9590000, 'Offline'),
('KH005', N'Kỹ thuật viên Thiết kế Đồ họa 2D', N'Khóa học Kỹ thuật viên Thiết kế Đồ họa 2D sẽ trang bị cho bạn những kiến thức và kỹ năng cần thiết để tạo ra các hình ảnh, biểu tượng, logo, và các ấn phẩm thiết kế khác trên máy tính. Bạn sẽ học cách sử dụng các phần mềm đồ họa chuyên dụng như Adobe Photoshop, Illustrator để biến những ý tưởng sáng tạo của mình thành hiện thực.', 'kh5.jpg', '2024-05-01', NULL, 15, 'CT001', 9100000, 'Offline'),
('KH006', N'Kỹ thuật viên Thiết kế Đồ họa chuyên nghiệp', N'Khóa học Kỹ thuật viên Thiết kế Đồ họa Chuyên nghiệp sẽ trang bị cho bạn một hành trang kiến thức và kỹ năng toàn diện để trở thành một nhà thiết kế đồ họa thực thụ. Khóa học không chỉ tập trung vào việc làm quen với các phần mềm thiết kế mà còn đào sâu vào các nguyên tắc thiết kế, tư duy sáng tạo và các kỹ năng cần thiết để tạo ra những sản phẩm đồ họa chất lượng cao, đáp ứng được yêu cầu của thị trường.', 'kh6.jpg', '2024-06-01', NULL, 10, 'CT001', 10900000, 'Offline'),
('KH007', N'Kỹ thuật viên Thiết kế Hệ thống nhận dạng thương hiệu', N'Khóa học Kỹ thuật viên Thiết kế Hệ thống Nhận dạng Thương hiệu sẽ trang bị cho bạn những kiến thức và kỹ năng chuyên sâu để xây dựng một hệ thống nhận diện thương hiệu hoàn chỉnh và chuyên nghiệp. Bạn sẽ học cách tạo ra một bộ nhận diện thương hiệu độc đáo, nhất quán và gây ấn tượng mạnh mẽ, giúp thương hiệu của bạn nổi bật và ghi dấu trong tâm trí khách hàng.', 'kh7.jpg', '2024-07-01', NULL, 15, 'CT001', 6890000, 'Offline'),
('KH008', N'Kỹ thuật viên Digital Painting', N'Khóa học Kỹ thuật viên Digital Painting sẽ đưa bạn vào thế giới nghệ thuật số, nơi bạn sẽ học cách tạo ra những tác phẩm hội họa tuyệt đẹp hoàn toàn trên máy tính. Thay vì sử dụng cọ vẽ và màu truyền thống, bạn sẽ sử dụng bảng vẽ điện tử và các phần mềm đồ họa chuyên dụng để vẽ, tô màu và tạo hiệu ứng.', 'kh8.jpg', '2024-08-01', NULL, 15, 'CT001', 7000000, 'Offline'),
('KH009', N'Kỹ thuật viên Thiết kế 3D Nội thất', N'Khóa học Kỹ thuật viên Thiết kế 3D Nội thất sẽ trang bị cho bạn những kỹ năng cần thiết để tạo ra các bản thiết kế nội thất sống động và chân thực trên máy tính. Bạn sẽ học cách sử dụng các phần mềm thiết kế 3D chuyên dụng để hình dung không gian sống một cách trực quan, từ đó giúp khách hàng dễ dàng hình dung và đưa ra quyết định.', 'kh9.jpg', '2024-09-01', NULL, 15, 'CT001', 8990000, 'Offline'),
('KH010', N'Kỹ thuật viên 2D Motion Graphic', N'Khóa học Kỹ thuật viên 2D Motion Graphic sẽ trang bị cho bạn những kiến thức và kỹ năng cần thiết để tạo ra các đoạn video động, bắt mắt và chuyên nghiệp bằng các phần mềm đồ họa chuyên dụng. Bạn sẽ học cách tạo ra các hiệu ứng chuyển động, hình ảnh động, và các đoạn video ngắn để sử dụng trong quảng cáo, giới thiệu sản phẩm, hoặc các dự án sáng tạo khác.', 'kh10.jpg', '2024-10-01', NULL, 10, 'CT001', 9500000, 'Offline'),
('KH011', N'Kỹ năng thiết kế Đồ họa', N'Khóa học Kỹ năng Thiết kế Đồ họa sẽ trang bị cho bạn những kiến thức và kỹ năng cần thiết để tạo ra những sản phẩm đồ họa chuyên nghiệp, từ những thiết kế đơn giản đến phức tạp. Bạn sẽ học cách sử dụng các phần mềm đồ họa chuyên dụng, nắm vững các nguyên tắc thiết kế và phát triển khả năng sáng tạo của mình.', 'kh11.jpg', '2024-11-01', NULL, 10, 'CT001', 9500000, 'Offline'),
('KH012', N'Thiết kế đồ họa nâng cao', N'Khóa học Thiết kế Đồ họa Nâng Cao được thiết kế dành cho những người đã có nền tảng cơ bản về thiết kế đồ họa và muốn nâng cao kỹ năng của mình lên một tầm cao mới. Khóa học sẽ giúp bạn khám phá sâu hơn về các nguyên tắc thiết kế, các công cụ chuyên dụng và các kỹ thuật phức tạp hơn, từ đó tạo ra những sản phẩm thiết kế độc đáo, sáng tạo và chuyên nghiệp.', 'kh12.jpg', '2024-12-01', NULL, 10, 'CT001', 10000000, 'Offline'),
('KH013', N'Data Analytics Certificate', N'Chứng chỉ Phân tích Dữ liệu là một bằng cấp chứng nhận bạn đã có khả năng thu thập, làm sạch, phân tích và trực quan hóa dữ liệu để đưa ra những quyết định kinh doanh sáng suốt. Khóa học này sẽ trang bị cho bạn những kiến thức và kỹ năng cần thiết để trở thành một nhà phân tích dữ liệu chuyên nghiệp.', 'kh13.jpg', '2025-01-01', NULL, 15, 'CT003', 6500000, 'Offline'),
('KH014', N'Lập trình di động đa nền tảng với Flutter', N'Flutter là một bộ công cụ phát triển ứng dụng di động đa nền tảng mã nguồn mở do Google phát triển. Nó cho phép các nhà phát triển xây dựng các ứng dụng chất lượng cao, chạy mượt mà trên cả hai hệ điều hành Android và iOS với cùng một codebase.', 'kh14.jpg', '2025-02-01', NULL, 10, 'CT002', 7700000, 'Offline'),
('KH015', N'Data Science and Machine Learning Certificate', N'Chứng chỉ Khoa học Dữ liệu và Học Máy là một bằng cấp chứng nhận bạn đã có khả năng áp dụng các kỹ thuật học máy để khám phá, phân tích và rút ra những thông tin giá trị từ lượng lớn dữ liệu. Khóa học này kết hợp cả kiến thức lý thuyết và thực hành, giúp bạn trở thành một nhà khoa học dữ liệu chuyên nghiệp.', 'kh15.jpg', '2025-03-01', NULL, 15, 'CT004', 9000000, 'Offline'),
('KH016', N'Artificial Intelligence and Applications for Business', N'"Thủ lĩnh Công nghệ Tương lai: Khám phá và Ứng dụng Trí tuệ Nhân tạo trong Doanh nghiệp" Khóa học này sẽ trang bị cho bạn hành trang để trở thành người dẫn đầu trong kỷ nguyên số. Bạn sẽ học cách tận dụng sức mạnh của AI để tối ưu hóa quy trình, nâng cao hiệu quả kinh doanh và tạo ra những sản phẩm dịch vụ đột phá. Qua các bài giảng lý thuyết và thực hành, bạn sẽ được trang bị kiến thức về các thuật toán học máy, công cụ AI phổ biến và cách áp dụng chúng vào các vấn đề kinh doanh thực tế."', 'kh16.jpg', '2025-04-01',NULL, 15, 'CT004', 15990000, 'Offline'),
('KH017', N'Master DevOps Engineer', N'Khóa học Master DevOps Engineer là một chương trình đào tạo chuyên sâu, trang bị cho bạn những kiến thức và kỹ năng toàn diện để trở thành một chuyên gia DevOps. Khóa học này tập trung vào việc giúp bạn làm chủ quy trình phát triển phần mềm từ khâu viết code đến khi đưa sản phẩm ra thị trường một cách nhanh chóng, ổn định và hiệu quả.', 'kh17.jpg', '2025-05-01', NULL, 10, 'CT002', 9990000, 'Offline'),
('KH018', N'Lập trình Game AI', N'Lập trình Game AI là một lĩnh vực hấp dẫn kết hợp giữa lập trình và trí tuệ nhân tạo, cho phép tạo ra những trò chơi điện tử thông minh và sống động hơn. Khóa học này sẽ giúp bạn trang bị những kiến thức và kỹ năng cần thiết để phát triển các đối thủ AI thông minh, các hệ thống vật lý phức tạp, và các trải nghiệm chơi game hấp dẫn.', 'kh18.jpg', '2025-06-01',NULL, 15, 'CT004', 11500000, 'Offline'),
('KH019', N'Ứng dụng Công nghệ thông tin cơ bản', N'Khóa học Ứng dụng Công nghệ Thông tin Cơ bản là một chương trình đào tạo giúp người học nắm vững những kiến thức và kỹ năng cơ bản về máy tính và các phần mềm ứng dụng phổ biến. Khóa học này thường được thiết kế dành cho những người mới bắt đầu, những người muốn làm quen với máy tính hoặc nâng cao hiểu biết về công nghệ thông tin để phục vụ cho công việc và cuộc sống hàng ngày.', 'kh19.jpg', '2025-07-01', NULL, 10, 'CT005', 3190000, 'Offline'),
('KH020', N'Kỹ thuật viên Thiết kế Website', N'Khóa học Kỹ thuật viên Thiết kế Website sẽ trang bị cho bạn những kiến thức và kỹ năng cần thiết để tạo ra các trang web chuyên nghiệp, đáp ứng nhu cầu của người dùng và phù hợp với xu hướng hiện đại.', 'kh20.jpg', '2025-08-01', NULL, 10, 'CT001', 11000000, 'Offline'),
('KH021', N'THVP chuẩn Quốc tế MOS Powerpoint', N'Khóa học THVP chuẩn Quốc tế MOS PowerPoint là một chương trình đào tạo chuyên sâu, giúp bạn nắm vững các kỹ năng sử dụng phần mềm PowerPoint một cách chuyên nghiệp và đạt được chứng chỉ MOS (Microsoft Office Specialist) PowerPoint. Chứng chỉ MOS được công nhận trên toàn thế giới và là một bằng chứng chứng tỏ khả năng sử dụng thành thạo PowerPoint của bạn.', 'kh21.jpg', '2025-09-01', NULL, 15, 'CT005', 3990000, 'Offline'),
('KH022', N'Lập trình Android', N'Lập trình Android là một khóa học giúp bạn trang bị những kiến thức và kỹ năng cần thiết để phát triển các ứng dụng di động chạy trên hệ điều hành Android. Với sự phổ biến của điện thoại thông minh và máy tính bảng, nhu cầu về các ứng dụng Android ngày càng tăng cao, tạo ra nhiều cơ hội việc làm hấp dẫn cho các nhà phát triển.', 'kh22.jpg', '2025-10-01', NULL, 10, 'CT002', 7550000, 'Offline'),
('KH023', N'Lập trình viên cơ bản Java', N'Khóa học Lập trình viên Java Cơ bản là một chương trình đào tạo giúp bạn làm quen với ngôn ngữ lập trình Java, một trong những ngôn ngữ lập trình phổ biến và mạnh mẽ nhất hiện nay. Khóa học này sẽ cung cấp cho bạn nền tảng kiến thức vững chắc để bắt đầu sự nghiệp trong lĩnh vực phát triển phần mềm.', 'kh23.jpg', '2025-11-01', NULL, 10, 'CT002', 6190000, 'Offline'),
('KH024', N'Kiểm thử phần mềm cơ bản', N'Kiểm thử phần mềm cơ bản là khóa học giúp bạn hiểu rõ về quy trình, kỹ thuật và các khái niệm nền tảng trong lĩnh vực kiểm thử phần mềm. Khóa học này sẽ trang bị cho bạn những kiến thức và kỹ năng cần thiết để phát hiện và báo cáo lỗi trong phần mềm, đảm bảo chất lượng sản phẩm trước khi đưa ra thị trường.', 'kh24.jpg', '2024-05-01', NULL, 15, 'CT006', 5990000, 'Offline'),
('KH025', N'Lập trình .NET', N'Khóa học lập trình .NET là một chương trình đào tạo chuyên sâu giúp bạn làm chủ nền tảng phát triển phần mềm đa năng và mạnh mẽ của Microsoft. Với .NET, bạn có thể xây dựng các ứng dụng web, ứng dụng desktop, ứng dụng di động và nhiều hơn nữa.', 'kh25.jpg', '2024-05-01', NULL, 10, 'CT002', 7990000, 'Offline'),
('KH026', N'SQL for Data Analytics', N'SQL for Data Analytics là một khóa học chuyên sâu tập trung vào việc sử dụng ngôn ngữ truy vấn có cấu trúc (Structured Query Language - SQL) để khai thác, phân tích và trích xuất thông tin hữu ích từ các cơ sở dữ liệu. Khóa học này là nền tảng không thể thiếu cho bất kỳ ai muốn làm việc trong lĩnh vực phân tích dữ liệu, khoa học dữ liệu hay bất kỳ ngành nghề nào liên quan đến xử lý dữ liệu lớn.', 'kh26.jpg', '2024-05-01', NULL, 15, 'CT003', 4300000, 'Offline'),
('KH027', N'Lập trình Python cơ bản', N'Khóa học lập trình Python cơ bản là một chương trình đào tạo giúp bạn làm quen với ngôn ngữ lập trình Python, một trong những ngôn ngữ phổ biến và dễ học nhất hiện nay. Khóa học này sẽ cung cấp cho bạn nền tảng kiến thức vững chắc để bắt đầu hành trình trở thành một lập trình viên Python.', 'kh27.jpg', '2024-05-01', NULL, 10, 'CT002', 7550000, 'Offline')

---- Update tính ngày kết thúc khóa học
--UPDATE KhoaHoc
--SET NgayKetThuc = dbo.TinhNgayKetThuc(K.NgayBatDau, K.SoBuoiHoc, L.ThuHoc)
--FROM KhoaHoc K
--JOIN LopHoc L ON K.MaKH = L.MaKH
--WHERE K.NgayKetThuc IS NULL 
--   OR K.NgayKetThuc <> dbo.TinhNgayKetThuc(K.NgayBatDau, K.SoBuoiHoc, L.ThuHoc)
--GO






-- 5. Thêm dữ liệu vào Bảng Lớp Học
INSERT INTO LopHoc (MaLH, TenPhong, MaKH, SiSo, GioBatDau, GioKetThuc, MaGV, TrangThai,ThuHoc) VALUES
('LH050', N'B101', 'KH002', 20, '08:00', '10:00', 'GV006', 0, '3-5-7'),
('LH051', N'A101', 'KH001', 20, '08:00', '10:00', 'GV001',0, '3-5-7'),

('LH002', N'A102', 'KH001', 20, '09:00', '11:00', 'GV002', 0, '2-4-6'),
('LH003', N'A103', 'KH001', 20, '13:00', '15:00', 'GV003', 0, '3-5-7'),
('LH004', N'A104', 'KH001', 20, '15:00', '17:00', 'GV004', 0, '2-4-6'),

('LH006', N'B101', 'KH002', 20, '08:00', '10:00', 'GV006', 0, '2-4-6'),
('LH007', N'B102', 'KH002', 20, '09:00', '11:00', 'GV007', 0, '3-5-7'),
('LH008', N'B103', 'KH002', 20, '13:00', '15:00', 'GV008', 0, '3-5-7'),
('LH009', N'B104', 'KH002', 20, '15:00', '17:00', 'GV009', 0, '2-4-6'),

('LH010', N'C101', 'KH003', 20, '08:00', '10:00', 'GV010', 0, '2-4-6'),
('LH011', N'C102', 'KH003', 20, '09:00', '11:00', 'GV011', 0, '3-5-7'),
('LH012', N'C103', 'KH003', 20, '13:00', '15:00', 'GV012', 0, '2-4-6'),
('LH013', N'C104', 'KH003', 20, '15:00', '17:00', 'GV013', 0, '3-5-7'),

('LH014', N'D101', 'KH004', 25, '08:00', '10:00', 'GV014', 0, '2-4-6'),
('LH015', N'D102', 'KH004', 20, '10:00', '12:00', 'GV015', 0, '2-4-6'),
('LH016', N'D103', 'KH004', 20, '13:00', '15:00', 'GV016', 0, '3-5-7'),
('LH017', N'D104', 'KH004', 20, '15:00', '17:00', 'GV017', 0, '3-5-7'),

('LH018', N'E101', 'KH005', 20, '08:00', '10:00', 'GV018', 0, '2-4-6'),
('LH019', N'E102', 'KH005', 20, '10:00', '12:00', 'GV019', 0, '3-5-7'),
('LH020', N'E103', 'KH005', 20, '13:00', '15:00', 'GV020', 0, '3-5-7'),
('LH021', N'E104', 'KH005', 20, '15:00', '17:00', 'GV021', 0, '2-4-6'),

('LH022', N'F101', 'KH006', 25, '08:00', '10:00', 'GV022', 0, '2-4-6'),
('LH023', N'F102', 'KH006', 20, '10:00', '12:00', 'GV023', 0, '3-5-7'),
('LH024', N'F103', 'KH006', 20, '13:00', '15:00', 'GV001', 0, '3-5-7'),
('LH025', N'F104', 'KH006', 20, '15:00', '17:00', 'GV002', 0, '2-4-6'),

('LH026', N'G101', 'KH007', 20, '08:00', '10:00', 'GV003', 0, '2-4-6'),
('LH027', N'G102', 'KH007', 20, '10:00', '12:00', 'GV004', 0, '3-5-7'),
('LH028', N'G103', 'KH007', 20, '13:00', '15:00', 'GV005', 0, '3-5-7'),
('LH029', N'G104', 'KH007', 20, '15:00', '17:00', 'GV006', 0, '2-4-6'),

('LH030', N'H101', 'KH008', 20, '08:00', '10:00', 'GV007', 0, '2-4-6'),
('LH031', N'H102', 'KH008', 20, '10:00', '12:00', 'GV008', 0, '3-5-7'),
('LH032', N'H103', 'KH008', 20, '13:00', '15:00', 'GV009', 0, '3-5-7'),
('LH033', N'H104', 'KH008', 20, '15:00', '17:00', 'GV010', 0, '2-4-6'),

('LH034', N'I101', 'KH009', 20, '08:00', '10:00', 'GV011', 0, '2-4-6'),
('LH035', N'I102', 'KH009', 20, '10:00', '12:00', 'GV012', 0, '3-5-7'),
('LH036', N'I103', 'KH009', 20, '13:00', '15:00', 'GV013', 0, '3-5-7'),
('LH037', N'I104', 'KH009', 20, '15:00', '17:00', 'GV014', 0, '2-4-6'),

('LH038', N'J101', 'KH010', 20, '08:00', '10:00', 'GV015', 0, '2-4-6'),
('LH039', N'J102', 'KH010', 20, '10:00', '12:00', 'GV016', 0, '3-5-7'),
('LH040', N'J103', 'KH010', 20, '13:00', '15:00', 'GV017', 0, '3-5-7'),
('LH041', N'J104', 'KH010', 20, '15:00', '17:00', 'GV018', 0, '2-4-6'),

('LH042', N'K101', 'KH011', 20, '08:00', '10:00', 'GV019', 0, '2-4-6'),
('LH043', N'K102', 'KH011', 20, '10:00', '12:00', 'GV020', 0, '3-5-7'),
('LH044', N'K103', 'KH011', 20, '13:00', '15:00', 'GV021', 0, '3-5-7'),
('LH045', N'K104', 'KH011', 20, '15:00', '17:00', 'GV022', 0, '2-4-6'),

('LH046', N'L101', 'KH012', 20, '08:00', '10:00', 'GV023', 0, '2-4-6'),
('LH047', N'L102', 'KH012', 20, '10:00', '12:00', 'GV001', 0, '3-5-7'),
('LH048', N'L103', 'KH012', 20, '13:00', '15:00', 'GV002', 0, '3-5-7'),
('LH049', N'L104', 'KH012', 20, '15:00', '17:00', 'GV003', 0, '2-4-6');




--===========================================================================================================================

-- 7. Thêm dữ liệu vào Bảng Phương Thức Thanh Toán
INSERT INTO PhuongThucThanhToan (MaPT, TenPT) VALUES
('001', N'Thanh toán chuyển khoản'),
('002', N'Thanh toán tiền mặt');




INSERT INTO TaiKhoan (TenDangNhap, MatKhau, QuyenHan, MaHV, MaGV) VALUES
('user1', '$2a$12$teqbQ8ZWoEczPWJ8LFm4x.uGXZEEljQBj5MdpWb.M3LfNF5jb0z5q', N'Học viên', 'HV001', NULL),
('TranThiB', '$2a$12$teqbQ8ZWoEczPWJ8LFm4x.uGXZEEljQBj5MdpWb.M3LfNF5jb0z5q', N'Học viên', 'HV002', NULL),
('user3', '$2a$12$teqbQ8ZWoEczPWJ8LFm4x.uGXZEEljQBj5MdpWb.M3LfNF5jb0z5q', N'Giáo viên', NULL, 'GV001'),
('user4', '$2a$12$teqbQ8ZWoEczPWJ8LFm4x.uGXZEEljQBj5MdpWb.M3LfNF5jb0z5q', N'Giáo viên', NULL, 'GV008'),
('TranThiG', '$2a$12$teqbQ8ZWoEczPWJ8LFm4x.uGXZEEljQBj5MdpWb.M3LfNF5jb0z5q', N'Giáo viên', NULL, 'GV002');




-- 9. Thêm dữ liệu vào Bảng Giao Dịch Học Phí
-- Thêm dữ liệu vào Bảng Giao Dịch Học Phí với trạng thái "Đã cập nhật"
INSERT INTO GiaoDichHocPhi (MaHV, MaKH, MaLH, MaPT, NgayGD, SoTien, SoDT, Email, TrangThai) 
VALUES
('HV001', 'KH001', 'LH001','001', GETDATE(), 5530000, '0123456789', 'tran18218@gmail.com', N'Đã duyệt'),
('HV002', 'KH001', 'LH001','001', GETDATE(), 5530000, '0987654321', 'b.tran@example.com', N'Đã duyệt'),
('HV003', 'KH001', 'LH001','001', GETDATE(), 5530000, '0912345678', 'c.le@example.com', N'Đã duyệt'),
('HV004', 'KH001', 'LH001','001', GETDATE(), 5530000, '0981234567', 'd.pham@example.com', N'Đã duyệt'),
('HV005', 'KH001', 'LH001','001', GETDATE(), 5530000, '0976543210', 'e.ngo@example.com', N'Đã duyệt'),
('HV006', 'KH001', 'LH001','001', GETDATE(), 5530000, '0976543211', 'f.hoang@example.com', N'Đã duyệt'),
('HV007', 'KH001', 'LH001','001', GETDATE(), 5530000, '0912345679', 'g.bui@example.com', N'Đã duyệt'),
('HV008', 'KH001', 'LH001','001', GETDATE(), 5530000, '0981234568', 'h.tran@example.com', N'Đã duyệt'),
('HV009', 'KH001', 'LH001','001', GETDATE(), 5530000, '0123456790', 'i.le@example.com', N'Đã duyệt'),
('HV010', 'KH001', 'LH001','001', GETDATE(), 5530000, '0912345680', 'j.nguyen@example.com', N'Đã duyệt'),
('HV011', 'KH001', 'LH001','001', GETDATE(), 5530000, '0981234570', 'k.pham@example.com', N'Đã duyệt'),
('HV012', 'KH001', 'LH001','001', GETDATE(), 5530000, '0123456791', 'l.vo@example.com', N'Đã duyệt'),
('HV013', 'KH001', 'LH001','001', GETDATE(), 5530000, '0912345681', 'm.vu@example.com', N'Đã duyệt'),
('HV014', 'KH001', 'LH001','001', GETDATE(), 5530000, '0981234571', 'n.le@example.com', N'Đã duyệt'),
('HV015', 'KH001', 'LH001','001', GETDATE(), 5530000, '0912345682', 'o.nguyen@example.com', N'Đã duyệt'),
('HV016', 'KH001', 'LH001','001', GETDATE(), 5530000, '0123456792', 'p.tran@example.com', N'Đã duyệt'),
('HV017', 'KH001', 'LH001','001', GETDATE(), 5530000, '0912345683', 'q.do@example.com', N'Đã duyệt'),
('HV018', 'KH001', 'LH001','001', GETDATE(), 5530000, '0981234572', 'r.dinh@example.com', N'Đã duyệt'),
('HV019', 'KH001', 'LH001','001', GETDATE(), 5530000, '0123456793', 's.bui@example.com', N'Đã duyệt'),
('HV020', 'KH001', 'LH001','001', GETDATE(), 5530000, '0912345684', 't.vu@example.com', N'Đã duyệt');

INSERT INTO GiaoDichHocPhi (MaHV, MaKH, MaLH, MaPT, NgayGD, SoTien, SoDT, Email, TrangThai) 
VALUES
('HV001', 'KH002', 'LH006','001', GETDATE(), 5700000, '0981234573', 'u.nguyen@example.com', N'Đã duyệt'),
('HV022', 'KH002', 'LH006','001', GETDATE(), 5700000, '0123456794', 'v.tran@example.com', N'Đã duyệt'),
('HV023', 'KH002', 'LH006','001', GETDATE(), 5700000, '0912345685', 'w.le@example.com', N'Đã duyệt'),
('HV024', 'KH002', 'LH006','001', GETDATE(), 5700000, '0981234574', 'x.pham@example.com', N'Đã duyệt'),
('HV025', 'KH002', 'LH006','001', GETDATE(), 5700000, '0123456795', 'y.hoang@example.com', N'Đã duyệt'),
('HV026', 'KH002', 'LH006','001', GETDATE(), 5700000, '0912345686', 'z.nguyen@example.com', N'Đã duyệt'),
('HV027', 'KH002', 'LH006','001', GETDATE(), 5700000, '0981234575', 'a1.bui@example.com', N'Đã duyệt'),
('HV028', 'KH002', 'LH006','001', GETDATE(), 5700000, '0123456796', 'b1.vo@example.com', N'Đã duyệt'),
('HV029', 'KH002', 'LH006','001', GETDATE(), 5700000, '0912345687', 'c1.vu@example.com', N'Đã duyệt'),
('HV030', 'KH002', 'LH006','001', GETDATE(), 5700000, '0981234576', 'd1.tran@example.com', N'Đã duyệt'),
('HV031', 'KH002', 'LH006','001', GETDATE(), 5700000, '0123456797', 'e1.nguyen@example.com', N'Đã duyệt'),
('HV032', 'KH002', 'LH006','001', GETDATE(), 5700000, '0912345688', 'f1.do@example.com', N'Đã duyệt'),
('HV033', 'KH002', 'LH006','001', GETDATE(), 5700000, '0981234577', 'g1.pham@example.com', N'Đã duyệt'),
('HV034', 'KH002', 'LH006','001', GETDATE(), 5700000, '0123456798', 'h1.bui@example.com', N'Đã duyệt'),
('HV035', 'KH002', 'LH006','001', GETDATE(), 5700000, '0912345689', 'i1.vo@example.com', N'Đã duyệt'),
('HV036', 'KH002', 'LH006','001', GETDATE(), 5700000, '0981234578', 'j1.le@example.com', N'Đã duyệt'),
('HV037', 'KH002', 'LH006','001', GETDATE(), 7890000, '0123456799', 'k1.vu@example.com', N'Đã duyệt'),
('HV038', 'KH002', 'LH006','001', GETDATE(), 5700000, '0912345690', 'l1.nguyen@example.com', N'Đã duyệt'),
('HV039', 'KH002', 'LH006','001', GETDATE(), 5700000, '0981234579', 'm1.tran@example.com', N'Đã duyệt'),
('HV040', 'KH003', 'LH010','001', GETDATE(), 7890000, '0123456800', 'n1.le@example.com', N'Đã duyệt'),
('HV041', 'KH003', 'LH010','001', GETDATE(), 7890000, '0912345691', 'o1.pham@example.com', N'Đã duyệt'),
('HV042', 'KH003', 'LH010','001', GETDATE(), 7890000, '0981234580', 'p1.bui@example.com', N'Đã duyệt'),
('HV043', 'KH003', 'LH010','001', GETDATE(), 7890000, '0123456801', 'q1.vo@example.com', N'Đã duyệt'),
('HV044', 'KH003', 'LH010','001', GETDATE(), 7890000, '0912345692', 'r1.vu@example.com', N'Đã duyệt'),
('HV045', 'KH003', 'LH010','001', GETDATE(), 7890000, '0981234581', 's1.nguyen@example.com', N'Đã duyệt'),
('HV046', 'KH003', 'LH010','001', GETDATE(), 7890000, '0123456802', 't1.do@example.com', N'Đã duyệt'),
('HV047', 'KH003', 'LH010','001', GETDATE(), 7890000, '0912345693', 'u1.tran@example.com', N'Đã duyệt'),
('HV048', 'KH003', 'LH010','001', GETDATE(), 7890000, '0981234582', 'v1.nguyen@example.com', N'Đã duyệt'),
('HV049', 'KH003', 'LH010','001', GETDATE(), 7890000, '0123456803', 'w1.pham@example.com', N'Đã duyệt'),
('HV050', 'KH003', 'LH010','001', GETDATE(), 7890000, '0912345694', 'x1.hoang@example.com', N'Chờ duyệt');



--===========================================================================================================================

-- 6. Thêm dữ liệu vào Bảng Chi Tiết Học Viên và Lớp Học
INSERT INTO ChiTiet_HocVien_LopHoc (MaLH, MaHV, Sobuoivang, KetQua) VALUES
('LH001', 'HV001', 0, NULL),
('LH001', 'HV002', 0, NULL),
('LH001', 'HV003', 0, NULL),
('LH001', 'HV004', 0, NULL),
('LH001', 'HV005', 0, NULL),
('LH001', 'HV006', 0, NULL),
('LH001', 'HV007', 0, NULL),
('LH001', 'HV008', 0, NULL),
('LH001', 'HV009', 0, NULL),
('LH001', 'HV010', 0, NULL),
('LH001', 'HV011', 0, NULL),
('LH001', 'HV012', 0, NULL),
('LH001', 'HV013', 0, NULL),
('LH001', 'HV014', 0, NULL),
('LH001', 'HV015', 0, NULL),
('LH001', 'HV016', 0, NULL),
('LH001', 'HV017', 0, NULL),
('LH001', 'HV018', 0, NULL),
('LH001', 'HV019', 0, NULL),
('LH001', 'HV020', 0, NULL);



INSERT INTO ChiTiet_HocVien_LopHoc (MaLH, MaHV, Sobuoivang, KetQua) VALUES
('LH006', 'HV001', 0, NULL),
('LH006', 'HV022', 0, NULL),
('LH006', 'HV023', 0, NULL),
('LH006', 'HV024', 0, NULL),
('LH006', 'HV025', 0, NULL),
('LH006', 'HV026', 0, NULL),
('LH006', 'HV027', 0, NULL),
('LH006', 'HV028', 0, NULL),
('LH006', 'HV029', 0, NULL),
('LH006', 'HV030', 0, NULL),
('LH006', 'HV031', 0, NULL),
('LH006', 'HV032', 0, NULL),
('LH006', 'HV033', 0, NULL),
('LH006', 'HV034', 0, NULL),
('LH006', 'HV035', 0, NULL),
('LH006', 'HV036', 0, NULL),
('LH006', 'HV037', 0, NULL),
('LH006', 'HV038', 0, NULL),
('LH006', 'HV039', 0, NULL),
('LH006', 'HV040', 0, NULL);


--===========================================================================================================================

INSERT INTO TinTucThongBao (Anh, TieuDe, NoiDung, LoaiTin, TrangThai, NgayTao)
VALUES 
('thong-bao.jpg', N'Thông Báo Nghỉ Tết', N'Trung tâm sẽ nghỉ từ ngày 29/12 đến 03/01.', N'Thông Báo', 1, '2023-12-01'),
('thong-bao.jpg', N'Khai Giảng Khóa Học Lập Trình', N'Khóa học lập trình C++ khai giảng vào ngày 15/01.', N'Tin Tức', 1, '2024-01-02'),
('thong-bao.jpg', N'Thông Báo Học Bổng 2024', N'Trung tâm triển khai học bổng 2024 dành cho học viên xuất sắc.', N'Thông Báo', 1, '2023-12-15'),
('thong-bao.jpg', N'Ưu Đãi Tháng 1', N'Giảm 20% học phí cho tất cả khóa học đăng ký trong tháng 1.', N'Tin Tức', 1, '2024-01-01'),
('thong-bao.jpg', N'Điều Chỉnh Lịch Học', N'Lịch học ngày 20/01 sẽ được dời sang ngày 21/01.', N'Thông Báo', 1, '2024-01-05'),
('thong-bao.jpg', N'Hoạt Động Từ Thiện', N'Trung tâm tổ chức hoạt động từ thiện vào ngày 22/01.', N'Tin Tức', 1, '2024-01-10'),
('thong-bao.jpg', N'Thông Báo Lịch Nghỉ Lễ', N'Trung tâm sẽ nghỉ lễ từ ngày 29/04 đến 02/05.', N'Thông Báo', 1, '2024-04-01'),
('thong-bao.jpg', N'Khai Giảng Khóa Học Mới', N'Khóa học Python khai giảng vào ngày 10/02.', N'Tin Tức', 1, '2024-02-01'),
('thong-bao.jpg', N'Ra Mắt Dịch Vụ Mới', N'Trung tâm triển khai dịch vụ tư vấn học tập miễn phí.', N'Tin Tức', 1, '2024-02-15'),
('thong-bao.jpg', N'Thông Báo Kết Quả Thi', N'Kết quả thi cuối khóa đã được cập nhật trên hệ thống.', N'Thông Báo', 1, '2024-02-20'),
('thong-bao.jpg', N'Lịch Họp Phụ Huynh', N'Họp phụ huynh học viên diễn ra vào ngày 15/03.', N'Tin Tức', 1, '2024-03-01'),
('thong-bao.jpg', N'Thông Báo Đóng Cửa Tạm Thời', N'Trung tâm sẽ đóng cửa để bảo trì hệ thống từ ngày 20/03.', N'Thông Báo', 1, '2024-03-10');



--===========================================================================================================================


-- Thêm các bình luận của học viên
-- Lưu ý: Thêm từng dòng insert, đừng thêm cùng 1 lúc sẽ bị trùng thời gian gây lỗi.
INSERT INTO BinhLuanKhoaHoc (MaHV, MaKH, NoiDung)
VALUES ('HV001', 'KH001', N'Khóa học rất thú vị và dễ hiểu!');

INSERT INTO BinhLuanKhoaHoc (MaHV, MaKH, NoiDung)
VALUES ('HV005', 'KH001', N'Giảng viên nhiệt tình và có phương pháp giảng dạy rõ ràng.');

INSERT INTO BinhLuanKhoaHoc (MaHV, MaKH, NoiDung)
VALUES ('HV003', 'KH001', N'Nội dung khóa học rất đầy đủ, tôi học được nhiều kiến thức bổ ích.');

INSERT INTO BinhLuanKhoaHoc ( MaHV, MaKH, NoiDung)
VALUES ('HV002', 'KH004', N'Chất lượng tương xứng với mức học phí bỏ ra.');

INSERT INTO BinhLuanKhoaHoc (MaHV, MaKH, NoiDung)
VALUES ('HV006', 'KH008', N'Giảng viên dạy rất dễ hiểu, em đã học được rất nhiều kiến thức bổ ích');

use QL_TrungTamTinHoc
select * from TaiKhoan
select * from GiaoVien
select * from KhoaHoc
select * from ChuongTrinhHoc
select * from BinhLuanKhoaHoc
select * from HocVien
select * from LichDay
select * from LichHoc
select * from LopHoc
select * from ChiTiet_HocVien_LopHoc
select * from GiaoDichHocPhi

delete from LichDay
delete from BinhLuanKhoaHoc	

delete from GiaoDichHocPhi where MaHV = 'HVRN4PCSHE'
delete from HocVien where MaHV = 'HVRN4PCSHE'

