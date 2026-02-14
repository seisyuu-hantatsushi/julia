#!/usr/bin/env Rscript
# rda_to_csv.R
# Usage:
#   Rscript rda_to_csv.R input.rda out_dir
#
# out_dir に <object_name>.csv を出力します。
# data.frame / matrix はそのままCSVへ、vector は1列CSVへ、list は「行数が揃う data.frame 化できるものだけ」出力。

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) {
  stop("Usage: Rscript rda_to_csv.R input.rda out_dir")
}
infile <- args[1]
outdir <- args[2]

dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

# 余計なものを汚さないように環境を分ける
e <- new.env(parent = emptyenv())
load(infile, envir = e)

obj_names <- ls(e)
cat("Loaded objects:\n")
print(obj_names)

to_df <- function(x) {
  # data.frame / tibble
  if (is.data.frame(x)) return(x)

  # matrix -> data.frame
  if (is.matrix(x)) return(as.data.frame(x))

  # vector (atomic) -> 1列 data.frame
  if (is.atomic(x) && is.vector(x) && length(dim(x)) == 0) {
    return(data.frame(value = x))
  }

  # list -> 可能なら data.frame 化
  if (is.list(x)) {
    # listの各要素が同じ長さの atomic/vector なら data.frame にできることがある
    ok <- TRUE
    lens <- sapply(x, function(v) if (is.null(v)) NA_integer_ else length(v))
    # NA が混ざる/長さが揃わない/複雑型は落とす
    if (any(is.na(lens))) ok <- FALSE
    if (ok && length(unique(lens)) != 1) ok <- FALSE
    if (ok && any(!sapply(x, function(v) is.atomic(v) && is.vector(v) && length(dim(v)) == 0))) ok <- FALSE

    if (ok) return(as.data.frame(x, stringsAsFactors = FALSE))
  }

  return(NULL) # 変換できない
}

sanitize <- function(name) {
  # ファイル名に使いにくい文字を置換
  gsub("[^A-Za-z0-9._-]+", "_", name)
}

written <- 0
skipped <- 0

for (nm in obj_names) {
  x <- get(nm, envir = e)
  df <- to_df(x)

  if (is.null(df)) {
    cat(sprintf("SKIP: %s (class=%s)\n", nm, paste(class(x), collapse = ",")))
    skipped <- skipped + 1
    next
  }

  outpath <- file.path(outdir, paste0(sanitize(nm), ".csv"))
  # row.names=FALSE が基本。行名に意味がある場合は TRUE にする。
  write.csv(df, outpath, row.names = FALSE)
  cat(sprintf("WROTE: %s -> %s (nrow=%d, ncol=%d)\n", nm, outpath, nrow(df), ncol(df)))
  written <- written + 1
}

cat(sprintf("\nDone. written=%d skipped=%d\n", written, skipped))
