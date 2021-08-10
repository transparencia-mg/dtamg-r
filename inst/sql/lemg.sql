select *
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
where cd_unidade_orc = 2041 and cd_elemento = 31 and cd_item = 2 
