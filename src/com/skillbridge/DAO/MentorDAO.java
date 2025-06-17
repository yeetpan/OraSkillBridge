package com.skillbridge.DAO;

import com.skillbridge.entities.Mentor;
import com.skillbridge.queries.MentorQueries;
import com.skillbridge.util.DB;

import java.sql.*;
import java.util.ArrayList;

public class MentorDAO {

    // Insert Mentor using Oracle sequence
    public static void createMentor(Mentor mentor) {
        try (Connection con = DB.connect()) {
            String query = MentorQueries.insert;
            PreparedStatement preparedStatement = con.prepareStatement(query);
            preparedStatement.setString(1, mentor.getMentor_name());
            preparedStatement.setString(2, mentor.getMentor_email());
            preparedStatement.setInt(3, mentor.getExpertise_id());

            int rowsAffected = preparedStatement.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Mentor inserted successfully!!");

                // Get the generated mentor_id
                Statement idStmt = con.createStatement();
                ResultSet rs = idStmt.executeQuery("SELECT mentor_seq.CURRVAL FROM dual");
                if (rs.next()) {
                    mentor.setMentor_id(rs.getInt(1));
                }
                rs.close();
                idStmt.close();
            }

            preparedStatement.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Read All Mentors
    public static ArrayList<Mentor> readMentors() throws SQLException {
        ArrayList<Mentor> listOfMentors = new ArrayList<>();
        try (Connection con = DB.connect();
             PreparedStatement preparedStatement = con.prepareStatement(MentorQueries.get_all);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                Mentor mentor = new Mentor(
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getInt("expertise_id")
                );
                mentor.setMentor_id(rs.getInt("mentor_id"));
                listOfMentors.add(mentor);
            }
        }
        return listOfMentors;
    }

    // Update Mentor
    public static void updateMentor(int mentor_id, String name, String email, int expertise_id) {
        try (Connection con = DB.connect();
             PreparedStatement preparedStatement = con.prepareStatement(MentorQueries.UPDATE)) {

            preparedStatement.setString(1, name);
            preparedStatement.setString(2, email);
            preparedStatement.setInt(3, expertise_id);
            preparedStatement.setInt(4, mentor_id);

            int rowsAffected = preparedStatement.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Updated mentor successfully!!");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    // Delete Mentor
    public static void deleteMentor(int mentor_id) {
        try (Connection con = DB.connect();
             PreparedStatement preparedStatement = con.prepareStatement(MentorQueries.DELETE_BY_ID)) {

            preparedStatement.setInt(1, mentor_id);
            int rowsAffected = preparedStatement.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Deleted mentor with id " + mentor_id + " successfully!!");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    // Get mentor_id by email
    public static int getMentorByEmail(String email) throws SQLException {
        int id = -1;
        try (Connection con = DB.connect();
             PreparedStatement preparedStatement = con.prepareStatement(MentorQueries.select_id_by_email)) {

            preparedStatement.setString(1, email);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                id = rs.getInt("mentor_id");
            }
        }
        return id;
    }

    // Get mentors by expertise
    public static ArrayList<Mentor> getMentorsByExpertise(int expertiseId) throws SQLException {
        ArrayList<Mentor> matchedMentors = new ArrayList<>();
        try (Connection con = DB.connect();
             PreparedStatement preparedStatement = con.prepareStatement(MentorQueries.get_by_expertise)) {

            preparedStatement.setInt(1, expertiseId);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                Mentor mentor = new Mentor(
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getInt("expertise_id")
                );
                mentor.setMentor_id(rs.getInt("mentor_id"));
                matchedMentors.add(mentor);
            }
        }
        return matchedMentors;
    }

    // Get mentor name by ID
    public static String GetMentorName(int mentorId) throws SQLException {
        try (Connection con = DB.connect();
             PreparedStatement preparedStatement = con.prepareStatement(MentorQueries.GET_NAME)) {

            preparedStatement.setInt(1, mentorId);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("name");
                } else {
                    throw new SQLException("No mentor found with ID: " + mentorId);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching mentor name for mentorId " + mentorId + ": " + e.getMessage());
            throw e;
        }
    }
}
