package com.clinicmanagement;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class ClinicManagement {
    // Thông tin kết nối tới MySQL
    private static final String URL = "jdbc:mysql://localhost:3306/clinicmanagement";
    private static final String USER = "root";  // Username của MySQL
    private static final String PASSWORD = "vietlong2k";  // Mật khẩu của MySQL

    public static void main(String[] args) {
        try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD)) {
            System.out.println("Kết nối thành công!");

            Scanner scanner = new Scanner(System.in);

            // Nhập tháng từ bàn phím
            System.out.print("Nhập tháng (1-12): ");
            String month = scanner.nextLine();

            // Liệt kê danh sách các bệnh trong tháng
            listDiseasesInMonth(connection, month);

            // Tính lương bác sỹ và y tá
            calculateSalary(connection, month);

            // Hiển thị thông tin bệnh nhân
            System.out.print("Nhập CMT của bệnh nhân: ");
            String cmt = scanner.nextLine();
            displayPatientInfo(connection, cmt);

            // Tính doanh thu của phòng khám
            calculateClinicRevenue(connection);

            scanner.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Liệt kê danh sách các loại bệnh trong một tháng
    public static void listDiseasesInMonth(Connection connection, String month) throws SQLException {
        String query = "SELECT DiseaseName, COUNT(DISTINCT PatientID) AS PatientCount " +
                "FROM (SELECT PatientID, DiseaseName, AdmissionDate, " +
                "LAG(DischargeDate) OVER (PARTITION BY PatientID, DiseaseName ORDER BY AdmissionDate) AS PrevDischargeDate " +
                "FROM Visit WHERE MONTH(AdmissionDate) = ?) AS filtered " +
                "WHERE (PrevDischargeDate IS NULL OR DATEDIFF(AdmissionDate, PrevDischargeDate) > 1) " +
                "GROUP BY DiseaseName " +
                "ORDER BY PatientCount DESC";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, Integer.parseInt(month)); // Chuyển tháng thành số nguyên để so sánh
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    System.out.println("Bệnh: " + resultSet.getString("DiseaseName") + 
                            " - Số lượng bệnh nhân: " + resultSet.getInt("PatientCount"));
                }
            }
        }
    }

    // Tính lương bác sỹ và y tá
    public static void calculateSalary(Connection connection, String month) throws SQLException {
        String doctorSalaryQuery = "SELECT DoctorID, COUNT(DISTINCT PatientID) AS VisitCount, " +
                "(7000000 + COUNT(DISTINCT PatientID) * 1000000) AS Salary " +
                "FROM Visit WHERE MONTH(DischargeDate) = ? " +
                "GROUP BY DoctorID";

        try (PreparedStatement statement = connection.prepareStatement(doctorSalaryQuery)) {
            statement.setInt(1, Integer.parseInt(month));

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    System.out.println("Doctor ID: " + resultSet.getInt("DoctorID") + 
                            " - Lương: " + resultSet.getDouble("Salary"));
                }
            }
        }

        String nurseSalaryQuery = "SELECT NurseID, COUNT(PatientID) AS SupportCount, " +
                "(5000000 + COUNT(PatientID) * 200000) AS Salary " +
                "FROM Visit WHERE MONTH(AdmissionDate) = ? " +
                "GROUP BY NurseID";

        try (PreparedStatement statement = connection.prepareStatement(nurseSalaryQuery)) {
            statement.setInt(1, Integer.parseInt(month));

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    System.out.println("Nurse ID: " + resultSet.getInt("NurseID") + 
                            " - Lương: " + resultSet.getDouble("Salary"));
                }
            }
        }
    }

    // Hiển thị thông tin bệnh nhân cùng toàn bộ lịch sử khám chữa bệnh
    public static void displayPatientInfo(Connection connection, String cmt) throws SQLException {
        // Sửa câu truy vấn để loại bỏ 'TreatmentStatus'
        String query = "SELECT p.FullName, p.CMT, v.DiseaseName, v.AdmissionDate, v.DischargeDate, v.TotalCost " +
                       "FROM Patient p " +
                       "JOIN Visit v ON p.PatientID = v.PatientID " +
                       "WHERE p.CMT = ?";

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, cmt);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    System.out.println("Bệnh nhân: " + resultSet.getString("FullName") +
                                       " - CMT: " + resultSet.getString("CMT"));
                    System.out.println("Bệnh: " + resultSet.getString("DiseaseName") +
                                       ", Ngày nhập viện: " + resultSet.getDate("AdmissionDate") +
                                       ", Ngày ra viện: " + resultSet.getDate("DischargeDate") +
                                       ", Chi phí: " + resultSet.getDouble("TotalCost"));
                }
            }
        }
    }

    // Tính doanh thu của phòng khám
    public static void calculateClinicRevenue(Connection connection) throws SQLException {
        String revenueQuery = "SELECT SUM(v.TotalCost) AS TreatmentRevenue, " +
                "(SELECT SUM(pd.Price * pd.Quantity) " +
                "FROM PrescriptionDetail pd " +
                "JOIN Prescription p ON pd.PrescriptionID = p.PrescriptionID) AS DrugRevenue " +
                "FROM Visit v";

        try (PreparedStatement statement = connection.prepareStatement(revenueQuery);
             ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                double treatmentRevenue = resultSet.getDouble("TreatmentRevenue");
                double drugRevenue = resultSet.getDouble("DrugRevenue");

                System.out.println("Doanh thu từ khám chữa bệnh: " + treatmentRevenue);
                System.out.println("Doanh thu từ bán thuốc: " + drugRevenue);
                System.out.println("Tổng doanh thu: " + (treatmentRevenue + drugRevenue));
            }
        }
    }
}
