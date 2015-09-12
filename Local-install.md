# Installing a local version of BETYdb

A standard ODB database provides access to the back-end PostgreSQL database server. This is hosted on a production server or locally. 

The following scripts make it easy to install the latest version of BETYdb locally (on Linux or OSX), populated with all public data. 
Many users of [PEcAn](https://www.pecanproject.org) install a local copy of BETYdb, and BETYdb can sync across different servers. 
The [PEcAn repository](https://github.com/PecanProject/pecan) provides useful configuration files. 
Their use is described in the developer's guide to [installing PEcAn](https://github.com/PecanProject/pecan/wiki/Installing-PEcAn). 
You can also run BETYdb on pre-configured PEcAn Virtual Machines using a VirtualBox or similar  software, and can be run on a laptop, desktop, server, or cloud services such as Amazon cloud or NCSA OpenStack.

* PostgreSQL: https://github.com/PecanProject/pecan/blob/master/scripts/load.bety.sh
* BETYdb documentation for `update.bety.sh`: https://github.com/PecanProject/bety/wiki/Updating-BETY
* PEcAn Documentation for BETYdb installation https://github.com/PecanProject/pecan/wiki/Installing-PEcAn#installing-bety
* The Federated network of independently hosted instances of BETYdb https://github.com/PecanProject/bety/wiki/Distributed-BETYdb