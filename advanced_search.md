---
SearchBox: /assets/textsearch.png
BETYdb_URL: "https://www.betydb.org"
---

# The Advanced Search Box

Most tables in BETYdb have search boxes; for example,
{{page.BETYdb_URL}}/citations and {{page.BETYdb_URL}}/sites. We describe below how
to query these tables and download the results as CSV, JSON, or XML. The Advanced Search box is the easiest way to download summary datasets designed to have
enough information (location, time, species, citations) to be useful for a wide
range of use cases.

### Using the Search Box

On the Welcome page of BETYdb there is a search option for trait and yield data
(Figure 1). This tool allows users to search the entire collection of trait and
yield data for specific sites, citations, species, and traits.

![Figure 1: BETYdb Advanced Search Box](/assets/textsearch.png)

The results page provides a map interface (Figure \ref{fig:mapsearch}) and the option to download a file containing search results.

The downloaded file is in CSV format. This file provides meta-data and provenance information, including: the SQL query used to extract the data, the date and time the query was made, the citation source of each result row, and a citation for BETYdb itself (_to be updated on publication_) (Figure \ref{fig:excelresults}).

_Instructions:_ Using the search box to search trait and yield data is very simple: Type the site (city or site name), species (scientific or common name), citation (author and/or year), or trait (variable name or description) into the search box and the results will show contents of BETYdb that match the search. The number of records per page can be changed to viewer preference and the search results can be downloaded in the Excel-compatible CSV format.

(Figure \ref{fig:textsearch})

The search map may be used in conjunction with search terms to restrict search results to a particular geographical area or even a specific site by clicking on a map.  Clicking on a particular site will restrict results to that site.  Clicking in the vicinity of a group of sites but not on a particular site will restrict the search to the region around the point clicked. Alternatively, if a search using search terms is done without clicking on the map, all sites associated with the returned results are highlighted on the map. Sites, species and traits can be searched further by clicking on or near highlighted locations on the map (Figure \ref{fig:accessmaps}). The color of each site indicates which sites match the search terms. Results can be downloaded by clicking the "Download Results" button on the upper right hand corner of the page.

(Figure \ref{fig:mapsearch})

## Details

### Basic search: Searching from the Home Page

1. Go to the home page [betydb.org](https://www.betydb.org). 
2. Enter one or more terms in the search box.  The search will succeed if (and only if) each term in the search box matches one of the following columns of the `traits_and_yields_view`: `sitename`, `city`, `scientificname`, `commonname`, `author`, `trait`, `trait_description`, or `citation_year`.  Thus, the more terms entered, the more restrictive the search. Note that a search term _matches_ a column value if it occurs anywhere within the text of that column value and that matches are case-insensitive.  Thus, the term "grass" would match a row with commonname column value "switchgrass" or "tussock cottongrass", a row with site name "Grassland Soil & Water Research Laboratory", or a row with trait description "for grasses, stem internode length".  There is no way to restrict which of the eight match columns a given term is matched against except perhaps by makeing the term itself more specific; in the example just given, typing "cottongrass" rather than just "grass" would make in more likely that only the match against the `commonname` column would succeed.
3. Click the search icon next to the search box (or press the ENTER key).  This will take one to the search results/advanced search page and show the result of the search.

### Advanced search: Searching from the Advanced Search page

1. From the home page, you can get to the advanced search page simply by typing search terms into the search box and clicking on the search icon.  (Or just click the search icon without entering any terms.  Or enter the URL for the advanced search page directly: www.betydb.org/search)
2. The search will return results for both traits and yields.
3. Enter one or more terms in the main search box.  As with basic searches, each term must match one of the eight searched columns.
4. Search results are updated as you type, but you may press the `Enter` key to do a formal search form submission; this will reload the page and update the URL in the browser address box to include all of the parameters of your search.

### Example

1. Go to [betydb.org](https://www.betydb.org)
2. Task 1 (simple search): Search for sugarcane yields — Enter the search string "sugarcane Ayield" in the search box.
3. You will see a new page with a table of results showing data about sugarcane yields.
4. Task 2 (advanced search): Limit results to a specific site — We just want to see the results for the 'Zentsuji' site.  Add a space and the word 'Zentsuji' to the search box.
5. You will see only the sugarcane yields for the 'Zentsuji' site.
6. Task 3 (advanced search): Limit results to a specific trait — We only want to see the results concerning stem\_biomass instead of annual yield.  Replace the word 'Ayield' with the word 'stem\_biomass' in the search box.
7. The resulting table rows all concern stem biomass data for sugarcane at the Zentsuji site.

