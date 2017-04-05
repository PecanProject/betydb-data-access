# Installing a local version of BETYdb

A standard ODB database connector can provide access to the back-end PostgreSQL database server. However, it is not possible to securely provide a public connection to one of the production BETYdb databases. If you would like to use PostgreSQL to access BETYdb, you can also install a version of BETYdb on your own comptuer

Many users of [PEcAn](https://www.pecanproject.org) install a local copy of BETYdb, and BETYdb can sync across different servers, sharing public data over the network. The [Distributed BETYdb](https://pecan.gitbooks.io/betydb-documentation/content/distributed_betydb.html) chapter of the BETYdb Technical Documentation describes the network of independently hosted instances of BETYdb, and how to keep them in sync.

Scripts used to keep these databases in sync are maintained in the [PEcAn Project repository](https://github.com/PecanProject/pecan) provides useful configuration files. Their use is described in the developer's guide to [installing PEcAn](https://pecanproject.github.io/pecan-documentation/installing-pecan.html). The [BETYdb installation](https://pecanproject.github.io/pecan-documentation/installing-pecan.html#installing-bety) chapter of the PEcAn Documentation explains how to import public data from one of the instances of BETYdb on the network. The key is the (load.bety.sh)[https://github.com/PecanProject/pecan/blob/master/scripts/load.bety.sh] script, but see documentation for details.


