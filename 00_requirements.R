# Project dependencies. Run from the repository root.
# Installs missing libraries only, then loads them.
packages <- c("ggplot2", "knitr", "rmarkdown")
missing <- setdiff(packages, rownames(installed.packages()))
if (length(missing) > 0) install.packages(missing, repos = "https://cloud.r-project.org")
invisible(lapply(packages, library, character.only = TRUE))
