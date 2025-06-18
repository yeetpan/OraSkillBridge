-- === SEQUENCES ===
CREATE SEQUENCE interests_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE student_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE internship_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE mentor_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE session_slot_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE application_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE stu_session_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE feedback_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE matchmaking_seq START WITH 1 INCREMENT BY 1 NOCACHE;

-- === TABLE CREATION ===
-- 1. Interests (Independent)
CREATE TABLE Interests (
    interest_id NUMBER PRIMARY KEY,
    interest_name VARCHAR2(100) NOT NULL
);

-- Trigger for Interests
CREATE OR REPLACE TRIGGER interests_trigger
BEFORE INSERT ON Interests
FOR EACH ROW
BEGIN
    :NEW.interest_id := interests_seq.NEXTVAL;
END;
/

-- 2. Student (Independent)
CREATE TABLE Student (
    student_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    college VARCHAR2(100)
);

-- Trigger for Student
CREATE OR REPLACE TRIGGER student_trigger
BEFORE INSERT ON Student
FOR EACH ROW
BEGIN
    :NEW.student_id := student_seq.NEXTVAL;
END;
/

-- 3. Internship (Independent)
CREATE TABLE Internship (
    internship_id NUMBER PRIMARY KEY,
    org_name VARCHAR2(100) NOT NULL,
    title VARCHAR2(100) NOT NULL,
    capacity NUMBER NOT NULL,
    description CLOB,
    deadline DATE
);

-- Trigger for Internship
CREATE OR REPLACE TRIGGER internship_trigger
BEFORE INSERT ON Internship
FOR EACH ROW
BEGIN
    :NEW.internship_id := internship_seq.NEXTVAL;
END;
/

-- 4. Student_Interests (Dependent on Interests and Student)
CREATE TABLE Student_Interests (
    student_id NUMBER NOT NULL,
    interest_id NUMBER NOT NULL,
    PRIMARY KEY (student_id, interest_id),
    CONSTRAINT fk_student_interests_student FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_student_interests_interest FOREIGN KEY (interest_id) REFERENCES Interests(interest_id) ON DELETE CASCADE
);

-- 5. Mentor (Dependent on Interests)
CREATE TABLE Mentor (
    mentor_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    expertise_id NUMBER NOT NULL,
    CONSTRAINT fk_mentor_expertise FOREIGN KEY (expertise_id) REFERENCES Interests(interest_id) ON DELETE CASCADE
);

-- Trigger for Mentor
CREATE OR REPLACE TRIGGER mentor_trigger
BEFORE INSERT ON Mentor
FOR EACH ROW
BEGIN
    :NEW.mentor_id := mentor_seq.NEXTVAL;
END;
/

-- 6. Matchmaking (Internal table, no foreign key constraints)
CREATE TABLE Matchmaking (
    match_id NUMBER PRIMARY KEY,
    student_id NUMBER NOT NULL,
    mentor_id NUMBER NOT NULL,
    mentor_name VARCHAR2(100) NOT NULL,
    interest_id NUMBER NOT NULL,
    interest_name VARCHAR2(100) NOT NULL
);

-- Trigger for Matchmaking
CREATE OR REPLACE TRIGGER matchmaking_trigger
BEFORE INSERT ON Matchmaking
FOR EACH ROW
BEGIN
    :NEW.match_id := matchmaking_seq.NEXTVAL;
END;
/

-- 7. Session_Slot (Dependent on Mentor)
CREATE TABLE Session_Slot (
    slot_id NUMBER PRIMARY KEY,
    mentor_id NUMBER NOT NULL,
    session_date DATE NOT NULL,
    time TIMESTAMP NOT NULL,
    duration NUMBER NOT NULL,
    status VARCHAR2(20),
    CONSTRAINT fk_session_slot_mentor FOREIGN KEY (mentor_id) REFERENCES Mentor(mentor_id) ON DELETE CASCADE
);

