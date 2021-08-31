SELECT dc.id_contratado,
dc.tp_documento,
dc.nr_documento,
CASE WHEN REGEXP_LIKE(dc.nome, '[0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}') THEN -- CASO CÉLULA CONTENHA CPF
    SUBSTR(dc.nome, 1, REGEXP_INSTR(dc.nome, '[0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}', 1, 1) -2) || -- PRIMEIRA PARTE DA CÉLULA OU PARTE SEM O CPF
    ' ***' || SUBSTR(REGEXP_SUBSTR(dc.nome, '[0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}'), 1, LENGTH(REGEXP_SUBSTR(dc.nome, '[0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}')) -2) || '**' || -- TRANSFORMA O CPF, TROCANDO INÍCIO E FIM POR *
    SUBSTR(dc.nome, REGEXP_INSTR(dc.nome, '[0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}', 1, 1) + length(REGEXP_SUBSTR(dc.nome, '[0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}', 1, 1))) -- SEGUNDA PARTE
    ELSE dc.nome END nome
FROM dm_contratado dc
