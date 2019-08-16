
-- Trabalho de Fundamento de Banco de Dados
-- Nomes : Conrado Boeira e Gabriel Wetzel


-- CRIACAO DAS TABELAS

--tabela Rua
create table Rua(
	Nome char(120) primary key,
	Numero_max numeric(5) not null,
	Numero_min numeric(5) not null,
	Coordenada_latitude_inicio numeric(8) not null,
	Coordenada_latitude_fim numeric(8) not null,
	Coordenada_longitude_inicio numeric(8) not null,
	Coordenada_longitude_fim numeric(8) not null
);

--tabela Bairro
create table Bairro(
	Nome char(120) primary key,
	Tamanho numeric (10,2) not null
);

--tablea Trecho
create table Trecho(
	Coordenada_latitude_inicio numeric(8) not null,
	Coordenada_latitude_fim numeric(8) not null,
	Coordenada_longitude_inicio numeric(8) not null,
	Coordenada_longitude_fim numeric(8) not null,
	Largura numeric (6,2) not null,
	Mao_dupla numeric (1) not null check (Mao_dupla in (1,0)), -- boolean
	Quantidade_faixas numeric(2) not null,
	Sinaleira numeric (1) not null check (Sinaleira in (1,0)), -- boolean
	Bairro char(120),
	Rua char(120),
	foreign key (Bairro) references Bairro,
	foreign key (Rua) references Rua,
  constraint PK_Trecho Primary key(Coordenada_latitude_inicio,Coordenada_latitude_fim,Coordenada_longitude_inicio, Coordenada_longitude_fim)
);


--tabela cruzamento
create table Cruzamento(
	Nome_rua1 char(120) not null,
	Nome_rua2 char(120) not null,
	rotatoria numeric(1) not null check (rotatoria in (1,0)), -- boolean
	Sinaleira numeric(1) not null check (Sinaleira in (1,0)), -- boolean
	foreign key(Nome_rua1) references Rua,
	foreign key(Nome_rua2) references Rua,
  constraint PK_Cruz Primary key(Nome_rua1, Nome_rua2)
  );

--tabela lote
create table Lote(
	ID numeric (10) primary key,
	Coordenada_latitude numeric (8) not null,
	Coordenada_longitude numeric (8) not null,
	Area numeric (10,2) not null,
	Rua char(120) not null,
	foreign key (Rua) references Rua
);

--tabela residencia
create table Residencia(
	Numero numeric(6) not null,
	CEP numeric (8) not null,
	Numero_comodos numeric(3) not null,
	Lote numeric (10) not null,
	foreign key (Lote) references Lote,
  constraint PK_Residencia primary key(Numero, CEP)
);

--tabela praca
create table Praca(
	Numero numeric(6) not null,
	Nome char (120) not null,
	Area numeric(10,2) not null,
	Lote numeric (10) not null,
	foreign key (Lote) references Lote,
  constraint PK_Praca primary key(Numero, Lote)
);

--tabela local de trabalho
create table Local_trabalho(
	Numero numeric(10) not null,
	Nome char (120) not null,
	CEP numeric (8) not null,
	Lote numeric (10) not null,
	foreign key (Lote) references Lote,
  constraint PK_Lt primary key(Numero, Nome, CEP)
);

--tabela empresa
create table Empresa(
	CNPJ numeric (14) not null,
	Setor char(120) not null,
	Nome_trabalho char(120) not null,
	numero_trabalho numeric(10) not null,
	cep_trabalho numeric(8) not null,
	foreign key(numero_trabalho, Nome_trabalho, cep_trabalho) references Local_trabalho,
  constraint PK_Empresa primary key(CNPJ, Nome_trabalho, numero_trabalho, cep_trabalho)
);

