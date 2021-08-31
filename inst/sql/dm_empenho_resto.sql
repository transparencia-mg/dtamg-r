SELECT
dede.id_empenho,
dede.nr_empenho,
dede.dt_empenho,
dede.dt_original,
dede.ano_exercicio,
dede.unidade_orcamentaria,
dede.unidade_executora,
dede.funcao,
dede.subfuncao,
dede.programa,
dede.acao,
dede.categoria_econ,
dede.grupo_desp,
dede.elemento_desp,
dede.item_desp,
dede.modalidade_aplic,
dede.tipo_empenho,
dede.fonte_recurso,
dede.identificador_orc,
CASE WHEN
         a.sqa_credor IS NOT NULL
         then '000.000.000-00 - INFORMACAO COM RESTRICAO DE ACESSO'
    WHEN a.sqa_credor IS NULL 
    AND REGEXP_LIKE(SUBSTR(dede.razao_social_credor, 1, Instr(dede.razao_social_credor, ' - ', 1, 1) -1), '[0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}')
    THEN REGEXP_REPLACE( -- SUBSTITUI AS TRÊS ÚLTIMAS LETRAS DO CPF/CNPJ
                -- SUBSTITUI AS 3 PRIMEIRAS LETRAS DO CPF/CNPJ
                REGEXP_REPLACE(
                    SUBSTR(dede.razao_social_credor, 1, Instr(dede.razao_social_credor, ' - ', -1, 1) -1), -- RETIRA PRIMEIRA PARTE DO SPLIT NA CÉLULA, ' - '
                        SUBSTR(dede.razao_social_credor, 1, 3), -- PADRÃO DOS 3 PRIMEIROS CARACTERES DA CÉLULA QUE SERÃO SUBSTITUÍDOS
                        '***', -- CARACTERES UTILIZADOS NA SUBSTITUIÇÃO
                        1,1), -- PRIMEIRA OCORRÊNCIA ENCONTRADA
               -- SUBSTITUI AS 3 PRIMEIRAS LETRAS DO CPF/CNPJ
                    SUBSTR(SUBSTR(dede.razao_social_credor, 1, Instr(dede.razao_social_credor, ' - ', -1, 1) -1), -3, 3), '-** ',1,1)
        -- SUBSTITUI AS TRÊS ÚLTIMAS LETRAS DO CPF/CNPJ
        -- -- CONCATENA A ÚLTIMA PARTE DO SPLIT NA CÉLULA, ' - '
        || SUBSTR(dede.razao_social_credor, Instr(dede.razao_social_credor, ' - ', -1, 1) +1)
    ELSE razao_social_credor
END razao_social_credor,
dede.vr_empenho
FROM dm_empenho_resto dede
LEFT JOIN
(
SELECT DISTINCT a.sqa_credor FROM (
SELECT
sqa_credor, 
CASE 
    WHEN dede.dt_original LIKE '%21' AND 
         dede.unidade_orcamentaria LIKE '4291%' AND -- 4291 - FUNDO ESTADUAL DE SAUDE
         dede.unidade_executora LIKE '1320007%' AND -- 1320007 - C - GABINETE -- NÃO EXISTE TABELA DM_UNIDADE_EXECUTORA, CÓDIGOS APENAS NAS TABELAS DM_EMPENHO_DESP E REST
         dede.nr_empenho IN (6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 41, 42, 43, 44, 45, 46, 47, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83) and
         REGEXP_LIKE(SUBSTR(dede.razao_social_credor, 1, Instr(dede.razao_social_credor, ' - ', 1, 1) -1), '[0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}')
         then 'hanseniase'
    WHEN dede.unidade_orcamentaria LIKE '2041%' AND -- 4291 - FUNDO ESTADUAL DE SAUDE
         dede.elemento_desp LIKE '31%' AND -- 1320007 - C - GABINETE -- NÃO EXISTE TABELA DM_UNIDADE_EXECUTORA, CÓDIGOS APENAS NAS TABELAS DM_EMPENHO_DESP E REST
         dede.item_desp LIKE '2%' AND
         REGEXP_LIKE(SUBSTR(dede.razao_social_credor, 1, Instr(dede.razao_social_credor, ' - ', 1, 1) -1), '[0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}')
         THEN 'premio-loterico'
         ELSE 'sem-anonimizacao'   
    END anonimizacao
from dm_empenho_resto dede
)a
WHERE a.anonimizacao <> 'sem-anonimizacao'
)a
ON dede.sqa_credor = a.sqa_credor
WHERE dede.{{particao.field}} = {{particao.value}}
