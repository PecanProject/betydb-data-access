
# Guide to accessing data from BETYdb

## What is covered here:

There are many ways to access data in BETYdb. This document is written for
people who want to get data from BETYdb through either 1) the web browser
interface search box or 2) the more powerful URL-based methods of submitting
queries programmatically. These URL-based queries are the basis of the rOpensci
'traits' package that allows users to retrieve data in R.

## What is not covered:

While these methods allow users to access these data, some users may wish to use
BETYdb actively in their research. If you want to contribute to BETYdb, see the
[Data Entry](https://pecan.gitbooks.io/betydbdoc-dataentry/content/)
documentation. That document teaches users how they can curate their own data
using BETYdb—either via the primary instance hosted at https://www.betydb.org or
as a distributed node on the BETYdb network that enables data sharing.

Many people who contribute data—and others who want to submit more complex
queries—can benefit from accessing a PostgreSQL server. Users who want to
install a BETYdb PostgreSQL database (just ask!) are able to enter, use, and
share data within and across a network of synced instances of BETYdb (see the
BETYdb Technical Documentation topic ["Distributed
BETYdb"](https://pecan.gitbooks.io/betydb-documentation/content/distributed_betydb.html)). This
network shares data that has not necessarily been independently reviewed beyond
the correction of extreme outliers. In practice, data sets in active use by
researchers have been evaluated for meaning by researchers. Expert knowledge is
encoded in the `priors` table, in the PEcAn meta-analysis models, and in the
Ecosystem models parameterized by the meta-analysis results.  Users with access
to a BETYdb PostgreSQL database can access data through R packages—in particular
`PEcAn.DB`, which is designed for use in PEcAn—or through any programming
language a scientist is likely to use.  When not using PEcAn, I recommend the R
package `dplyr` unless you prefer constructing joins directly in SQL.

## Data sharing

Data is made available for analysis after it is submitted and reviewed by a
database administrator. These data are suitable for basic scientific research
and modeling. All reviewed data are made publicly available after publication to
users of BETYdb who are conducting primary research.

If you want data that has not been reviewed, please request access. There are
many records that are not publicly available through the web API, but that can
be accessed by installing a copy of the BETYdb PostgreSQL database.

## Access restrictions 

All public data in BETYdb is made available under the [Open Data Commons
Attribution License (ODC-By)
v1.0](http://opendatacommons.org/licenses/by/1-0/). You are free to share,
create, and adapt its contents.  For tables having an `access_level` column,
data in rows where the column value is 1 or 2 is not covered by this license,
but may be available for use with consent.

## Quality flags

In tables and views containing trait and yield data, the `checked` column value
indicates if data has been checked (1), has _not_ been checked (0), or has been
identified as incorrect (-1). Checked data has been independently reviewed. By
default, only _checked_ data is provided through the web browser interface and
API.  As of [BETYdb 4.4 (Oct 14
2015)](https://github.com/PecanProject/bety/releases/tag/betydb_4.4), users can
opt-in to viewing and downloading unchecked data either by way of a web browser
or via the API.  Unchecked data may also be loaded into a local PostgreSQL
database simply by running the script
[`./load.bety.sh`](https://raw.githubusercontent.com/PecanProject/pecan/master/scripts/load.bety.sh).

## Citation

Please cite the source of data as:

> LeBauer, David; Dietze, Michael; Kooper, Rob; Long, Steven; Mulrooney,
  Patrick; Rohde, Gareth Scott; Wang, Dan; (2010): Biofuel Ecophysiological
  Traits and Yields Database (BETYdb); Energy Biosciences Institute, University
  of Illinois at Urbana-Champaign. http://dx.doi.org/10.13012/J8H41PB9

In publications, please also include a copy of the data that you used and
information about the original publication.  The _original publication_ data
corresponds to the citation author, year, and title in database queries.

It is important to archive the data used in a particular analysis so that
someone can reproduce your results and check your assumptions.  Keep in mind,
though, that we are continually collecting new data and checking existing data:
BETYdb is not a static source of data.

## A brief overview of some key topics

**Data access**

Data is made available for analysis after it is submitted and reviewed by a
database administrator. These data are suitable for basic scientific research
and modeling. All reviewed data are made publicly available after publication to
users of BETYdb who are conducting primary research. Access to these raw data
is provided to users based on affiliation and contribution of data.

**Search box**

On the Welcome page of BETYdb there is a search option for trait and yield
data. This tool allows users to search the entire database for specific sites,
species, and traits.

**Enhanced search capabilities: the Advanded Search page**

The result of a search using the Welcome page search box is displayed on its own
page, called the Advanced Search page.  This page has additional search
features, including map-based searching.

Following a search using the search box, one may click the "Search Using Map"
button. The results of the search are then shown in Google Maps, that is, each
site represented in the search result will be highlighted on the map.  Moreover,
a search can be further refined by site location by clicking locations of
interest on the map.

Another feature of the Advanced Search page is the "Download Results" button;
clicking it will send a CSV file of the most recent search result to your
computer.

**General CSV downloads**

Data from any database table can be downloaded as a CSV file.

For example[^alt-example], to download all of the Switchgrass (Panicum virgatum) yield data,
open the BETYdb Welcome page at https://www.betydb.org, select Species under
Data menu.  Type "Panicum virgatum" in the search box and click on the "Show"
icon in the Actions column of the row for Panicum virgatum.  You should see the
URL `https://www.betydb.org/species/938` in the address box after the View
Species page is displayed.  The trailing number in the URL—938—is the id number
of the species Panicum virgatum.  You can now use this number to search for
yields for this species.

To do so, enter the URL for the species listing page,
https://www.betydb.org/yields, into the browser address box, append ".csv" to
indicate that you want results in CSV format, and append the query string
"?specie_id=938" to indicate that you want only the results for Panicum
virgatum.  Your browser should then download a CSV file containing all yield
records (subject to your user permissions) for Panicum virgatum.

This is just one of a number of ways of downloading data from BETYdb.  See the
[API for URL-based Queries](API.md) for additional information.

**API keys**

Using an API key allows access to data without having to enter a login.  For
example, assuming "Kq2xEWiRCyj90Sq7EFVn2A0LxJb58UTbscJl4fJP" is a valid API key[^API-key],
you could visit the URL
https://www.betydb.org/yields.csv?specie_id=938&key=Kq2xEWiRCyj90Sq7EFVn2A0LxJb58UTbscJl4fJP"
directly (that is, without first logging in) to download a CSV file of Panicum
virgatum yield data.

**Installing BETYdb (the complete database)**

See [Installing your own version of BETYdb](Local-install.md).



---

[^alt-example]: This example is revisited in the section [Original API](original_api.md#a-simple-example), where the same information is retrieved in XML format by issuing GET requests to URLs.

[^API-key]: This is the guest user's API key at the time of writing.
