# PEcAn R package


## PEcAn.DB functions

Like [using the R dplyr package](r_dplyr_package.md), the [PEcAn.DB](https://github.com/PecanProject/pecan/tree/master/db) package requires the user to have read access to a PostgreSQL server running BETYdb. 
Unlike the dplyr package, the PEcAn.DB package is less secure, more difficult to install.
The primary reason to use this package is if you are using the [PEcAn ecosystem modeling framework](https://pecanproject.org).
The easiest way to install the BETYdb server and run these queries is to use the PEcAn virtual machine. 
This can be done on your computer or through Amazon Web Services.

Here is some of the basic functionality:

```r
settings <- list(database = list(bety = list(driver = "PostgreSQL", user = "bety", dbname = "bety", password = "bety")))

# equivalent to standard method to load PEcAn settings:
# settings <- read.settings("pecan.xml")

library(PEcAn.DB)
require(RPostgreSQL)
dbcon <- db.open(settings$database$bety)

miscanthus <- db.query("select lat, lon, date, trait, units, mean from traits_and_yields_view where genus = 'Miscanthus';", con = dbcon)

salix_spp <- query.pft_species(pft = "salix", modeltype = "BIOCRO", con = dbcon)

salix_vcmax <- query.trait.data(trait = "Vcmax", spstr = vecpaste(salix_spp$id), con = dbcon)
```