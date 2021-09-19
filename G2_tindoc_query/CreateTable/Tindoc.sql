create database tindoc;
use tindoc;
CREATE TABLE tindoc.patient
  (
     id			BIGINT NOT NULL auto_increment,
     ssn			VARCHAR(50) NOT NULL,
     first_name		VARCHAR(50) NOT NULL,
	middle_name	    VARCHAR(50),
     last_name		VARCHAR(50) NOT NULL,
     email			VARCHAR(50) NOT NULL,
     phone_number	VARCHAR(20),
     state		VARCHAR(30) NOT NULL,
     zipcode		INT NOT NULL,
     gender		ENUM('M', 'F'),
     date_of_birth	DATEtime NOT NULL,
     username		VARCHAR(100) NOT NULL,
     password		VARCHAR(100) NOT NULL,
     last_login		DATETIME,
     registered_at	DATETIME NOT NULL DEFAULT now(),
     updated_at	      DATETIME NOT NULL DEFAULT now(),
     PRIMARY KEY (id)
  ); 

  
  CREATE TABLE tindoc.doctor
  (
     id			BIGINT NOT NULL auto_increment,
     first_name		VARCHAR(50) NOT NULL,
	middle_name	VARCHAR(50) NULL,
     last_name		VARCHAR(50) NOT NULL,
     hospital_id		BIGINT NOT NULL,
     expert_field_id	BIGINT NOT NULL,
     email			VARCHAR(50) NOT NULL,
     PRIMARY KEY (id),
     KEY fk_hospital_id (hospital_id),
     KEY fk_expert_field_id(expert_field_id),
     UNIQUE KEY email (email)
  ); 
CREATE TABLE tindoc.hospital
  (
     id           BIGINT NOT NULL auto_increment,
     name         VARCHAR(250) NOT NULL,
     phone		 VARCHAR(30) NOT NULL,
     address      TEXT NOT NULL,
	state        VARCHAR(30)NOT NULL,
	zipcode      INT NOT NULL,
     PRIMARY KEY (id)
  ); 
  
  CREATE TABLE tindoc.expert_field
  (
     id          BIGINT NOT NULL auto_increment,
     name        VARCHAR(150) NOT NULL,
     description TEXT NOT NULL,
     PRIMARY KEY (id),
     UNIQUE KEY name (name)

  ); 
CREATE TABLE tindoc.prescription
  (
     id					BIGINT NOT NULL auto_increment,
     appointment_id		BIGINT NOT NULL,
     message			LONGTEXT NOT NULL,
     treatment_duration	INT NOT NULL,
     consult_price		INT NOT NULL,
     PRIMARY KEY (id),
     UNIQUE KEY appointment_id (appointment_id)
  ); 
CREATE TABLE tindoc.workshift
  (
     id         BIGINT NOT NULL auto_increment,
     start_time TIME NOT NULL,
     end_time   TIME NOT NULL,
     day        VARCHAR(50) NOT NULL,
     PRIMARY KEY(id)
  ); 
  
  CREATE TABLE tindoc.work
  (
     id           BIGINT NOT NULL auto_increment,
     doctor_id    BIGINT NOT NULL,
     workshift_id BIGINT NOT NULL,
     PRIMARY KEY(id),
     KEY fk_doctor_id (doctor_id),
     KEY fk_workshift_id (workshift_id)
  ); 
CREATE TABLE tindoc.medicine
  (
     id          BIGINT NOT NULL auto_increment,
     name        TEXT NOT NULL,
     price       INT NOT NULL,
     description TEXT NULL,
     PRIMARY KEY(id)
  ); 

CREATE TABLE tindoc.bill_item
  (
     id          BIGINT NOT NULL auto_increment,
     bill_id     BIGINT NOT NULL,
     medicine_id BIGINT NOT NULL,
     quantity    FLOAT NOT NULL,
     PRIMARY KEY(id),
     key fk_bill_id (bill_id),
     key fk_medicine_id (medicine_id)
  ); 
CREATE TABLE tindoc.bill
  (
     id              BIGINT NOT NULL auto_increment,
     created_at    DATETIME NOT NULL DEFAULT Now(),
     medicine_price     BIGINT NOT NULL,
     patient_id      BIGINT,
     PRIMARY KEY(id),
     KEY fk_patient_id(patient_id)
  ); 
CREATE TABLE tindoc.appointment
  (
     id			BIGINT NOT NULL auto_increment,
     patient_id		BIGINT NOT NULL,
     doctor_id		BIGINT NOT NULL,
     appointment_time DATEtime NOT NULL,
     meeting_type	ENUM('online', 'offline') NOT NULL,
     meeting_duration  BIGINT NOT NULL,
     message		LONGTEXT,
     status		ENUM('new', 'accepted', 'rejected') DEFAULT 'new',
     created_at		DATETIME NOT NULL DEFAULT Now(),
     updated_at		DATETIME,
     rating_score	INT,
	CHECK (rating_score <= 5),
     PRIMARY KEY (id),
     KEY fk_patient_id(patient_id),
     KEY fk_doctor_id(doctor_id)
  );

alter table tindoc.doctor
add CONSTRAINT fk_hospital_id FOREIGN KEY (hospital_id) REFERENCES
     tindoc.hospital(id) ON DELETE CASCADE ON UPDATE CASCADE,
add CONSTRAINT fk_expert_field FOREIGN KEY (expert_field_id) REFERENCES
     tindoc.expert_field(id) ON DELETE CASCADE ON UPDATE CASCADE;

alter table tindoc.prescription
add CONSTRAINT fk_appointment_id FOREIGN KEY (appointment_id) REFERENCES
     tindoc.appointment(id) ON DELETE CASCADE ON UPDATE CASCADE;
     
alter table tindoc.work
add CONSTRAINT fk_doctor_id FOREIGN KEY (doctor_id) REFERENCES
     tindoc.doctor(id) ON DELETE CASCADE ON UPDATE CASCADE,
     add CONSTRAINT fk_workshift_id FOREIGN KEY (workshift_id) REFERENCES
     tindoc.workshift(id) ON DELETE CASCADE ON UPDATE CASCADE;
     
alter table tindoc.bill_item
add CONSTRAINT fk_bill_id FOREIGN KEY (bill_id) REFERENCES tindoc.bill(id)
     ON DELETE CASCADE ON UPDATE CASCADE,
     add CONSTRAINT fk_medicine_id FOREIGN KEY (medicine_id) REFERENCES
     tindoc.medicine(id) ON DELETE CASCADE ON UPDATE CASCADE;

alter table tindoc.bill
add CONSTRAINT fk_billpatient_id FOREIGN KEY (patient_id) REFERENCES
     tindoc.patient(id) ON DELETE CASCADE ON UPDATE CASCADE;
     
alter table tindoc.appointment
add CONSTRAINT fk_appatient_id FOREIGN KEY (patient_id) REFERENCES
     tindoc.patient(id) ON DELETE CASCADE ON UPDATE CASCADE,
add CONSTRAINT fk_doctor1_id FOREIGN KEY (doctor_id) REFERENCES
     tindoc.doctor(id) ON DELETE CASCADE ON UPDATE CASCADE;




#Update Query
Update patient set middle_name=’venkata’ where id=1;

#Delete Query
Delete from doctor where id=1;

