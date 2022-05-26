-- Creating tables for PH-EmployeeDB

-- drop TABLE dept_emp

create table title(
	 emp_no INT NOT NULL,
     title VARCHAR NOT NULL,
     from_date DATE NOT NULL,
	 to_date DATE NOT NULL,
     FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	 FOREIGN KEY (emp_no) REFERENCES salaries (emp_no),
     PRIMARY KEY (emp_no, title, from_date) 
);

--DROP TABLE title;

SELECT * FROM departments;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM dept_emp;
SELECT * FROM title;

-- DROP TABLE employees CASCADE;
-- CASCADE: also remove the connections to other tables in the database

-- Retirement Eligibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT count(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- INTO: create a new table then insert info that was selected
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- CREATE new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
-- SELECT only dept_name in depatment's table, emp_no, from_date and to_date in dept_manager table
-- FROM departments table (table 1)
-- INNER JOIN dept_manager(points to table 2)
-- ON departments.dept_no = dept_manager.dept_no: looking the match dept_no
SELECT departments.dept_name, dept_manager.emp_no, dept_manager.from_date, dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;


SELECT d.dept_name, dm.emp_no, dm.from_date, dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no;

-- Create table "current_emp" that hoding employee  still employed
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- retrn table of curent employees who are eligible for retirement
SELECT * FROM current_emp;

-- Employee count by department number
-- group by depatment number
-- order by(sort by) smallest to largest department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO current_retire_employee_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT emp_no, first_name,last_name,gender
INTO emp_info
FROM EMPLOYEES
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM emp_info;
DROP table emp_info;

-- SELECT emp_no, first_name,last_name, gender from employees table
-- SELECT salary from salaries table
-- SELECT to_date from dept_emp table
-- all info into new table "emp_info"
-- we only want emp_no that match with employees and salary table, AND employees and dept_emp table
-- inner join; only shows emp_no that exist in all three employee, salary, dept_emp tables
-- filter that only want birth date in between 1952-1955, hiredate between 1985 and 1988
-- filter that still working as current employee
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');



-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
SELECT * FROM manager_info;

-- Get the list of name and department belongs to
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp as de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no);

SELECT * FROM dept_info;

SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
INTO sales_info
FROM current_emp AS ce
INNER JOIN dept_emp as de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE (d.dept_name = 'Sales');

SELECT * FROM sales_info;
DROP TABLE sales_info;

SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
INTO sales_and_dev_info
FROM current_emp AS ce
INNER JOIN dept_emp as de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE (d.dept_name = 'Sales')
OR (d.dept_name = 'Development');

SELECT * FROM sales_and_dev_info;