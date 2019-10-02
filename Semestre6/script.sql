----- INSERTIONS -------

insert into CBO2002_GRANDEGRUPO
select * from duncanbda.CBO2002_GRANDEGRUPO;

insert into CBO2002_GRUPO
select * from duncanbda.CBO2002_GRUPO;

insert into CBO2002_SUBGRUPO
select * from duncanbda.CBO2002_SUBGRUPO;

insert into CBO2002_FAMILIA
select * from duncanbda.CBO2002_FAMILIA;

insert into CBO2002_OCUPACAO
select * from duncanbda.CBO2002_OCUPACAO;

insert into CID10_CATEGORIAS
select * from duncanbda.CID10_CATEGORIAS;

insert into CID10_SUBCATEGORIAS
select * from duncanbda.CID10_SUBCATEGORIAS;

insert into CNAE20_DIVISOES
select * from duncanbda.CNAE20_DIVISOES;

insert into CNAE20_GRUPOS
select * from duncanbda.CNAE20_GRUPOS;

insert into CNAE20_CLASSES
select * from duncanbda.CNAE20_CLASSES;

insert into MUNICIPIOS
select * from duncanbda.MUNICIPIOS;

insert into MUNICIPIOS_POPULACOES
select * from duncanbda.MUNICIPIOS_POPULACOES;

insert into ACID_TRABALHO_2019_10
select * from duncanbda.ACID_TRABALHO_2019_10;

---- Queries -----

select denominacao, mes_ano_acidente, count(*) as numero_acidentes
from ACID_TRABALHO_2019_10 join CNAE20_CLASSES on CNAE20_EMPREGADOR = CLASSE_NUM
where(AGENTE_CAUSADOR_ACIDENTE like 'Ser Vivo%' and sexo = 'Masculino' and CLASSE_NUM = 5310)
group by denominacao, mes_ano_acidente
order by MES_ANO_ACIDENTE, denominacao;

select distinct CID10_CATEGORIAS.cat as categoria, CID10_CATEGORIAS.descricao as descricao, natureza_da_lesao
from ACID_TRABALHO_2019_10 join CID10_SUBCATEGORIAS on ACID_TRABALHO_2019_10.cid_10 = CID10_SUBCATEGORIAS.subcat  
join CID10_CATEGORIAS on CID10_SUBCATEGORIAS.cat = CID10_CATEGORIAS.cat
where (AGENTE_CAUSADOR_ACIDENTE like 'Ser Vivo%' and sexo = 'Masculino' and CLASSE_NUM = 5310)
order by categoria,natureza_da_lesao;
