--- Nome: Conrado Santos Boeira
--- Matrícula: 17104100-7

---- Get Stats -----
analyze table CBO2002_FAMILIA compute statistics;
analyze table CBO2002_GRANDEGRUPO compute statistics;
analyze table CBO2002_GRUPO compute statistics;
analyze table CBO2002_OCUPACAO compute statistics;
analyze table CBO2002_SUBGRUPO compute statistics;
analyze table CID10_CATEGORIAS compute statistics;
analyze table CID10_SUBCATEGORIAS compute statistics;
analyze table CNAE20_CLASSES compute statistics;
analyze table CNAE20_DIVISOES compute statistics;
analyze table CNAE20_GRUPOS compute statistics;
analyze table MUNICIPIOS compute statistics;
analyze table MUNICIPIOS_POPULACOES compute statistics;
analyze table ACID_TRABALHO_2019_10 compute statistics;

select table_name, num_rows, blocks, avg_space, avg_row_len from user_tables;
select table_name, column_id, column_name, data_type, data_length, num_distinct,
density, num_nulls, avg_col_len from user_tab_columns;
select table_name, constraint_name, constraint_type, search_condition, index_name
from user_constraints;
SELECT SEGMENT_NAME, BYTES, BLOCKS FROM USER_SEGMENTS
ORDER BY 2 DESC;

---- Queries -----

select denominacao, mes_ano_acidente, count(*) as numero_acidentes
from ACID_TRABALHO_2019_10 join CNAE20_CLASSES on CNAE20_EMPREGADOR = CLASSE_NUM
where(AGENTE_CAUSADOR_ACIDENTE like 'Ser Vivo%' and sexo = 'Masculino' and CLASSE_NUM = 5310)
group by denominacao, mes_ano_acidente
order by MES_ANO_ACIDENTE, denominacao;

select distinct CID10_CATEGORIAS.cat as categoria, CID10_CATEGORIAS.descricao as descricao, natureza_da_lesao
from ACID_TRABALHO_2019_10 join CID10_SUBCATEGORIAS on ACID_TRABALHO_2019_10.cid_10 = CID10_SUBCATEGORIAS.subcat  
join CID10_CATEGORIAS on CID10_SUBCATEGORIAS.cat = CID10_CATEGORIAS.cat
where (AGENTE_CAUSADOR_ACIDENTE like 'Ser Vivo%' and sexo = 'Masculino' and CNAE20_EMPREGADOR = 5310)
order by categoria,natureza_da_lesao;


---- Create/drop index -----
create bitmap index bix_agente on ACID_TRABALHO_2019_10 (AGENTE_CAUSADOR_ACIDENTE);
create bitmap index bix_sexo on ACID_TRABALHO_2019_10 (sexo);
create bitmap index bix_classes on ACID_TRABALHO_2019_10 (CNAE20_EMPREGADOR);

drop index bix_agente;
drop index bix_sexo;
drop index bix_classes;

create index ix_agente on ACID_TRABALHO_2019_10 (AGENTE_CAUSADOR_ACIDENTE);
create index ix_sexo on ACID_TRABALHO_2019_10 (sexo);
create index ix_classes on ACID_TRABALHO_2019_10 (CNAE20_EMPREGADOR);

drop index ix_agente;
drop index ix_sexo;
drop index ix_classes;

---- Get Stats -----
analyze table CBO2002_FAMILIA compute statistics;
analyze table CBO2002_GRANDEGRUPO compute statistics;
analyze table CBO2002_GRUPO compute statistics;
analyze table CBO2002_OCUPACAO compute statistics;
analyze table CBO2002_SUBGRUPO compute statistics;
analyze table CID10_CATEGORIAS compute statistics;
analyze table CID10_SUBCATEGORIAS compute statistics;
analyze table CNAE20_CLASSES compute statistics;
analyze table CNAE20_DIVISOES compute statistics;
analyze table CNAE20_GRUPOS compute statistics;
analyze table MUNICIPIOS compute statistics;
analyze table MUNICIPIOS_POPULACOES compute statistics;
analyze table ACID_TRABALHO_2019_10 compute statistics;

select table_name, num_rows, blocks, avg_space, avg_row_len from user_tables;
select table_name, column_id, column_name, data_type, data_length, num_distinct,
density, num_nulls, avg_col_len from user_tab_columns;
select table_name, constraint_name, constraint_type, search_condition, index_name
from user_constraints;
SELECT SEGMENT_NAME, BYTES, BLOCKS FROM USER_SEGMENTS
ORDER BY 2 DESC;

---- Queries -----

select denominacao, mes_ano_acidente, count(*) as numero_acidentes
from ACID_TRABALHO_2019_10 join CNAE20_CLASSES on CNAE20_EMPREGADOR = CLASSE_NUM
where(AGENTE_CAUSADOR_ACIDENTE like 'Ser Vivo%' and sexo = 'Masculino' and CLASSE_NUM = 5310)
group by denominacao, mes_ano_acidente
order by MES_ANO_ACIDENTE, denominacao;

select distinct CID10_CATEGORIAS.cat as categoria, CID10_CATEGORIAS.descricao as descricao, natureza_da_lesao
from ACID_TRABALHO_2019_10 join CID10_SUBCATEGORIAS on ACID_TRABALHO_2019_10.cid_10 = CID10_SUBCATEGORIAS.subcat  
join CID10_CATEGORIAS on CID10_SUBCATEGORIAS.cat = CID10_CATEGORIAS.cat
where (AGENTE_CAUSADOR_ACIDENTE like 'Ser Vivo%' and sexo = 'Masculino' and CNAE20_EMPREGADOR = 5310)
order by categoria,natureza_da_lesao;
