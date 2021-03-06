SELECT
dede.*,
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
END razao_social_credor_anonimizado
FROM dm_empenho_resto dede
LEFT JOIN
(
SELECT DISTINCT a.sqa_credor FROM (
SELECT
sqa_credor,
CASE
    WHEN dede.ano_exercicio > 2021 AND
         dede.unidade_orcamentaria LIKE '4291%' AND -- 4291 - FUNDO ESTADUAL DE SAUDE
         dede.upg LIKE '761%' AND
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
