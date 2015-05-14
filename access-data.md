
# Guide to accessing data from BETYdb \label{sec:overview}

Data is made available for analysis after it is submitted and reviewed by a database administrator. These data are suitable for basic scientific research and modeling. All reviewed data are made publicly available after publication to users of BETY-db who are conducting primary research. Access to these raw data is provided to users based on affiliation and contribution of data.

All public data in BETYdb is made available under the [Open Data Commons Attribution License (ODC-By) v1.0](http://opendatacommons.org/licenses/by/1-0/). You are free to share, create, and adapt its contents. Data with an access_level field and value <= 2 is is not covered by this license, but may be available for use with consent.

Please cite the source of data as:

> LeBauer, David; Dietze, Michael; Kooper, Rob; Long, Steven; Mulrooney, Patrick; Rohde, Gareth Scott; Wang, Dan; (2010): Biofuel Ecophysiological Traits and Yields Database (BETYdb); Energy Biosciences Institute, University of Illinois at Urbana-Champaign. http://dx.doi.org/10.13012/J8H41PB9



## Search Box \label{sec:searchbox}

On the welcome page of BETYdb there is a search option for trait and yield data (Figure \ref{fig:textsearch}). This tool allows users to search the entire collection of trait and yield data for specific sites, citations, species, and traits.

The results page provides a map interface (Figure \ref{fig:mapsearch}) and the option to download a file containing search results.

The downloaded file is in CSV format. This file provides meta-data and provenance information, including: the SQL query used to extract the date, the date and time the query was made, and the citation source of each result row, as well as a citation for BETYdb itself (_to be updated on publication_) (Figure \ref{fig:excelresults}).


_Instructions:_ Using the search box to search trait and yield data is very simple: Type the site (city or site name), species (scientific or common name), citation (author and/or year), or trait (variable name or description) into the search box and the results will show contents of BETYdb that match the search. The number of records per page can be changed to viewer preference and the search results can be downloaded in the Excel-compatible CSV format. 

(Figure \ref{fig:textsearch})


The search map may be used in conjunction with search terms to restrict search results to a particular geographical area or even a specific site by clicking on a map.  Clicking on a particular site will restrict results to that site.  Clicking in the vicinity of a group of sites but not on a particular site will restrict the search to the region around the point clicked. Alternatively, if a search using search terms is done without clicking on the map, all sites associated with the returned results are highlighted on the map. Sites, species and traits can be searched further by clicking on or near highlighted locations on the map (Figure \ref{fig:accessmaps}). The color of each site indicates which sites match the search terms. Results can be downloaded by clicking the "Download Results" button on the upper right hand corner of the page. 

(Figure \ref{fig:mapsearch})

## Details\label{sec:searchdetails}

### Basic search: Searching from the Home Page\label{sec:basicsearch}

1.	Go to the home page [betydb.org](https://www.betydb.org). 
2.	Enter one or more terms in the search box.  The search will succeed if (and only if) each term in the search box matches one of the following columns of the `traits_and_yields_view`: `sitename`, `city`, `scientificname`, `commonname`, `author`, `trait`, `trait_description`, or `citation_year`.  Thus, the more terms entered, the more restrictive the search. Note that a search term _matches_ a column value if it occurs anywhere within the text of that column value, and that matches are case-insensitive.  Thus, the term "grass" would match a row with commonname column value "switchgrass" or "tussock cottongrass", a row with site name "Grassland Soil & Water Research Laboratory", or a row with trait description "for grasses, stem internode length".  There is no way to restrict which of the eight match columns a given term is matched against.
3.	Click the search icon next to the search box (or press the ENTER key).  This will take one to the search results/advanced search page and show the result of the search.

### Advanced search: Searching from the Advanced Search page\label{sec:advancedsearch}

1.	From the home page, you can get to the advanced search page simply by typing search terms into the search box and clicking on the search icon.  (Or just click the search icon without entering any terms.  Or enter the URL for the advanced search page directly: www.betydb.org/search)
2.	The search will return results for both traits and yields.
3.	Enter one or more terms in the main search box.  As with basic searches, each term must match one of the eight searched columns.
4.	Search results are updated as you type, but you may press the `Enter` key to do a formal search form submission; this will reload the page and update the URL in the browser address box to include all of the parameters of your search.



### Example\label{sec:searchexample}

1. Go to [betydb.org](https://www.betydb.org)
2. Simple search: for sugarcane yields -- Enter the search string "sugarcane Ayield" in the search box.

3. You will see a new page with a table of results show data about sugarcane yields.
6. Advanced search task 2: Limit results to a specific site -- We just want to see the results for the 'Zentsuji' site.  Add a space and the word 'Zentsuji' to the search box.
7. You will see only the search results for the 'Zentsuji' site.
8. Advanced search task 3: Limit results to a specific trait -- We only want to see the results concerning stem\_biomass.  Replace the word 'Ayield' with the word 'stem\_biomass' to the search box.
9. The resulting table rows all concern stem biomass data for sugarcane at the Zentsuji site.

