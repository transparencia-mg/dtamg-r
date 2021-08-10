select {{fields}}
from {{source}}
{{#particao}}
where {{field}} = {{value}}
{{/particao}}
