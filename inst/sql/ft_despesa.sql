select * from ft_despesa_2002 
{{#ft_despesa}}
union all 
select * from {{.}}
{{/ft_despesa}}


