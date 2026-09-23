output "budget_name" {
  description = "Name of the monthly cost guardrail budget"
  value       = aws_budgets_budget.monthly_guardrail.name
}
