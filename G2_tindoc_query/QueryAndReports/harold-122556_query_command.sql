-- Harold Popluhar 122556

-- Prescription from each doctor

SELECT 
    d.id AS doctor_id,
    d.first_name,
    d.last_name,
    p.id AS precription_id,
    p.message,
    p.treatment_duration,
    p.consult_price
FROM
    prescription p
        INNER JOIN
    appointment a ON p.appointment_id = a.id
        INNER JOIN
    doctor d ON a.doctor_id = d.id
ORDER BY d.id;

-- List of medecine the patient can order

SELECT 
    p.id AS patient_id,
    p.first_name,
    p.last_name,
    m.id AS medicine_id,
    m.name
FROM
    patient p
        INNER JOIN
    bill b ON p.id = b.patient_id
        INNER JOIN
    bill_item b_i ON b_i.bill_id = b.id
        INNER JOIN
    medicine m ON m.id = b_i.medicine_id
ORDER BY p.id ASC;

-- Typical disease by each quarter
 
SELECT 
    w.id,
    w.name,
    w.Prob_first_quarter,
    x.Prob_second_quarter,
    y.Prob_third_quarter,
    z.Prob_fourth_quarter
FROM
    (SELECT 
        wa.id,
            wa.name,
            (wa.Number_of_cases_first_quarter / wb.Total_of_cases) AS Prob_first_quarter
    FROM
        (SELECT 
        ef.id,
            ef.name,
            COUNT(ef.id) AS Number_of_cases_first_quarter
    FROM
        expert_field ef
    INNER JOIN doctor d ON d.expert_field_id = ef.id
    INNER JOIN appointment a ON a.doctor_id = d.id
    WHERE
        MONTH(a.appointment_time) BETWEEN 1 AND 3
    GROUP BY ef.id
    ORDER BY COUNT(ef.id) DESC) AS wa
    INNER JOIN (SELECT 
        COUNT(ef.id) AS Total_of_cases
    FROM
        expert_field ef
    INNER JOIN doctor d ON d.expert_field_id = ef.id
    INNER JOIN appointment a ON a.doctor_id = d.id
    WHERE
        MONTH(a.appointment_time) BETWEEN 1 AND 3) AS wb) AS w
        INNER JOIN
    ((SELECT 
        wa.id,
            wa.name,
            wa.Number_of_cases_second_quarter / wb.Total_of_cases AS Prob_second_quarter
    FROM
        (SELECT 
        ef.id,
            ef.name,
            COUNT(ef.id) AS Number_of_cases_second_quarter
    FROM
        expert_field ef
    INNER JOIN doctor d ON d.expert_field_id = ef.id
    INNER JOIN appointment a ON a.doctor_id = d.id
    WHERE
        MONTH(a.appointment_time) BETWEEN 4 AND 6
    GROUP BY ef.id
    ORDER BY COUNT(ef.id) DESC) AS wa
    INNER JOIN (SELECT 
        COUNT(ef.id) AS Total_of_cases
    FROM
        expert_field ef
    INNER JOIN doctor d ON d.expert_field_id = ef.id
    INNER JOIN appointment a ON a.doctor_id = d.id
    WHERE
        MONTH(a.appointment_time) BETWEEN 4 AND 6) AS wb)) AS x ON x.id = w.id
        INNER JOIN
    ((SELECT 
        wa.id,
            wa.name,
            wa.Number_of_cases_third_quarter / wb.Total_of_cases AS Prob_third_quarter
    FROM
        (SELECT 
        ef.id,
            ef.name,
            COUNT(ef.id) AS Number_of_cases_third_quarter
    FROM
        expert_field ef
    INNER JOIN doctor d ON d.expert_field_id = ef.id
    INNER JOIN appointment a ON a.doctor_id = d.id
    WHERE
        MONTH(a.appointment_time) BETWEEN 7 AND 9
    GROUP BY ef.id
    ORDER BY COUNT(ef.id) DESC) AS wa
    INNER JOIN (SELECT 
        COUNT(ef.id) AS Total_of_cases
    FROM
        expert_field ef
    INNER JOIN doctor d ON d.expert_field_id = ef.id
    INNER JOIN appointment a ON a.doctor_id = d.id
    WHERE
        MONTH(a.appointment_time) BETWEEN 7 AND 9) AS wb)) AS y ON w.id = y.id
        INNER JOIN
    ((SELECT 
        wa.id,
            wa.name,
            wa.Number_of_cases_fourth_quarter / wb.Total_of_cases AS Prob_fourth_quarter
    FROM
        (SELECT 
        ef.id,
            ef.name,
            COUNT(ef.id) AS Number_of_cases_fourth_quarter
    FROM
        expert_field ef
    INNER JOIN doctor d ON d.expert_field_id = ef.id
    INNER JOIN appointment a ON a.doctor_id = d.id
    WHERE
        MONTH(a.appointment_time) BETWEEN 10 AND 12
    GROUP BY ef.id
    ORDER BY COUNT(ef.id) DESC) AS wa
    INNER JOIN (SELECT 
        COUNT(ef.id) AS Total_of_cases
    FROM
        expert_field ef
    INNER JOIN doctor d ON d.expert_field_id = ef.id
    INNER JOIN appointment a ON a.doctor_id = d.id
    WHERE
        MONTH(a.appointment_time) BETWEEN 10 AND 12) AS wb)) AS z ON w.id = z.id;

