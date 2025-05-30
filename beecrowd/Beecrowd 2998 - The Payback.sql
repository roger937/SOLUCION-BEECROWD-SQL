WITH running_operations_returns AS (
		SELECT 
		clients.id,
		clients.name,
		clients.investment,
		operations.month,
		SUM(profit) OVER (PARTITION BY client_id ORDER BY operations.id) AS running_sum_of_profit,
		SUM(profit) OVER (PARTITION BY client_id ORDER BY operations.id) - clients.investment AS return
	FROM operations
	INNER JOIN clients
		ON operations.client_id = clients.id
	ORDER BY operations.client_id, operations.month
	
)

SELECT 
	payback_month_return.name,
	running_operations_returns.investment,
	running_operations_returns.month AS month_of_payback,
	payback_month_return.return
FROM (
	
	SELECT DISTINCT ON (id)
		name,
		investment,
		return
	FROM running_operations_returns
	WHERE return >= 0
	
) AS payback_month_return
INNER JOIN running_operations_returns
	USING (return )
ORDER BY return DESC
;
