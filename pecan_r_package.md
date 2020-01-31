# PEcAn R package


## PEcAn.DB functions

Like the [R dplyr package], the [PEcAn.DB](https://github.com/PecanProject/pecan/tree/develop/base/db) package requires the user to have read access to a PostgreSQL server running BETYdb.
Unlike the dplyr package, the PEcAn.DB package is less secure, more difficult to install.
The primary reason to use this package is if you are using the [PEcAn ecosystem modeling framework](https://pecanproject.github.io).
The easiest way to install the BETYdb server and run these queries is to use the PEcAn virtual machine.
This can be done on your computer or through Amazon Web Services.

Here is some of the basic functionality:

```r
settings <- read.settings("pecan.xml")

# For database queries, this is equivalent to:
# settings <- list(database = list(bety = list(driver = "PostgreSQL", user = "bety", dbname = "bety", password = "bety")))

library(PEcAn.DB)
require(RPostgreSQL)
dbcon <- db.open(settings$database$bety)

miscanthus <- db.query("select lat, lon, date, trait, units, mean from traits_and_yields_view where genus = 'Miscanthus';", con = dbcon)

salix_spp <- query.pft_species(pft = "salix", modeltype = "BIOCRO", con = dbcon)

salix_vcmax <- query.trait.data(trait = "Vcmax", spstr = vecpaste(salix_spp$id), con = dbcon)
```

## Installing a PEcAn Virtual Machine (BETYdb sandbox)

If you want

* full access to the public content of BETYdb
* the easiest way to get started using PEcAn tools to access BETYdb
* to develop BETYdb 
* have full access to the server and database

You may want to install a PEcAn Virtual Machine

These are the steps 

1. Setting up the virtual machine:
   1. Download PEcAn virtual machine (.ova file) from [here](https://opensource.ncsa.illinois.edu/projects/artifacts.php?key=PECAN){target="_blank"}.
   1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads){target="_blank"}.
   1. Open VirtualBox. If you want, go to the preferences and change your default machine folder. This will be about 14–15 GB, so make sure you select a drive with plenty of space.
   1. go to File > Import Appliance, and select the .ova file you downloaded. Continue.
   1. Check "Reinitialize the MAC address of all network cards" and press Import.
1. Using the virtual machine:
   1. In the VirtualBox Manager window, select the PEcAn VM and press Start.
   1. A new window will pop up and boot Linux, eventually prompting you for a username. Enter "carya" (no quotes) and then "illinois" (again no quotes) for the password. You're now at the Linux command line.
   1. Open up Safari and go to localhost:6480/rstudio. Log in with the same username and password as above.
   1. You're in RStudio! Now you can start accessing BETYdb from here, for example by using [dplyr][R dplyr package].
   
See also tutorials on pecanproject.org 

Note:

* Any changes or additions to the database not be synced back to other BETYdb databases
   * please report errors and updates to github.com/pecanproject/bety/issues/new
* If you want to run a production instance of BETYdb and / or add sync your database with others, see the [BETYdb documentation section on distributed databases](https://pecanproject.github.io/bety-documentation/technical/distributed-instances-of-betydb.html){target="_blank"}. (This will not be covered here.)
