# Utility functions used by processing scripts.
# Inputs: FRED raw CSV or year/value table. Outputs: validated tables and summaries.

read_fred <- function(series_id) {
  file <- file.path("data", "raw", paste0(series_id, ".csv"))
  if (!file.exists(file)) stop("Missing: ", file, ". Copy the corresponding CSV from FRED into data/raw/ first.")
  d <- read.csv(file, stringsAsFactors = FALSE, na.strings = c(".", "", "NA"))
  date_column <- intersect(c("observation_date", "DATE"), names(d))
  if (!length(date_column) || !series_id %in% names(d)) stop("Bad FRED columns: ", file)
  out <- data.frame(date = as.Date(d[[date_column[1]]]), value = as.numeric(d[[series_id]]))
  if (anyNA(out$date) || anyDuplicated(out$date)) stop("Date error in ", series_id)
  out
}

# Summarize monthly series. Requires all 12 months; incomplete years are excluded.
# monthly_fun: sum for unadjusted monthly spending; mean for monthly average employment/CPI.
annualize_monthly <- function(d, monthly_fun = c("mean", "sum")) {
  monthly_fun <- match.arg(monthly_fun)
  d$year <- as.integer(format(d$date, "%Y"))
  by_year <- split(d, d$year)
  rows <- lapply(by_year, function(g) {
    g <- g[!is.na(g$value), ]
    # Require Jan-Dec with exactly one observation per month.
    mo <- as.integer(format(g$date, "%m"))
    if (length(mo) != 12L || !setequal(mo, 1:12)) return(NULL)
    f <- if (monthly_fun == "sum") sum else mean
    data.frame(year = unique(g$year), value = f(g$value))
  })
  rows <- Filter(Negate(is.null), rows)
  if (!length(rows)) stop("No complete years in monthly series")
  out <- do.call(rbind, rows)
  rownames(out) <- NULL
  out[order(out$year), ]
}

# Assert one observation per year and no invalid values.
validate_annual <- function(d, column) {
  if (anyDuplicated(d$year)) stop("Duplicate years in ", column)
  if (anyNA(d[[column]]) || any(!is.finite(d[[column]]))) stop("Missing/invalid ", column)
  if (any(d[[column]] < 0)) stop("Negative ", column)
  invisible(d)
}
