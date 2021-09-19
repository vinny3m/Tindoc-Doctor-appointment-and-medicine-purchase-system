-- Can see the appointment time.
SELECT 
    appointment.patient_id,
    CONCAT(doctor.first_name, ' ', doctor.last_name) AS doctor_name,
    appointment.appointment_time
FROM
    appointment
        INNER JOIN
    doctor ON appointment.doctor_id = doctor.id
WHERE
    patient_id = 13;
-- Number of hospitals which treat the medical problem near to the location of the patient
SELECT 
    DISTINCT(hospital.id) AS hospital_id,
    hospital.name AS hospital_name,
    hospital.state,
    expert_field.name AS disease_field
FROM
    doctor
        INNER JOIN
    hospital ON doctor.hospital_id = hospital.id
		INNER JOIN
	expert_field ON doctor.expert_field_id = expert_field.id
WHERE doctor.expert_field_id = 4 AND hospital.state = 'Louisiana'
ORDER BY hospital.id;
-- Find which hospitals have more doctors than average assume that the average doctors in a hospital might be 25 (Use having clause)
SELECT 
    hospital.id AS hospital_id,
    hospital.name AS hospital_name,
    hospital.state,
    COUNT(doctor.id) AS doctor_count
FROM
    doctor
        INNER JOIN
    hospital ON doctor.hospital_id = hospital.id
GROUP BY hospital.id
HAVING doctor_count > (SELECT 
        AVG(doctor_count)
    FROM
        (SELECT 
            COUNT(doctor.id) AS doctor_count
        FROM
            doctor
        INNER JOIN hospital ON doctor.hospital_id = hospital.id
        GROUP BY hospital.id) count);
-- Can see their work hours
SELECT 
    doctor.id,
    first_name,
    middle_name,
    last_name,
    start_time,
    end_time,
    day
FROM
    doctor
        INNER JOIN
    work ON doctor.id = work.doctor_id
        INNER JOIN
    workshift ON work.workshift_id = workshift.id
WHERE
    doctor.id = 18;
-- Can see the number of patients that make appointment between particular time.
SELECT 
    appointment.id,
    CONCAT(patient.first_name,
            ' ',
            patient.last_name) AS patient_name,
    appointment_time,
    meeting_type,
    message,
    status,
    appointment.created_at,
    appointment.updated_at
FROM
    appointment
        INNER JOIN
    patient ON appointment.patient_id = patient.id
WHERE
    doctor_id = 1
        AND appointment_time BETWEEN '2021-08-01 23:59:59' AND '2021-09-09 23:59:59'
        AND status = 'accepted';
-- How many doctor for each work shift
SELECT 
    workshift_id,
    workshift.day,
    workshift.start_time,
    workshift.end_time,
    COUNT(doctor_id)
FROM
    work
        INNER JOIN
    workshift ON work.workshift_id = workshift.id
GROUP BY workshift_id;
-- Total cases for each expert field in specific date.
SELECT 
    expert_field_id,
    expert_field.name,
    expert_field.description,
    COUNT(appointment.id)
FROM
    appointment
        INNER JOIN
    doctor ON appointment.doctor_id = doctor.id
        INNER JOIN
    expert_field ON expert_field.id = doctor.expert_field_id
WHERE
    appointment_time BETWEEN '2020-01-01 23:59:59' AND '2021-09-09 23:59:59'
GROUP BY expert_field_id;