--tabela predio servico publico
create table Servico_publico(
	orgao_publico char(120) not null,
	funcao char(120) not null,
	Nome_trabalho char(120) not null,
	numero_trabalho numeric(10) not null,
	cep_trabalho numeric(8) not null,
	foreign key(numero_trabalho, Nome_trabalho, cep_trabalho) references Local_trabalho,
  constraint PK_sp primary key(Nome_trabalho, numero_trabalho, cep_trabalho)
);

--tabela pessoa
create table Pessoa(
	Nome char(120) not null,
	Idade numeric(3) not null,
	RG numeric(10) primary key,
	Sexo char(1) check (Sexo in ('M', 'F', 'O')), -- O para outros
	CPF numeric(11), -- algumas criancas nao tem cpf
	Residencia_numero numeric(6) not null,
	Residencia_cep numeric(8) not null,
	Nome_trabalho char(120) not null,
	numero_trabalho numeric(10) not null,
	cep_trabalho numeric(8) not null,
	foreign key(Residencia_numero, Residencia_cep) references Residencia,
	foreign key(numero_trabalho, Nome_trabalho, cep_trabalho) references Local_trabalho
);

--tabela Proprietario
create table Proprietario(
	Data_Aquisicao Date not null,
	Preco_aquisicao numeric (10,2) not null check (Preco_aquisicao > 0),
	Proprietario numeric(10) not null,
	Lote numeric(10) not null,
	foreign key (Proprietario) references Pessoa,
	foreign key (Lote) references Lote,
  constraint PK_Prop primary key(Proprietario, Lote)
);


Insert into Rua values('Santo Antonio',100, 2, 3000, 3000, 1000, 2000);
Insert into Rua values('Borges de Medeiros',300, 2, 2000, 4000, 2000, 2000);
Insert into Rua values('Ipiranga',150, 100, 2000, 2000, 2000, 4000);
Insert into Rua values('Independencia',100, 2, 4000, 4000, 2000, 4000);
Insert into Rua values('Albert',500, 5, 1000, 2000, 3000, 3000);
Insert into Rua values('Uppsala',200, 2, 1000, 1000, 2000, 3000);
Insert into Rua values('Cordoba',300, 2, 4000, 5000, 3000, 3000);
Insert into Rua values('Garibaldi',150, 100, 5000, 5000, 2000, 3000);
Insert into Rua values('Broadway',200, 100, 2000, 4000, 4000, 4000);
Insert into Rua values('Osvaldo Aranha', 200, 100, 3000, 3000, 4000, 7000);


Insert into Cruzamento values('Santo Antonio', 'Borges de Medeiros', 1, 0);
Insert into Cruzamento values('Ipiranga', 'Albert', 0, 1);
Insert into Cruzamento values('Ipiranga', 'Borges de Medeiros', 0, 1);
Insert into Cruzamento values('Ipiranga', 'Broadway', 0, 1);
Insert into Cruzamento values('Independencia', 'Borges de Medeiros', 0, 1);
Insert into Cruzamento values('Independencia', 'Cordoba', 0, 1);
Insert into Cruzamento values('Independencia', 'Broadway', 0, 1);
Insert into Cruzamento values('Albert', 'Uppsala', 1, 1);
Insert into Cruzamento values('Cordoba', 'Garibaldi', 1, 1);
Insert into Cruzamento values('Broadway', 'Osvaldo Aranha', 1, 0);


Insert into Bairro values('Centro', 10000);
Insert into Bairro values('Cidade Alta', 10000);
Insert into Bairro values('Bom Inicio', 10000);

