package com.skillbridge.DAO;

import com.skillbridge.entities.Application;
import com.skillbridge.queries.ApplicationQueries;
import com.skillbridge.util.DB;

import java.sql.*;
import java.util.ArrayList;

public class ApplicationDAO {

    public static void createApplication(Application app) {
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(
                     ApplicationQueries.INSERT,
                     new String[]{"application_id"})) {

            ps.setInt(1, app.getStudent_id());
            ps.setInt(2, app.getInternship_id());
            ps.setString(3, app.getStatus());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Application inserted successfully!!");
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        app.setApplication_id(rs.getInt(1));
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public static ArrayList<Application> getAllApplications() {
        ArrayList<Application> list = new ArrayList<>();
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(ApplicationQueries.GET_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Application app = new Application(
                        rs.getInt("student_id"),
                        rs.getInt("internship_id"),
                        rs.getString("status")
                );
                app.setApplication_id(rs.getInt("application_id"));
                list.add(app);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public static void updateApplicationStatus(int app_id, String status) {
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(ApplicationQueries.UPDATE_STATUS)) {

            ps.setString(1, status);
            ps.setInt(2, app_id);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Application status updated!");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public static ArrayList<Application> getByStudentId(int student_id) {
        ArrayList<Application> list = new ArrayList<>();
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(ApplicationQueries.GET_BY_STUDENT)) {

            ps.setInt(1, student_id);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Application app = new Application(
                        rs.getInt("student_id"),
                        rs.getInt("internship_id"),
                        rs.getString("status")
                );
                app.setApplication_id(rs.getInt("application_id"));
                list.add(app);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public static void deleteApplication(int app_id) {
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(ApplicationQueries.DELETE_BY_ID)) {

            ps.setInt(1, app_id);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Application deleted with ID: " + app_id);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
