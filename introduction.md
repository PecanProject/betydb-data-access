
# Guide to accessing data from BETYdb 

## What is covered here:

There are many ways to access data in BETYdb. This document is written for people who want to get data from BETYdb through either 1) the web interface search box or 2) the more powerful url-based methods of submitting queries. This url-based query is the basis of the rOpensci 'traits' package that allows users to retrieve data in R.

## What is not covered:

While these methods allow users to access these data, some users may wish to use BETYdb actively in their research. If you want to contribute to BETYdb, see the [Data Entry](https://www.authorea.com/users/5574/articles/6800/_show_article) documentation. That document teaches users how they can curate their own data using BETYdb—either betydb.org or as a distributed node on the BETYdb network that enables data sharing.

Many people who contribute data—and others who want to submit more complex queries—can benefit from accessing a PostgreSQL server. Users who want to install a a BETYdb PostgreSQL database (just ask!) are able to enter, use, and share data within and across a network of synced instances of BETYdb (see wiki ["Distributed BETYdb"](https://github.com/PecanProject/bety/wiki/Distributed-BETYdb)). This network shares data that has not necessarily been independently reviewed beyond the correction of extreme outliers. In practice, data sets in active use by researchers have been evaluated for meaning by researchers. Expert knowledge encoded in the 'priors' table, in the PEcAn meta-analysis models and the Ecosystem models parameterized by the meta-analysis results.  
Users with access to a BETYdb PostgreSQL database can access data through R packages, in particular `PEcAn.DB` which is designed for use in PEcAn or 2) any programming language a scientist is likely to use. 
When not using PEcAn, I recommend the R package `dplyr` unless you prefer joins in SQL. 

## Data Sharing

Data is made available for analysis after it is submitted and reviewed by a database administrator. These data are suitable for basic scientific research and modeling. All reviewed data are made publicly available after publication to users of BETYdb who are conducting primary research. 

If you want data that has not been reviewed, please request access. There are many records that are not publicly available through the web API, but that can be installed as a PostgreSQL database.

## Access Restrictions 

All public data in BETYdb is made available under the [Open Data Commons Attribution License (ODC-By) v1.0](http://opendatacommons.org/licenses/by/1-0/). You are free to share, create, and adapt its contents. Data with an `access_level` field and value <= 2 is is not covered by this license, but may be available for use with consent. 

## Quality Flags

The `checked` value indicates if data has been checked (1) is unchecked (0) or identified as incorrect (-1). Checked data has been independently reviewed. By default, only checked data is provided through the web interface and API; as of [BETYdb 4.4 (Oct 14 2015)](https://github.com/PecanProject/bety/releases/tag/betydb_4.4) users can opt-in to download unchecked data from the web search interface and API. Unchecked data (0) is also available as a PostgreSQL database (as easy as [`./load.bety.sh`](https://raw.githubusercontent.com/PecanProject/pecan/master/scripts/load.bety.sh)). 

## Citation

Please cite the source of data as:

> LeBauer, David; Dietze, Michael; Kooper, Rob; Long, Steven; Mulrooney, Patrick; Rohde, Gareth Scott; Wang, Dan; (2010): Biofuel Ecophysiological Traits and Yields Database (BETYdb); Energy Biosciences Institute, University of Illinois at Urbana-Champaign. http://dx.doi.org/10.13012/J8H41PB9

When publishing, also include a copy of the data that you used as well as information about the original publication. 
This is provided as citation author, year, title, and date in database queries.

It is important to archive the data used in a particular analysis so that someone can reproduce your results and check your assumptions.
As we are continually collecting new data and checking existing data, BETYdb is not a static source of data.

## Key Topics

**Data access**

Data is made available for analysis after it is submitted and reviewed by a database administrator. These data are suitable for basic scientific research and modeling. All reviewed data are made publicly available after publication to users of BETY-db who are conducting primary research. Access to these raw data is provided to users based on affiliation and contribution of data.

**Search Box**

On the welcome page of BETYdb there is a search option for trait and yield data. This tool allows users to search the entire database for specific sites, species, and traits.

**Advanced Search**

On the welcome page of BETYdb there is a search option for trait and yield data. This tool allows users to search the entire database for specific sites, species, and traits.

**Text Based Search**

On the welcome page of BETYdb there is a search option for trait and yield data. This tool allows users to search the entire database for specific sites, species, and traits

**Maps Based Search**

Advance search using maps is used by seraching for a specific site(city), species and trait. The results of the search are then shown in Google Maps. Sites, species and traits can be searched further by clicking on the geographical location on the map. Additionally, there is a legand that shows selected sites that match serach, don't match search, and sites that fall outside search area. All of these results can be downloaded by clicking the “download results” button on the upper right hand corner.


**CSV Downloads**

Data can be downloaded as a .csv= file, and data from previously published syntheses can be downloaded without login. For example, to download all of the Switchgrass (Panicum virgatum L.) yield data,

Open the BETY homepage www.betydb.org Select Species under BETYdb Select Yields under BETYdb To download all records as a comma-delimited (.csv) file, scroll down and select the [link](http://ebi-forecast.igb.uiuc.edu/bety/maps/yields?format=csv&species=938 ) *(In CSV Format)

**API keys**

Using an API key allows access to data without having to enter a login. To use an API key, simply append @?key=@ to the end of the URL. Each user must obtain a unique API key.

**Installing BETY (the complete database)**

There are two flavors of BETY: PHP and RUBY. The PHP version allows for minimal interaction with the database while the RUBY version allows for full interaction with the database. Both, however, require the database to be created and installed.

**Database Creation**

The following creates the user, database and populates the database with the latest version from Illinois. 