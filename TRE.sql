
CREATE TABLE Localidade (
  localidade_id serial PRIMARY KEY,
  nome varchar(80),
  cep varchar(80)
);


CREATE TABLE Zonaeleitoral (
  zona_id serial PRIMARY KEY,
  nome varchar(80),
  localidade_fk integer,
  FOREIGN KEY (localidade_fk) REFERENCES localidade(localidade_id)
);


CREATE TABLE PartidoPolitico (
  
  partido_id serial PRIMARY KEY,
  nome varchar(80),
  codpartido integer
  );


CREATE TABLE Secao (
  
  secao_id serial PRIMARY KEY,
  zona_fk integer,
  FOREIGN KEY (zona_fk) REFERENCES Zonaeleitoral(zona_id)
);


CREATE TABLE Candidato (

  candidato_id serial PRIMARY KEY,
  nome varchar(80),
  codcand integer,
  localidade_fk integer,
  partido_fk integer,
  FOREIGN KEY (localidade_fk) REFERENCES localidade(localidade_id),
  FOREIGN KEY (partido_fk) REFERENCES PartidoPolitico(partido_id)
);

CREATE TABLE Eleitor (
  eleitor_id serial PRIMARY KEY,
  nome varchar(80),
  cpf varchar(80),
  secao_fk integer,
  FOREIGN KEY (secao_fk) REFERENCES Secao(secao_id)
);



CREATE TABLE Voto (
  voto_id serial PRIMARY KEY,
  secao_fk integer,
  candidato_fk integer,
  FOREIGN KEY (secao_fk) REFERENCES Secao(secao_id),
  FOREIGN KEY (candidato_fk) REFERENCES Candidato(Candidato_id)	
);


--Popular tabela
INSERT INTO localidade (nome, cep) VALUES ('niteroi','34740012');
INSERT INTO localidade (nome, cep) VALUES ('sao goncalo','34740013');
INSERT INTO localidade (nome, cep) VALUES ('rio de janeiro','34740014');

INSERT INTO Zonaeleitoral(nome,localidade_fk) VALUES ('UFF-Praia vermelha',1);
INSERT INTO Zonaeleitoral(nome,localidade_fk) VALUES ('Unidos de portugal',2);
INSERT INTO Zonaeleitoral(nome,localidade_fk) VALUES ('UFRJ-Praia vermelha',3);

INSERT INTO Partidopolitico(nome,codpartido) VALUES ('PMDB',1);
INSERT INTO Partidopolitico(nome,codpartido) VALUES ('PT',2);
INSERT INTO Partidopolitico(nome,codpartido) VALUES ('PSOL',3);
INSERT INTO Partidopolitico(nome,codpartido) VALUES ('PSDB',4);

INSERT INTO Secao(zona_fk) VALUES (1);
INSERT INTO Secao(zona_fk) VALUES (1);
INSERT INTO Secao(zona_fk) VALUES (2);
INSERT INTO Secao(zona_fk) VALUES (2);
INSERT INTO Secao(zona_fk) VALUES (3);
INSERT INTO Secao(zona_fk) VALUES (3);

INSERT INTO Candidato(nome,codcand,localidade_fk,partido_fk) VALUES ('zé do gás',10,1,1);
INSERT INTO Candidato(nome,codcand,localidade_fk,partido_fk) VALUES ('zé do taxi',11,1,2);
INSERT INTO Candidato(nome,codcand,localidade_fk,partido_fk) VALUES ('zé do mototaxi',12,1,3);
INSERT INTO Candidato(nome,codcand,localidade_fk,partido_fk) VALUES ('zé da escola',10,2,1);
INSERT INTO Candidato(nome,codcand,localidade_fk,partido_fk) VALUES ('zé do uber',22,2,2);
INSERT INTO Candidato(nome,codcand,localidade_fk,partido_fk) VALUES ('zé da van',23,2,3);
INSERT INTO Candidato(nome,codcand,localidade_fk,partido_fk) VALUES ('zé da borracharia',30,3,1);
INSERT INTO Candidato(nome,codcand,localidade_fk,partido_fk) VALUES ('zé da piscina',30,3,2);
INSERT INTO Candidato(nome,codcand,localidade_fk,partido_fk) VALUES ('zé do Vasco',30,3,3);


INSERT INTO Eleitor(nome,cpf,secao_fk) VALUES ('zé da escola','15758866445',1);
INSERT INTO Eleitor(nome,cpf,secao_fk) VALUES ('Ricardo','15758866442',1);
INSERT INTO Eleitor(nome,cpf,secao_fk) VALUES ('Carol','15758866443',2);
INSERT INTO Eleitor(nome,cpf,secao_fk) VALUES ('Bia','15758866446',2);
INSERT INTO Eleitor(nome,cpf,secao_fk) VALUES ('Laura','15758866447',3);
INSERT INTO Eleitor(nome,cpf,secao_fk) VALUES ('Fabiana','15758866448',3);
INSERT INTO Eleitor(nome,cpf,secao_fk) VALUES ('Ronnie','12758866446',4);
INSERT INTO Eleitor(nome,cpf,secao_fk) VALUES ('Ragnar','13758866447',4);
INSERT INTO Eleitor(nome,cpf,secao_fk) VALUES ('Michele','24758866448',5);
INSERT INTO Eleitor(nome,cpf,secao_fk) VALUES ('Fernando','34758866448',5);
INSERT INTO Eleitor(nome,cpf,secao_fk) VALUES ('Rodrigo','44758866448',6);
INSERT INTO Eleitor(nome,cpf,secao_fk) VALUES ('Diogo','54758866448',6);

INSERT INTO Voto(secao_fk,candidato_fk) VALUES (1,1);
INSERT INTO Voto(secao_fk,candidato_fk) VALUES (1,1);
INSERT INTO Voto(secao_fk,candidato_fk) VALUES (2,2);
INSERT INTO Voto(secao_fk,candidato_fk) VALUES (2,1);
INSERT INTO Voto(secao_fk,candidato_fk) VALUES (4,4);
INSERT INTO Voto(secao_fk,candidato_fk) VALUES (4,4);
INSERT INTO Voto(secao_fk,candidato_fk) VALUES (4,4);
INSERT INTO Voto(secao_fk,candidato_fk) VALUES (3,5);
INSERT INTO Voto(secao_fk,candidato_fk) VALUES (5,9);
INSERT INTO Voto(secao_fk,candidato_fk) VALUES (5,9);
INSERT INTO Voto(secao_fk,candidato_fk) VALUES (6,9);
INSERT INTO Voto(secao_fk,candidato_fk) VALUES (6,9);



--Consultas

--CANDIDATOS COM NENHUM VOTO
SELECT c.nome
FROM candidato c
where c.candidato_id not in (select v.candidato_fk from voto v)
group by c.nome

--CANDIDATOS MAIS VOTADO
SELECT c.nome
FROM candidato c, voto v
where c.candidato_id = v.candidato_fk
group by c.nome
ORDER BY count(v.candidato_fk) DESC
LIMIT 1;

--CANDIDATOS DA LOCALIDADE NITEROI QUE TIVERAM MAIS DE 1 VOTO
SELECT c.nome, count(v.candidato_fk)
FROM candidato c, voto v, localidade l
where c.candidato_id = v.candidato_fk and l.localidade_id=c.localidade_fk and l.nome='niteroi'
group by c.nome
having count(v.candidato_fk)>1;

