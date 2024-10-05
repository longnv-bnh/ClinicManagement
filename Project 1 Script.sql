-- Tạo cơ sở dữ liệu
CREATE DATABASE ClinicManagement;
USE ClinicManagement;

-- Bảng Doctor (Bác sĩ)
CREATE TABLE Doctor (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    CMT VARCHAR(12) NOT NULL,
    Name VARCHAR(50) NOT NULL,
    Code VARCHAR(10) NOT NULL UNIQUE,
    BirthDate DATE,
    Address VARCHAR(100),
    CareerRank VARCHAR(50),
    Seniority INT,
    EducationLevel VARCHAR(50),
    Specialty VARCHAR(50)
);

-- Bảng Nurse (Y tá)
CREATE TABLE Nurse (
    NurseID INT PRIMARY KEY AUTO_INCREMENT,
    CMT VARCHAR(12) NOT NULL,
    EmployeeCode VARCHAR(10) NOT NULL UNIQUE,
    EducationLevel VARCHAR(50),
    Seniority INT,
    BirthDate DATE,
    Address VARCHAR(100),
    PhoneNumber VARCHAR(15)
);

-- Bảng Patient (Bệnh nhân)
CREATE TABLE Patient (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    CMT VARCHAR(12) NOT NULL,
    Code VARCHAR(10) NOT NULL UNIQUE,
    BirthDate DATE,
    Address VARCHAR(100),
    PhoneNumber VARCHAR(15)
);

-- Bảng Visit (Lịch sử khám)
CREATE TABLE Visit (
    VisitID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    NurseID INT,
    AdmissionDate DATE,
    DischargeDate DATE,
    DiseaseName VARCHAR(100),
    TotalCost DECIMAL(15, 2),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
    FOREIGN KEY (NurseID) REFERENCES Nurse(NurseID)
);

-- Bảng Prescription (Đơn thuốc)
CREATE TABLE Prescription (
    PrescriptionID INT PRIMARY KEY AUTO_INCREMENT,
    VisitID INT,
    MedicineName VARCHAR(100),
    FOREIGN KEY (VisitID) REFERENCES Visit(VisitID)
);

-- Bảng PrescriptionDetail (Chi tiết đơn thuốc)
CREATE TABLE PrescriptionDetail (
    PrescriptionID INT,
    Price DECIMAL(10, 2),
    Quantity INT,
    PRIMARY KEY (PrescriptionID),
    FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID)
);
-- Doctor
INSERT INTO Doctor (CMT, Name, Code, BirthDate, Address, CareerRank, Seniority, EducationLevel, Specialty)
VALUES
('123456789', 'Bs. Nguyễn Văn An', 'BS001', '1970-06-15', '123 Đường Chính, TP A', 'Bác sĩ chính', 20, 'Bác sĩ Y khoa', 'Tim mạch'),
('987654321', 'Bs. Trần Thị Bình', 'BS002', '1980-04-22', '456 Đường Sồi, TP B', 'Chuyên gia', 15, 'Tiến sĩ', 'Thần kinh'),
('345678912', 'Bs. Phạm Minh Công', 'BS003', '1975-03-12', '789 Đường Anh Đào, TP C', 'Bác sĩ chính', 18, 'Bác sĩ Y khoa', 'Nhi khoa'),
('654789321', 'Bs. Lê Thị Dung', 'BS004', '1968-11-30', '123 Đường Hồng Mai, TP D', 'Giáo sư', 25, 'Giáo sư', 'Ung bướu');
-- Nurse
INSERT INTO Nurse (CMT, EmployeeCode, EducationLevel, Seniority, BirthDate, Address, PhoneNumber)
VALUES
('456789123', 'NV001', 'Cử nhân', 5, '1990-12-01', '789 Đường Thông, TP A', '0987654321'),
('321654987', 'NV002', 'Trung cấp', 3, '1995-07-10', '321 Đường Tuyết Tùng, TP B', '0912345678'),
('789123456', 'NV003', 'Cử nhân', 8, '1988-09-05', '123 Đường Đào, TP C', '0977654321'),
('987321654', 'NV004', 'Trung cấp', 6, '1992-03-18', '456 Đường Lê Lợi, TP D', '0965432178');
-- Patient
INSERT INTO Patient (FullName, CMT, Code, BirthDate, Address, PhoneNumber)
VALUES
('Nguyễn Thị Mai', '345678901234', 'BN001', '1995-06-18', '102 Đường Quả Óc Chó', '0987654321'),
('Trần Văn Bình', '345678901235', 'BN002', '1989-11-22', '203 Đường Hạt Dẻ', '0987654322'),
('Lê Hoàng Nam', '345678901236', 'BN003', '2000-04-01', '304 Đường Liễu', '0987654323'),
('Phạm Thị Hoa', '345678901237', 'BN004', '1987-05-14', '405 Đường Hồng Mai', '0987654324'), 
('Vũ Văn Sơn', '345678901238', 'BN005', '1992-03-22', '506 Đường Kim Mã', '0987654325'), 
('Hoàng Thị Thanh', '345678901241', 'BN006', '1996-12-01', '809 Đường Hoàng Quốc Việt', '0987654328'), 
('Lương Văn Đức', '345678901242', 'BN007', '1998-07-07', '910 Đường Bạch Mai', '0987654329'), 
('Nguyễn Hoàng Minh', '345678901243', 'BN008', '1995-10-15', '1011 Đường Thái Hà', '0987654330'), 
('Phan Thị Hạnh', '345678901244', 'BN009', '1986-01-30', '1112 Đường Láng', '0987654331'), 
('Nguyễn Văn Khoa', '345678901246', 'BN010', '1982-11-02', '1314 Đường Trung Kính', '0987654333');

