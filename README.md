# SkillBridge CRM Console App (Java + JDBC with Oracle XE)

**SkillBridge** is a nonprofit console-based CRM system that connects students with mentors and internship opportunities. This version uses **Java + JDBC** and is built with a structured package layout under `com.skillbridge.*`.

---

## Tech Stack

- **Java 17+**
- **Oracle Database XE (21c or 18c)**
- **Oracle SQL Developer** (to manage DB & run `pop.sql`)
- **Oracle JDBC Driver (`ojdbc17.jar`)**

---
## 🎥 Project Demo

[![Watch the demo](https://img.youtube.com/vi/w2smXvJxYaE/0.jpg)](https://www.youtube.com/watch?v=w2smXvJxYaE)

## Getting Started

### Prerequisites

- Oracle XE installed and running
- Tables, triggers, and sequences are created and populated via the `pop.sql` script

---

## Compilation Instructions

To compile the project manually using the command line, follow this sequence (or use an IDE like IntelliJ where only `App.java` needs to be run if dependencies are configured):

### 1. Compile DB Connection Utility
```
javac com/skillbridge/util/DB.java
```

### 2. Compile Entities
```
javac com/skillbridge/entities/*.java
```

### 3. Compile SQL Query Classes
```
javac com/skillbridge/queries/*.java
```

### 4. Compile DAOs
```
javac com/skillbridge/DAO/*.java
```

### 5. Compile Services
```
javac com/skillbridge/services/*.java
```

### 6. Compile and Run App
```
javac com/skillbridge/App.java
java com.skillbridge.App
```

---

## Database Setup

Run the `pop.sql` file using **Oracle SQL Developer** or any Oracle-compatible SQL CLI tool to:
- Create all tables
- Define sequences and triggers for auto-generating primary keys
- Insert sample data for `Students`, `Mentors`, `Interests`, `Internships`, and `Session_Slot`

---

## Folder Summary

| Folder             | Purpose                                                              |
|--------------------|----------------------------------------------------------------------|
| `util/`            | DB connection helper using Oracle JDBC (`ojdbc`)                     |
| `entities/`        | POJO classes representing each table (Student, Mentor, etc.)         |
| `queries/`         | SQL strings for each entity's operations                             |
| `DAO/`             | Handles actual SQL interactions using `PreparedStatement`            |
| `services/`        | Contains business logic for workflows like booking or matching       |
| `App.java`         | Entry point and menu for interacting with the console system         |

---

## Notes

- All primary keys are generated using **Oracle SEQUENCE + TRIGGER** setup
- All foreign key constraints are enforced
- String constants are used for statuses (`Available`, `Booked`, etc.)
- SQL statements are Oracle-compliant and tuned for Oracle JDBC
- `pop.sql` includes both structure + seed data for easier local testing
- Schema includes integrity and status validation logic

---


