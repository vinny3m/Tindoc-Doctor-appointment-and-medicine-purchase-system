#1)Show doctor information with their name, email,expert field, hospital which they belong to, no of appointments, no of working hours, average rating for a doctor, maximum rating, min rating of a doctor, no of patients who visited the doctor. **
SELECT dr.id,
       Concat(dr.first_name, ' ', dr.middle_name, ' ', dr.last_name) AS
       'doctor name',
       a.a_count                                                     AS
       'no of appointments',
       b.b_avg_rat                                                   AS
       'averating rating of the doctor',
       c.c_max_rat                                                   AS
       'maximum rating of the doctor',
       d.d_min_rat                                                   AS
       'minimum rating of the doctor',
       e.e_cnt_of_patients_who_visited_him                           AS
       'no of patients who have visited this doctor',
       ef.NAME                                                       AS
       'expert field name',
       h.NAME                                                        AS
       'hospital name',
       dr.email
FROM   myfirstdb.doctor dr
       INNER JOIN (SELECT Count(ap.id) AS a_count,
                          dr.id        AS a_doctor_id
                   FROM   myfirstdb.doctor dr
                          INNER JOIN myfirstdb.appointment ap
                                  ON ap.doctor_id = dr.id
                   GROUP  BY dr.id) AS a
               ON a.a_doctor_id = dr.id
       INNER JOIN (SELECT Round(Avg(ap.rating_score)) AS b_avg_rat,
                          dr.id                       AS b_doctor_id
                   FROM   myfirstdb.appointment ap
                          INNER JOIN myfirstdb.doctor dr
                                  ON ap.doctor_id = dr.id
                   GROUP  BY dr.id) AS b
               ON b.b_doctor_id = dr.id
       INNER JOIN (SELECT Max(ap.rating_score) AS c_max_rat,
                          dr.id                AS c_doctor_id
                   FROM   myfirstdb.appointment ap
                          INNER JOIN myfirstdb.doctor dr
                                  ON ap.doctor_id = dr.id
                   GROUP  BY dr.id) AS c
               ON c.c_doctor_id = dr.id
       INNER JOIN (SELECT Min(ap.rating_score) AS d_min_rat,
                          dr.id                AS d_doctor_id
                   FROM   myfirstdb.appointment ap
                          INNER JOIN myfirstdb.doctor dr
                                  ON ap.doctor_id = dr.id
                   GROUP  BY dr.id) AS d
               ON d.d_doctor_id = dr.id
       INNER JOIN (SELECT Count(x.p_id) AS e_cnt_of_patients_who_visited_him,
                          x.d_id        AS e_doctor_id
                   FROM   (SELECT dr.id       AS d_id,
                                  Count(p.id) AS patient_count,
                                  p.id        AS p_id
                           FROM   doctor dr
                                  INNER JOIN myfirstdb.appointment ap
                                          ON ap.doctor_id = dr.id
                                  INNER JOIN myfirstdb.patient p
                                          ON p.id = ap.patient_id
                           GROUP  BY dr.id,
                                     p.id
                           HAVING patient_count > 0
                           ORDER  BY dr.id) AS x
                   GROUP  BY x.d_id) AS e
               ON e.e_doctor_id = dr.id
       INNER JOIN myfirstdb.hospital h
               ON dr.hospital_id = h.id
       INNER JOIN myfirstdb.expert_field ef
               ON dr.expert_field_id = ef.id
ORDER  BY dr.id; 



#2) Get the average duration spent by each doctor on patients and display his details along with the expert field.*
SELECT dr.id,
       Concat(dr.first_name, ' ', COALESCE(dr.middle_name, ' '), ' ',
       dr.last_name) AS
       doctor_name,
       dr.email,
       dr.expert_field_id,
       ef.NAME,
       Avg(ap.meeting_duration)
       AS 'averageDuration spent on each meeting (min)'
FROM   myfirstdb.doctor dr
       INNER JOIN myfirstdb.appointment ap
               ON ap.doctor_id = dr.id
       INNER JOIN myfirstdb.expert_field ef
               ON ef.id = dr.expert_field_id
GROUP  BY dr.id
ORDER  BY doctor_id; 



