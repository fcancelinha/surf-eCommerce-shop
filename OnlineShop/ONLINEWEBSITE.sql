select * from utilizador
select * from produto

-- Ainda não criada

create table encomenda (
	ID int identity primary key,
	DataEncomenda date,
	IDproduto int references produto(id) on delete cascade,
	IDcliente int references utilizador(id) on delete cascade,
	IDestado int references estadoEncomenda(id)
)

create table estadoEncomenda(
	id int identity primary key,
	estado varchar(50)
)

create table admins(
	ID int identity primary key,
	adminNome varchar(50),
	adminMail varchar(100),
	adminPass varchar(100),
	activo bit,
	IDadmin int references tipoAdmin(id)
)

create table tipoAdmin(
	ID int identity primary key,
	descricao varchar(50)
)

create table produto(
	ID int identity primary key,
	imagem varbinary(max),
	titulo varchar(50),
	resumo varchar(300),
	descricao varchar(max),
	detalhe1 varchar(100),
	detalhe2 varchar(100),
	preco decimal(10,2),
	idCategoria int references categoria(id),
)

create table categoria(
	ID int identity primary key,
	descricao varchar(50)
)

create table utilizador(
	ID int identity primary key,
	nome varchar(100),
	email varchar(50),
	password varchar(50),
	empresa varchar(50) null,
	nif varchar(100) null,
	morada varchar(max),
	activo bit,
	idUtilizador int references tipoUtilizador(id),
	avatar varbinary(MAX)
)

create table tipoUtilizador(
	ID int identity primary key,
	descricao varchar(50)
)

create table carrinho(
	IDproduto int references produto(ID) ON DELETE CASCADE,
	IDutilizador int references Utilizador(ID) ON DELETE CASCADE,
	Cookie varchar(MAX) null
)


-- PAGINAÇÃO ATRAVÉS DO SQL
-- Lógica: Se houver 500.000 produtos é melhor carregar apenas uma parte de cada vez do que todos e depois paginar com javascript tornando a aplicação mais leve.

GO
create or alter proc productsPaginatedFiltered(@Campo varchar(100), @Ordem varchar(100), @Categoria varchar(100), @Pagina int, @ItemsPagina int) AS
SELECT produto.ID, 
	   produto.imagem, 
	   produto.titulo, 
	   produto.resumo, 
	   produto.preco, 
	   categoria.descricao 
FROM produto inner join categoria on produto.idCategoria = categoria.ID
WHERE categoria.descricao = IIF(@Categoria = 'Todos', categoria.descricao , @Categoria)
ORDER BY CASE WHEN @Campo = 'Preco' AND @Ordem = 'ASC' THEN produto.preco END,
		 CASE WHEN @Campo = 'Preco' AND @Ordem = 'DESC' THEN produto.preco END DESC,
		 CASE WHEN @Campo = 'Nome' AND @Ordem = 'ASC' THEN produto.titulo END,
		 CASE WHEN @Campo = 'Nome' AND @Ordem = 'DESC' THEN produto.titulo END DESC
OFFSET (@Pagina - 1) * @ItemsPagina ROWS
FETCH NEXT @ItemsPagina ROWS ONLY


GO
create or alter proc numberOfPages(@categoria varchar(100)) as
Select count(produto.id) AS 'Num' FROM produto inner join categoria on produto.idCategoria = categoria.ID
WHERE categoria.descricao = IIF(@Categoria = 'Todos', categoria.descricao , @Categoria)



select * from utilizador



-- PROC INSERT PRODUTO 

select * from produto

GO
create or alter proc inserir_produto (@imagem varbinary(max),
								      @titulo varchar(50),
									  @resumo varchar(300),
									  @descricao varchar(max),
									  @detalhe1 varchar(100),
									  @detalhe2 varchar(100),
									  @preco decimal(10,2),
									  @idCategoria int,
									  @output varchar(300) output)
AS
begin try
begin tran

	IF EXISTS(select '*' from produto where produto.titulo = @titulo)
		throw 60001, 'O produto já se encontra inserido', 10
	
	insert into produto values(@imagem, @titulo, @resumo, @descricao, @detalhe1, @detalhe2, @preco, @idCategoria)

commit
end try
begin catch
	set @output = ERROR_MESSAGE();
	rollback;
end catch


-- SELECT TODOS OS PRODUTOS

-- AZ
select produto.ID, produto.imagem, produto.titulo, produto.resumo, produto.preco, categoria.descricao 
from produto inner join categoria on produto.idCategoria = categoria.ID
ORDER BY produto.titulo ASC

