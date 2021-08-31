with id_favorecido_premios_lotericos as (
        select distinct id_favorecido
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
        join dm_unidade_orc uo using (id_unidade_orc)
        join dm_elemento_desp ed using (id_elemento)
        join dm_item_desp id using (id_item)
        where uo.cd_unidade_orc = 2041 
        and ed.cd_elemento = 31 
        and id.cd_item = 2 
        ),
     id_favorecido_hanseniase as (
        select distinct id_favorecido
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
        where ano_particao > 2021 and
              cd_unidade_orc = 4291 and
              upg = 761
     )

select id_favorecido, 
       case 
            when id_favorecido in (select * from id_favorecido_premios_lotericos) then '0'
            when id_favorecido in (select * from id_favorecido_hanseniase) then '0'
            else '***.' ||
              substr(lpad(to_char(nr_cpf), 11, '0'), 4, 3) || 
              '.' ||
              substr(lpad(to_char(nr_cpf), 11, '0'), 7, 3) || 
              '-**'
       end as nr_cpf,
masp,
       case 
            when id_favorecido in (select id_favorecido from id_favorecido_premios_lotericos) /* and tp_documento = 1  */ then 'INFORMACAO COM RESTRICAO DE ACESSO'
            when id_favorecido in (select id_favorecido from id_favorecido_hanseniase) /* and tp_documento = 1 */ then 'INFORMACAO COM RESTRICAO DE ACESSO'
            else nome
       end as nome
from dm_favorecido_scdp
