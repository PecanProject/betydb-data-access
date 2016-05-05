# PEcAn R package


### PEcAn.DB functions

```r
settings <-list(database = list(bety = list(driver = "PostgreSQL", user = "bety", dbname = "bety", password = "bety")))

# equivalent to standard method to load PEcAn settings:
# settings <- read.settings("pecan.xml")

library(PEcAn.DB)
require(RPostgreSQL)
dbcon <- db.open(settings$database$bety)

miscanthus <- db.query("select lat, lon, date, trait, units, mean from traits_and_yields_view where genus = 'Miscanthus';", con = dbcon)

salix_spp <- query.pft_species(pft = "salix", modeltype = "BIOCRO", con = dbcon)

salix_vcmax <- query.trait.data(trait = "Vcmax", spstr = vecpaste(salix_spp$id), con = dbcon)
```