-- ZA
select produto.ID, produto.imagem, produto.titulo, produto.resumo, produto.preco, categoria.descricao 
from produto inner join categoria on produto.idCategoria = categoria.ID
ORDER BY produto.titulo DESC

--Preco ASC
select produto.ID, produto.imagem, produto.titulo, produto.resumo, produto.preco, categoria.descricao 
from produto inner join categoria on produto.idCategoria = categoria.ID
ORDER BY produto.preco ASC

--Preco DESC

select produto.ID, produto.imagem, produto.titulo, produto.resumo, produto.preco, categoria.descricao 
from produto inner join categoria on produto.idCategoria = categoria.ID
ORDER BY produto.preco DESC


-- PROCEDURE ADICIONAR ITEM (@ID refere-se ao produto, @IDutilizador refere-se ao utilizador)

GO
create or alter proc adicionaItem (@ID int, @IDutilizador int, @Cookie varchar(Max), @output varchar(300) output) AS
BEGIN TRY
BEGIN TRAN
	
	insert into carrinho values(@ID, @IDutilizador, @Cookie)

COMMIT
END TRY
BEGIN CATCH
	set @output = ERROR_MESSAGE();
	ROLLBACK;
END CATCH

-- diminuir quantidade

-- delete top(1) from carrinho where carrinho.IDproduto = @ID AND carrinho.IDutilizador =  AND carrinho.Cookie = 

-- aumentar quantidade

-- insert into carrinho values(@ID, @IDutilizador, @Cookie)


-- PROCEDURE CHECKOUT 

go
CREATE OR ALTER PROC itemCart(@IDutilizador int, @Cookie varchar(MAX)) AS
select produto.ID, produto.imagem, produto.titulo, produto.resumo, categoria.descricao, count(produto.id) AS 'Qtd', sum(produto.preco) AS 'Total', produto.preco AS 'Unitario'
from utilizador inner join carrinho on utilizador.id = carrinho.IDutilizador
				inner join produto on produto.ID = carrinho.IDproduto
				inner join categoria on categoria.ID = produto.idCategoria
where carrinho.IDutilizador = IIF(@IDutilizador = 1, null, @IDutilizador) or carrinho.Cookie = @Cookie
group by produto.ID, produto.imagem, produto.titulo, produto.resumo, categoria.descricao, produto.preco


select * from tipoUtilizador

-- CHECK LOGIN E ALTERAÇÃO DO CARRINHO// adicionar mais coisas ao objecto

GO
CREATE OR ALTER PROC checkLogin(@email varchar(50), @password varchar(50), @Cookie varchar(MAX), @output varchar(300) output) AS
BEGIN TRY
		
		IF NOT EXISTS(select '*' from utilizador where utilizador.email = @email)
			THROW 60001, 'Não está registado! Registe-se para comprar', 10
		IF NOT EXISTS(select '*' from utilizador where utilizador.email = @email and utilizador.password = @password)
			THROW 60001, 'Utilizador ou palavra-passe erradas', 10
		IF NOT EXISTS(select '*' from utilizador where utilizador.email = @email and utilizador.activo = 1)
			THROW 60002, 'Conta encontra-se por activar', 10
		
		select * from utilizador 
		where utilizador.email = @email AND utilizador.password = @password

BEGIN TRAN
		
		IF @Cookie IS NOT NULL
		update carrinho
		set carrinho.IDutilizador = (select utilizador.ID from utilizador where utilizador.email = @email)
		where carrinho.Cookie = @Cookie

COMMIT
END TRY
BEGIN CATCH
	set @output = ERROR_MESSAGE();
END CATCH


-- DELETE ITEM DO CHECKOUT

GO
CREATE OR ALTER PROC deleteCheckoutItem(@ID int, @IDutilizador int, @Cookie varchar(Max)) AS 
BEGIN TRY
BEGIN TRAN
	
	IF @IDutilizador = 1
	delete from carrinho
	where carrinho.IDproduto = @ID AND carrinho.Cookie = @Cookie
	else
	delete from carrinho
	where carrinho.IDproduto = @ID AND carrinho.IDutilizador = @IDutilizador

COMMIT
END TRY
BEGIN CATCH
	ROLLBACK;
END CATCH

-- PROCEDURE DETALHE DO PRODUTO


GO 
CREATE OR ALTER PROC produtoDetalhe (@ID int) AS
select produto.ID, produto.imagem, produto.titulo, produto.resumo, produto.descricao as 'corpo', produto.detalhe1, produto.detalhe2, produto.preco, categoria.descricao 
from produto inner join categoria on produto.idCategoria = categoria.ID
where produto.ID = @ID

