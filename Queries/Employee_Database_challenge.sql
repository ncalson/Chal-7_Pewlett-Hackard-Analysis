-- Deliverable 1
SELECT e.emp_no,
    e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN title as ti ON (e.emp_no = ti.emp_no)
INNER JOIN dept_emp as de ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles AS rt
Order BY emp_no, to_date DESC;

SELECT COUNT(ut.emp_no),ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title 
ORDER BY COUNT(ut.title) DESC;

-- Deliverable 2
SELECT DISTINCT ON(e.emp_no)e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
de.from_date,
ti.title
INTO mentor_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de ON (e.emp_no = de.emp_no)
INNER JOIN title AS ti ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no;

SELECT COUNT(me.emp_no),me.title
INTO mentor_titles
FROM mentor_eligibility as me
GROUP BY title 
ORDER BY COUNT(title) DESC;

SELECT mt.title,
	mt.count AS mentor_count,
	rt.count AS retiree_count
INTO retiree_mentor
FROM mentor_titles AS mt
INNER JOIN retiring_titles AS rt ON (mt.title = rt.title)
ORDER BY title;