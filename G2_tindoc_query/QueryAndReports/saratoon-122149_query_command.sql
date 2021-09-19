-- Saratoon Khantasima 122149

-- Most needed field of expertise filter by age and gender
	SELECT 
		(SELECT 
				e.name
			FROM
				myfirstdb.patient p
					INNER JOIN
				myfirstdb.appointment a ON p.id = a.patient_id
					INNER JOIN
				myfirstdb.doctor d ON a.doctor_id = d.id
					INNER JOIN
				myfirstdb.expert_field e ON d.expert_field_id = e.id
			WHERE
				p.gender = 'M'
					AND TIMESTAMPDIFF(YEAR,
					p.date_of_birth,
					NOW()) < 20
			GROUP BY e.id
			ORDER BY COUNT(e.id) DESC
			LIMIT 1) AS 'Most needed field of expertise for Male age below 20',
		(SELECT 
				e.name
			FROM
				myfirstdb.patient p
					INNER JOIN
				myfirstdb.appointment a ON p.id = a.patient_id
					INNER JOIN
				myfirstdb.doctor d ON a.doctor_id = d.id
					INNER JOIN
				myfirstdb.expert_field e ON d.expert_field_id = e.id
			WHERE
				p.gender = 'M'
					AND TIMESTAMPDIFF(YEAR,
					p.date_of_birth,
					NOW()) > 20
					AND TIMESTAMPDIFF(YEAR,
					p.date_of_birth,
					NOW()) < 40
			GROUP BY e.id
			ORDER BY COUNT(e.id) DESC
			LIMIT 1) AS 'Most needed field of expertise for Male age between 20 and 40',
		(SELECT 
				e.name
			FROM
				myfirstdb.patient p
					INNER JOIN
				myfirstdb.appointment a ON p.id = a.patient_id
					INNER JOIN
				myfirstdb.doctor d ON a.doctor_id = d.id
					INNER JOIN
				myfirstdb.expert_field e ON d.expert_field_id = e.id
			WHERE
				p.gender = 'M'
					AND TIMESTAMPDIFF(YEAR,
					p.date_of_birth,
					NOW()) > 40
			GROUP BY e.id
			ORDER BY COUNT(e.id) DESC
			LIMIT 1) AS 'Most needed field of expertise for Male age above 40',
		(SELECT 
				e.name
			FROM
				myfirstdb.patient p
					INNER JOIN
				myfirstdb.appointment a ON p.id = a.patient_id
					INNER JOIN
				myfirstdb.doctor d ON a.doctor_id = d.id
					INNER JOIN
				myfirstdb.expert_field e ON d.expert_field_id = e.id
			WHERE
				p.gender = 'F'
					AND TIMESTAMPDIFF(YEAR,
					p.date_of_birth,
					NOW()) < 20
			GROUP BY e.id
			ORDER BY COUNT(e.id) DESC
			LIMIT 1) AS 'Most needed field of expertise for Female age below 20',
		(SELECT 
				e.name
			FROM
				myfirstdb.patient p
					INNER JOIN
				myfirstdb.appointment a ON p.id = a.patient_id
					INNER JOIN
				myfirstdb.doctor d ON a.doctor_id = d.id
					INNER JOIN
				myfirstdb.expert_field e ON d.expert_field_id = e.id
			WHERE
				p.gender = 'F'
					AND TIMESTAMPDIFF(YEAR,
					p.date_of_birth,
					NOW()) > 20
					AND TIMESTAMPDIFF(YEAR,
					p.date_of_birth,
					NOW()) < 40
			GROUP BY e.id
			ORDER BY COUNT(e.id) DESC
			LIMIT 1) AS 'Most needed field of expertise for Female age between 20 and 40',
		(SELECT 
				e.name
			FROM
				myfirstdb.patient p
					INNER JOIN
				myfirstdb.appointment a ON p.id = a.patient_id
					INNER JOIN
				myfirstdb.doctor d ON a.doctor_id = d.id
					INNER JOIN
				myfirstdb.expert_field e ON d.expert_field_id = e.id
			WHERE
				p.gender = 'F'
					AND TIMESTAMPDIFF(YEAR,
					p.date_of_birth,
					NOW()) > 40
			GROUP BY e.id
			ORDER BY COUNT(e.id) DESC
			LIMIT 1) AS 'Most needed field of expertise for Female age above 40';