Insert into Trecho values(3000, 3000, 1000, 1500, 20, 0, 3, 1,'Centro', 'Santo Antonio');
Insert into Trecho values(3000, 3000, 1500, 2000, 20, 0, 3, 1,'Centro', 'Santo Antonio');
Insert into Trecho values(2000, 3000, 2000, 2000, 10, 1, 2, 1,'Centro', 'Borges de Medeiros');
Insert into Trecho values(3000, 4000, 2000, 2000, 10, 1, 2, 0,'Centro', 'Borges de Medeiros');
Insert into Trecho values(2000, 2000, 2000, 3000, 25, 1, 5, 1,'Bom Inicio', 'Ipiranga');
Insert into Trecho values(2000, 2000, 3000, 4000, 30, 1, 6, 1,'Bom Inicio', 'Ipiranga');
Insert into Trecho values(4000, 4000, 2000, 3000, 30, 1, 6, 1,'Centro', 'Independencia');
Insert into Trecho values(4000, 4000, 3000, 4000, 30, 1, 6, 0,'Centro', 'Independencia');
Insert into Trecho values(1000, 1500, 3000, 3000, 15, 0, 2, 0,'Bom Inicio', 'Albert');
Insert into Trecho values(1500, 2000, 3000, 3000, 15, 1, 2, 1,'Bom Inicio', 'Albert');
Insert into Trecho values(1000, 1000, 2000, 2500, 15, 0, 2, 0,'Bom Inicio', 'Uppsala');
Insert into Trecho values(1000, 1000, 2500, 3000, 10, 0, 1, 0,'Bom Inicio', 'Uppsala');
Insert into Trecho values(4000, 4500, 3000, 3000, 30, 1, 3, 1,'Centro', 'Cordoba');
Insert into Trecho values(4500, 5000, 3000, 3000, 30, 1, 3, 0,'Centro', 'Cordoba');
Insert into Trecho values(5000, 5000, 2000, 2500, 20, 1, 2, 1,'Centro', 'Garibaldi');
Insert into Trecho values(5000, 5000, 2500, 3000, 15, 0, 2, 0,'Centro', 'Garibaldi');
Insert into Trecho values(2000, 3000, 4000, 4000, 30, 1, 4, 1,'Cidade Alta', 'Broadway');
Insert into Trecho values(3000, 4000, 4000, 4000, 30, 1, 4, 1,'Cidade Alta', 'Broadway');
Insert into Trecho values(3000, 3000, 4000, 5500, 30, 1, 4, 1,'Cidade Alta', 'Osvaldo Aranha');
Insert into Trecho values(3000, 3000, 5500, 7000, 20, 0, 2, 0,'Cidade Alta', 'Osvaldo Aranha');
-- Insert into Trecho values();

-- create table Trecho(
-- 	Coordenada_latitude_inicio numeric(8) primary key,
-- 	Coordenada_latitude_fim numeric(8) primary key,
-- 	Coordenada_longitude_inicio numeric(8) primary key,
-- 	Coordenada_longitude_fim numeric(8) primary key,
-- 	Largura numeric (6,2) not null,
-- 	Mao_dupla numeric (1) not null,
-- 	Quantidade_faixas numeric(2) not null,
-- 	Sinaleira numeric (1) not null,
-- 	Bairro char(120),
-- 	Rua char(120),
-- 	foreign key (Bairro) references Bairro,
-- 	foreign key (Rua) references Rua
-- );


Insert into Lote values(1, 2500, 2500, 100, 'Borges de Medeiros');
Insert into Lote values(2, 3500, 3500, 100, 'Broadway');
Insert into Lote values(3, 4500, 2500, 100, 'Cordoba');
Insert into Lote values(4, 500, 2500, 100, 'Uppsala');
Insert into Lote values(5, 4500, 3500, 100, 'Cordoba');
Insert into Lote values(6, 2500, 5500, 500, 'Osvaldo Aranha');
Insert into Lote values(7, 2500, 6000, 100, 'Osvaldo Aranha');
Insert into Lote values(8, 3500, 6000, 400, 'Osvaldo Aranha');
Insert into Lote values(9, 3500, 6500, 500, 'Osvaldo Aranha');


-- create table Lote(
-- 	ID numeric (10) primary key,
-- 	Coordenadas numeric (8) not null,
-- 	Area numeric (10,2) not null
-- );