#3)Total bill of the patient made till date. *
SELECT p.id,
       Concat(p.first_name, ' ', p.middle_name, ' ', p.last_name) AS
       patient_name,
       Ifnull(b.medicine_price, 0)                                AS
       'medicine price',
       Ifnull(pr.consult_price, 0)                                AS
       'consultation price',
       ( Ifnull(b.medicine_price, 0)
         + Ifnull(pr.consult_price, 0) )                          AS
       'total bill made by the patient till date',
       Avg(( Ifnull(b.medicine_price, 0)
             + Ifnull(pr.consult_price, 0) ))                     AS
       'average amount purchased by the patient till date'
FROM   myfirstdb.patient p
       LEFT JOIN myfirstdb.bill b
              ON p.id = b.patient_id
       LEFT JOIN myfirstdb.appointment ap
              ON p.id = ap.patient_id
       LEFT JOIN myfirstdb.prescription pr
              ON ap.id = pr.appointment_id
GROUP  BY p.id
ORDER  BY p.id; 



#4)Show the most frequent appointment type(online or offline) with respect to age and gender. **
SELECT (SELECT Concat(ap.meeting_type, ' ',
                      '- ', 'no of patients ', Count(ap.meeting_type))
        FROM   myfirstdb.patient pa
               INNER JOIN myfirstdb.appointment ap
                       ON pa.id = ap.patient_id
        WHERE  pa.gender = 'M'
               AND Timestampdiff(year, pa.date_of_birth, Now()) < 20
        GROUP  BY ap.meeting_type
        ORDER  BY Count(ap.meeting_type) DESC
        LIMIT  1) AS 'most_frequent_type_for_male_under 20 years',
       (SELECT Concat(ap.meeting_type, ' ',
               '- ', 'no of patients ', Count(ap.meeting_type))
        FROM   myfirstdb.patient pa
               INNER JOIN myfirstdb.appointment ap
                       ON pa.id = ap.patient_id
        WHERE  pa.gender = 'F'
               AND Timestampdiff(year, pa.date_of_birth, Now()) < 20
        GROUP  BY ap.meeting_type
        ORDER  BY Count(ap.meeting_type) DESC
        LIMIT  1) AS 'most_frequent_type_for_female_under 20 years',
       (SELECT Concat(ap.meeting_type, ' ',
               '- ', 'no of patients ', Count(ap.meeting_type))
        FROM   myfirstdb.patient pa
               INNER JOIN myfirstdb.appointment ap
                       ON pa.id = ap.patient_id
        WHERE  pa.gender = 'M'
               AND Timestampdiff(year, pa.date_of_birth, Now()) > 20
               AND Timestampdiff(year, pa.date_of_birth, Now()) < 40
        GROUP  BY ap.meeting_type
        ORDER  BY Count(ap.meeting_type) DESC
        LIMIT  1) AS 'most_frequent_type_for_male_between 20 - 40 years',
       (SELECT Concat(ap.meeting_type, ' ',
               '- ', 'no of patients ', Count(ap.meeting_type))
        FROM   myfirstdb.patient pa
               INNER JOIN myfirstdb.appointment ap
                       ON pa.id = ap.patient_id
        WHERE  pa.gender = 'F'
               AND Timestampdiff(year, pa.date_of_birth, Now()) > 20
               AND Timestampdiff(year, pa.date_of_birth, Now()) < 40
        GROUP  BY ap.meeting_type
        ORDER  BY Count(ap.meeting_type) DESC
        LIMIT  1) AS 'most_frequent_type_for_female_between 20 - 40 years',
       (SELECT Concat(ap.meeting_type, ' ',
               '- ', 'no of patients ', Count(ap.meeting_type))
        FROM   myfirstdb.patient pa
               INNER JOIN myfirstdb.appointment ap
                       ON pa.id = ap.patient_id
        WHERE  pa.gender = 'M'
               AND Timestampdiff(year, pa.date_of_birth, Now()) > 40
        GROUP  BY ap.meeting_type
        ORDER  BY Count(ap.meeting_type) DESC
        LIMIT  1) AS 'most_frequent_type_for_male_above  40 years',
       (SELECT Concat(ap.meeting_type, ' ',
               '- ', 'no of patients ', Count(ap.meeting_type))
        FROM   myfirstdb.patient pa
               INNER JOIN myfirstdb.appointment ap
                       ON pa.id = ap.patient_id
        WHERE  pa.gender = 'F'
               AND Timestampdiff(year, pa.date_of_birth, Now()) > 40
        GROUP  BY ap.meeting_type
        ORDER  BY Count(ap.meeting_type) DESC
        LIMIT  1) AS 'most_frequent_type_for_female_above 40 years'; 

