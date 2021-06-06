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

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
INTO unique_titles
FROM ret_titles
ORDER BY emp_no, to_date DESC;

--Retrieve the number of employees by most recent job title
SELECT title, COUNT(emp_no) AS "emp_count"
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY "emp_count" DESC;
