
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



--Consultas

--CANDIDATOS COM NENHUM VOTO
SELECT c.nome
FROM candidato c, voto v
where c.candidato_id = v.candidato_fk
group by c.nome
having count(v.candidato_fk)=0;

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