-- Trigger for Session_Slot
CREATE OR REPLACE TRIGGER session_slot_trigger
BEFORE INSERT ON Session_Slot
FOR EACH ROW
BEGIN
    :NEW.slot_id := session_slot_seq.NEXTVAL;
END;
/

-- 8. Application (Dependent on Student and Internship)
CREATE TABLE Application (
    application_id NUMBER PRIMARY KEY,
    student_id NUMBER NOT NULL,
    internship_id NUMBER NOT NULL,
    status VARCHAR2(50),
    CONSTRAINT fk_application_student FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_application_internship FOREIGN KEY (internship_id) REFERENCES Internship(internship_id) ON DELETE CASCADE
);

-- Trigger for Application
CREATE OR REPLACE TRIGGER application_trigger
BEFORE INSERT ON Application
FOR EACH ROW
BEGIN
    :NEW.application_id := application_seq.NEXTVAL;
END;
/

-- 9. Stu_Session (Dependent on Student, Mentor, Session_Slot)
CREATE TABLE Stu_Session (
    booking_id NUMBER PRIMARY KEY,
    slot_id NUMBER NOT NULL,
    student_id NUMBER NOT NULL,
    mentor_id NUMBER NOT NULL,
    booking_status VARCHAR2(50),
    CONSTRAINT fk_stu_session_slot FOREIGN KEY (slot_id) REFERENCES Session_Slot(slot_id) ON DELETE CASCADE,
    CONSTRAINT fk_stu_session_student FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_stu_session_mentor FOREIGN KEY (mentor_id) REFERENCES Mentor(mentor_id) ON DELETE CASCADE
);

-- Trigger for Stu_Session
CREATE OR REPLACE TRIGGER stu_session_trigger
BEFORE INSERT ON Stu_Session
FOR EACH ROW
BEGIN
    :NEW.booking_id := stu_session_seq.NEXTVAL;
END;
/

-- 10. Feedback (Dependent on Stu_Session, Student)
CREATE TABLE Feedback (
    feedback_id NUMBER PRIMARY KEY,
    booking_id NUMBER NOT NULL,
    student_id NUMBER NOT NULL,
    rating NUMBER NOT NULL,
    comments VARCHAR2(400),
    CONSTRAINT fk_feedback_booking FOREIGN KEY (booking_id) REFERENCES Stu_Session(booking_id) ON DELETE CASCADE,
    CONSTRAINT fk_feedback_student FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE
);

-- Trigger for Feedback
CREATE OR REPLACE TRIGGER feedback_trigger
BEFORE INSERT ON Feedback
FOR EACH ROW
BEGIN
    :NEW.feedback_id := feedback_seq.NEXTVAL;
END;
/

-- === DATA INSERTION ===
-- 1. Interests
INSERT INTO Interests (interest_name) VALUES ('Database Systems');
INSERT INTO Interests (interest_name) VALUES ('Web Development');
INSERT INTO Interests (interest_name) VALUES ('Machine Learning');
INSERT INTO Interests (interest_name) VALUES ('Cloud Computing');

-- 2. Student
INSERT INTO Student (name, email, college) VALUES ('John Doe', 'john.doe@example.com', 'Tech University');
INSERT INTO Student (name, email, college) VALUES ('Alice Smith', 'alice.smith@example.com', 'Innovate College');
INSERT INTO Student (name, email, college) VALUES ('Bob Johnson', 'bob.johnson@example.com', 'Future Institute');
INSERT INTO Student (name, email, college) VALUES ('Emma Brown', 'emma.brown@example.com', 'Tech University');

