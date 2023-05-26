-- CRIAÇÃO DO BANCO DE DADOS
CREATE SCHEMA IF NOT EXISTS salgadaria;

USE salgadaria;

-- CRIAÇÃO DA TABELA ADDRESS

CREATE TABLE IF NOT EXISTS salgadaria.address (
  idaddress INT NOT NULL AUTO_INCREMENT,
  road VARCHAR(35) NOT NULL,
  neighborhood VARCHAR(25) NULL,
  number INT NOT NULL,
  city VARCHAR(25) NOT NULL,
  state VARCHAR(25) NULL,
  complement VARCHAR(20) NULL,
  cep CHAR(8) NOT NULL,
  PRIMARY KEY (idaddress)
);

-- CRIAÇÃO DA TABELA INDIVIDUAL_CUSTOMER

CREATE TABLE IF NOT EXISTS salgadaria.individual_customer (
  idindividual_customer INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(15) NOT NULL,
  second_name VARCHAR(15) NULL,
  last_name VARCHAR(15) NOT NULL,
  birthday DATE NULL,
  cpf CHAR(11) NOT NULL,
  cell_phone CHAR(13) NULL,
  address_idaddress INT NOT NULL,
  PRIMARY KEY (idindividual_customer, address_idaddress),
  UNIQUE INDEX cpf_UNIQUE (cpf ASC) VISIBLE,
  INDEX fk_individual_customer_address_idx (address_idaddress ASC) VISIBLE,
  CONSTRAINT fk_individual_customer_address FOREIGN KEY (address_idaddress) REFERENCES salgadaria.address (idaddress)
);

-- CRIAÇÃO DA TABELA CORPORATE_CLIENT

CREATE TABLE IF NOT EXISTS salgadaria.corporate_client (
  idcorporate_client INT NOT NULL AUTO_INCREMENT,
  corporate_name VARCHAR(45) NOT NULL,
  cnpj CHAR(14) NOT NULL,
  foundation_date DATE NULL,
  state_registration CHAR(15) NOT NULL,
  email VARCHAR(35) NULL,
  phone CHAR(12) NULL,
  address_idaddress INT NOT NULL,
  PRIMARY KEY (idcorporate_client, address_idaddress),
  UNIQUE INDEX cnpj_UNIQUE (cnpj ASC) VISIBLE,
  UNIQUE INDEX state_registration_UNIQUE (state_registration ASC) VISIBLE,
  INDEX fk_corporate_client_address1_idx (address_idaddress ASC) VISIBLE,
  CONSTRAINT fk_corporate_client_address1 FOREIGN KEY (address_idaddress) REFERENCES salgadaria.address (idaddress)
);

-- CRIAÇÃO DA TABELA DEPOSIT

CREATE TABLE IF NOT EXISTS salgadaria.deposit (
  idflavors INT NOT NULL AUTO_INCREMENT,
  flavors_name VARCHAR(25) NOT NULL,
  amount INT NOT NULL,
  PRIMARY KEY (idflavors)
);

-- CRIAÇÃO DA TABELA DELIVERYMAN

CREATE TABLE IF NOT EXISTS salgadaria.deliveryman (
  iddeliveryman INT NOT NULL AUTO_INCREMENT,
  deliveryman_name VARCHAR(35) NOT NULL,
  deliveryman_cpf CHAR(11) NOT NULL,
  deliveryman_phone CHAR(13) NOT NULL,
  address_idaddress INT NOT NULL,
  PRIMARY KEY (iddeliveryman, address_idaddress),
  UNIQUE INDEX deliveryman_cpf_UNIQUE (deliveryman_cpf ASC) VISIBLE,
  INDEX fk_deliveryman_address1_idx (address_idaddress ASC) VISIBLE,
  CONSTRAINT fk_deliveryman_address1 FOREIGN KEY (address_idaddress) REFERENCES salgadaria.address (idaddress)
);

-- CRIAÇÃO DA TABELA DELIVERY

CREATE TABLE IF NOT EXISTS salgadaria.delivery (
  iddelivery INT NOT NULL AUTO_INCREMENT,
  number_delivery VARCHAR(45) NOT NULL,
  status_delivery ENUM('Recebido', 'Em processamento', 'Em entrega') NOT NULL,
  tracking_code INT NOT NULL,
  deliveryman_iddeliveryman INT NOT NULL,
  PRIMARY KEY (iddelivery, deliveryman_iddeliveryman),
  INDEX fk_delivery_deliveryman1_idx (deliveryman_iddeliveryman ASC) VISIBLE,
  UNIQUE INDEX number_delivery_UNIQUE (number_delivery ASC) VISIBLE,
  UNIQUE INDEX tracking_code_UNIQUE (tracking_code ASC) VISIBLE,
  CONSTRAINT fk_delivery_deliveryman1 FOREIGN KEY (deliveryman_iddeliveryman) REFERENCES salgadaria.deliveryman (iddeliveryman)
);

