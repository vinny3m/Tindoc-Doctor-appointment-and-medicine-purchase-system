-- Nopphawan Nurnuansuwan 122410

-- Can see appointment and prescription history. (e.g. patient id = 3)

	SELECT 
		ap.appointment_time AS 'Appointment date/time',
		CONCAT(dr.first_name, ' ', dr.last_name) AS 'Doctor name',
		ap.meeting_type AS 'Meeting type',
		ap.meeting_duration AS 'Meeting duration (min)',
		ap.message AS 'Appointment detail',
		ps.message AS 'Prescription message',
		ps.consult_price AS 'Consult price (USD)'
	FROM
		((patient pt
		LEFT JOIN appointment ap ON ap.patient_id = pt.id)
		LEFT JOIN prescription ps ON ap.id = ps.appointment_id)
			LEFT JOIN
		doctor dr ON ap.doctor_id = dr.id
	WHERE
		pt.id = 3
	ORDER BY ap.appointment_time DESC;

-- Can see average days that each doctor accepts an appointment.

	SELECT 
		dr.first_name,
		AVG((DATEDIFF(ap.created_at, ap.updated_at))) AS Average_day
	FROM
		appointment ap
			LEFT JOIN
		doctor dr ON ap.doctor_id = dr.id
	WHERE
		ap.status = 'accepted'
	GROUP BY dr.id
	ORDER BY Average_day DESC;

-- Number of patient living in each state in selected hospital 

	SELECT 
		pt.state, COUNT(pt.state) AS 'Number of patient'
	FROM
		patient pt
			LEFT JOIN
		appointment ap ON pt.id = ap.patient_id
			LEFT JOIN
		doctor dr ON ap.doctor_id = dr.id
			LEFT JOIN
		hospital hp ON dr.hospital_id = hp.id
	WHERE
		hp.id = 2
	GROUP BY pt.state
	ORDER BY pt.state;

-- Get the most common disease in the state (Max number of cases in specific field in each state)

	SELECT 
		State, Disease, MAX(CT) AS 'Number of case'
	FROM
		(SELECT 
			pt.state AS State, ep.name AS Disease, COUNT(*) AS CT
		FROM
			(patient pt
		RIGHT JOIN appointment ap ON pt.id = ap.patient_id
		LEFT JOIN doctor dr ON ap.doctor_id = dr.id
		LEFT JOIN expert_field ep ON dr.expert_field_id = ep.id)
		GROUP BY ep.name , pt.state) T
	GROUP BY State
	ORDER BY State;

-- Show all patients who didn’t have any appointment and bills

	SELECT 
		pt.ssn,
		CONCAT(pt.first_name, ' ', pt.last_name) AS 'Patient name'
	FROM
		patient pt
			LEFT JOIN
		appointment ap ON pt.id = ap.patient_id
			LEFT JOIN
		bill b ON pt.id = b.patient_id
	WHERE
		b.id IS NULL AND ap.id IS NULL;

/* Show the patient information with their current age, number of appointment that they have made, 
number of bill that they have created, total appointment and bill, and number of medicine that they have ordered. */

	SELECT 
		CONCAT(pt.first_name, ' ', pt.last_name) AS 'Patient name',
		pt.phone_number,
		pt.email,
		pt.state,
		TIMESTAMPDIFF(YEAR,
			pt.date_of_birth,
			NOW()) AS 'age',
		A.Ap_no AS Appointment_no,
		B.Bill_no AS Bill_no,
		(SELECT Appointment_no + Bill_no) AS Total_Appointment_Bill,
		BT.Med_no AS Medicine_no
	FROM
		patient pt
			LEFT JOIN
		(SELECT 
			pt.id AS id, COUNT(ap.id) AS Ap_no
		FROM
			patient pt
		LEFT JOIN appointment ap ON pt.id = ap.patient_id
		GROUP BY pt.id) A ON A.id = pt.id
			LEFT JOIN
		(SELECT 
			pt.id AS id, COUNT(b.id) AS Bill_no
		FROM
			patient pt
		LEFT JOIN bill b ON pt.id = b.patient_id
		GROUP BY pt.id) B ON B.id = pt.id
			LEFT JOIN
		(SELECT 
			pt.id AS id, COUNT(bt.id) AS Med_no
		FROM
			patient pt
		LEFT JOIN bill b ON pt.id = b.patient_id
		LEFT JOIN bill_item bt ON b.id = bt.bill_id
		GROUP BY pt.id) BT ON BT.id = pt.id
	ORDER BY Total_Appointment_Bill DESC;