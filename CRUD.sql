
--    CRUD.sql for SkillBridge Application
    ------------------------------------

--    This file contains all the necessary SQL operations for Create, Read, Update, and Delete (CRUD)
--    functionality for the following entities: Application, Feedback, Internship, Matchmaking,
--    Mentor, Session (Stu_Session), Session_Slot, Student_Interests, and Student.
--
--    Note:
--    - ? is a wildcard placeholder used in prepared statements (JDBC).
--    - Replace each ? with the corresponding value.

-- APPLICATION TABLE

-- Insert a new application
INSERT INTO Application (application_id, student_id, internship_id, status)
VALUES (application_seq.NEXTVAL, ?, ?, ?);

-- Get all applications
SELECT * FROM Application;

-- Get applications by student ID
SELECT * FROM Application WHERE student_id = ?;

-- Get applications by internship ID
SELECT * FROM Application WHERE internship_id = ?;

-- Update application status by application ID
UPDATE Application SET status = ? WHERE application_id = ?;

-- Delete application by application ID
DELETE FROM Application WHERE application_id = ?;

-- FEEDBACK TABLE

-- Insert feedback entry (after session)
INSERT INTO Feedback (booking_id, student_id, rating, comments)
VALUES (?, ?, ?, ?);

-- Get feedback by student ID
SELECT * FROM Feedback WHERE student_id = ?;

-- View feedback submitted for a specific mentor
SELECT f.feedback_id, f.rating, f.comments, f.student_id, s.booking_id
FROM Feedback f
JOIN Stu_Session s ON f.booking_id = s.booking_id
WHERE s.mentor_id = ?;

-- Update feedback rating and comments
UPDATE Feedback SET rating = ?, comments = ? WHERE feedback_id = ?;

-- Delete feedback by ID
DELETE FROM Feedback WHERE feedback_id = ?;

-- INTERNSHIP TABLE

-- Insert a new internship opportunity
INSERT INTO Internship (org_name, title, capacity, description, deadline)
VALUES (?, ?, ?, ?, ?);

-- Get all internships
SELECT * FROM Internship;

-- Get internship by ID
SELECT * FROM Internship WHERE internship_id = ?;

-- Update internship details
UPDATE Internship SET org_name = ?, title = ?, capacity = ?, description = ?, deadline = ?
WHERE internship_id = ?;

-- Delete internship by ID
DELETE FROM Internship WHERE internship_id = ?;


-- MATCHMAKING TABLE

-- Insert matched mentors for a student based on interests
INSERT INTO Matchmaking (student_id, mentor_id, mentor_name, interest_id, interest_name)
SELECT s.student_id, m.mentor_id, m.name, i.interest_id, i.interest_name
FROM Student s
JOIN Student_Interests si ON s.student_id = si.student_id
JOIN Interests i ON si.interest_id = i.interest_id
JOIN Mentor m ON m.expertise_id = i.interest_id
WHERE s.student_id = ?;

-- Show all matched mentors for a student
SELECT * FROM Matchmaking WHERE student_id = ?;

-- MENTOR TABLE

-- Insert new mentor
INSERT INTO Mentor (mentor_id, name, email, expertise_id)
VALUES (mentor_seq.NEXTVAL, ?, ?, ?);

-- Get all mentors
SELECT * FROM Mentor;

-- Get mentors by area of expertise
SELECT * FROM Mentor WHERE expertise_id = ?;

-- Get mentor record by email
SELECT * FROM Mentor WHERE email = ?;

-- Get mentor name by ID
SELECT name FROM Mentor WHERE mentor_id = ?;

-- Update mentor details
UPDATE Mentor SET name = ?, email = ?, expertise_id = ? WHERE mentor_id = ?;

-- Delete mentor by ID
DELETE FROM Mentor WHERE mentor_id = ?;


-- STU_SESSION TABLE

-- Book a session slot for a student with a mentor
INSERT INTO Stu_Session (slot_id, student_id, mentor_id, booking_status)
VALUES (?, ?, ?, ?);

-- Get all sessions booked by a student
SELECT * FROM Stu_Session WHERE student_id = ?;

-- Update session booking status
UPDATE Stu_Session SET booking_status = ? WHERE booking_id = ?;

-- SESSION_SLOT TABLE

-- Insert a new session slot (created by mentor)
INSERT INTO Session_Slot (mentor_id, session_date, time, duration, status)
VALUES (?, ?, ?, ?, ?);

-- Get all available session slots for a mentor
SELECT * FROM Session_Slot WHERE mentor_id = ? AND status = 'Available';

-- Update slot status (e.g., to 'Booked')
UPDATE Session_Slot SET status = ? WHERE slot_id = ?;

-- STUDENT_INTERESTS TABLE

-- Insert a student's interest
INSERT INTO Student_Interests (student_id, interest_id)
VALUES (?, ?);

-- Get interest IDs for a specific student
SELECT interest_id FROM Student_Interests WHERE student_id = ?;

-- Delete all interests for a student (used when updating preferences)
DELETE FROM Student_Interests WHERE student_id = ?;


-- STUDENT TABLE

-- Insert a new student record
INSERT INTO Student (name, email, college)
VALUES (?, ?, ?);

-- Get student ID using email
SELECT student_id FROM Student WHERE email = ?;

-- Get all students
SELECT * FROM Student;

-- Delete student by ID
DELETE FROM Student WHERE student_id = ?;

-- Update student details
UPDATE Student SET name = ?, email = ?, college = ? WHERE student_id = ?;

-- Get student name by ID
SELECT name FROM Student WHERE student_id = ?;
