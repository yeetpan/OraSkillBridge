package com.skillbridge.DAO;

import com.skillbridge.entities.Internship;
import com.skillbridge.queries.InternshipQueries;
import com.skillbridge.util.DB;

import java.io.StringReader;
import java.sql.*;
import java.util.ArrayList;

public class InternshipDAO {

    public static void createInternship(Internship internship) {
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(
                     InternshipQueries.INSERT,
                     new String[]{"internship_id"})) {

            ps.setString(1, internship.getOrg_name());
            ps.setString(2, internship.getTitle());
            ps.setInt(3, internship.getCapacity());

            // ✅ For Oracle CLOB
            ps.setCharacterStream(4, new StringReader(internship.getDescription()));

            // ✅ For Oracle DATE
            ps.setDate(5, new java.sql.Date(internship.getDeadline().getTime()));

            int rows = ps.executeUpdate();
            if (rows > 0) {
                System.out.println("Internship inserted successfully!");
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    internship.setInternship_id(rs.getInt(1));
                }
                rs.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static ArrayList<Internship> readInternship() {
        ArrayList<Internship> internships = new ArrayList<>();
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(InternshipQueries.GET_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String orgName = rs.getString("org_name");
                String title = rs.getString("title");
                int capacity = rs.getInt("capacity");

                // ✅ Read CLOB safely
                Clob clob = rs.getClob("description");
                String description = (clob != null) ? clob.getSubString(1, (int) clob.length()) : null;

                Date deadline = rs.getDate("deadline");
                Internship internship = new Internship(orgName, title, capacity, description, deadline);
                internship.setInternship_id(rs.getInt("internship_id"));
                internships.add(internship);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return internships;
    }

    public static Internship getInternshipById(int internshipId) {
        Internship internship = null;
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(InternshipQueries.GET_BY_ID)) {

            ps.setInt(1, internshipId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String orgName = rs.getString("org_name");
                String title = rs.getString("title");
                int capacity = rs.getInt("capacity");

                Clob clob = rs.getClob("description");
                String description = (clob != null) ? clob.getSubString(1, (int) clob.length()) : null;

                Date deadline = rs.getDate("deadline");

                internship = new Internship(orgName, title, capacity, description, deadline);
                internship.setInternship_id(rs.getInt("internship_id"));
            }

            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return internship;
    }

    public static void DeleteInternship(int internshipId) {
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(InternshipQueries.DELETE_BY_ID)) {

            ps.setInt(1, internshipId);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                System.out.println("Deleted Internship with id " + internshipId + " successfully!!");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void updateInternship(Internship internship) {
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(InternshipQueries.UPDATE_BY_ID)) {

            ps.setString(1, internship.getOrg_name());
            ps.setString(2, internship.getTitle());
            ps.setInt(3, internship.getCapacity());

            ps.setCharacterStream(4, new StringReader(internship.getDescription()));
            ps.setDate(5, new java.sql.Date(internship.getDeadline().getTime()));
            ps.setInt(6, internship.getInternship_id());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                System.out.println("Internship updated successfully!");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
