package com.skillbridge.queries;

public class StudentQueries {
    public static final String insert =
            "INSERT INTO Student (name, email, college) VALUES (?, ?, ?)";

    public static final String get_id =
            "SELECT student_id FROM Student WHERE email = ?";

    public static final String get_all =
            "SELECT * FROM Student";

    public static final String delete_by_id =
            "DELETE FROM Student WHERE student_id = ?";

    public static final String update =
            "UPDATE Student SET name = ?, email = ?, college = ? WHERE student_id = ?";

    public static final String get_name_by_id =
            "SELECT name FROM Student WHERE student_id = ?";
}