-- 3. Internship
INSERT INTO Internship (org_name, title, capacity, description, deadline)
VALUES ('Tech Corp', 'Database Intern', 5, 'Work on database optimization projects.', TO_DATE('2025-07-01', 'YYYY-MM-DD'));
INSERT INTO Internship (org_name, title, capacity, description, deadline)
VALUES ('Web Innovators', 'Frontend Developer', 3, 'Develop responsive web applications.', TO_DATE('2025-06-30', 'YYYY-MM-DD'));
INSERT INTO Internship (org_name, title, capacity, description, deadline)
VALUES ('AI Solutions', 'ML Engineer', 4, 'Build machine learning models.', TO_DATE('2025-08-15', 'YYYY-MM-DD'));

-- 4. Student_Interests
INSERT INTO Student_Interests (student_id, interest_id) VALUES (1, 1); -- John: Database Systems
INSERT INTO Student_Interests (student_id, interest_id) VALUES (1, 2); -- John: Web Development
INSERT INTO Student_Interests (student_id, interest_id) VALUES (2, 2); -- Alice: Web Development
INSERT INTO Student_Interests (student_id, interest_id) VALUES (2, 3); -- Alice: Machine Learning
INSERT INTO Student_Interests (student_id, interest_id) VALUES (3, 3); -- Bob: Machine Learning
INSERT INTO Student_Interests (student_id, interest_id) VALUES (4, 1); -- Emma: Database Systems

-- 5. Mentor
INSERT INTO Mentor (name, email, expertise_id) VALUES ('Jane Smith', 'jane.smith@example.com', 1); -- Database Systems
INSERT INTO Mentor (name, email, expertise_id) VALUES ('Michael Lee', 'michael.lee@example.com', 2); -- Web Development
INSERT INTO Mentor (name, email, expertise_id) VALUES ('Sarah Davis', 'sarah.davis@example.com', 3); -- Machine Learning
INSERT INTO Mentor (name, email, expertise_id) VALUES ('David Wilson', 'david.wilson@example.com', 1); -- Database Systems

-- 6. Session_Slot
INSERT INTO Session_Slot (mentor_id, session_date, time, duration, status)
VALUES (1, TO_DATE('2025-06-20', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-06-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 60, 'AVAILABLE');
INSERT INTO Session_Slot (mentor_id, session_date, time, duration, status)
VALUES (2, TO_DATE('2025-06-21', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-06-21 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 45, 'AVAILABLE');
INSERT INTO Session_Slot (mentor_id, session_date, time, duration, status)
VALUES (3, TO_DATE('2025-06-22', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-06-22 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 90, 'BOOKED');

-- 7. Application
INSERT INTO Application (student_id, internship_id, status) VALUES (1, 1, 'PENDING'); -- John: Database Intern
INSERT INTO Application (student_id, internship_id, status) VALUES (2, 2, 'ACCEPTED'); -- Alice: Frontend Developer
INSERT INTO Application (student_id, internship_id, status) VALUES (3, 3, 'REJECTED'); -- Bob: ML Engineer
INSERT INTO Application (student_id, internship_id, status) VALUES (4, 1, 'PENDING'); -- Emma: Database Intern

-- 8. Stu_Session
INSERT INTO Stu_Session (slot_id, student_id, mentor_id, booking_status) VALUES (1, 1, 1, 'CONFIRMED'); -- John with Jane
INSERT INTO Stu_Session (slot_id, student_id, mentor_id, booking_status) VALUES (2, 2, 2, 'CONFIRMED'); -- Alice with Michael
INSERT INTO Stu_Session (slot_id, student_id, mentor_id, booking_status) VALUES (3, 3, 3, 'CANCELLED'); -- Bob with Sarah

-- 9. Feedback
INSERT INTO Feedback (booking_id, student_id, rating, comments) VALUES (1, 1, 5, 'Great session on database optimization!');
INSERT INTO Feedback (booking_id, student_id, rating, comments) VALUES (2, 2, 4, 'Very helpful for web development.');
INSERT INTO Feedback (booking_id, student_id, rating, comments) VALUES (3, 3, 3, 'Session was cancelled, but mentor was prepared.');

-- COMMIT CHANGES
COMMIT;