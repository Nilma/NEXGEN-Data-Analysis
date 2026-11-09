-- =========================================================
-- NEXGEN Consultants (MySQL) - SAMPLE DATA (INSERT SCRIPT)
-- =========================================================

USE nexgen;

-- Consultants
INSERT INTO Consultant (FullName, ExperienceYears) VALUES
('Aisha Rahman', 6),
('Mikkel Larsen', 10),
('Sofie Jensen', 4),
('Jonas Holm', 8);

-- Skills
INSERT INTO Skill (SkillName) VALUES
('Java'),
('UX'),
('Cloud'),
('SQL'),
('Project Management');

-- Consultant skills
INSERT INTO ConsultantSkill (ConsultantID, SkillID, SkillLevel) VALUES
(1, 1, 4), -- Aisha: Java
(1, 3, 3), -- Aisha: Cloud
(1, 4, 4), -- Aisha: SQL
(2, 1, 5), -- Mikkel: Java
(2, 5, 4), -- Mikkel: PM
(3, 2, 4), -- Sofie: UX
(3, 4, 3), -- Sofie: SQL
(4, 3, 4), -- Jonas: Cloud
(4, 4, 4); -- Jonas: SQL

-- Customers
INSERT INTO Customer (CompanyName, Industry, ContactName, ContactEmail, ContactPhone) VALUES
('Nordic Retail A/S', 'Retail', 'Camilla Lund', 'camilla.lund@nordicretail.example', '+45 11 22 33 44'),
('BlueWave Logistics', 'Logistics', 'Thomas Møller', 'thomas.moeller@bluewave.example', '+45 55 66 77 88');

-- Projects
INSERT INTO Project (CustomerID, Title, StartDate, EndDate, Budget) VALUES
(1, 'E-commerce platform modernization', '2026-01-05', NULL, 850000.00),
(2, 'Cloud migration assessment', '2026-02-01', '2026-03-15', 250000.00);

-- Assignments (agreed hourly rate per assignment)
INSERT INTO Assignment (ConsultantID, ProjectID, RoleName, HourlyRate) VALUES
(2, 1, 'Project Lead', 1200.00),
(1, 1, 'Developer',     950.00),
(3, 1, 'Designer',      850.00),
(4, 2, 'Cloud Engineer',1050.00),
(1, 2, 'Developer',     900.00);

-- Timesheets
INSERT INTO Timesheet (AssignmentID, WorkDate, Hours) VALUES
-- Project 1
(1, '2026-01-06', 6.00),
(1, '2026-01-07', 5.50),
(2, '2026-01-06', 7.50),
(2, '2026-01-08', 8.00),
(3, '2026-01-07', 6.00),
(3, '2026-01-09', 4.00),

-- Project 2
(4, '2026-02-03', 7.00),
(4, '2026-02-04', 6.50),
(5, '2026-02-03', 4.00),
(5, '2026-02-05', 5.00);

-- Quick sanity checks (optional)
-- SELECT * FROM v_ProjectBilling;
-- SELECT CompanyName, Title, TotalHours, TotalAmount FROM v_ProjectBilling ORDER BY ProjectID;
