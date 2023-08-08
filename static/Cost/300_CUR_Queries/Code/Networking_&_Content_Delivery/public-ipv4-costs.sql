SELECT 
	date_trunc('day',"line_item_usage_start_date") "day", 
	"bill_payer_account_id", 
	"line_item_usage_account_id", 
	"line_item_usage_type" ,
	"product_region", 
	--"line_item_resource_id",
	sum("line_item_usage_amount") usage_hours, 
	sum("line_item_unblended_cost") actual_cost_usd,
	sum("line_item_usage_amount")*0.005 projected_cost_usd
FROM ${table_name}
WHERE 
	year = cast(year(date_trunc('month', current_date) - interval '1' month) as varchar) 
	and month in (date_format(date_trunc('month', current_date) - interval '1' month,'%m'),date_format(date_trunc('month', current_date) - interval '1' month,'%c'))
	and "line_item_usage_type" like '%PublicIPv4%'
	and "line_item_line_item_type" = 'Usage'
GROUP BY
	date_trunc('day',"line_item_usage_start_date"), 
	"bill_payer_account_id", 
	"line_item_usage_account_id", 
	"line_item_usage_type" ,
	"product_region"
	--,"line_item_resource_id"
ORDER BY sum("line_item_usage_amount") desc
