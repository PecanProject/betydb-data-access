# The BETYdb API

TODO: What is an API? Why is it useful?

The BETYdb Application Programming Interface (API) provides access to results in csv, json, and xml format from url-based queries written in a web browser or scripting language such as R, Matlab, or Python (e.g. the rOpenSci traits package). All the tables in BETYdb are RESTful, which allows you to use GET, POST, PUT, or DELETE methods without interacting with the web interface. The primary advantage of this approach is the ability to submit more complex queries that access information and tables than are not available through the web-interface. Another advantage is that text-based queries can be recorded with more precision than instructions for interacting with the web-interface, and can be constructed automatically within a scripting language. In the future, this feature will be used to access BETYdb by the [`traits` package](https://github.com/ropensci/traits/issues/3) under development by rOpenSci. It would be straightforward to translate funcitons in the PEcAn.DB package to use the API. See appendix for examples. Each registered user has an API key that allows access to restricted data and tables without requiring a login or password.
 

The API has two options: easy and hard. 

## Easy Way

The easy way provides most useful information in a single table in a csv format that is easy to use - in any spreadsheet software or scripting language (or json or xml, see below). 


Data can be downloaded as a `.csv` file, and data from previously published syntheses can be downloaded without login. For example, to download all of the Switchgrass (Panicum virgatum L.) yield data,

    https://www.betydb.org/traits.csv?genus=Switchgrass

## Hard Way 

The "hard way" downloads individual tables from the database. This appraoch allows more complex queries and faster programatic access. In the future, this feature will be used to access BETYdb by the [`rotraits` package](https://github.com/ropensci/rotraits/issues/3) under development by rOpenSci. It would be straightforward to translate funcitons in the PEcAn.DB package to use the API. Currently, PEcAn accesses the PostgreSQL database directly, via ssh tunnel. 

    
Howver, most of the useful information, for example about sites and treatments, is provided on other tables. Thus, useful queries will should  trouble is that this file will need to 

### Cross-table queries using CSV, JSON and XML APIs

BETYdb has the ability to return any object in these three formats. All the tables in BETYdb are RESTful, which allows you to GET, POST, PUT, or DELETE them without interacting with the web interface. Here are some examples. In all of these examples, you can use exchange `.json` with `.xml` or `.csv` depending on the format that you want.

### Examples

Here are some examples to define the  format of valid requests:

Return all citations in json format (replace json with xml or csv for those formats):

    https://www.betydb.org/citations.json

Return all yield data for the genus ‘Miscanthus’:
  
    https://www.betydb.org/yields.json?genus=Miscanthus
    https://www.betydb.org/yields.json?genus=Miscanthus&species=giganteus
    
**[The following is the correct syntax. You must `include` each associated table that you want to use in your query, and you must qualify columns from joined tables with their table name.]**

    https://www.betydb.org/yields.json?include[]=specie&species.genus=Miscanthus    
    https://www.betydb.org/yields.json?include[]=specie&species.genus=Miscanthus&species.species=sinensis
    
**These each return a list of yields together with information from the associated tables--including the species table--for each yield. Thus, this query will show the same species information multiple times--once for each yield.**

**An alternative way of extracting the same information in a different format is:**

    https://www.betydb.org/species.json?genus=Miscanthus&include[]=yields       
    https://www.betydb.org/species.json?genus=Miscanthus&species=sinensis&include[]=yields
    
**These each return a list of Miscanthus species (a list of length one in the second case) where each list item itself contains a list of yields for the species of the item. Since species and yields are in a one-to-many relationship, each species is only listed once.**

Return all yield data from the with author = Heaton and year = 2008 (can also be queried by title):

    https://www.betydb.org/citations.xml?include[]=yields&author=Heaton&year=2008

Find species associated with the ~~`biocro.salix`~~ `salix` pft:

~~https://www.betydb.org/species.xml?include[]=pfts_species&include[]=pfts&name=biocro.salix~~

    https://www.betydb.org/pfts.xml?pfts.name=salix&include[]=specie

**[There are some irregularities about when you need to use include[]=. You _always_ have to use it to query on an associated table. You sometimes need it to see the associated table's information. But sometimes you don't.]**

**[You _should_ also be able to do the query like so:]**  

    https://www.betydb.org/species.xml?pfts.name=salix&include[]=pfts
    
**[This works, but you get pfts elements that contain no information inside each species element.]**  


 Return all citations with their associated sites.  (You use the singular version of the associated tables name—`site` in this case—when the relationship is many to one, and the plural when many to many. **Hint**: if the main table has a foreign key that references the table you are attempting to include—that is, something like `relatedtable_id`—then you need to use the singular version.)  

    https://www.betydb.org/citations.json?include[]=sites 

Return all citations with their associated sites and yields (working on ability to nest this deeper):  

    https://www.betydb.org/citations.json?include[]=sites&include[]=yields
    
**(Note that this will take considerable time since the information for all yields rows will be displayed.)**

Return all citations with the field journal equal to ‘Agronomy Journal’ and author equal to ‘Adler’ with their associated sites and yields.  **Note that you need to use `%20` or simple `+` to represent the space character in a URL.** 

    https://www.betydb.org/citations.json?journal=Agronomy%20Journal&author=Adler&include[]=sites&include[]=yields
    
**[On pecandev, you can try this query instead since the former doesn't return any yields there:]**

    http://pecandev.igb.illinois.edu/citations.json?journal=Biomass+and+Bioenergy&author=Fang&include[]=sites&include[]=yields

Return citation 1 in json format, can also be achieved by adding ’?id=1’ to line 1  

    https://www.betydb.org/citations/1.json 

Return citation 1 in json format with it’s associated sites  

    https://www.betydb.org/citations/1.json?include[]=sites 

Return citation 1 in json format with it’s associated sites and yields 

    https://www.betydb.org/citations/1.json?include[]=sites&include[]=yields 

## API keys

Using an API key allows access to data without having to enter a login. To use an API key, simply append @?key=@ to the end of the URL. Each user must obtain a unique API key.

### For admins

Users who signed up on previous releases may not have an API key in the database. To create an API key for every existing user, run the command below

    rake bety:make_keys

This command will only be needed once.


