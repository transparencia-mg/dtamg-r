select id_empenho, 
       ano_exercicio, 
       sqa_gmifp, 
       sqa_credor, 
       sqa_natureza, 
       sqa_unidade_orc, 
       sqa_progtrab, 
       sqa_unidade_exec, 
       sqa_empenho, 
       nr_empenho, 
       dt_empenho, 
       unidade_orcamentaria, 
       unidade_executora, 
       funcao, 
       subfuncao, 
       programa, 
       acao, 
       categoria_econ, 
       grupo_desp, 
       elemento_desp, 
       item_desp, 
       modalidade_aplic, 
       tipo_empenho, 
       fonte_recurso, 
       identificador_orc, 
       razao_social_credor, 
       vr_empenho 
from {{source}} a
join fl_compras_empenho b
on a.id_empenho = b.id_empenho
# using (id_empenho)
# where id_empenho in (select id_empenho from fl_compras_empenho)
