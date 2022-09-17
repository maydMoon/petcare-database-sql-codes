-- QUERYS PARA A ULTILIZAÇÃO DO SGBD
USE petcare; 

-- Verifica Login e se é veterinario 
DELIMITER //
CREATE PROCEDURE login_verification_vet
(username VARCHAR(45), password_p VARCHAR(45))
BEGIN
	IF EXISTS(SELECT * FROM employee 
    WHERE email = username AND password = password_p) THEN 
    BEGIN
		SELECT idvet, crmv, speciality, email, password, name, employeeType FROM vet, employee
		WHERE employee.idEmployee = vet.idVet AND employee.email = username;
	END;
    END IF;
END;
//
DELIMITER ;

-- Verifica Login e se é atendente 
DELIMITER //
CREATE PROCEDURE login_verification
(username VARCHAR(45), password_p VARCHAR(45))
BEGIN
	IF EXISTS(SELECT * FROM employee 
    WHERE email = username AND password = password_p) THEN 
    BEGIN
		SELECT * FROM employee
		WHERE employee.email = username AND employee.employeeType = 'Attendant';
	END;
    END IF;
END;
//
DELIMITER ;

-- Criar Client (CREATE) 
DELIMITER //
CREATE PROCEDURE register_client
(cpfClient VARCHAR(15), nameClient VARCHAR(45), emailClient VARCHAR(45), 
	phoneClient VARCHAR(15), addressClient VARCHAR(45), OUT output BOOLEAN)
BEGIN
	IF NOT EXISTS(SELECT cpf FROM client WHERE client.cpf = cpfClient) THEN 
    BEGIN
		INSERT INTO client(cpf, name, email, phone, address) 
        VALUES (cpfClient, nameClient, emailClient, phoneClient, addressClient);
        SET output = TRUE;
	END;
    ELSE
		SET output = FALSE;
    END IF;
END;
//
DELIMITER ;

-- Delete Client (DELETE) 
DELIMITER //
CREATE PROCEDURE delete_client 
(cpfClient VARCHAR(15), OUT output BOOLEAN)
BEGIN
	IF EXISTS (SELECT cpf FROM client WHERE client.cpf = cpfClient) THEN 
    BEGIN
		DELETE FROM pet WHERE cpfClient = pet.cpfTutor;
        DELETE FROM client WHERE cpf = cpfClient;
        SET output = TRUE;
	END;
    ELSE
		SET output = FALSE;
    END IF;
END;
//
DELIMITER ;

-- Update Client (UPDATE) 
DELIMITER //
CREATE PROCEDURE update_client
(cpfClient VARCHAR(15), nameClient VARCHAR(45), emailClient VARCHAR(45), 
	phoneClient VARCHAR(15), addressClient VARCHAR(45), OUT output BOOLEAN)
BEGIN
	IF EXISTS (SELECT cpf FROM client WHERE client.cpf = cpfClient) THEN 
    BEGIN
		UPDATE client
        SET name = nameClient, email = emailClient, phone = phoneClient, address = addressClient
        WHERE client.cpf = cpfClient;
        SET output = TRUE;
	END;
    ELSE
		SET output = FALSE;
    END IF;
END;
//
DELIMITER ;

-- Read all pets (just one client) (READ PET) 
DELIMITER //
CREATE PROCEDURE list_all_pets_one_client
(cpfClient VARCHAR(15))
BEGIN
	IF EXISTS (SELECT cpf FROM client WHERE client.cpf = cpfClient) THEN 
    BEGIN
		SELECT * FROM pet
        WHERE pet.cpfTutor = cpfClient;
	END;
    END IF;
END;
//
DELIMITER ;

-- Create Pet 
INSERT INTO pet(name, sex, species, breed, size, weight, birthDate, cpfTutor, image) VALUES('-', '-', '-', '-', '-', 0, null,'-', null);

