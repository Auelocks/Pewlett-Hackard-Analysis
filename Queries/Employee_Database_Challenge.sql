--The number of retiring employees by title.
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	tt.title,
	tt.from_date,
	tt.to_date
INTO ret_titles
FROM employees as e
INNER JOIN titles as tt
ON (e.emp_no = tt.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

SELECT * FROM ret_titles;
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
INTO unique_titles
FROM ret_titles
ORDER BY emp_no, to_date DESC;

-- Use Dictinct with Orderby to remove duplicate rows, WHERE only include current employees
SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
INTO unique_titles_current
FROM ret_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;

SELECT COUNT(emp_no) FROM unique_titles_current;

--Retrieve the number of employees by most recent job title
SELECT title, COUNT(emp_no) AS "emp_count"
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY "emp_count" DESC;

--Based on current employees, Retrieve the number of employees by most recent job title
SELECT title, COUNT(emp_no) AS "emp_count"
INTO retiring_titles_current
FROM unique_titles_current
GROUP BY title
ORDER BY "emp_count" DESC;

--Employees Eligible for Mentorship Program
SELECT DISTINCT ON (emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	tl.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de ON (e.emp_no = de.emp_no)
INNER JOIN titles AS tl ON (e.emp_no = tl.emp_no)
WHERE de.to_date = ('9999-01-01') AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no;

--Create new tables with counts of eligible mentees and mentors
SELECT title, COUNT(emp_no) AS "mentee_emp_count"
INTO mentee_count
FROM mentorship_eligibility
GROUP BY title
ORDER BY "mentee_emp_count" DESC;

SELECT title, COUNT(emp_no) AS "mentor_emp_count"
INTO mentor_count
FROM unique_titles_current
GROUP BY title
ORDER BY "mentor_emp_count" DESC;

--Merge tables of employee counts to check mentor-to-mentee ratio
SELECT me.title,
	me.mentee_emp_count,
	mo.title,
	mo.mentor_emp_count
FROM mentee_count as me
FULL OUTER JOIN mentor_count as mo
ON me.title = mo.title;