-- CRIAÇÃO DA TABELA DEPARTMENT

CREATE TABLE IF NOT EXISTS salgadaria.department (
  iddepartment INT NOT NULL AUTO_INCREMENT,
  department_name VARCHAR(25) NOT NULL,
  description VARCHAR(50) NULL,
  number_of_employees INT NULL,
  creation_date DATE NULL,
  PRIMARY KEY (iddepartment)
);

-- CRIAÇÃO DA TABELA EMPLOYEE

CREATE TABLE IF NOT EXISTS salgadaria.employee (
  idemployee INT NOT NULL AUTO_INCREMENT,
  employee_name VARCHAR(45) NOT NULL,
  cpf CHAR(11) NOT NULL,
  phone CHAR(13) NULL,
  identification INT NOT NULL,
  admission_date DATE NOT NULL,
  gender ENUM('M', 'F') NULL,
  department_iddepartment INT NOT NULL,
  address_idaddress INT NOT NULL,
  PRIMARY KEY (idemployee, department_iddepartment, address_idaddress),
  UNIQUE INDEX cpf_UNIQUE (cpf ASC) VISIBLE,
  UNIQUE INDEX identification_UNIQUE (identification ASC) VISIBLE,
  INDEX fk_employee_department1_idx (department_iddepartment ASC) VISIBLE,
  INDEX fk_employee_address1_idx (address_idaddress ASC) VISIBLE,
  CONSTRAINT fk_employee_department1 FOREIGN KEY (department_iddepartment) REFERENCES salgadaria.department (iddepartment)
  CONSTRAINT fk_employee_address1 FOREIGN KEY (address_idaddress) REFERENCES salgadaria.address (idaddress)
)

-- CRIAÇÃO DA TABELA ORDER

CREATE TABLE IF NOT EXISTS salgadaria.order (
  idorder INT NOT NULL AUTO_INCREMENT,
  request_number VARCHAR(45) NOT NULL,
  request_date VARCHAR(45) NOT NULL,
  amount_food INT NOT NULL,
  choice ENUM('Um cento', 'Meio Cento') NOT NULL,
  individual_customer_idindividual_customer INT NOT NULL,
  corporate_client_idcorporate_client INT NOT NULL,
  deposit_idflavors INT NOT NULL,
  delivery_iddelivery INT NOT NULL,
  employee_idemployee INT NOT NULL,
  PRIMARY KEY (idorder, individual_customer_idindividual_customer, corporate_client_idcorporate_client, deposit_idflavors, delivery_iddelivery, employee_idemployee),
  INDEX fk_order_individual_customer1_idx (individual_customer_idindividual_customer ASC) VISIBLE,
  INDEX fk_order_corporate_client1_idx (corporate_client_idcorporate_client ASC) VISIBLE,
  INDEX fk_order_deposit1_idx (deposit_idflavors ASC) VISIBLE,
  INDEX fk_order_delivery1_idx (delivery_iddelivery ASC) VISIBLE,
  UNIQUE INDEX request_number_UNIQUE (request_number ASC) VISIBLE,
  INDEX fk_order_employee1_idx (employee_idemployee ASC) VISIBLE,
  CONSTRAINT fk_order_individual_customer1 FOREIGN KEY (individual_customer_idindividual_customer) REFERENCES salgadaria.individual_customer (idindividual_customer),
  CONSTRAINT fk_order_corporate_client1 FOREIGN KEY (corporate_client_idcorporate_client) REFERENCES salgadaria.corporate_client (idcorporate_client),
  CONSTRAINT fk_order_deposit1 FOREIGN KEY (deposit_idflavors), REFERENCES salgadaria.deposit (idflavors),
  CONSTRAINT fk_order_delivery1 FOREIGN KEY (delivery_iddelivery), REFERENCES salgadaria.delivery (iddelivery),
  CONSTRAINT fk_order_employee1 FOREIGN KEY (employee_idemployee), REFERENCES salgadaria.employee (idemployee)
);

###########################################
###### INSERÇÃO DOS DADOS NAS TABELAS #####
###########################################

-- INSERÇÕES NA TABELA ADDRESS
INSERT INTO salgadaria.address (road, neighborhood, number, city, state, complement, cep)
VALUES ('Rua A', 'Bairro X', 123, 'Cidade A', 'Estado A', 'Complemento 1', '12345678'),
       ('Rua B', 'Bairro Y', 456, 'Cidade B', 'Estado B', 'Complemento 2', '23456789'),
       ('Rua C', 'Bairro Z', 789, 'Cidade C', 'Estado C', 'Complemento 3', '34567890');

