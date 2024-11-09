#' Oster Regression Analysis
#'
#' This function performs a regression analysis using the Oster method and calculates betaf and zeroeff.
#'
#' The function supports regression analysis with the `felm` package and allows for the selection of adjusted or within R-squared values.
#'
#' @param reg_type A string specifying the type of regression to perform. Currently, only "felm" is supported.
#' @param depvar A string specifying the name of the dependent variable.
#' @param indepvar A string specifying the name of the independent variable.
#' @param controls A vector of strings specifying the control variables.
#' @param fixed_effects A vector of strings specifying the fixed effects.
#' @param cluster_var A string specifying the clustering variable for standard errors.
#' @param data A data frame containing the data for the regression.
#' @param r_type A string specifying the type of R-squared to use: 'r2_a' for adjusted R-squared or 'r2_within' for within R-squared. Default is 'r2_within'.
#' @return A named vector containing the dependent variable, beta_tilde, betaf, and zeroeff.
#' @importFrom lfe felm
#' @export
#' @examples
#' \dontrun{
#' data <- data.frame(y = rnorm(100), x = rnorm(100), z = rnorm(100), cluster = rep(1:10, each = 10))
#' osterReg("felm", "y", "x", c("z"), c("dayofweek"), "cluster", data)
#' }
osterReg <- function(reg_type, depvar, indepvar, controls, fixed_effects, cluster_var, data, r_type = 'r2_within') {
  # Construct regression formulas
  control_formula <- paste(controls, collapse = " + ")
  fixed_effects_formula <- paste(fixed_effects, collapse = " + ")

  # Full and reduced regression formulas
  formula_full <- as.formula(paste(depvar, "~", indepvar, "+", control_formula, "|", fixed_effects_formula, "| 0 |", cluster_var))
  formula_reduced <- as.formula(paste(depvar, "~", indepvar, "|", fixed_effects_formula, "| 0 |", cluster_var))

  # Run regression analysis
  if (reg_type == "felm") {
    model_full <- felm(formula_full, data = data)
    model_reduced <- felm(formula_reduced, data = data)
  } else {
    stop("Unsupported regression type")
  }

  # Extract R-squared values
  if (r_type == 'r2_a') {
    R_tilde <- summary(model_full)$r2adj
    R_c <- summary(model_reduced)$r2adj
  } else if (r_type == 'r2_within') {
    R_tilde <- summary(model_full)$P.r.squared
    R_c <- summary(model_reduced)$P.r.squared
  } else {
    stop("Unsupported R type. Please choose 'r2_a' for adjusted R-squared or 'r2_within' for within R-squared.")
  }

  # Extract coefficients
  beta_tilde <- coef(model_full)[indepvar]
  beta_c <- coef(model_reduced)[indepvar]

  # Calculate betaf and zeroeff
  betaf <- beta_tilde - (beta_c - beta_tilde) * ((1.3 * R_tilde - R_tilde) / (R_tilde - R_c))
  zeroeff <- ((beta_tilde + 0) * (R_tilde - R_c)) / ((beta_c - beta_tilde) * (1.3 * R_tilde - R_tilde))

  # Return results
  return(c(depvar = depvar, beta_tilde = beta_tilde, betaf = betaf, zeroeff = zeroeff))
}
