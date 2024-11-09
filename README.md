以下是一个简单的`README.md`模板，适用于你的R包`causalReg`：

```markdown
# causalReg

`causalReg` is an R package designed to perform regression analysis using the Oster method. It provides tools for calculating `betaf` and `zeroeff` for causal inference based on Oster Method.

## Installation

To install the package from GitHub, ensure you have Rtools installed, then use the following commands:

```r
# Install devtools if you haven't already
install.packages("devtools")
# Install causalReg from GitHub
devtools::install_github("chen-junluo/causalReg")
```

## Dependencies

- `lfe`: Used for performing fixed effects linear models.

## Usage

Here's a basic example of how to use the `osterReg` function:

```r
library(causalReg)

# Example data
data <- data.frame(
  y = rnorm(100),
  x = rnorm(100),
  z = rnorm(100),
  cluster = rep(1:10, each = 10)
)

# Run Oster regression
result <- osterReg(
  reg_type = "felm",
  depvar = "y",
  indepvar = "x",
  controls = c("z"),
  fixed_effects = c("cluster"),
  cluster_var = "cluster",
  data = data
)

print(result)
```

## Functionality

### `osterReg`

- **Description**: Performs regression analysis using the Oster method.
- **Parameters**:
  - `reg_type`: Type of regression (currently supports "felm").
  - `depvar`: Dependent variable name.
  - `indepvar`: Independent variable name.
  - `controls`: Control variables.
  - `fixed_effects`: Fixed effects.
  - `cluster_var`: Clustering variable for standard errors.
  - `data`: Data frame for the regression.
  - `r_type`: R-squared type ('r2_a' or 'r2_within').

## Author

- Dylan Junluo CHEN

## License

This project is licensed under the MIT License - see the LICENSE file for details.