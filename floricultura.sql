CREATE TABLE Cliente (
  cliente_id serial PRIMARY KEY,
  nome varchar(80) NOT NULL,
  telefone varchar(11) NOT NULL
);
CREATE TABLE Regiao (
  regiao_id serial PRIMARY KEY,
  nome varchar(80) NOT NULL 
);
CREATE TABLE Flores (
  flor_id serial PRIMARY KEY,
  nome varchar(80) NOT NULL,
  especie varchar(30) NOT NULL
);
CREATE TABLE Floricultura (
  floricultura_id serial PRIMARY KEY,
  nome varchar(80) NOT NULL,
  telefone varchar(11) NOT NULL
);
CREATE TABLE FloriculturaRegiao (
  regiao_fk integer,
  floricultura_fk integer,
  PRIMARY KEY (regiao_fk, floricultura_fk),
  FOREIGN KEY (floricultura_fk) REFERENCES Floricultura(floricultura_id),
  FOREIGN KEY (regiao_fk) REFERENCES Regiao(regiao_id)
);

CREATE TABLE Estoque (
  estoque_id  serial PRIMARY KEY,
  floricultura_fk integer NOT NULL,
  FOREIGN KEY (floricultura_fk) REFERENCES Floricultura(floricultura_id)
 );

CREATE TABLE EstoqueFlores (
  estoque_fk integer,
  flor_fk integer,
  qnt integer,
  PRIMARY KEY (estoque_fk, flor_fk),
  FOREIGN KEY (flor_fk) REFERENCES Flores(flor_id),
  FOREIGN KEY (estoque_fk) REFERENCES Estoque(estoque_id)  
 );

CREATE TABLE Endereco (
  endereco_id  serial PRIMARY KEY,
  numerocasa integer NOT NULL,
  cep varchar(8) NOT NULL,
  cliente_fk integer NOT NULL, 
  FOREIGN KEY (cliente_fk) REFERENCES Cliente(cliente_id)  
 );
CREATE TABLE Pedido (
  pedido_id  serial PRIMARY KEY,
  floricultura_fk integer NOT NULL,
  endereco_fk integer NOT NULL,
  cliente_fk integer NOT NULL, 
  FOREIGN KEY (cliente_fk) REFERENCES Cliente(cliente_id),  
  FOREIGN KEY (floricultura_fk) REFERENCES Floricultura(floricultura_id),
  FOREIGN KEY (endereco_fk) REFERENCES Endereco(endereco_id)	
);

CREATE TABLE PedidoFlores (
  pedido_fk  integer,
  flor_fk integer,
  qnt integer NOT NULL,
  PRIMARY KEY (pedido_fk, flor_fk),
  FOREIGN KEY (pedido_fk) REFERENCES Pedido(pedido_id),  
  FOREIGN KEY (flor_fk) REFERENCES Flores(flor_id)
);
 


--Populando tabelas
INSERT INTO Cliente (nome, telefone) VALUES ('Ricardo','37088302');
INSERT INTO Cliente (nome, telefone) VALUES ('Carol','37088301');

INSERT INTO Regiao (nome) VALUES ('Niteroi');
INSERT INTO Regiao (nome) VALUES ('Bahia');
INSERT INTO Regiao (nome) VALUES ('Acre');

INSERT INTO Flores (nome, especie) VALUES ('Rosa','Azul');
INSERT INTO Flores (nome, especie) VALUES ('Rosa','Branca');

INSERT INTO Floricultura (nome, telefone) VALUES ('FloriculturaIN','37088405');
INSERT INTO Floricultura (nome, telefone) VALUES ('INFloricultura','37088408');
INSERT INTO Floricultura (nome, telefone) VALUES ('FloriculturaAC','37088409');

INSERT INTO FloriculturaRegiao (regiao_fk, floricultura_fk) VALUES (1,1);
INSERT INTO FloriculturaRegiao (regiao_fk, floricultura_fk) VALUES (2,2);
INSERT INTO FloriculturaRegiao (regiao_fk, floricultura_fk) VALUES (3,2);
INSERT INTO FloriculturaRegiao (regiao_fk, floricultura_fk) VALUES (3,3);

INSERT INTO Estoque(floricultura_fk) VALUES (1);
INSERT INTO Estoque(floricultura_fk) VALUES (2);
INSERT INTO Estoque(floricultura_fk) VALUES (3);

INSERT INTO EstoqueFlores(estoque_fk,flor_fk, qnt) VALUES (1,2,300);
INSERT INTO EstoqueFlores(estoque_fk,flor_fk, qnt) VALUES (2,2,300);
INSERT INTO EstoqueFlores(estoque_fk,flor_fk, qnt) VALUES (3,1,300);

INSERT INTO Endereco(numerocasa, cep, cliente_fk) VALUES (293,24740011,1);
INSERT INTO Endereco(numerocasa, cep, cliente_fk) VALUES (294,24740012,2);


INSERT INTO Pedido(floricultura_fk, endereco_fk, cliente_fk) VALUES (1,1,1);
INSERT INTO Pedido(floricultura_fk, endereco_fk, cliente_fk) VALUES (2,1,2);
INSERT INTO Pedido(floricultura_fk, endereco_fk, cliente_fk) VALUES (3,2,2);
INSERT INTO Pedido(floricultura_fk, endereco_fk, cliente_fk) VALUES (1,2,1);

INSERT INTO Pedidoflores(pedido_fk, flor_fk, qnt) VALUES (1,1,200);
INSERT INTO Pedidoflores (pedido_fk, flor_fk, qnt) VALUES (2,1,50);
INSERT INTO Pedidoflores (pedido_fk, flor_fk, qnt) VALUES (1,2,10);
INSERT INTO Pedidoflores (pedido_fk, flor_fk, qnt) VALUES (3,2,20);
INSERT INTO Pedidoflores (pedido_fk, flor_fk, qnt) VALUES (4,1,1);
INSERT INTO Pedidoflores (pedido_fk, flor_fk, qnt) VALUES (4,2,3);

select * from pedidoflores
---Consultas

--NUMERO DE PEDIDOS FEITOS EM CADA ENDEREÇO 
SELECT cep, numerocasa, COUNT(e.endereco_id) NumPedidos
FROM endereco as e, pedido as p
WHERE p.endereco_fk=e.endereco_id
GROUP BY cep, numerocasa;

--Quantidade de flores que tiveram mais de 100 unidades vendidas
SELECT f.nome,f.especie, sum(qnt) qntvendida
FROM flores as f, pedidoflores as pf
WHERE pf.flor_fk=f.flor_id
GROUP BY f.nome, f.especie
HAVING sum(qnt)>100;

--Os 2 maiores pedidos e quais clientes fizeram 
SELECT c.nome, p.pedido_id, qnt
FROM cliente as c, pedido as p, pedidoflores as pf
WHERE c.cliente_id=p.cliente_fk and pf.pedido_fk=p.pedido_id
ORDER BY pf.qnt DESC
LIMIT 2;



