with id_favorecido_premios_lotericos as (
        select id_favorecido
        from (select * from ft_despesa_2002 
              union all 
              select * from ft_despesa_2003
              union all 
              select * from ft_despesa_2004
              union all 
              select * from ft_despesa_2005
              union all 
              select * from ft_despesa_2006
              union all 
              select * from ft_despesa_2007
              union all 
              select * from ft_despesa_2008
              union all 
              select * from ft_despesa_2009
              union all 
              select * from ft_despesa_2010
              union all 
              select * from ft_despesa_2011
              union all 
              select * from ft_despesa_2012
              union all 
              select * from ft_despesa_2013
              union all 
              select * from ft_despesa_2014
              union all 
              select * from ft_despesa_2015
              union all 
              select * from ft_despesa_2016
              union all 
              select * from ft_despesa_2017
              union all 
              select * from ft_despesa_2018
              union all 
              select * from ft_despesa_2019
              union all 
              select * from ft_despesa_2020
              union all 
              select * from ft_despesa_2021)
        join dm_unidade_orc using (id_unidade_orc)
        join dm_elemento_desp using (id_elemento)
        join dm_item_desp using (id_item)
        where cd_unidade_orc = 2041 and 
              cd_elemento = 31 and 
              cd_item = 2 
        ),
     id_favorecido_hanseniase as (
        select id_favorecido
        from (select * from ft_despesa_2002 
              union all 
              select * from ft_despesa_2003
              union all 
              select * from ft_despesa_2004
              union all 
              select * from ft_despesa_2005
              union all 
              select * from ft_despesa_2006
              union all 
              select * from ft_despesa_2007
              union all 
              select * from ft_despesa_2008
              union all 
              select * from ft_despesa_2009
              union all 
              select * from ft_despesa_2010
              union all 
              select * from ft_despesa_2011
              union all 
              select * from ft_despesa_2012
              union all 
              select * from ft_despesa_2013
              union all 
              select * from ft_despesa_2014
              union all 
              select * from ft_despesa_2015
              union all 
              select * from ft_despesa_2016
              union all 
              select * from ft_despesa_2017
              union all 
              select * from ft_despesa_2018
              union all 
              select * from ft_despesa_2019
              union all 
              select * from ft_despesa_2020
              union all 
              select * from ft_despesa_2021)
        join dm_unidade_orc using (id_unidade_orc)
        join dm_empenho_desp using (id_empenho)
        where ano_particao >= 2021 and
              cd_unidade_orc = 4291 and
              unidade_executora like '1320007%' and
              nr_empenho in (6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 41, 42, 43, 44, 45, 46, 47, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83)
     )

select id_favorecido, tp_documento,
       case 
            when id_favorecido in (select * from id_favorecido_premios_lotericos) and tp_documento = 1 then '0'
            when id_favorecido in (select * from id_favorecido_hanseniase) and tp_documento = 1 then '0'
            when tp_documento = 1 then '***.' ||
                                       substr(lpad(to_char(nr_documento), 11, '0'), 4, 3) || 
                                       '.' ||
                                       substr(lpad(to_char(nr_documento), 11, '0'), 7, 3) || 
                                       '-**'
            else to_char(nr_documento)
       end as nr_documento,
       case 
            when id_favorecido in (select id_favorecido from id_favorecido_premios_lotericos) and tp_documento = 1 then 'INFORMACAO COM RESTRICAO DE ACESSO'
            when id_favorecido in (select id_favorecido from id_favorecido_hanseniase) and tp_documento = 1 then 'INFORMACAO COM RESTRICAO DE ACESSO'
            else nome
       end as nome
from dm_favorecido
