SELECT
	v.id_venda AS [ID — Cupom Fiscal],
	v.NSU_TEF AS [NSU],
	e.Modalidade AS [Modalidade],
	CONVERT(DECIMAL (10,2), v.Valor_Venda / 100.0) AS [Valor Venda],
	CONCAT(CASE
		WHEN e.Modalidade = 'Débito' THEN 1.20
		ELSE 2.20
	END, + '%') AS [Taxa Contratada],
	CONCAT(CONVERT(DECIMAL (10,2), e.Taxa_MDR_Aplicada_Pct / 10.0), '%') AS [Taxa Cobrada (%)],
	CONCAT(CONVERT(DECIMAL (10,2), (e.Taxa_MDR_Aplicada_Pct / 10.0) - CASE
		WHEN e.Modalidade = 'Débito' THEN 1.2
		ELSE 2.2
	END), '%') AS [Diferença Taxa],
	CONVERT(DECIMAL (10,2), (v.Valor_Venda / 100) * (e.Taxa_MDR_Aplicada_Pct / 10.0 - CASE
		WHEN e.Modalidade = 'Débito' THEN 1.2
		ELSE 2.2
	END) / 100) AS [Prejuízo Indevido (R$)]
FROM Vendas_Sistema_Posto v
INNER JOIN Extrato_Cartoes_Adquirente e
	ON v.NSU_TEF = e.NSU
WHERE
	((e.Taxa_MDR_Aplicada_Pct / 10.0) > 1.2 AND e.Modalidade = 'Débito')
	OR
	((e.Taxa_MDR_Aplicada_Pct / 10.0) > 2.2 AND e.Modalidade LIKE 'Crédito%');
