# 🏏 Pie-in-the-Sky – IPL Match Bidding App

Pie-in-the-Sky is a **database-driven IPL Match Bidding application** designed to allow registered users to legally bid on IPL matches and earn points based on correct predictions. The project focuses on **SQL-based data modeling, querying, and analytics** to derive meaningful insights from match and bidding data.

This project was developed as part of an **SQL & Database Management learning initiative**, emphasizing real-world schema design, relationships, and advanced SQL queries.

---

## 📌 Key Features

### 👤 User & Bidding Features

* User registration and authentication (Admin / Bidder)
* Predict match winners before the toss
* Modify or cancel bids before match start
* Earn points for correct predictions (no negative points)
* View personal points and leaderboard ranking
* View top 3 bidders on the leaderboard
* Access team standings and match schedules

### 🏆 Dynamic Point System

* **Tournament start (all teams at 0 points):** Correct prediction = 2 points
* **Points difference ≤ 6:**

  * Predict higher-point team → 2 points
  * Predict lower-point team → 3 points
* **Points difference > 6:**

  * Predict higher-point team → 2 points
  * Predict lower-point team → 5 points

### 🛠️ Admin Capabilities

* Manage tournaments, teams, players, and stadiums
* Schedule and reschedule matches
* Declare match results and winners
* Update team and player statistics
* Monitor bidder participation and team support percentage

---

## 🗂️ Database Design

The project consists of **12 normalized tables**, designed to capture tournament, match, team, player, bidder, and bidding details.

### 📋 List of Tables

1. **IPL_User** – User authentication and roles
2. **IPL_Stadium** – Stadium details
3. **IPL_Team** – Team master data
4. **IPL_Player** – Player details and performance
5. **IPL_Team_Players** – Team–Player mapping
6. **IPL_Tournament** – Tournament details
7. **IPL_Match** – Match-level information
8. **IPL_Match_Schedule** – Scheduling and venue details
9. **IPL_Bidder_Details** – Bidder personal details
10. **IPL_Bidding_Details** – Bidding activity and status
11. **IPL_Bidder_Points** – Bidder points summary
12. **IPL_Team_Standings** – Team standings and points

> 📌 The schema supports **primary keys, foreign keys, composite keys, and constraints** to maintain data integrity.

---

## 🧩 ER Diagram

The ER Diagram visually represents relationships among users, bidders, matches, teams, tournaments, and bids.

*(Refer to ER Diagram included in the project files)*

---

## 🛠️ Technologies Used

* **MySQL / SQL**
* Relational Database Design
* Joins, Subqueries, Aggregations
* Window Functions
* Triggers

---

## 🚀 How to Run the Project

1. Install **MySQL Server** and **MySQL Workbench**
2. Create a new database
3. Run the provided SQL script to:

   * Create tables
   * Insert sample data
4. Validate execution using `SELECT` queries
5. Execute analytical SQL queries to derive insights

---

## 🔍 Problem Statement

The objective of this project is to **analyze IPL match and bidding data using SQL queries** and derive insights such as:

* Bidder win percentages
* Stadium-wise match statistics
* Toss impact on match outcomes
* Bidder performance trends
* Team and player performance analysis

Each query result is followed by **business insights** derived from the output.

---

## ❓ Sample SQL Questions Solved

* Percentage of wins for each bidder
* Stadium-wise match count
* Toss winner vs match winner analysis
* Team performance (wins/losses)
* Bowler and all-rounder analysis
* Year-wise and month-wise bidder points
* Top 3 & Bottom 3 bidders
* Advanced queries using joins and subqueries
* Trigger-based data backup implementation

---

## ⚙️ Additional Feature – Trigger Implementation

Two tables were created:

* **Student_Details**
* **Student_Details_Backup**

A **database trigger** ensures that whenever a student record is inserted or updated, the old data is automatically stored in the backup table. This simulates a real-world **audit and recovery mechanism**.

---

## 📈 Learning Outcomes

* Strong understanding of relational database design
* Hands-on experience with complex SQL queries
* Real-world data analysis and insight generation
* Practical use of triggers for data backup
* Business-focused interpretation of query results

---

## 👩‍💻 Author

**Alisha Verma**
MCA | Aspiring Data Analyst
Skills: SQL, MySQL, Data Analysis, AWS

---

⭐ If you find this project helpful, feel free to star the repository!
