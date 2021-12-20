select {{fields}}
from {{source}}
{{#particao}}
where {{field}} = {{value}}
{{/particao}}
{{#filtro}}
where id_empenho in (select id_empenho from {{filtro}})
{{/filtro}}
