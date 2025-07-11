package com.skillbridge.queries;

public class SessionQueries {
    public static final String INSERT =
            "INSERT INTO Stu_Session (slot_id, student_id, mentor_id, booking_status) VALUES (?, ?, ?, ?)";

    public static final String GET_BY_STUDENT =
            "SELECT * FROM Stu_Session WHERE student_id = ?";

    public static final String UPDATE_STATUS =
            "UPDATE Stu_Session SET booking_status = ? WHERE booking_id = ?";
}
