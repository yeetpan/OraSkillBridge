package com.skillbridge.DAO;

import com.skillbridge.entities.Student;
import com.skillbridge.queries.StudentQueries;
import com.skillbridge.util.DB;

import java.sql.*;
import java.util.ArrayList;

public class StudentDAO {

    public static void createStudent(Student student) {
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(StudentQueries.insert, new String[]{"student_id"})) {

            ps.setString(1, student.getStudent_name());
            ps.setString(2, student.getStudent_email());
            ps.setString(3, student.getStudent_college());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                System.out.println("Student inserted successfully!!");
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        student.setStudent_id(rs.getInt(1));
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static ArrayList<Student> readStudent() {
        ArrayList<Student> listOfStudents = new ArrayList<>();

        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(StudentQueries.get_all);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Student stu = new Student(
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("college")
                );
                stu.setStudent_id(rs.getInt("student_id"));
                listOfStudents.add(stu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return listOfStudents;
    }

    public static void updateStudent(int student_id, String name, String email, String college) {
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(StudentQueries.update)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, college);
            ps.setInt(4, student_id);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                System.out.println("Student updated successfully!!");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void deleteStudent(int student_id) {
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(StudentQueries.delete_by_id)) {

            ps.setInt(1, student_id);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                System.out.println("Deleted Student with id " + student_id + " successfully!!");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static int getStudentIdByEmail(String email) {
        int id = -1;

        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(StudentQueries.get_id)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    id = rs.getInt("student_id");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return id;
    }

    public static String getStudentName(int studentId) {
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(StudentQueries.get_name_by_id)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("name");
                } else {
                    throw new SQLException("No student found with ID: " + studentId);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error fetching student name for studentId " + studentId + ": " + e.getMessage());
            return null;
        }
    }
}