-- 	How many patients per month

	select 
	(SELECT count(a.patient_id) FROM myfirstdb.appointment a inner join myfirstdb.patient p
	on a.patient_id = p.Id
	where a.appointment_time between '2020-09-01 00:00:00' and '2020-10-01 00:00:00') as "Number of patients in Sep 2020",
	(SELECT count(a.patient_id) FROM myfirstdb.appointment a inner join myfirstdb.patient p
	on a.patient_id = p.Id
	where a.appointment_time between '2020-10-01 00:00:00' and '2020-11-01 00:00:00') as "Number of patients in Oct 2020",
	(SELECT count(a.patient_id) FROM myfirstdb.appointment a inner join myfirstdb.patient p
	on a.patient_id = p.Id
	where a.appointment_time between '2020-11-01 00:00:00' and '2020-12-01 00:00:00') as "Number of patients in Nov 2020",
	(SELECT count(a.patient_id) FROM myfirstdb.appointment a inner join myfirstdb.patient p
	on a.patient_id = p.Id
	where a.appointment_time between '2020-12-01 00:00:00' and '2021-01-01 00:00:00') as "Number of patients in Dec 2020",
	(SELECT count(a.patient_id) FROM myfirstdb.appointment a inner join myfirstdb.patient p
	on a.patient_id = p.Id
	where a.appointment_time between '2021-01-01 00:00:00' and '2021-02-01 00:00:00') as "Number of patients in Jan 2021",
	(SELECT count(a.patient_id) FROM myfirstdb.appointment a inner join myfirstdb.patient p
	on a.patient_id = p.Id
	where a.appointment_time between '2021-02-01 00:00:00' and '2021-03-01 00:00:00') as "Number of patients in Feb 2021",
	(SELECT count(a.patient_id) FROM myfirstdb.appointment a inner join myfirstdb.patient p
	on a.patient_id = p.Id
	where a.appointment_time between '2021-03-01 00:00:00' and '2021-04-01 00:00:00') as "Number of patients in Mar 2021"
	,(SELECT count(a.patient_id) FROM myfirstdb.appointment a inner join myfirstdb.patient p
	on a.patient_id = p.Id
	where a.appointment_time between '2021-04-01 00:00:00' and '2021-05-01 00:00:00') as "Number of patients in Apr 2021"
	,(SELECT count(a.patient_id) FROM myfirstdb.appointment a inner join myfirstdb.patient p
	on a.patient_id = p.Id
	where a.appointment_time between '2021-05-01 00:00:00' and '2021-06-01 00:00:00') as "Number of patients in May 2021"
	,(SELECT count(a.patient_id) FROM myfirstdb.appointment a inner join myfirstdb.patient p
	on a.patient_id = p.Id
	where a.appointment_time between '2021-06-01 00:00:00' and '2021-07-01 00:00:00') as "Number of patients in Jun 2021"
	,(SELECT count(a.patient_id) FROM myfirstdb.appointment a inner join myfirstdb.patient p
	on a.patient_id = p.Id
	where a.appointment_time between '2021-07-01 00:00:00' and '2021-08-01 00:00:00') as "Number of patients in Jul 2021"
	,(SELECT count(a.patient_id) FROM myfirstdb.appointment a inner join myfirstdb.patient p
	on a.patient_id = p.Id
	where a.appointment_time between '2021-08-01 00:00:00' and '2021-09-01 00:00:00') as "Number of patients in Aug 2021"
	;

-- See bill details

	SELECT 
		*
	FROM
		myfirstdb.bill;

-- See the patient who often sick

	SELECT 
		patient_id, COUNT(id) AS 'number of appointment'
	FROM
		myfirstdb.appointment
	GROUP BY patient_id
	ORDER BY COUNT(id) DESC;

-- No of case for each doctor

	SELECT 
		d.id,
		d.first_name,
		d.middle_name,
		d.last_name,
		COUNT(a.id) AS 'number of cases'
	FROM
		myfirstdb.doctor d
			INNER JOIN
		myfirstdb.appointment a ON d.id = a.doctor_id
	GROUP BY d.id;
    
-- check the rating for doctor

	SELECT 
		doctor_id, AVG(rating_score) AS 'Rating for doctor'
	FROM
		myfirstdb.appointment
	GROUP BY doctor_id;