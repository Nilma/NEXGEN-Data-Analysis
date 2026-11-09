-- =========================================================
-- NEXGEN Consultants (MySQL) - CREATE SCRIPT
-- Built from the case requirements: consultants, customers,
-- projects, assignments, and billing via hours * hourly rate.
-- =========================================================

DROP DATABASE IF EXISTS nexgen;
CREATE DATABASE nexgen CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nexgen;

-- -------------------------
-- Core master data tables
-- -------------------------

CREATE TABLE Consultant (
  ConsultantID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  FullName     VARCHAR(80) NOT NULL,
  ExperienceYears TINYINT UNSIGNED NOT NULL,
  CONSTRAINT chk_consultant_experience
    CHECK (ExperienceYears BETWEEN 0 AND 60)
);

CREATE TABLE Skill (
  SkillID   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  SkillName VARCHAR(50) NOT NULL,
  CONSTRAINT uq_skill_name UNIQUE (SkillName)
);

-- Many-to-many: Consultant <-> Skill
CREATE TABLE ConsultantSkill (
  ConsultantID INT NOT NULL,
  SkillID      INT NOT NULL,
  SkillLevel   TINYINT UNSIGNED NULL, -- optional 1-5
  CONSTRAINT chk_skill_level CHECK (SkillLevel IS NULL OR SkillLevel BETWEEN 1 AND 5),
  PRIMARY KEY (ConsultantID, SkillID),
  FOREIGN KEY (ConsultantID) REFERENCES Consultant(ConsultantID)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (SkillID) REFERENCES Skill(SkillID)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Customer (
  CustomerID   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  CompanyName  VARCHAR(100) NOT NULL,
  Industry     VARCHAR(60)  NOT NULL,
  ContactName  VARCHAR(80)  NOT NULL,
  ContactEmail VARCHAR(120) NULL,
  ContactPhone VARCHAR(30)  NULL,
  CONSTRAINT uq_customer_company UNIQUE (CompanyName)
);

CREATE TABLE Project (
  ProjectID   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  CustomerID  INT NOT NULL,
  Title       VARCHAR(120) NOT NULL,
  StartDate   DATE NOT NULL,
  EndDate     DATE NULL,
  Budget      DECIMAL(12,2) NULL,

  CONSTRAINT chk_project_dates CHECK (EndDate IS NULL OR EndDate >= StartDate),
  CONSTRAINT chk_project_budget CHECK (Budget IS NULL OR Budget >= 0),

  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- -------------------------
-- Work allocation + billing
-- -------------------------

-- Assignment: which consultant works on which project + role.
-- We store the agreed hourly rate per assignment (can vary by project/role).
CREATE TABLE Assignment (
  AssignmentID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ConsultantID INT NOT NULL,
  ProjectID    INT NOT NULL,
  RoleName     VARCHAR(40) NOT NULL,
  HourlyRate   DECIMAL(10,2) NOT NULL,

  CONSTRAINT chk_hourly_rate CHECK (HourlyRate BETWEEN 0 AND 999999.99),
  CONSTRAINT uq_assignment UNIQUE (ConsultantID, ProjectID, RoleName),

  FOREIGN KEY (ConsultantID) REFERENCES Consultant(ConsultantID)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Timesheet: hours registered per day per assignment.
-- Billing can be computed as SUM(Hours * HourlyRate) per project/customer.
CREATE TABLE Timesheet (
  TimesheetID   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  AssignmentID  INT NOT NULL,
  WorkDate      DATE NOT NULL,
  Hours         DECIMAL(5,2) NOT NULL,

  CONSTRAINT chk_hours CHECK (Hours > 0 AND Hours <= 24),

  FOREIGN KEY (AssignmentID) REFERENCES Assignment(AssignmentID)
    ON UPDATE CASCADE ON DELETE CASCADE,

  -- Prevent duplicate registrations for same day per assignment
  CONSTRAINT uq_timesheet UNIQUE (AssignmentID, WorkDate)
);

-- Helpful views for invoicing
CREATE VIEW v_ProjectBilling AS
SELECT
  p.ProjectID,
  p.Title,
  p.CustomerID,
  c.CompanyName,
  SUM(t.Hours) AS TotalHours,
  SUM(t.Hours * a.HourlyRate) AS TotalAmount
FROM Project p
JOIN Customer c   ON c.CustomerID = p.CustomerID
JOIN Assignment a ON a.ProjectID = p.ProjectID
JOIN Timesheet t  ON t.AssignmentID = a.AssignmentID
GROUP BY p.ProjectID, p.Title, p.CustomerID, c.CompanyName;