-- Visit
INSERT INTO Visit (PatientID, DoctorID, NurseID, AdmissionDate, DischargeDate, DiseaseName, TotalCost)
VALUES
(1, 1, 1, '2023-09-01', '2023-09-05', 'Cảm cúm', 500000.00),
(2, 2, 2, '2023-09-10', '2023-09-15', 'Đau đầu', 300000.00),
(3, 3, 3, '2023-09-20', '2023-09-25', 'Phát ban da', 200000.00),
(4, 1, 2, '2023-09-02', '2023-09-06', 'Viêm họng', 400000.00), 
(5, 2, 3, '2023-09-07', '2023-09-12', 'Đau bụng', 350000.00), 
(6, 3, 1, '2023-09-13', '2023-09-18', 'Tiêu chảy', 250000.00), 
(7, 1, 2, '2023-09-21', '2023-09-26', 'Sốt xuất huyết', 600000.00), 
(8, 2, 3, '2023-09-27', '2023-10-02', 'Viêm phổi', 700000.00), 
(9, 3, 1, '2023-10-03', '2023-10-08', 'Viêm dạ dày', 550000.00), 
(10, 1, 2, '2023-10-09', '2023-10-13', 'Nhiễm trùng da', 300000.00);

-- Prescription
INSERT INTO Prescription (VisitID, MedicineName)
VALUES
(1, 'Paracetamol'),
(2, 'Ibuprofen'),
(3, 'Antihistamine'),
(4, 'Amoxicillin'), 
(5, 'Metronidazole'), 
(6, 'Oral Rehydration Solution'), 
(7, 'Paracetamol'), 
(8, 'Cefuroxime'), 
(9, 'Omeprazole'), 
(10, 'Clindamycin');

-- PrescriptionDetail
INSERT INTO PrescriptionDetail (PrescriptionID, Price, Quantity)
VALUES
(1, 50000.00, 2),
(2, 30000.00, 1),
(3, 20000.00, 3),
(4, 60000.00, 3), 
(5, 50000.00, 2), 
(6, 20000.00, 5), 
(7, 30000.00, 4), 
(8, 70000.00, 2), 
(9, 50000.00, 3), 
(10, 40000.00, 2);

-- Các Truy vấn theo yêu cầu
-- Liệt kê danh sách các loại bệnh trong một tháng cụ thể
SELECT DiseaseName, COUNT(DISTINCT PatientID) AS PatientCount
FROM (
    SELECT PatientID, DiseaseName, AdmissionDate, 
           LAG(DischargeDate) OVER (PARTITION BY PatientID, DiseaseName ORDER BY AdmissionDate) AS PrevDischargeDate
    FROM Visit
    WHERE MONTH(AdmissionDate) = 9
) AS filtered
WHERE (PrevDischargeDate IS NULL OR DATEDIFF(AdmissionDate, PrevDischargeDate) > 1)
GROUP BY DiseaseName
ORDER BY PatientCount DESC;
-- Tính lương Bác sỹ và Y tá trong tháng
-- Lương Bác sỹ
SELECT DoctorID, COUNT(DISTINCT PatientID) AS VisitCount, 
       (7000000 + COUNT(DISTINCT PatientID) * 1000000) AS Salary 
FROM Visit 
WHERE MONTH(DischargeDate) = 9
GROUP BY DoctorID;
-- Lương Y tá
SELECT NurseID, COUNT(PatientID) AS SupportCount, 
       (5000000 + COUNT(PatientID) * 200000) AS Salary 
FROM Visit 
WHERE MONTH(AdmissionDate) = 9 
GROUP BY NurseID;
-- Thông tin khám chữa bệnh của một bệnh nhân
SELECT P.FullName, V.AdmissionDate, V.DischargeDate, V.DiseaseName, V.TotalCost, 
       (SELECT GROUP_CONCAT(MedicineName SEPARATOR ', ') FROM Prescription WHERE VisitID = V.VisitID) AS Medicines
FROM Patient P
JOIN Visit V ON P.PatientID = V.PatientID
WHERE P.CMT = '345678901234';
-- Tính Doanh thu của phòng khám
SELECT SUM(v.TotalCost) AS TreatmentRevenue, 
       (SELECT SUM(pd.Price * pd.Quantity) 
        FROM PrescriptionDetail pd 
        JOIN Prescription p ON pd.PrescriptionID = p.PrescriptionID 
        JOIN Visit v2 ON p.VisitID = v2.VisitID 
        WHERE MONTH(v2.AdmissionDate) = 9) AS DrugRevenue 
FROM Visit v 
WHERE MONTH(v.AdmissionDate) = 9;
