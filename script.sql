-- Criando Schema
create schema CLUBE_DO_LIVRO;

-- Comando para utilizar um Schema
use clube_do_livro;

-- Criando tabelas
/*
	O Padrão para a criação dos atributos é:
    nome_do_campo tipo[tamanho] [not null]
*/
create table livros (
	id_livro int not null,
    nome_livro varchar(100) not null,
    autoria varchar(100) not null,
    editora varchar(100) not null,
    categoria varchar(100) not null,
    preco decimal(5, 2) not null,
    
    -- Definindo a chave primária
    primary key (id_livro)
);

create table estoque (
	id_livro int not null,
	qtd_estoque int not null,
	primary key (id_livro)
);

create table vendas (
	id_pedido int not null,
	id_vendedor int not null,
	id_livro int not null,
	qtd_vendida int not null,
	data_venda date not null,
	primary key (id_vendedor,id_pedido)
);

create table vendedores (
	id_vendedor int not null,
	nome_vendedor varchar(255) not null,
	primary key (id_vendedor)
);

-- Alterando tabelas criadas, adicionando chaves estrangeiras
alter table estoque add constraint fk_estoque_livros
foreign key (id_livro) 
references livros (id_livro)
-- Forçar um erro toda vez que deletar ou alterar um dado que esteja na tabela estoque, mas não esteja na tabela livros
on delete no action
on update no action;

alter table vendas add constraint fk_vendas_livros
foreign key (id_livro)
references livros (id_livro)
on delete no action
on update no action;

alter table vendas add constraint fk_vendas_vendedores
foreign key (id_vendedor)
references vendedores (id_vendedor)
on delete no action
on update no action;

-- Inserindo dados nas tabelas
insert into livros (id_livro, nome_livro, autoria, editora, categoria, preco)
values (1, 'Dom Casmurro', 'Machado de Assis', 'Editora XYZ', 'Romance', 29.99); -- Inserção única

insert into livros (id_livro, nome_livro, autoria, editora, categoria, preco)
values (2, 'O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 'Editora ABC', 'Infantojuvenil', 19.99),
       (3, '1984', 'George Orwell', 'Editora DEF', 'Ficção Científica', 24.99); -- Inserção múltipla

insert into livros (id_livro, nome_livro, autoria, editora, categoria, preco)
values 	(4,    'Dom Casmurro',                     'Machado de Assis',    'Via Leitura',   'Romance',    19.90),
		(5,    'Memórias Póstumas de Brás Cubas',    'Machado de Assis',    'Antofágica',    'Romance',    45),
		(6,    'Quincas Borba',                 'Machado de Assis',    'L&PM Editores', 'Romance',    48.5),
		(7,    'Ícaro',                             'Gabriel Pedrosa',     'Ateliê',          'Poesia',    36),
		(8,    'Os Lusíadas',                     'Luís Vaz de Camões',  'Montecristo',   'Poesia',    18.79),
		(9,    'Outros Jeitos de Usar a Boca',    'Rupi Kaur',          'Planeta',          'Poesia',    34.8);

insert into vendedores (id_vendedor, nome_vendedor)
values
(1,'Paula Rabelo'),
(2,'Juliana Macedo'),
(3,'Roberto Barros'),
(4,'Barbara Jales');

insert into vendas (id_pedido, id_vendedor, id_livro, qtd_vendida, data_venda)
values
(1, 3, 7, 1, '2020-11-02'),
(2, 4, 8, 2, '2020-11-02'),
(3, 4, 4, 3, '2020-11-02'),
(4, 1, 7, 1, '2020-11-03'),
(5, 1, 6, 3, '2020-11-03'),
(6, 1, 9, 2, '2020-11-04'),
(7, 4, 1, 3, '2020-11-04'),
(8, 1, 5, 2, '2020-11-05'),
(9, 1, 2, 1, '2020-11-05'),
(10, 3, 8, 2, '2020-11-11'),
(11, 1, 1, 4, '2020-11-11'),
(12, 2, 10, 10, '2020-11-11'),
(13, 1, 12, 5, '2020-11-18'),
(14, 2, 4, 1, '2020-11-25'),
(15, 3, 13, 2,'2021-01-05'),
(16, 4, 13, 1, '2021-01-05'),
(17, 4, 4, 3, '2021-01-06'),
(18, 2, 12, 2, '2021-01-06');

insert into estoque (id_livro, qtd_estoque)
values
(1, 7),
(2, 10),
(3, 2),
(8, 4);

commit;


-- Consultando dadados
select nome_livro "Nome do Livro", autoria, editora, categoria, preco "R$" from livros;

select * from livros where categoria = 'Poesia'; -- utilizando where para adicionar cláusulas de retorno

select * from livros 
where categoria = 'Romance'
and preco < 48;

select * from livros 
where categoria = 'Poesia'
and autoria not in ('Luís Vaz de Camões', 'Gabriel Pedrosa');

select distinct autoria from livros -- Retornando dados distintos, ou seja, não se repete
order by autoria; -- sendo ordenado por ordem alfabética do nome

-- Delando dados
delete from vendas 
where id_livro = 8;

delete from estoque 
where id_livro = 8;

delete from livros 
where id_livro = 8;

commit;


-- Alterando dados
update livros
set preco = 0.9*preco
where id_livro > 0;


-- Fazendo consulta unindo tabelas
select b.nome_vendedor, sum(a.qtd_vendida) -- para realizar um função de agregação, precisar agrupar a coluna referenciada da função
from vendas a, vendedores b
where a.id_vendedor = b.id_vendedor
group by b.nome_vendedor;

-- Fazendo consulta unindo tabelas com o "inner join"
-- O inner join irá retornar os dados que contém em ambas as tabelas
select b.nome_vendedor, sum(a.qtd_vendida) -- para somar desta forma, é necessário agrupar
from vendas a inner join vendedores b on (a.id_vendedor = b.id_vendedor)
group by b.nome_vendedor;

-- Fazendo consulta unindo tabelas com o "left join"
-- O left join irá retornar os dados da primeira tabela do join (á esquerda)
select a.nome_livro, sum(b.qtd_vendida)
from livros a left join vendas b on (a.id_livro = b.id_livro)
group by a.nome_livro;

-- Fazendo consulta unindo tabelas com o "right join"
-- O right join irá retornar os dados da segunda tabela do join (á direita)
select a.nome_livro, sum(b.qtd_vendida)
from livros a right join vendas b on (a.id_livro = b.id_livro)
group by a.nome_livro;

-- Também há o "Full Outer Join", Esse comando apresenta a união entre duas tabelas.




