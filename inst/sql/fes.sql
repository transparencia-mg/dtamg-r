select distinct unidade_executora, item_desp
from ft_despesa_2021
join dm_unidade_orc using (id_unidade_orc)
join dm_empenho_desp using (id_empenho)
where ano_particao >= 2021 and
      cd_unidade_orc = 4291 and
      unidade_executora like '1320007%' and
      nr_empenho in (6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 41, 42, 43, 44, 45, 46, 47, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83)