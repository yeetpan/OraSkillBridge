CREATE SEQUENCE student_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE mentor_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE internship_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE application_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE feedback_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE interest_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE matchmaking_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE session_slot_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE stu_session_seq START WITH 1 INCREMENT BY 1;

-- === CREATE TABLES ===
CREATE TABLE Interests (
    interest_id NUMBER PRIMARY KEY,
    interest_name VARCHAR2(100)
);

CREATE TABLE Student (
    student_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    email VARCHAR2(100),
    college VARCHAR2(100)
);

CREATE TABLE Student_Interests (
    student_id NUMBER REFERENCES Student(student_id),
    interest_id NUMBER REFERENCES Interests(interest_id),
    PRIMARY KEY(student_id, interest_id)
);

CREATE TABLE Mentor (
    mentor_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    email VARCHAR2(100),
    expertise_id NUMBER REFERENCES Interests(interest_id)
);

CREATE TABLE Internship (
    internship_id NUMBER PRIMARY KEY,
    org_name VARCHAR2(100),
    title VARCHAR2(100),
    capacity NUMBER,
    description CLOB,
    deadline DATE
);

CREATE TABLE Application (
    application_id NUMBER PRIMARY KEY,
    student_id NUMBER REFERENCES Student(student_id),
    internship_id NUMBER REFERENCES Internship(internship_id),
    status VARCHAR2(50)
);

CREATE TABLE Session_Slot (
    slot_id NUMBER PRIMARY KEY,
    mentor_id NUMBER REFERENCES Mentor(mentor_id),
    session_date DATE,
    time TIMESTAMP,
    duration NUMBER,
    status VARCHAR2(20)
);

CREATE TABLE Stu_Session (
    booking_id NUMBER PRIMARY KEY,
    slot_id NUMBER REFERENCES Session_Slot(slot_id),
    student_id NUMBER REFERENCES Student(student_id),
    mentor_id NUMBER REFERENCES Mentor(mentor_id),
    booking_status VARCHAR2(50)
);

CREATE TABLE Feedback (
    feedback_id NUMBER PRIMARY KEY,
    booking_id NUMBER REFERENCES Stu_Session(booking_id),
    student_id NUMBER REFERENCES Student(student_id),
    rating NUMBER,
    comments VARCHAR2(400)
);

-- === CREATE TRIGGERS ===
CREATE OR REPLACE TRIGGER trg_student_id
BEFORE INSERT ON Student
FOR EACH ROW
BEGIN
  IF :new.student_id IS NULL THEN
    SELECT student_seq.NEXTVAL INTO :new.student_id FROM dual;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_mentor_id
BEFORE INSERT ON Mentor
FOR EACH ROW
BEGIN
  IF :new.mentor_id IS NULL THEN
    SELECT mentor_seq.NEXTVAL INTO :new.mentor_id FROM dual;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_internship_id
BEFORE INSERT ON Internship
FOR EACH ROW
BEGIN
  IF :new.internship_id IS NULL THEN
    SELECT internship_seq.NEXTVAL INTO :new.internship_id FROM dual;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_application_id
BEFORE INSERT ON Application
FOR EACH ROW
BEGIN
  IF :new.application_id IS NULL THEN
    SELECT application_seq.NEXTVAL INTO :new.application_id FROM dual;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_feedback_id
BEFORE INSERT ON Feedback
FOR EACH ROW
BEGIN
  IF :new.feedback_id IS NULL THEN
    SELECT feedback_seq.NEXTVAL INTO :new.feedback_id FROM dual;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_interest_id
BEFORE INSERT ON Interests
FOR EACH ROW
BEGIN
  IF :new.interest_id IS NULL THEN
    SELECT interest_seq.NEXTVAL INTO :new.interest_id FROM dual;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_session_slot_id
BEFORE INSERT ON Session_Slot
FOR EACH ROW
BEGIN
  IF :new.slot_id IS NULL THEN
    SELECT session_slot_seq.NEXTVAL INTO :new.slot_id FROM dual;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_stu_session_id
