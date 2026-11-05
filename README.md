# STAT 107 Half-Way Project — Analysis Files 

**Question:** Do infrastructure construction and the number of jobs predict poverty rates in the United States?

**Scope:** United States annual observations, 2002–2024, using highway/street construction spending as a *partial proxy* for infrastructure construction. The regressions are preliminary and do not prove causation or forecasting accuracy.

## Files

| File or folder | Purpose |
|---|---|
| `00_requirements.R` | Installs and loads R packages |
| `02_Functions.R` | Documented functions for loading/validating FRED CSV data and annual aggregation |
| `11_DataCleaning_Processing.Rmd` | Reads raw CSVs, cleans, aggregates, merges and saves data |
| `31_DataVisualization.Rmd` | Generates charts, tables, correlations and preliminary regression |
| `data/raw/` | Place the four **original downloaded CSVs** here; commit these files |
| `data/processed/` | Created annual CSV, RData and cleaning checks |
| `figures/` | Saved charts |
| `results/` | Summary statistics, correlations and regression output |
| `31_DataVisualization.pdf` | PDF with charts and statistical analysis |
| `11_DataCleaning_Processing.html` | HTML with data cleaning and processing results |
## Download raw CSV files manually (one time)

Click each link, save the CSV with the **exact filename** shown, and place it in `data/raw/`. Do not edit the original files. If a browser shows the CSV instead of downloading it, use Save As.

| Filename | Download link | Variable |
|---|---|---|
| `TLHWYCON.csv` | https://fred.stlouisfed.org/graph/fredgraph.csv?id=TLHWYCON | Monthly U.S. highway/street construction expenditure, nominal millions USD (not seasonally adjusted) |
| `PAYEMS.csv` | https://fred.stlouisfed.org/graph/fredgraph.csv?id=PAYEMS | Monthly total nonfarm payroll employment, thousands of jobs (seasonally adjusted) |
| `PPAAUS00000A156NCEN.csv` | https://fred.stlouisfed.org/graph/fredgraph.csv?id=PPAAUS00000A156NCEN | Annual U.S. SAIPE poverty rate, percent of people (all ages) |
| `CPIAUCSL.csv` | https://fred.stlouisfed.org/graph/fredgraph.csv?id=CPIAUCSL | Monthly CPI-U index (seasonally adjusted) |

These series are accessed via FRED (Federal Reserve Bank of St. Louis); underlying statistics originate from the U.S. Census Bureau and Bureau of Labor Statistics. Sources: https://fred.stlouisfed.org/series/TLHWYCON , https://fred.stlouisfed.org/series/PAYEMS , https://fred.stlouisfed.org/series/PPAAUS00000A156NCEN , and https://fred.stlouisfed.org/series/CPIAUCSL .

## Reproduce in RStudio

1. Open RStudio and use **Session > Set Working Directory > Choose Directory** to select the `STAT107_Halfway_Project` folder (not the `data` subfolder). Confirm `getwd()` points to the project root.
2. Copy all four CSVs into `data/raw/` using the filenames above.
3. Run `source("00_requirements.R")` in the Console. An internet connection may be required to install R packages the first time.
4. Open **`11_DataCleaning_Processing.Rmd`** and click **Knit**. This saves `data/processed/us_annual_2002_2024.csv`, cleaning diagnostics and `data/processed/22_ProcessedData.RData`.
5. Open **`31_DataVisualization.Rmd`** and click **Knit**. This saves PNG files to `figures/` and numeric/statistical results to `results/`.
6. Confirm the number of matched observations and inspect charts. Commit the raw CSVs, analysis code, generated outputs and this README to GitHub. Test knitting both files in the order above from a fresh R session.

### Annual data preparation

- Construction: sum 12 monthly unadjusted spending observations to get annual nominal spending (millions USD).
- Jobs: average 12 monthly payroll employment observations (thousands); convert to millions.
- CPI: annual mean of the 12 monthly CPI values; convert construction spending to constant 2024 USD.
- Poverty: use annual percentage values as reported.
- Match on year, retain 2002–2024, and require valid, complete data.

### Final dataset variables

`year`, `construction_nominal_musd`, `jobs_thousands`, `cpi_index`, `poverty_pct`, `construction_real_2024_musd`, `jobs_millions`.

**Interpretation notes:** Total jobs is a count of payroll positions, not a count of unique employed people or an employment rate. Highway and street construction is one category of infrastructure. The national annual sample is small; association and in-sample regression are not evidence of causal effects or validated prediction.
