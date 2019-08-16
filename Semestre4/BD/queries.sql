select distinct Rua.nome, Trecho.Quantidade_faixas
from Trecho inner join Rua on Rua.nome = Trecho.Rua
inner join Bairro on Bairro.nome = Trecho.bairro
where Bairro.tamanho > 30000 and Trecho.Quantidade_faixas > 2 and Rua.Coordenada_latitude_inicio > 2000;

select Pessoa.Nome, Pessoa.Idade 
from Pessoa where Pessoa.Rg in
(select Proprietario
from Proprietario
where preco_aquisicao > (select avg(preco_aquisicao) from Proprietario));

select * from Empresa where Empresa.nome_trabalho in
(select local_trabalho.nome from local_trabalho where local_trabalho.Lote in
(select Lote.Id from Lote inner join local_trabalho on Lote.id = local_trabalho.Lote
minus
select Lote.Id from Lote inner join praca on Lote.id = praca.Lote));

delete from Rua where nome = 'Santo Antonio';

select * from Trecho;