-- QUERY PRODUTO RELACIONADOS
GO 
CREATE OR ALTER PROC produtoRelacionado (@ID int) AS
select top(4) produto.ID, produto.imagem, produto.titulo, produto.preco
from produto 
where produto.ID != @ID AND produto.IDcategoria = (select produto.IDcategoria from produto where produto.ID = @ID)

--QUERY RETORNAR PRODUTOS BACKOFFICE

select * from produto inner join categoria on produto.IDcategoria = categoria.ID

-- PROC UPDATE PRODUTO

GO
create or alter proc updateProd (@ID int,
								 @imagem varbinary(max),
								 @titulo varchar(50),
							     @resumo varchar(300),
								 @descricao varchar(max),
								 @detalhe1 varchar(100),
								 @detalhe2 varchar(100),
								 @preco decimal(10,2),
								 @idCategoria int,
								 @output varchar(300) output)
AS
begin try
begin tran

	update produto
	set   produto.imagem =  IIF(LEN(@imagem) = 0, produto.imagem, @imagem),
		  produto.titulo = @titulo,
		  produto.resumo = @resumo,
		  produto.descricao = @descricao,
		  produto.detalhe1 = @detalhe1,
		  produto.detalhe2 = @detalhe2,
		  produto.preco = @preco,
		  produto.idCategoria = @idCategoria
	where produto.ID = @ID

commit
end try
begin catch
	set @output = ERROR_MESSAGE();
	rollback;
end catch


-- FILL MODAL PRODUTO

GO 
CREATE OR ALTER PROC modalProduto(@ID int) AS
select * from produto inner join categoria on produto.IDcategoria = categoria.ID
where produto.ID = @ID

-- QUERY REPEATER UTILIZADOR BACKOFFICE

select * from utilizador inner join tipoUtilizador on utilizador.idUtilizador = tipoUtilizador.id

--PROC INSERIR UTILIZADOR BACKOFFICE || REGISTO DO UTILIZADOR

GO
create or alter proc inserirUtilizador(@nome varchar(100), 
									   @password varchar(50),
									   @email varchar(50),
									   @empresa varchar(50),
									   @nif varchar(100),
									   @morada varchar(max),
									   @activo bit,
									   @idUtilizador int,
									   @pedidoRevenda bit,
									   @output varchar(300) output)
AS
BEGIN TRY
BEGIN TRAN

		IF EXISTS(SELECT '*' FROM utilizador where utilizador.email = @email)
			throw 60001, 'Este email já se encontra registado', 1

		IF EXISTS(SELECT '*' FROM utilizador where utilizador.nif = @nif)
			throw 60002, 'Este NIF já se encontra registado', 10

		insert into utilizador values(@nome,@email,@password,@empresa,@nif,@morada,@activo,@idUtilizador,@pedidoRevenda)

COMMIT
END TRY
BEGIN CATCH
	set @output = ERROR_MESSAGE();
	ROLLBACK;
END CATCH


select * from utilizador

--PROC ACTUALIZAR UTILIZADOR BACKOFFICE

GO
create or alter proc actUtilBack         (@ID int,
										  @nome varchar(100), 
									      @email varchar(50),
									      @empresa varchar(50),
									      @nif varchar(100),
									      @activo bit,
									      @idUtilizador int,
									      @output varchar(300) output)
AS
BEGIN TRY
BEGIN TRAN

		update utilizador
		set   utilizador.nome = @nome,
			  utilizador.email = @email,
			  utilizador.empresa = @empresa,
			  utilizador.nif = @nif,
			  activo = @activo,
			  idUtilizador = @idUtilizador
		where utilizador.ID = @ID

COMMIT
END TRY
BEGIN CATCH
	set @output = ERROR_MESSAGE();
	ROLLBACK;
END CATCH

select * from utilizador
select * from carrinho


-- PROC Alterar password por parte do utlizador

GO
create or alter proc alterarPasswordUtilizador(@ID int, @passwordAntiga varchar(50), @passwordNova varchar(50), @output varchar(300) output ) AS
BEGIN TRY
BEGIN TRAN

	IF NOT EXISTS(select '*' from utilizador where utilizador.ID = @ID AND utilizador.password = @passwordAntiga)
		THROW 60001, 'Password actual é incorrecta', 10

	update utilizador
	set password = @passwordNova
	where utilizador.ID = @ID
	
COMMIT
END TRY
BEGIN CATCH
	set @output = ERROR_MESSAGE();
	ROLLBACK;
END CATCH


--PROC RECUPERACAO PASSWORD

