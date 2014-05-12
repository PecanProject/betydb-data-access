## Data access

Data is made available for analysis after it is submitted and reviewed by a database administrator. These data are suitable for basic scientific research and modeling. All reviewed data are made publicly available after publication to users of BETY-db who are conducting primary research. Access to these raw data is provided to users based on affiliation and contribution of data.

### Search Box

On the welcome page of BETYdb there is a search option for trait and yield data. This tool allows users to search the entire database for specific sites, species, and traits.

![alt text](figures/searchbox.png)

### Advanced Search

Advanced search can be used by using text or seaching using map. 


##### Text Based Search
The advance search can be used by searching for trait and yield data through text. Doing so is very simple, type in the site (city), species or trait into the search bar and the results will show what is the the BetYdb database. The number of records per page can be changed to viewer preference and the search results can be downloaded in an excel sheet format. 


![alt text](figures/textsearch.png)


##### Maps Based Search
Advance search using maps is used by seraching for a specific site(city), species and trait. The results of the search are then shown in Google Maps. Sites, species and traits can be searched further by clicking on the geographical location on the map. Additionally, there is a legand that shows selected sites that  match serach, don't match search, and sites that fall outside search area. All of these results can be downloaded by clicking the "download results" button on the upper right hand corner. 

![alt text](figures/accessmaps.png)


### CSV Downloads

Data can be downloaded as a .csv= file, and data from previously published syntheses can be downloaded without login. For example, to download all of the Switchgrass (Panicum virgatum L.) yield data,

Open the BETY homepage www.betydb.org
Select Species under BETYdb
Select Yields under BETYdb
To download all records as a comma-delimited (.csv) file, scroll down and select the link http://ebi-forecast.igb.uiuc.edu/bety/maps/yields?format=csv&species=938 *(In CSV Format)

### JSON, CVS, and XML API

The format of your request will need to be:

BetyDB has the ability to return any object in these three formats. All the tables in BetyDB are RESTful, which allows you to GET, POST, PUT, or DELETE them without interacting with the web interface. Here are some examples. In all of these examples, you can use exchange `.json` and `.xml` depending on the format you want.

Return all citations in json format (replace json with xml or csv for those formats)

    https://www.betydb.org/citations.json

Return all yield data for the genus ‘Miscanthus’  
  
    https://www.betydb.org/yields.json?genus=Miscanthus
    https://www.betydb.org/yields.json?genus=Miscanthus&species=giganteus 

Return all yield data from the with author = Heaton and year = 2004 (can also be queried by title)

    https://www.betydb.org/citations.xml?include[]=yields&author=Heaton&year=2004

Find species associated with the `biocro.salix` pft 

    https://www.betydb.org/species.xml?include[]=pfts_species&include[]=pfts&name=biocro.salix

 Return all citations with their associated sites (you use the singular version of the associated tables name - site - when the relationship is many to one, and the plural when many to many; hint: if the id of the table you are attempting to include is in the record - relatedtable_id - then it is the singular version.   

    https://www.betydb.org/citations.json?include[]=sites 

Return all citations with their associated sites and yields (working on ability to nest this deeper)    

    https://www.betydb.org/citations.json?include[]=sites&include[]=yields 

Return all citations with the field journal equal to ‘Agronomy Journal’ and author equal to ‘Adler’ with their associated sites and yields.  

    https://www.betydb.org/citations.json?journal=Agronomy%20Journal&author=Adler&include[]=sites&include[]=yields 

Return citation 1 in json format, can also be achieved by adding ’?id=1’ to line 1  

    https://www.betydb.org/citations/1.json 

Return citation 1 in json format with it’s associated sites  

    https://www.betydb.org/citations/1.json?include[]=sites 

Return citation 1 in json format with it’s associated sites and yields 

    https://www.betydb.org/citations/1.json?include[]=sites&include[]=yields 

### API keys

Using an API key allows access to data without having to enter a login. To use an API key, simply append @?key=@ to the end of the URL. Each user must obtain a unique API key.

### Installing BETY (the complete database)

There are two flavors of BETY: PHP and RUBY. The PHP version allows for minimal interaction with the database while the RUBY version allows for full interaction with the database. Both, however, require the database to be created and installed.
