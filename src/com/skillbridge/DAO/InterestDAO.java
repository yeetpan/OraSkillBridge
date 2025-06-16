package com.skillbridge.DAO;
//InterestDAO
import com.skillbridge.queries.InterestsQueries;
import com.skillbridge.util.DB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

//used to display the interests to the user(mentor & student).
public class InterestDAO {
    public static void showInterests() {
        try (Connection con = DB.connect();
             PreparedStatement ps = con.prepareStatement(InterestsQueries.SHOW_INTERESTS);
             ResultSet rs = ps.executeQuery()) {

            boolean found = false;
            while (rs.next()) {
                found = true;
                System.out.println("Interest id -> " + rs.getInt("interest_id") +
                        " | Interest: " + rs.getString("interest_name"));
            }

            if (!found) {
                System.out.println("No interests found in the database.");
            }

        } catch (SQLException e) {
            e.printStackTrace(); // Use this for real debugging
        }
    }
}