-- INSERÇÕES NA TABELA INDIVIDUAL_CUSTOMER
INSERT INTO salgadaria.individual_customer (first_name, second_name, last_name, birthday, cpf, cell_phone, address_idaddress)
VALUES ('João', 'Carlos', 'Silva', '1990-01-15', '12345678901', '99999999', 1),
       ('Maria', 'Aparecida', 'Santos', '1985-05-20', '98765432109', '88888888', 2),
       ('Pedro', NULL, 'Almeida', '1998-09-10', '45678901234', '77777777', 3);

-- INSERÇÕES NA TABELA CORPORATE_CLIENT
INSERT INTO salgadaria.corporate_client (corporate_name, cnpj, foundation_date, state_registration, email, phone, address_idaddress)
VALUES ('Empresa A', '12345678901234', '2000-12-01', '123456789012345', 'empresa_a@email.com', '11111111', 1),
       ('Empresa B', '98765432109876', '1995-06-10', '987654321098765', 'empresa_b@email.com', '22222222', 2),
       ('Empresa C', '65432109876543', '2010-03-25', '654321098765432', 'empresa_c@email.com', '33333333', 3);

-- INSERÇÕES NA TABELA DEPOSIT
INSERT INTO salgadaria.deposit (flavors_name, amount)
VALUES ('Presunto e Queijo', 100),
       ('Frango com Catupiry', 50),
       ('Carne com Cheddar', 75);

-- INSERÇÕES NA TABELA DELIVERYMAN
INSERT INTO salgadaria.deliveryman (deliveryman_name, deliveryman_cpf, deliveryman_phone, address_idaddress)
VALUES ('José', '12345678901', '999999999', 1),
       ('Carlos', '98765432109', '888888888', 2),
       ('Fernanda', '45678901234', '777777777', 3);

-- INSERÇÕES NA TABELA DELIVERY
INSERT INTO salgadaria.delivery (number_delivery, status_delivery, tracking_code, deliveryman_iddeliveryman)
VALUES ('D001', 'Recebido', 123456, 1),
       ('D002', 'Em processamento', 234567, 2),
       ('D003', 'Em entrega', 345678, 3);

-- INSERÇÕES NA TABELA DEPARTMENT
INSERT INTO salgadaria.department (department_name, description, number_of_employees, creation_date)
VALUES ('Vendas', 'Setor de vendas', 10, '2010-01-01'),
       ('RH', 'Recursos Humanos', 5, '2005-05-05'),
       ('Financeiro', 'Setor financeiro', 8, '2012-10-10');

-- INSERÇÕES NA TABELA EMPLOYEE
INSERT INTO salgadaria.employee (employee_name, cpf, phone, identification, admission_date, gender, department_iddepartment, address_idaddress)
VALUES ('Ana', '12345678901', '111111111', 1, '2010-01-01', 'F', 1, 1),
       ('Marcos', '98765432109', '222222222', 2, '2005-05-05', 'M', 2, 2),
       ('Julia', '45678901234', '333333333', 3, '2012-10-10', 'F', 3, 3);

-- INSERÇÕES NA TABELA ORDER
INSERT INTO salgadaria.`order` (request_number, request_date, amount_food, choice, individual_customer_idindividual_customer, corporate_client_idcorporate_client, deposit_idflavors, delivery_iddelivery, employee_idemployee)
VALUES ('R001', '2023-05-26', 100, 'Um cento', 1, 1, 1, 1, 1),
       ('R002', '2023-05-26', 50, 'Meio Cento', 2, 2, 2, 2, 2),
       ('R003', '2023-05-26', 75, 'Um cento', 3, 3, 3, 3, 3);

##############################################
###### CRIAÇÃO DAS QUERYS PARA CONSULTAS #####
##############################################

--------------------------------------------
-- RECUPERAÇÕES SIMPLES COM SELECT STATEMENT
--------------------------------------------
1 - Recuperação de todos os registros da tabela "address":
SELECT * FROM salgadaria.address;

2 - Recuperação dos nomes e CPFs dos clientes individuais da tabela "individual_customer":
SELECT first_name, cpf FROM salgadaria.individual_customer;

3 - Recuperação das informações de pedidos da tabela "order" que estão em status de entrega:
SELECT * FROM salgadaria.'order' WHERE status_delivery = 'Em entrega';

------------------------------
-- FILTROS COM WHERE STATEMENT
------------------------------
1 - Recuperação dos endereços de clientes individuais da cidade "Cidade A":
SELECT * FROM salgadaria.address WHERE city = 'Cidade A';

