# Guide to accessing data from BETYdb

Data is made available for analysis after it is submitted and reviewed by a database administrator. These data are suitable for basic scientific research and modeling. All reviewed data are made publicly available after publication to users of BETY-db who are conducting primary research. Access to these raw data is provided to users based on affiliation and contribution of data.

## Search Box

On the welcome page of BETYdb there is a search option for trait and yield data (Figure \ref{fig:textsearch}). This tool allows users to search the entire database for specific sites, species, and traits.

The results page provides a map interface (Figure \ref{fig:mapsearch}) and the option to download the file in the upper right of the page.

The downloaded file is in csv format. This file provides meta-data and provenance information, including: the date and the SQL query used to access, as well as a citation for BETYdb itself (_to be updated on publication_) and the source of each record (Figure \ref{fig:excelresults}).


_Instructions:_ The advanced search can be used by searching for trait and yield data through text. Doing so is very simple, type in the site (city), species or trait into the search bar and the results will show what is the the BetYdb database. The number of records per page can be changed to viewer preference and the search results can be downloaded in an excel sheet format. 

(Figure \ref{fig:textsearch})


Advanced search using maps is used by seraching for a specific site(city), species and trait. The results of the search are then shown in Google Maps. Sites, species and traits can be searched further by clicking on the geographical location on the map. Additionally, there is a legand that shows selected sites that  match serach, don't match search, and sites that fall outside search area. All of these results can be downloaded by clicking the "download results" button on the upper right hand corner. 

(Figure \ref{fig:mapsearch})

## Details

### Basic search:

1.	Got to the home page. (This will be either: http://pecandev.igb.illinois.edu/bety, https://ebi-forecast.igb.illinois.edu/beta, or https://www.betydb.org.)
2.	Enter one or more terms in the search box.  Each term must match one of (1) the scientific name of a species; (2) the common name of a species; (3) the name of a treatment.  Thus, the more terms entered, the more restrictive the search.  In addition to normal search terms, the keywords “trait” or “yield” may be entered to restrict the type of data returned.
3.	Click the search icon next to the search box (or press the ENTER key).  This will take one to the search results/advanced search page and show the result of the search.

### Advanced search:

1.	From the home page, you can get to the advanced search page simply by doing a basic search.  (Or just click the search icon without entering any terms.  Or enter the URL for the advanced search page directly by appending “/searches” to the URL given in step one of the Basic search instructions.)
2.	By default, the search will return results for both traits and yields.  Use the radio buttons to restrict results to one or the other.
3.	Enter one or more terms in the main search box.  As with basic searches, each term must match one of (1) the scientific name of a species; (2) the common name of a species; (3) the name of a treatment.  (Unlike basic searches, the “trait” and “yield” keywords are not recognized.  Using them here will most likely eliminate all search results since they don’t match the name of a species or treatment.  Use the radio buttons instead in order to restrict the search type.)
4.	Press the Submit button to obtain search results.
5.	Narrowing Search Results: Once you have obtained a search result, you may refine the result by applying further restrictions using the “Narrow your search” panel on the right side of the page.  Enter terms in one or more of the three search boxes there to limit results by Site, by Species, or by Trait.  Then either click one of the “Apply Limit” links or click the Submit button again.

Notes:

1.	Search terms or case-insensitive and a search term will match a species name, treatment name, site name or trait name if it matches any part of the name.  Thus, simply typing “misc” will match against “Miscanthus”, “Miscanthus sacchariflorus”, “Miscanthus sinensis”, or “Miscanthus X giganteus”.
2.	The “species” search box in the “Narrow your search” panel only matches against scientific names.  To match against common names, put the term in the main search box.
3.	For sites having no formal site name, the city name is shown instead.  Note however that when narrowing your search by site, the term entered will only be matched against site names.
4.	The layout of the advanced search page looks best when your browser window is as wide as possible.


### Example

1. Go to http://pecandev.igb.illinois.edu
2. Simple search: sugarcane yields -- Enter the search term "sugarcane" followed by the keyword "yields" in the "SEARCH FOR TRAITS AND YIELDS" box; then click the search icon.
3. You will see a new page with a table of results show data about sugarcane yields.
4. Advanced search task 1: Switch to showing trait data -- Click the radio button next to the word "traits"; then click the Submit button.
5. Now you will see search results related to sugarcane trait data.
6. Advanced search task 2: Limit results to a specific site -- We just want to see the results for the 'Mackay' site.  In the 'Narrow Your Search ...' area on the right side of the page, enter the word 'Mackay' into the 'By Site' box; then click the 'Apply Limit' link.
7. You will see only the search results for the 'Mackay' site.
8. Advanced search task 3: Limit results to a specific trait -- We only want to see the results concerning shoot density.  In the 'Narrow Your Search ...' area on the right side of the page, enter the word 'density' into the 'By Trait' box; then click the 'Apply Limit' link.
9. The resulting table rows all concern total shoot density data for sugarcane at the Mackay site.