GO
create or alter proc recuperacaoPassword(@email varchar(50), @password varchar(50), @output varchar(300) output) AS
BEGIN TRY
BEGIN TRAN
		
		IF NOT EXISTS(select '*' from utilizador where utilizador.email = @email)
			throw 60001, 'Este email não se encontra registado', 10
		ELSE
			update utilizador set utilizador.password = @password where utilizador.email = @email	

COMMIT
END TRY
BEGIN CATCH
	set @output = ERROR_MESSAGE();
	ROLLBACK;
END CATCH


-- PROC REALIZAR ENCOMENDA


create table encomenda (
	ID int identity primary key,
	DataEncomenda date,
	qtd int,
	total decimal,
	IDproduto int references produto(id) on delete cascade,
	IDcliente int references utilizador(id) on delete cascade,
	IDestado int references estadoEncomenda(id)
)

create table estadoEncomenda(
	id int identity primary key,
	estado varchar(50)
)

select * from carrinho
select * from utilizador
select * from encomenda

GO
create or alter proc realizarEncomenda(@IDcliente int, @PDF varchar(MAX)) AS
BEGIN TRY
BEGIN TRAN
	
	insert into encomenda
	select getdate() as 'dataencomenda', count(produto.ID) as 'productcount', sum(produto.preco) as 'productssum', produto.id as 'productid', utilizador.ID as 'utilizador', 1 as 'estado', @PDF
	from produto inner join carrinho on produto.ID = carrinho.IDproduto
				 inner join utilizador on carrinho.IDutilizador =  utilizador.ID
	where utilizador.id = @IDcliente
	group by produto.ID, utilizador.ID

	delete from carrinho where carrinho.IDutilizador = @IDcliente

COMMIT
END TRY
BEGIN CATCH
	ROLLBACK;
END CATCH

-- RETORNO DA ENCOMENDA PARA O UTILIZADOR ATRAVÉS DE SQL SOURCE

select * from encomenda

GO
create or alter proc selectEncomenda(@IDcliente int) AS
select encomenda.DataEncomenda AS 'Data', SUM(encomenda.qtd) AS 'Qtd', IIF(utilizador.idUtilizador = 3, Sum(encomenda.total) /1.20, Sum(encomenda.total))  AS 'Total', estadoEncomenda.estado AS 'Estado', encomenda.PDF
from encomenda inner join estadoEncomenda on encomenda.IDestado = estadoEncomenda.id
			   inner join utilizador on utilizador.ID = encomenda.IDcliente
where encomenda.IDcliente = @IDcliente 
group by encomenda.DataEncomenda, estadoEncomenda.estado, utilizador.idUtilizador, encomenda.PDF


-- PROC DAS ENCOMENDAS DO BACKOFFICE

GO
create or alter proc selectEncomendaBackoffice AS
select encomenda.PDF ,encomenda.DataEncomenda AS 'Data', utilizador.nome, utilizador.morada, SUM(encomenda.qtd) AS 'Qtd', IIF(utilizador.idUtilizador = 3, Sum(encomenda.total) /1.20, Sum(encomenda.total))  AS 'Total', encomenda.IDestado AS 'Estado'
from encomenda inner join estadoEncomenda on encomenda.IDestado = estadoEncomenda.id
			   inner join utilizador on utilizador.ID = encomenda.IDcliente
group by encomenda.PDF, encomenda.DataEncomenda, encomenda.IDestado, utilizador.idUtilizador, utilizador.morada, utilizador.nome



-- ALTERAR ESTADO DA ENCOMENDA
GO
create or alter proc alterarEstadoEncomenda(@pdf varchar(max), @IDestado int) AS
BEGIN TRY
BEGIN TRAN
	
	update encomenda set encomenda.IDestado = @IDestado where encomenda.PDF = @pdf

COMMIT
END TRY
BEGIN CATCH
	ROLLBACK;
END CATCH

select * from encomenda


-- APAGAR ENCOMENDA

GO
create or alter proc apagarEncomenda(@pdf varchar(max)) AS
BEGIN TRY
BEGIN TRAN
	
	delete from encomenda where encomenda.PDF = @pdf

COMMIT
END TRY
BEGIN CATCH
	ROLLBACK;
END CATCH


-- QUERY SEARCH - melhor proc

go
create or alter proc searchItem(@search varchar(MAX))AS
select produto.ID, produto.imagem, produto.titulo, produto.resumo, produto.preco, categoria.descricao 
from produto inner join categoria on produto.idCategoria = categoria.ID
where produto.titulo like '%'+ @search +'%'

-- PROC LOGIN BACKOFFICE