-- Update Pet (UPDATE) 
DELIMITER //
CREATE PROCEDURE update_pet
(id INTEGER UNSIGNED, namePet VARCHAR(30), sexPet CHAR(5), 
	speciesPet VARCHAR(15), breedPet VARCHAR(25), sizePet VARCHAR(10), 
    weightPet FLOAT, birthDatePet DATE, imagePet LONGBLOB, OUT output BOOLEAN)
BEGIN
	IF EXISTS (SELECT idPet FROM pet WHERE pet.idPet = id) THEN 
    BEGIN
		UPDATE pet
        SET name = namePet, sex = sexPet, species = speciesPet, breed = breedPet, size = sizePet,
        weight = weightPet, birthDate = birthDatePet, image = imagePet
        WHERE pet.idPEt = id;
        SET output = TRUE;
	END;
    ELSE
		SET output = FALSE;
    END IF;
END;
//
DELIMITER ;

-- Delete pet (DELETE) 
DELIMITER //
CREATE PROCEDURE delete_pet
(id INTEGER UNSIGNED, OUT output BOOLEAN)
BEGIN
	IF EXISTS (SELECT idPet FROM pet WHERE pet.idPet = id) THEN 
    BEGIN
		DELETE FROM pet WHERE id = pet.idPet;
        SET output = TRUE;
	END;
    ELSE
		SET output = FALSE;
    END IF;
END;
//
DELIMITER ;

-- Criar Consultation (CREATE) 
DELIMITER //
CREATE PROCEDURE register_consultation
(dateTime DATETIME, idV INTEGER UNSIGNED, idP INTEGER UNSIGNED, 
	statusC VARCHAR(15), priceC FLOAT, OUT output BOOLEAN)
BEGIN
	IF NOT EXISTS(SELECT * FROM consultation WHERE consultationDateTime = dateTime AND idVet = idV AND idPet = idP) THEN 
    BEGIN
		INSERT INTO consultation(consultationDateTime, idVet, idPet, status, price) 
        VALUES (dateTime, idV, idP, statusC, priceC);
        SET output = TRUE;
	END;
    ELSE
		SET output = FALSE;
    END IF;
END;
//
DELIMITER ;

-- Update Consultation (UPDATE) 
DELIMITER //
CREATE PROCEDURE update_consultation
(dateTime DATETIME, idV INTEGER UNSIGNED, idP INTEGER UNSIGNED, 
	statusC VARCHAR(15), priceC FLOAT, OUT output BOOLEAN)
BEGIN
	IF EXISTS (SELECT consultationDateTime, idVet, idPet FROM consultation WHERE consultationDateTime = dateTime AND idVet = idV AND idPet = idP) THEN 
    BEGIN
		UPDATE consultation
        SET status = statusC, price = priceC
        WHERE consultationDateTime = dateTime AND idVet = idV AND idPet = idP;
        SET output = TRUE;
	END;
    ELSE
		SET output = FALSE;
    END IF;
END;
//
DELIMITER ;

-- Delete Consultation (DELETE) 
DELIMITER //
CREATE PROCEDURE delete_consultation
(dateTime DATETIME, idV INTEGER UNSIGNED, idP INTEGER UNSIGNED, OUT output BOOLEAN)
BEGIN
	IF EXISTS (SELECT consultationDateTime, idVet, idPet FROM consultation WHERE consultationDateTime = dateTime AND idVet = idV AND idPet = idP) THEN 
    BEGIN
		DELETE FROM exam WHERE consultationDateTime = dateTime AND idVet = idV AND idPet = idP;
        DELETE FROM clinical_record WHERE consultationDateTime = dateTime AND idVet = idV AND idPet = idP;
        DELETE FROM consultation WHERE consultationDateTime = dateTime AND idVet = idV AND idPet = idP;
        SET output = TRUE;
	END;
    ELSE
		SET output = FALSE;
    END IF;
END;
//
DELIMITER ;

