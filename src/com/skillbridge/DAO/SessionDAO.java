package com.skillbridge.DAO;

import com.skillbridge.entities.Session;
import com.skillbridge.queries.SessionQueries;
import com.skillbridge.util.DB;

import java.sql.*;
import java.util.ArrayList;

public class SessionDAO {

    public static void createSession(Session session) throws SQLException {
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(
                     SessionQueries.INSERT,
                     new String[]{"booking_id"})) {

            ps.setInt(1, session.getSlot_id());
            ps.setInt(2, session.getStudent_id());
            ps.setInt(3, session.getMentor_id());
            ps.setString(4, session.getBooking_status());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Session booked successfully!!");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    session.setBooking_id(rs.getInt(1));
                }
            }
        }
    }

    public static ArrayList<Session> getSessionsByStudent(int studentId) throws SQLException {
        ArrayList<Session> sessionList = new ArrayList<>();
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(SessionQueries.GET_BY_STUDENT)) {

            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Session session = new Session(
                        rs.getInt("slot_id"),
                        rs.getInt("student_id"),
                        rs.getInt("mentor_id"),
                        rs.getString("booking_status")
                );
                session.setBooking_id(rs.getInt("booking_id"));
                sessionList.add(session);
            }
        }
        return sessionList;
    }

    public static void UpdateSessionStatus(int bookingId, String bookingStatus) throws SQLException {
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(SessionQueries.UPDATE_STATUS)) {

            String normalizedStatus = bookingStatus.equalsIgnoreCase("cancelled") ? "Cancelled" :
                    bookingStatus.equalsIgnoreCase("completed") ? "Completed" : bookingStatus;

            ps.setString(1, normalizedStatus);
            ps.setInt(2, bookingId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Session status updated successfully!!");
            }
        }
    }

    public static ArrayList<Session> getSessionsByBookingId(int bookingId) throws SQLException {
        ArrayList<Session> sessions = new ArrayList<>();
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM Stu_Session WHERE booking_id = ?")) {

            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Session session = new Session(
                        rs.getInt("slot_id"),
                        rs.getInt("student_id"),
                        rs.getInt("mentor_id"),
                        rs.getString("booking_status")
                );
                session.setBooking_id(rs.getInt("booking_id"));
                sessions.add(session);
            }
        }
        return sessions;
    }

    public static boolean isAlreadyBooked(int studentId, int slotId) {
        String query = "SELECT COUNT(*) FROM Stu_Session WHERE student_id = ? AND slot_id = ?";
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setInt(1, studentId);
            ps.setInt(2, slotId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking existing booking: " + e.getMessage());
        }
        return false;
    }
}