GO 
create or alter proc checkLoginAdmins(@username varchar(50), @password varchar(50), @output varchar(300) output) AS
begin try
begin tran

		IF not exists (select '*' from admins where admins.adminNome = @username AND admins.adminPass = @password)
			Throw 60001, 'Email ou password erradas', 10
		IF exists (select '*' from admins where admins.adminNome = @username AND admins.activo = 0)
			throw 60002, 'Contacte o administrador, conta desactivada', 10
		
		select admins.adminNome, admins.IDadmin
		from admins where admins.adminNome = @username

commit
end try
begin catch
	set @output = ERROR_MESSAGE();
	rollback
end catch


-- PROC REGISTO DO UTILIZADOR PELO FRONT-END

GO
create or alter proc registoUtilizador(@nome varchar(100),
									   @email varchar(50),
									   @password varchar(50),
									   @empresa varchar(100),
									   @nif varchar(100),
									   @morada varchar(max),
									   @pedido bit,
									   @output varchar(300) output)
AS
BEGIN TRY
BEGIN TRAN

		IF EXISTS(select '*' from utilizador where utilizador.email = @email)
			throw 60001, 'Email já se encontra registado, efectue o login', 10

		IF EXISTS(select '*' from utilizador where utilizador.nif = @nif)
			throw 60001, 'Este nif já se encontra registado', 10
	
		insert into utilizador values(@nome, @email,@password,  IIF(@empresa = '', null, @empresa),  IIF(@nif = '', null, @nif), @morada, 0, 2, @pedido)
COMMIT
END TRY
BEGIN CATCH
	set @output = ERROR_MESSAGE();
	ROLLBACK;
END CATCH

-- PROC DE ATIVACAO DA CONTA DO UTILIZADOR

GO
create or alter proc ativacaoConta(@email varchar(50)) AS
BEGIN TRY
BEGIN TRAN

	update utilizador set utilizador.activo = 1 where utilizador.email = @email

COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
END CATCH


-- PROC ALTERACAO DE DETALHES PELO CLIENT

select * from utilizador


GO 
create or alter proc alterarDetalhesCliente(@ID int,
											@nome varchar(100), 
										    @email varchar(50), 
											@empresa varchar(50), 
											@nif varchar(100), 
											@morada varchar(MAX),
											@output varchar(300) output) 
AS
BEGIN TRY
BEGIN TRAN

	update utilizador 
	set utilizador.nome = @nome,
		utilizador.email =  @email,
		utilizador.empresa = @empresa,
		utilizador.nif = @nif,
		utilizador.morada = @morada
	where utilizador.id = @ID

COMMIT
END TRY
BEGIN CATCH
	set @output = ERROR_MESSAGE();
	ROLLBACK;
END CATCH


--CATEGORIAS
select produto.ID, produto.imagem, produto.titulo, produto.resumo, produto.preco, categoria.descricao 
from produto inner join categoria on produto.idCategoria = categoria.ID
where categoria.descricao = 'Fatos'

select produto.ID, produto.imagem, produto.titulo, produto.resumo, produto.preco, categoria.descricao 
from produto inner join categoria on produto.idCategoria = categoria.ID
where categoria.descricao = 'ROUPA'

select produto.ID, produto.imagem, produto.titulo, produto.resumo, produto.preco, categoria.descricao 
from produto inner join categoria on produto.idCategoria = categoria.ID
where categoria.descricao = 'PRANCHAS'

select * from admins
select * from estadoEncomenda


-- PROC SELECT ESTATÍSTICA

GO
create or alter proc backofficeEstatistica (@utilizadores int output, @produtos int output, @encomendas int output) AS
set @utilizadores =(select count(utilizador.id) - 1 as 'Utilizadores' from utilizador)
set @produtos=(select count(produto.ID)  as 'Produtos' from produto)
set @encomendas =(select count(distinct encomenda.PDF) as 'Encomendas' from encomenda)


select * from utilizador

-- REGISTO ATRAVÉS DO LOGIN SOCIAL 

GO
create or alter proc registoSocial(@nome varchar(100), @password varchar(50), @email varchar(50), @Cookie varchar(MAX)) AS
BEGIN TRY
BEGIN TRAN

		IF NOT EXISTS(SELECT '*' FROM utilizador WHERE utilizador.email = @email)
			INSERT INTO utilizador VALUES(@nome, @email, @password, null, null, null, 1, 2, 0)

		IF @Cookie IS NOT NULL
		update carrinho
		set carrinho.IDutilizador = (select utilizador.ID from utilizador where utilizador.email = @email)
		where carrinho.Cookie = @Cookie

		select * from utilizador where utilizador.email = @email
COMMIT
END TRY
BEGIN CATCH
	ROLLBACK;
END CATCH