-- View com dados da consulta e outros dados relacionados -> pet, vet/employee, consulation (READ) 
CREATE VIEW consulation_data AS
SELECT * FROM pet, (SELECT idPet AS idPetCons, consultationDateTime, status, price, consultation.idVet, employee.name AS vetName, speciality
FROM  consultation, employee, vet
WHERE employee.idEmployee = consultation.idVet 
AND vet.idVet = consultation.idVet) AS cons
WHERE pet.idPet = cons.idPetCons;

SElECT * FROM consulation_data;

-- View com dados da consulta e dados relacionados de um vet especifico
DELIMITER //
CREATE PROCEDURE list_vet_consultations
(idV INTEGER UNSIGNED, OUT output BOOLEAN)
BEGIN
	IF EXISTS(SELECT * FROM consultation WHERE idVet = 2) THEN 
    BEGIN
		SELECT * FROM pet, (SELECT idPet AS idPetCons, consultationDateTime, status, price, consultation.idVet, employee.name AS vetName, speciality
		FROM  consultation, employee, vet
		WHERE employee.idEmployee = consultation.idVet 
		AND vet.idVet = consultation.idVet AND consultation.idVet = idV) AS cons
		WHERE pet.idPet = cons.idPetCons;
        SET output = TRUE;
	END;
    ELSE
		SET output = FALSE;
    END IF;
END;
//
DELIMITER ;

CALL list_vet_consultations(2,@output);

-- Criar Exam 
DELIMITER //
CREATE PROCEDURE create_exam
(dateTime DATETIME, idV INTEGER UNSIGNED, idP INTEGER UNSIGNED, 
	nameE VARCHAR(30), resultE VARCHAR(40), dateTimeE DATETIME, OUT output BOOLEAN)
BEGIN
	IF NOT EXISTS(SELECT * FROM exam WHERE consultationDateTime = dateTime AND idVet = idV AND idPet = idP) THEN 
    BEGIN
		INSERT INTO exam(consultationDateTime, idVet, idPet, name, result, examDateTime) 
        VALUES (dateTime, idV, idP, nameE, resultE, dateTimeE);
        SET output = TRUE;
	END;
    ELSE
		SET output = FALSE;
    END IF;
END;
//
DELIMITER ;

-- Criar clinical record
DELIMITER //
CREATE PROCEDURE create_clinical_record
(dateTime DATETIME, idV INTEGER UNSIGNED, idP INTEGER UNSIGNED, 
	descriptionCR VARCHAR(60), OUT output BOOLEAN)
BEGIN
	IF NOT EXISTS(SELECT * FROM clinical_record WHERE consultationDateTime = dateTime AND idVet = idV AND idPet = idP) THEN 
    BEGIN
		INSERT INTO clinical_record(consultationDateTime, idVet, idPet, description) 
        VALUES (dateTime, idV, idP, descriptionCR);
        SET output = TRUE;
	END;
    ELSE
		SET output = FALSE;
    END IF;
END;
//
DELIMITER ;

-- Criar Financeiro
DELIMITER //
CREATE PROCEDURE create_finance
(idE INTEGER UNSIGNED, idCR INTEGER UNSIGNED, 
	amountF FLOAT, statusF VARCHAR(15), paymentF VARCHAR(45), OUT output BOOLEAN)
BEGIN
	IF NOT EXISTS(SELECT * FROM finance WHERE idClinicalRecord = idCR) THEN 
    BEGIN
		INSERT INTO finance(amount, status, payment, idEmployee, idClinicalRecord) 
        VALUES (amountF, statusF, paymentF, idE, idCR);
        SET output = TRUE;
	END;
    ELSE
		SET output = FALSE;
    END IF;
END;
//
DELIMITER ;

-- listar exames 
SELECT * FROM exam;

-- listar Medicamentos
SELECT * FROM medication;

-- listar financeiro

-- editar financeiro

-- busca por nome do vet (retorna todos os dados dos vets que possuem ex: Paulo no nome)
SELECT * FROM vet, employee
WHERE employee.name LIKE '%NAME%' AND vet.idVet = idEmployee; -- Aleternar a busca entre inicio do nome % antes do nome inserido, no fim insira % depois do nome, nesse estado pesquisa independente da posição