-- The average treatment duration for each medical problem

	SELECT 
		ef.id,
		ef.name,
		AVG(p.treatment_duration) AS average_treatment_duration,
		AVG(p.consult_price) AS average_consult_price
	FROM
		expert_field ef
			INNER JOIN
		doctor d ON d.expert_field_id = ef.id
			INNER JOIN
		appointment a ON a.doctor_id = d.id
			INNER JOIN
		prescription p ON p.appointment_id = a.id
	GROUP BY ef.id;

-- Get a fast report of previous medical problems of the patient

	SELECT 
		p.id,
		p.first_Name,
		p.last_Name,
		ef.name,
		presc.treatment_duration,
		presc.message
	FROM
		expert_field ef
			INNER JOIN
		doctor d ON d.expert_field_id = ef.id
			INNER JOIN
		appointment a ON a.doctor_id = d.id
			INNER JOIN
		patient p ON a.patient_id = p.id
			INNER JOIN
		prescription presc ON a.id = presc.appointment_id
	WHERE
		p.id = 1
	ORDER BY ef.id;

-- don't have to have a status accepted to see that the problem had a problem

	SELECT 
		p.id,
		p.first_Name,
		p.last_Name,
		ef.name,
		presc.treatment_duration,
		presc.message
	FROM
		expert_field ef
			INNER JOIN
		doctor d ON d.expert_field_id = ef.id
			INNER JOIN
		appointment a ON a.doctor_id = d.id
			INNER JOIN
		patient p ON a.patient_id = p.id
			INNER JOIN
		prescription presc ON a.id = presc.appointment_id
	WHERE
		p.id = 1
	ORDER BY ef.id;

-- Get the right distribution of doctors in each medical sector (number of appointment for the number of working hours of doctors per sector)

	SELECT 
		b1.h_id,
		b1.ef_id,
		b1.ef_name,
		b1.average_of_appointment_hours_per_week,
		b2.number_of_doctor,
		b2.number_of_working_hours_in_the_sector,
		b2.average_number_of_working_hours_per_doctor_per_week
	FROM
		(SELECT 
			a1.h_id,
				a1.ef_id,
				a1.ef_name,
				AVG(a1.total_appointment_minute_per_week) / 60 AS average_of_appointment_hours_per_week
		FROM
			(SELECT 
			h.id AS h_id,
				ef.id AS ef_id,
				ef.name AS ef_name,
				WEEK(a.appointment_time) AS week,
				SUM(a.meeting_duration) AS total_appointment_minute_per_week
		FROM
			expert_field ef
		INNER JOIN doctor d ON d.expert_field_id = ef.id
		INNER JOIN appointment a ON a.doctor_id = d.id
		INNER JOIN hospital h ON d.hospital_id = h.id
		GROUP BY WEEK(a.appointment_time) , ef.id , h.id
		ORDER BY WEEK(a.appointment_time)) AS a1
		GROUP BY a1.h_id , a1.ef_id
		ORDER BY a1.h_id) AS b1
			INNER JOIN
		(SELECT 
			a2.h_id,
				a2.ef_id,
				a2.ef_name,
				COUNT(a2.doc_id) AS number_of_doctor,
				SUM(a2.number_of_working_hours) AS number_of_working_hours_in_the_sector,
				AVG(a2.number_of_working_hours) AS average_number_of_working_hours_per_doctor_per_week
		FROM
			(SELECT 
			ef.id AS ef_id,
				ef.name AS ef_name,
				d.id AS doc_id,
				h.id AS h_id,
				SUM(ABS(TIMESTAMPDIFF(HOUR, wsh.end_time, wsh.start_time))) AS number_of_working_hours
		FROM
			expert_field ef
		INNER JOIN doctor d ON d.expert_field_id = ef.id
		INNER JOIN work w ON w.doctor_id = d.id
		INNER JOIN workshift wsh ON wsh.id = w.workshift_id
		INNER JOIN hospital h ON d.hospital_id = h.id
		GROUP BY d.id
		ORDER BY h.id) AS a2
		GROUP BY a2.h_id , a2.ef_id
		ORDER BY a2.h_id) AS b2 ON b2.h_id = b1.h_id
			AND b2.ef_id = b1.ef_id
	ORDER BY b1.h_id; 