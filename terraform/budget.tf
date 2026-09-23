# GRID-001: $25/month guardrail so a runaway resource can't burn cash unnoticed.
# Two notifications: one on actual spend (something is already happening),
# one on forecasted spend (something is about to happen, based on trend).
resource "aws_budgets_budget" "monthly_guardrail" {
  name         = "gridiron-monthly-guardrail"
  budget_type  = "COST"
  limit_amount = var.budget_limit_usd
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.budget_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.budget_email]
  }

  tags = {
    Project     = var.project
    Environment = var.environment
    Owner       = var.owner
  }
}
