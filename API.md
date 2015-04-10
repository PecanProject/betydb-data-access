# The BETYdb API

TODO: What is an API? Why is it useful?

The BETYdb Application Programming Interface (API) provides access to results in csv, json, and xml format from URL-based queries entered in a web browser or called from a scripting language such as R, Matlab, or Python (e.g. the rOpenSci traits package). All the tables in BETYdb are RESTful, which allows you to use GET, POST, PUT, or DELETE methods without interacting with the web-browser-based GUI interface. The primary advantage of this approach is the ability to submit more complex queries that access information and tables than are not available through the GUI interface. Another advantage is that text-based queries can be recorded with more precision than instructions for interacting with the GUI interface, and can be constructed automatically within a scripting language. In the future, this feature will be used to access BETYdb by the [`traits` package](https://github.com/ropensci/traits/issues/3) under development by rOpenSci. It would be straightforward to translate funcitons in the PEcAn.DB package to use the API. See the appendix for examples. Each registered user has an API key that allows access to restricted data and tables without requiring a login or password.
 

The API has two options: easy and hard. 

## Easy Way

[Note: In all the examples in this section, we have written the query URLs as though they are to be run in the browser after having logged in to the BETYdb web site.  To run these queries programmatically, the URLs used will have to be modified to include the API key.  See the section on API keys below.]

The easy way provides most useful information in a single table in a csv format that is easy to use in any spreadsheet software or scripting language. (Other possible formats are json and xml; see below). 


Data can be downloaded as a `.csv` file, and data from previously published syntheses can be downloaded without login. For example, to download all of the trait data for the switchgrass species Panicum virgatum, we must first look up the id number of the Panicum virgatum species.  We can do this by querying the species table:

    https://www.betydb.org/species.csv?scientificname=Panicum+virgatum
    
and examining the "id" column value of the one-row result.  Once we have the id, we can use it to query the traits table:

    https://www.betydb.org/traits.csv?specie_id=938

The reason we must use this two-stage process is that the traits table doesn't contain the species name information directly.  **_Note that there is no guarantee that these id numbers will not change!_**  Although it is rather unlikely that the id number for Panicum virgatum wil change between the time we query the species table to look it up and the time we use it to query the traits table, it entirely possible that if we run the query `https://www.betydb.org/traits.csv?specie_id=938` a year from now, the results will be for an entirely different species!  For this and other reasons, it is worthwhile learning how to do cross-table queries.

## Hard Way 

~~The "hard way" downloads individual tables from the database.~~ This appraoch allows more complex queries and faster programatic access. In the future, this feature will be used to access BETYdb by the [`rotraits` package](https://github.com/ropensci/rotraits/issues/3) under development by rOpenSci. It would be straightforward to translate funcitons in the PEcAn.DB package to use the API. Currently, PEcAn accesses the PostgreSQL database directly, via ssh tunnel. 

    
~~However, most of the useful information, for example about sites and treatments, is provided on other tables. Thus, useful queries will should  trouble is that this file will need to~~ REWRITE! 

### Cross-table queries using CSV, JSON and XML APIs

BETYdb has the ability to return any object in these three formats. All the tables in BETYdb are RESTful, which allows you to GET, POST, PUT, or DELETE them without interacting with the web interface. Here are some examples. In all of these examples, you can use exchange `.json` with `.xml` or `.csv` depending on the format that you want.

### Examples

Here are some examples to define the  format of valid requests:
 
1. Return all trait data for "Panicum virgatum" without having to know its species id number:

   https://www.betydb.org/traits.csv?include[]=specie&species.scientificname=Panicum+virgatum

This will produce exactly the same result file as the "easy" query above that used the specie_id number.  (Note, however, that the XML and JSON formats of the same query give more information than the corresponding "easy" query.  Since XML and JSON are more highly-structured that CSV, it is easy to include full species information with each yield item returned, and queries using these formats do so.)

A few pointers about the syntax of this query.

a. We could have used the URL `https://www.betydb.org/traits.csv` to download the entire traits table (or rather, that portion of the table which the user is permitted to access).  To restrict the results, we use a _query string_, which is the portion of the URL after the question mark.  The query string consists of one or more clauses of the form `key=value` separated by `&` characters.

b. In order to use columns from an associated table in our query (in this case, the species table), we have to have an "include[]=" clause in our query string.  The value to use after the equals sign is the singular form of the name of the associated table.  (That we use "specie" here instead of the true singular form of "species" which is also "species" is an artifact of the Rails programming.)  _Note you must include the square brackets after "include"!_

c. When restricting the query by the value of a column in an associated table, you have to qualitify the name of the column with the name of the table: tablename.columname=...  Thus, here we write "species.scientificname=Panicum+virgatum" instead of "scientficname=Panicum+virgatum".

d. URLs can not contain spaces.  If the value you are querying against contains a space, substitute `+` or `%20` in the URL.

2. Return all citations in json format (replace json with xml or csv for those formats):

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

Find species associated with the `salix` pft:


    https://www.betydb.org/pfts.xml?pfts.name=salix&include[]=specie

**[You can also do the query like so:]**  

    https://www.betydb.org/species.xml?pfts.name=salix&include[]=pfts


 Return all citations with their associated sites: 

    https://www.betydb.org/citations.json?include[]=sites
    
(**Note**: When using `include[]=`, you use the singular version of the associated table's name when the relationship is many to one, and the plural—here `sites`—when it is many to many. **Hint**: if the main table has a foreign key that references the table you are attempting to include—that is, something like `relatedtable_id`—then you need to use the singular version.) 

Return all citations with their associated sites and yields (working on ability to nest this deeper):  

    https://www.betydb.org/citations.json?include[]=sites&include[]=yields
    
**(Note that this will take considerable time since the information for all yields rows will be displayed.)**

Return all citations with the field journal equal to ‘Agronomy Journal’ and author equal to ‘Adler’ with their associated sites and yields.  **use `+` to represent the space character.** 

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

Using an API key allows access to data without having to enter a login. To use an API key, simply append `?key=<your key>` to the end of the URL. Each user must obtain a unique API key.

### For admins

Users who signed up on previous releases may not have an API key in the database. To create an API key for every existing user, run the command below

    rake bety:make_keys

This command will only be needed once.


