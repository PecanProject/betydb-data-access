# Installing a local version of BETYdb

A standard ODB database provides access to the back-end database server (PostgreSQL by default, optionally MySQL) that is hosted on a production server or locally. PEcAn accesses the PostgreSQL database directly, using an Open Database Connectivity (ODBC) API, although this requires access to a BETYdb database server.

The following scripts make it easy to install the latest version of BETYdb locally (on Linux or OSX), populated with all public data. This is the recommended way to use with [PEcAn](https://www.pecanproject.org); in fact, these scripts are part of the [PEcAn repository](https://github.com/PecanProject/pecan) and their use is described in the developer's guide to [installing PEcAn](https://github.com/PecanProject/pecan/wiki/Installing-PEcAn). Users interested in this option, but unfamiliar with Linux should either a) start with the PEcAn Virtual Machine or b) find someone who is familiar with Linux.

* MySQL: https://github.com/PecanProject/pecan/blob/master/scripts/update.mysql.sh
* PostgreSQL: https://github.com/PecanProject/pecan/blob/master/scripts/update.psql.sh