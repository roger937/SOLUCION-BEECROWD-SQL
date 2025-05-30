WITH
func_venc_desc AS(
SELECT  emp_venc.matr AS matricula,SUM(vencimento.valor) AS valor FROM  emp_venc
INNER JOIN vencimento ON emp_venc.cod_venc = vencimento.cod_venc
GROUP BY emp_venc.matr 
UNION ALL
SELECT  emp_desc.matr AS matricula, -SUM(COALESCE(desconto.valor,0)) AS valor  FROM  emp_desc
INNER JOIN desconto ON desconto.cod_desc = emp_desc.cod_desc
GROUP BY emp_desc.matr),
salario_liquido AS ( SELECT  func_venc_desc.matricula as matr, 
					SUM(func_venc_desc.valor) AS sal_lqd 
					FROM func_venc_desc 
					GROUP BY func_venc_desc.matricula),
nome_func_divisao AS ( SELECT 	1 as empresa, 
					  			empregado.nome,
					  			empregado.lotacao_div,
					  			COALESCE(salario_liquido.sal_lqd,0) AS sal_liq
					  FROM empregado
					  LEFT JOIN salario_liquido
					  ON salario_liquido.matr = empregado.matr
					 	
),
media_salarial AS(
SELECT 	nome_func_divisao.empresa, AVG(nome_func_divisao.sal_liq)::numeric(10,2) AS media
		FROM nome_func_divisao 
	    GROUP BY nome_func_divisao.empresa
)
		
SELECT nome_func_divisao.nome, nome_func_divisao.sal_liq AS salario FROM nome_func_divisao
       WHERE nome_func_divisao.sal_liq > (SELECT media_salarial.media FROM media_salarial WHERE media_salarial.empresa=1 ) 
	   AND nome_func_divisao.sal_liq > 8000.00
	   ORDER BY nome_func_divisao.lotacao_div ASC