BEFORE INSERT ON Stu_Session
FOR EACH ROW
BEGIN
  IF :new.booking_id IS NULL THEN
    SELECT stu_session_seq.NEXTVAL INTO :new.booking_id FROM dual;
  END IF;
END;
/

--POPULATING THE DATA
--Sample Student Data
INSERT INTO Student (name, email, college) VALUES ('Alice Johnson', 'alice@example.com', 'XYZ University');
INSERT INTO Student (name, email, college) VALUES ('Bob Smith', 'bob@example.com', 'ABC Institute');
INSERT INTO Student (name, email, college) VALUES ('Charlie Davis', 'charlie@edu.org', 'Tech University');
INSERT INTO Student (name, email, college) VALUES ('Diana Lee', 'diana@campusmail.com', 'MIT');
INSERT INTO Student (name, email, college) VALUES ('Ethan Hunt', 'ethan@uniworld.edu', 'Stanford University');
--Sample Mentor Data
INSERT INTO Mentor (name, email, expertise_id) VALUES ('Dr. Emily Ray', 'emily@mentors.com', 1);
INSERT INTO Mentor (name, email, expertise_id) VALUES ('Mr. John Doe', 'john@mentors.com', 3);
INSERT INTO Mentor (name, email, expertise_id) VALUES ('Ms. Sarah Kim', 'sarah.kim@mentors.com', 2);
INSERT INTO Mentor (name, email, expertise_id) VALUES ('Prof. Anil Mehta', 'anil@iit.edu', 4);
INSERT INTO Mentor (name, email, expertise_id) VALUES ('Dr. Julia Stone', 'jstone@mentorhub.com', 5);
--Sample Internship Data
INSERT INTO Internship (org_name, title, capacity, description, deadline)
VALUES ('Tech Corp', 'Backend Developer Intern', 3, 'Work on backend APIs and microservices.', TO_DATE('2025-07-15', 'YYYY-MM-DD'));

INSERT INTO Internship (org_name, title, capacity, description, deadline)
VALUES ('CyberSecure Inc.', 'Security Analyst Intern', 2, 'Assist in penetration testing and audit logs.', TO_DATE('2025-08-01', 'YYYY-MM-DD'));

INSERT INTO Internship (org_name, title, capacity, description, deadline)
VALUES ('AI Labs', 'ML Research Intern', 4, 'Support in model training and evaluation.', TO_DATE('2025-07-30', 'YYYY-MM-DD'));

INSERT INTO Internship (org_name, title, capacity, description, deadline)
VALUES ('WebSolutions', 'Frontend Developer Intern', 5, 'Build responsive web interfaces.', TO_DATE('2025-07-25', 'YYYY-MM-DD'));

INSERT INTO Internship (org_name, title, capacity, description, deadline)
VALUES ('HealthTech AI', 'Data Science Intern', 2, 'Analyze medical data trends.', TO_DATE('2025-08-05', 'YYYY-MM-DD'));
--Sample Session_Slot Data
INSERT INTO Session_Slot (mentor_id, session_date, time, duration, status)
VALUES (1, TO_DATE('2025-06-20', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-06-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 60, 'Available');

INSERT INTO Session_Slot (mentor_id, session_date, time, duration, status)
VALUES (2, TO_DATE('2025-06-21', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-06-21 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 45, 'Available');

INSERT INTO Session_Slot (mentor_id, session_date, time, duration, status)
VALUES (3, TO_DATE('2025-06-22', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-06-22 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 30, 'Booked');

INSERT INTO Session_Slot (mentor_id, session_date, time, duration, status)
VALUES (4, TO_DATE('2025-06-23', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-06-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 60, 'Available');

INSERT INTO Session_Slot (mentor_id, session_date, time, duration, status)
VALUES (5, TO_DATE('2025-06-24', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-06-24 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 30, 'Available');