#5)Patients can choose on which day he wants to have an appointment by seeing the total number of appointments for a particular doctor on a specific day. Show the number of appointments for a doctor on a specific day and probability of patients having appointments on that specific day(patients having appointment on a  particular day with a specific doctor / number of patients having appointment with  that specific doctor). **
SELECT cday.x_id                                         AS 'doctor id',
       cday.x_name                                       AS 'doctor name',
       cday.cnt_per_day                                  AS
       'no of appointments for a doctor on that particular day',
       cday.x_day                                        AS 'day',
       ( ( cday.cnt_per_day ) / ( cdoc.ct_per_doctor ) ) AS
       'probabily of patients having appointment on that particular day'
FROM   (SELECT Count(x.day)  AS 'cnt_per_day',
               x.doctor_id   AS x_id,
               x.doctor_name AS x_name,
               x.day         AS x_day
        FROM   (SELECT Dayname(ap.appointment_time)             AS day,
                       dr.id                                    AS 'doctor_id',
                       Concat(dr.first_name, ' ', dr.last_name) AS 'doctor_name'
                FROM   myfirstdb.appointment ap
                       INNER JOIN myfirstdb.doctor dr
                               ON dr.id = ap.doctor_id
                ORDER  BY dr.id) AS x
        GROUP  BY x.doctor_id,
                  x.day
        ORDER  BY x.doctor_id) AS cday
       INNER JOIN (SELECT Count(y.day)  AS 'ct_per_doctor',
                          y.doctor_id   AS y_id,
                          y.doctor_name AS y_name,
                          y.day         AS y_day
                   FROM   (SELECT Dayname(ap.appointment_time)             AS
                                  day,
                                  dr.id                                    AS
                                  'doctor_id',
                                  Concat(dr.first_name, ' ', dr.last_name) AS
                                  'doctor_name'
                           FROM   myfirstdb.appointment ap
                                  INNER JOIN myfirstdb.doctor dr
                                          ON dr.id = ap.doctor_id
                           ORDER  BY dr.id) AS y
                   GROUP  BY y.doctor_id
                   ORDER  BY y.doctor_id) AS cdoc
               ON cday.x_id = cdoc.y_id; 



#6) Patients can see the latest appointment given by a particular doctor
SELECT dr.id,
       Concat(dr.first_name, ' ', dr.middle_name, ' ', dr.last_name) AS
       'doctor name',
       ap.patient_id,
       Concat(p.first_name, ' ', p.middle_name, ' ', p.last_name)    AS
       'patient name',
       ap.appointment_time
FROM   myfirstdb.doctor dr
       INNER JOIN myfirstdb.appointment ap
               ON ap.doctor_id = dr.id
       INNER JOIN myfirstdb.patient p
               ON ap.patient_id = p.id
WHERE  dr.id = 1
       AND status = 'accepted'
ORDER  BY ap.appointment_time DESC
LIMIT  1; 



#7) Show the total revenue generated by a particular year.
SELECT Year(b.created_at)               AS year,
       Sum(Ifnull(b.medicine_price, 0)) AS 'total revenue (USD)'
FROM   myfirstdb.bill b
GROUP  BY Year(b.created_at); 


#8) Patients can see the maximum consultation price, minimum consultation price, average consultation price of all doctors and can choose the doctor accordingly.*
SELECT dr.id,
       Concat(dr.first_name, ' ', COALESCE(dr.middle_name, ' '), ' ',
       dr.last_name) AS
       doctor_name,
       ef.NAME
       AS expert_field_name,
       Avg(pr.consult_price)
       AS average_consult_price,
       Min(pr.consult_price)
       AS min_consult_price,
       Max(pr.consult_price)
       AS max_consult_price
FROM   myfirstdb.doctor dr
       INNER JOIN myfirstdb.expert_field ef
               ON dr.expert_field_id = ef.id
       INNER JOIN myfirstdb.appointment ap
               ON ap.doctor_id = dr.id
       INNER JOIN myfirstdb.prescription pr
               ON pr.appointment_id = ap.id
GROUP  BY dr.id
ORDER  BY dr.id; 


