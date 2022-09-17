-- CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE petcare;
USE petcare;

-- CRIAÇÃO DAS TABELAS
CREATE TABLE employee				
	(idEmployee INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	 name VARCHAR(45) NOT NULL,
	 email VARCHAR(45) NOT NULL,
   	 password VARCHAR(20) NOT NULL,
   	 employeeType VARCHAR(25) NOT NULL);
    
CREATE TABLE vet
	(idVet INTEGER UNSIGNED PRIMARY KEY,
	 crmv INTEGER NOT NULL,
	 speciality VARCHAR(30) NOT NULL,
	 CONSTRAINT fk_employee
	 FOREIGN KEY (idVet) 
	 REFERENCES employee(idEmployee));
    
CREATE TABLE client
	(cpf VARCHAR(15) PRIMARY KEY, 
	 name VARCHAR(45), 
     email VARCHAR(45),
	 phone VARCHAR(15), 
	 address VARCHAR(50));
    
CREATE TABLE pet 
	(idPet INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	 name VARCHAR(30), 
	 sex CHAR(5),
	 species VARCHAR(15),
	 breed VARCHAR(25),
	 size VARCHAR(10),
	 weight FLOAT,
	 birthDate DATE,
     cpfTutor VARCHAR(15),
     image BLOB,
     CONSTRAINT fk_tutor
		FOREIGN KEY (cpfTutor)
        REFERENCES client(cpf)
        ON DELETE CASCADE);

CREATE TABLE medication
	(idMedication INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	 name VARCHAR(30) NOT NULL,
	 price FLOAT NOT NULL);
     
CREATE TABLE consultation 
	(consultationDateTime DATETIME,
	 idVet INTEGER UNSIGNED,
	 idPet INTEGER UNSIGNED, 
     status VARCHAR (15),
     price FLOAT,
	 PRIMARY KEY(idVet, idPet, consultationDateTime),
   	 INDEX fk_Pet (idPet),
	 INDEX fk_Vet (idVet),
	 CONSTRAINT fk_Pet
		FOREIGN KEY (idPet) 
		REFERENCES pet(idPet)
        ON DELETE CASCADE,
	 CONSTRAINT fk_Vet
		FOREIGN KEY (idVet) 
		REFERENCES vet(idVet)
        ON DELETE CASCADE);	
        
CREATE TABLE exam 
	(idExam INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	 name VARCHAR(30),
	 examDateTime DATETIME,
	 result VARCHAR(40),
     consultationDateTime DATETIME,
	 idVet INTEGER UNSIGNED,
	 idPet INTEGER UNSIGNED,
     CONSTRAINT fk_consultation_exam 
		FOREIGN KEY (idVet, idPet, consultationDateTime)
        REFERENCES consultation(idVet, idPet, consultationDateTime)
        ON DELETE CASCADE);
        
CREATE TABLE clinical_record 
	(idClinicalRecord INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	 description VARCHAR(60),
	 consultationDateTime DATETIME,
	 idVet INTEGER UNSIGNED,
	 idPet INTEGER UNSIGNED,
	 CONSTRAINT fk_consultation_clinical_record
		FOREIGN KEY (idVet, idPet, consultationDateTime)
        REFERENCES consultation(idVet, idPet, consultationDateTime)
        ON DELETE CASCADE);
        
CREATE TABLE drug_registration  
	(idDrugRegistration INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	 dosage INTEGER,
     idMedication INTEGER UNSIGNED,
     idClinicalRecord INTEGER UNSIGNED,
     INDEX fk_medication (idMedication),
     INDEX fk_clinical_record (idClinicalRecord),
     CONSTRAINT fk_medication 
		FOREIGN KEY (idMedication)
        REFERENCES medication(idMedication)
        ON DELETE CASCADE,
	 CONSTRAINT fk_clinical_record 
		FOREIGN KEY (idClinicalRecord) 
        REFERENCES clinical_record(idClinicalRecord)
        ON DELETE CASCADE);
        
CREATE TABLE finance 
	(idFinance INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	 amount FLOAT,
	 status VARCHAR(15),
	 payment VARCHAR(45),
	 idEmployee INTEGER UNSIGNED,
	 idClinicalRecord INTEGER UNSIGNED,
     INDEX fk_employee_finance (idEmployee),
	 INDEX fk_clinical_record_finance (idClinicalRecord),
     CONSTRAINT fk_employee_finance
		FOREIGN KEY (idEmployee)
        REFERENCES employee(idEmployee)
        ON DELETE CASCADE,
	 CONSTRAINT fk_clinical_record_finance
		FOREIGN KEY (idClinicalRecord) 
        REFERENCES clinical_record(idClinicalRecord)
        ON DELETE CASCADE);


