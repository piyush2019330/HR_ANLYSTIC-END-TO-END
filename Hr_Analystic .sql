-- Create database
CREATE DATABASE IF NOT EXISTS HR_PROJECT;
USE HR_PROJECT;

-- Drop table if already created wrong
DROP TABLE IF EXISTS employees;

-- Create correct table (MATCHING HR DATASET)
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
	JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20),
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 CHAR(2),
    OverTime VARCHAR(10),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);

drop table employees;
-- Enable local infile
SET GLOBAL local_infile = 1;


LOAD DATA LOCAL INFILE '/Users/piyushdata/Desktop/HR_clean.csv'
INTO TABLE employees
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- verify data
SELECT * FROM employees;
SELECT COUNT(*) AS total_employees
FROM employees;

SELECT (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE  0 END) * 100.0 / COUNT(*)) AS attrition_rate
FROM employees;

-- Employees by department 

SELECT Department, COUNT(*) AS total
from employees
GROUP BY Department;

-- Attrition by Department 

SELECT Department,
	   COUNT(*) As total,
	   SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count 
from employees
GROUP BY Department;

-- Which department has highest attrition? 

SELECT Department, COUNT(*) AS attrition_count
from employees
where  Attrition = "Yes"
GROUP BY Department 
ORDER BY attrition_count DESC;


-- Do new employees leave more?
select count(*) as early_leavers
from employees
where YearsAtCompany <= 2
AND Attrition = 'Yes';

-- Attrition based on experience 

SELECT YearsAtCompany,
       COUNT(*) AS total,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count
       FROM employees
       GROUP BY YearsAtCompany
       ORDER BY YearsAtCompany;
       
       SELECT * FROM employees;
       
-- Does Distance from home affect attrition?

SELECT DistanceFromHome,
       COUNT(*) AS toral,
       SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) As attrition_count
from employees
GROUP BY DistanceFromHome
ORDER BY DistanceFromHome;

select 
    count(*) as total_employees,
    count(case when Attrition = 'YES' THEN 1 END) AS total_attrition
    FROM employees;

-- WHICH JOB ROLE HAS HIGHEST ATTRITION?

SELECT JobRole,
       COUNT(*) AS total,
	    SUM(CASE WHEN Attrition = "Yes" THEN 1 ELSE 0 END) AS attrition_count
FROM employees
GROUP BY JobRole
ORDER BY attrition_count DESC;


CREATE TABLE employees_final AS
SELECT 
    *,
    
    CASE 
        WHEN YearsAtCompany <= 2 AND DistanceFromHome > 10 THEN 'High Risk'
        ELSE 'Low Risk'
    END AS risk_level,

    CASE 
        WHEN Attrition = 'Yes' THEN 1
        ELSE 0
    END AS attrition_flag,

    CASE 
        WHEN DistanceFromHome <= 5 THEN 'Near'
        WHEN DistanceFromHome <= 15 THEN 'Medium'
        ELSE 'Far'
    END AS distance_category

FROM employees;

select * from employees_final;

CREATE USER 'powerbi'@'%' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON HR_PROJECT.* TO 'powerbi'@'%';
FLUSH PRIVILEGES;



    
   

