2 - Recuperação dos nomes e CNPJs dos clientes corporativos que foram cadastrados a partir de 2022:
SELECT corporate_name, cnpj FROM salgadaria.corporate_client WHERE YEAR(foundation_date) >= 2022;

3 - Recuperação dos pedidos feitos por um cliente individual com CPF específico:
SELECT * FROM salgadaria.`order` WHERE individual_customer_idindividual_customer = (SELECT idindividual_customer FROM salgadaria.individual_customer WHERE cpf = '12345678901');

-------------------------------------------------
-- CRIE EXPRESSÕES PARA GERAR ATRIBUTOS DERIVADOS
-------------------------------------------------
1 - Recuperação dos nomes completos dos clientes individuais concatenando os campos "first_name" e "last_name" em um único atributo chamado "full_name":
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM salgadaria.individual_customer;

2 - Recuperação dos anos de fundação dos clientes corporativos, calculando a diferença entre o ano atual e o ano de fundação como um atributo chamado "years_since_foundation":
SELECT corporate_name, foundation_date, YEAR(CURDATE()) - YEAR(foundation_date) AS years_since_foundation FROM salgadaria.corporate_client;

3 - Recuperação dos pedidos com o valor total calculado multiplicando a quantidade de comida pelo preço unitário como um atributo chamado "total_value":
SELECT idorder, amount_food, (amount_food * price) AS total_value FROM salgadaria.`order` JOIN salgadaria.deposit ON salgadaria.`order`.deposit_idflavors = salgadaria.deposit.idflavors;

-------------------------------------------
-- DEFINA ORDENAÇÕES DOS DADOS COM ORDER BY
-------------------------------------------
1 - Recuperação dos endereços dos clientes individuais ordenados por cidade em ordem alfabética crescente:
SELECT * FROM salgadaria.address WHERE neighborhood IS NOT NULL ORDER BY city ASC;

2 - Recuperação dos nomes e CNPJs dos clientes corporativos ordenados por nome da empresa em ordem alfabética decrescente:
SELECT corporate_name, cnpj FROM salgadaria.corporate_client ORDER BY corporate_name DESC;

3 - Recuperação dos pedidos feitos por clientes individuais ordenados por data de pedido em ordem crescente:
SELECT * FROM salgadaria.`order` WHERE individual_customer_idindividual_customer = (SELECT idindividual_customer FROM salgadaria.individual_customer WHERE cpf = '12345678901') ORDER BY request_date ASC;

-----------------------------------------------------
-- CONDIÇÕES DE FILTROS AOS GRUPOS – HAVING STATEMENT
-----------------------------------------------------
1 - Recuperação dos departamentos que possuem mais de 5 funcionários:
SELECT department_iddepartment, COUNT(*) as total_employees
FROM salgadaria.employee
GROUP BY department_iddepartment
HAVING total_employees > 5;

2 - Recuperação dos sabores de depósitos que possuem uma quantidade total superior a 100:
SELECT deposit_idflavors, SUM(amount) as total_amount
FROM salgadaria.deposit
GROUP BY deposit_idflavors
HAVING total_amount > 100;

3 - Recuperação dos clientes corporativos que possuem mais de 2 pedidos realizados:
SELECT corporate_client_idcorporate_client, COUNT(*) as total_orders
FROM salgadaria.`order`
WHERE corporate_client_idcorporate_client IS NOT NULL
GROUP BY corporate_client_idcorporate_client
HAVING total_orders > 2;

-----------------------------------------------------------------------------------
-- CRIE JUNÇÕES ENTRE TABELAS PARA FORNECER UMA PERSPECTIVA MAIS COMPLEXA DOS DADOS
-----------------------------------------------------------------------------------
1 - Recuperação dos pedidos juntamente com os nomes dos clientes individuais e seus respectivos endereços:
SELECT o.idorder, i.first_name, i.last_name, a.city
FROM salgadaria.`order` AS o
JOIN salgadaria.individual_customer AS i ON o.individual_customer_idindividual_customer = i.idindividual_customer
JOIN salgadaria.address AS a ON i.address_idaddress = a.idaddress;

2 - Recuperação dos funcionários juntamente com os nomes dos departamentos em que eles trabalham:
SELECT e.idemployee, e.employee_name, d.department_name
FROM salgadaria.employee AS e
JOIN salgadaria.department AS d ON e.department_iddepartment = d.iddepartment;

3 - Recuperação dos pedidos com informações de entrega, incluindo o nome do entregador e o status de entrega:
SELECT o.iddelivery, o.number_delivery, d.deliveryman_name, o.status_delivery
FROM salgadaria.delivery AS o
JOIN salgadaria.deliveryman AS d ON o.deliveryman_iddeliveryman = d.iddeliveryman;