CREATE TABLE Jogador (
  jogador_id serial PRIMARY KEY,
  nome varchar(80) NOT NULL,
  situacao varchar(11) NOT NULL,
  idade integer NOT NULL,
  numero integer NOT NULL,
  posicao integer NOT NULL	
);
CREATE TABLE Tecnico (
  tecnico_id serial PRIMARY KEY,
  nome varchar(80) NOT NULL,
  idade integer NOT NULL
  );

CREATE TABLE Clube(
  clube_id serial PRIMARY KEY,
  nome varchar(80) NOT NULL,
  escudo varchar(11) NOT NULL
);

CREATE TABLE Estadio (
  estadio_id serial PRIMARY KEY,
  nome varchar(80) NOT NULL,
  capacidade varchar(11) NOT NULL,
  cep integer NOT NULL
);

CREATE TABLE ClubeEstadio(
  estadio_fk integer,
  clube_fk integer,
  PRIMARY KEY (clube_fk, estadio_fk),
  FOREIGN KEY (estadio_fk) REFERENCES Clube(clube_id),
  FOREIGN KEY (clube_fk) REFERENCES Estadio(estadio_id)
  );



CREATE TABLE Equipe (
  equipe_id serial PRIMARY KEY,
  categoria varchar(80) NOT NULL,
  divisao varchar(11) NOT NULL,
  tecnico_fk integer NOT NULL,
  clube_fk integer NOT NULL,
  FOREIGN KEY (tecnico_fk) REFERENCES Tecnico(tecnico_id),
  FOREIGN KEY (clube_fk) REFERENCES Clube(clube_id)
	
);


CREATE TABLE JogadorEquipe (
  jogador_fk integer,
  equipe_fk integer,
  PRIMARY KEY (jogador_fk, equipe_fk),
  FOREIGN KEY (equipe_fk) REFERENCES Equipe(equipe_id),
  FOREIGN KEY (jogador_fk) REFERENCES Jogador(jogador_id)
);

CREATE TABLE Partida (
  partida_id serial PRIMARY KEY,
  data date,
  pp real,	
  mandante_fk integer,
  partida_fk integer,
  estadio_fk integer,
  FOREIGN KEY (mandante_fk) REFERENCES Equipe(equipe_id),
  FOREIGN KEY (partida_fk) REFERENCES Equipe(equipe_id),
  FOREIGN KEY (estadio_fk) REFERENCES Estadio(estadio_id)	
);

CREATE TABLE JogadorPartida (
  jogador_fk integer,
  partida_fk integer,
  gols integer,
  vermelho integer,
  amarelo integer,
  PRIMARY KEY (jogador_fk, partida_fk),
  FOREIGN KEY (partida_fk) REFERENCES Partida(partida_id),
  FOREIGN KEY (jogador_fk) REFERENCES Jogador(jogador_id)
);


--Consultas

--Quantos jogadores fizeram gols
SELECT  count(distinct j.jogador_id)
FROM Jogador as j, JogadorPartida as jp
WHERE j.jogador_id=jp.jogador_fk  and gols>0

--Quantos clubes fizeram gols
SELECT  count(distinct c.clube_id)
FROM Jogador as j, JogadorPartida as jp, JogadorEquipe as je, Equipe as e, Clube as c
WHERE j.jogador_id=jp.jogador_fk and j.jogador_id=je.jogador_fk and e.equipe_id=je.equipe_fk and e.clube_fk=c.clube_id and gols>0

--Cada jogador que recebeu mais de 2 cartoes amarelos
SELECT  j.nome, count(amarelo) cartoesamarelos
FROM Jogador as j, JogadorPartida as jp
WHERE j.jogador_id=jp.jogador_fk  
GROUP BY j.nome
HAVING count(amarelo)>2
ORDER BY count(amarelo) ASC;

