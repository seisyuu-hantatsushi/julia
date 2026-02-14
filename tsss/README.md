# Rによる 時系列モデリング入門
[Rによる 時系列モデリング入門(北川 源四郎 著)](https://www.iwanami.co.jp/book/b548849.html)のプログラム例のjulia版
## TSSS Data
https://jasp.ism.ac.jp/ism/TSSS/
## .rdaをcsvにするRのスクリプト
`R_scripts/rda_to_csv.R`
```sh
$ Rscript rda_to_csv.R ~/work/TSSSData/TSSS/data/HAKUSAN.rda ./csv_out
Loaded objects:
[1] "HAKUSAN"
WROTE: HAKUSAN -> ./csv_out/HAKUSAN.csv (nrow=1000, ncol=4)

Done. written=1 skipped=0
```
