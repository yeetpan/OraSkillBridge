package com.skillbridge.queries;

public class MentorQueries {
    // Insert a new mentor
    public static final String insert =
            "INSERT INTO Mentor (name, email, expertise_id) VALUES (?, ?, ?)";

    // Get all mentors
    public static final String get_all =
            "SELECT * FROM Mentor";

    // Get mentors by interest area (expertise)
    public static final String get_by_expertise =
            "SELECT * FROM Mentor WHERE expertise_id = ?";

    // Get mentor record by email
    public static final String select_id_by_email =
            "SELECT * FROM Mentor WHERE email = ?";

    // Delete mentor by ID
    public static final String DELETE_BY_ID =
            "DELETE FROM Mentor WHERE mentor_id = ?";

    // Update mentor details
    public static final String UPDATE =
            "UPDATE Mentor SET name = ?, email = ?, expertise_id = ? WHERE mentor_id = ?";

    // Get mentor name by ID
    public static final String GET_NAME =
            "SELECT name FROM Mentor WHERE mentor_id = ?";
}
