# The BETYdb Web API \label{sec:betyapi}

TODO: What is an API? Why is it useful?

The BETYdb Application Programming Interface (API) is a means of obtaining search or query results in CSV, JSON, or XML format from URL-based queries entered into a Web browser or called from a scripting language such as R, Matlab, or Python (e.g. the rOpenSci traits package). All the tables in BETYdb are RESTful, which allows you to use GET, POST, PUT, or DELETE methods without interacting with the web-browser-based GUI interface. The primary advantage of this approach is the ability to submit complex queries that access information and tables without having to do so through the GUI interface: text-based queries can be recorded with more precision than instructions for interacting with the GUI interface, and can be constructed automatically within a scripting language. In the future, this feature will be used to access BETYdb by the [`traits` package](https://github.com/ropensci/traits/issues/3) under development by rOpenSci. It would be straightforward to translate functions in the PEcAn.DB package to use the API. See the appendix for examples. Each registered user has an API key that allows access to restricted data without requiring a login or password.
 

The Web API for querying BETYdb supports both simple single-table queries and complex queries involving two or more tables. 

## Simple API Queries

[Note: In all the examples in this section, we have written the query URLs as though they are to be run in the browser after having logged in to the BETYdb web site.  To run these queries programmatically, the URLs used will have to be modified to include the API key.  See the section on API keys below.]

The simpler URL-based queries provide a way to extract useful information from a single database table in CSV (comma-separated values) format, which is easy to use in any spreadsheet software or scripting language.  (Other possible formats are JSON and XML; see below).


Data can be downloaded as a `.csv` file, and data from previously published syntheses can be downloaded without login.  In the simplest case, we can use a single key-value pair to filter the table, restricting the result to the set of rows having a given value in a given column.  For example, to download all of the trait data for the switchgrass species Panicum virgatum, we must first look up the id number of the Panicum virgatum species.  We can do this by querying the species table:

    https://www.betydb.org/species.csv?scientificname=Panicum+virgatum
    
and examining the "id" column value of the one-row result.  Once we have the id, we can use it to query the traits table:

    https://www.betydb.org/traits.csv?specie_id=938

The reason we must use this two-stage process is that the traits table doesn't contain the species name information directly.  **_Note that there is no guarantee that these id numbers will not change!_**  Although it is rather unlikely that the id number for Panicum virgatum wil change between the time we query the species table to look it up and the time we use it to query the traits table, it entirely possible that if we run the query `https://www.betydb.org/traits.csv?specie_id=938` a year from now, the results will be for an entirely different species!  For this and other reasons, it is worthwhile learning how to do cross-table queries.

## Complex API Queries

The API allows more complex queries and faster programmatic access by including multiple search terms to the query URL. 
This feature is (for example) used to access BETYdb via the [Ropensci `traits` package](https://github.com/ropensci/rotraits/issues/3).

### A brief summary of the syntax of URL-based queries:

* The portion of the URL directly following `https://www.betydb.org/` determines the primary table being queried and the format of the query result.  For example, `https://www.betydb.org/traits.json` would obtain results from the traits table in JSON format and `https://www.betydb.org/yields.xml` would get results from the yields table in XML format.
* The URL `https://www.betydb.org/traits.csv` will download the entire traits table (or rather, that portion of the table which the user is permitted to access) in CSV format.  To restrict the results, we use a _query string_, which is the portion of the URL after the question mark.  The query string consists of one or more clauses of the form `key=value` separated by `&` characters.  For example, to obtain only the portion of the traits table associated with the site having id 99, the species having id 938, and the citation having id 45, we could write `https://www.betydb.org/traits.csv?site_id=99&specie_id=938&citation_id=45`.  Note that restrictions are cummulative: each claus further restricts the result of applying the previous restriction.  There is (currently) no way of taking the disjunction of multiple clauses--that is, there is not way of "OR-ing" the clauses together.
*  URLs can not contain spaces.  If the value you are querying against contains a space, substitute `+` or `%20` in the URL.  Thus, above we had to write the query URL as `https://www.betydb.org/species.csv?scientificname=Panicum+virgatum`.  We couldn't have written it as `https://www.betydb.org/species.csv?scientificname=Panicum virgatum`.


### Cross-table queries

It is possible to write queries involving multiple tables, but compared with the full expressive power of SQL, this ability is somewhat limited.  Nevertheless, must common queries of interest should be possible.  Here is a short outline of the scope and syntax of such queries:

* In any multiple-table query, there is always a "primary" table.  This corresponds to the name directly following the hostname portion of the URL.  For example, in a query of the form `https://www.betydb.org/yields.csv?specie_id=938&...`, "yields" is the primary table of the query.
* Other tables involved in the query must be related to the primary table in one of the following three ways: (1) The primary table has a foreign key column that refers to the other table.  For example, the `citation_id` column of the yields table refers to the citations table, so we can include the citations table in any query on the yields table.  (2) The other table has a foreign key referring to the primary table.  For example, we could involve the cultivars table in any query where species is the primary table because the cultivars table has a `specie_id` column.  (3) There is a join table connecting the primary table to the other table.  For example, because the `citations_sites` table joins the citations table with the sites table, a query with `citations` as the primary table is allowed to include the sites table.
* For each "other" table involved in the query, there must be a clause in the query string of the URL of the form `include[]=other`.  The "other" portion of this clause is either (1) the name of the other table; (2) the singular form of the name of the other table.  Which of these two to use depends on whether a row of the primary table may be associated with multiple rows of the other table (case 1) or whether a row of the primary table is always associated with at most one row of the associated table (case 2).  An easy rule of thumb here is to use the singular form if the primary table has a foreign key column referring to the other table and to use the bona fide (plural) table name otherwise.  Note that for the purposes of this syntactical requirement and contrary to reality, "specie" is the singular form of "species".  _Note you must include the square brackets after "include"!_
* "include[]-ing" another table in a query allows the query to filter query results based on column values in that other table.  But to do so, the "key" portion of the filter clause must be of the form "\<table name>.\<column name>".
* "include[]-ing" another table in a query has another effect in the case of XML and JSON-formatted results: The associated row(s) from the included table are included with each entity of the primary table the query returns.  For example, consider the query `https://www.betydb.org/cultivars.xml?species.genus=Salix&include[]=specie`.  Not only with this return all cultivars for any species with genus Salix, it will return detail species information for each cultivar returned.  Contrast this with the CSV-format query `https://www.betydb.org/cultivars.csv?species.genus=Salix&include[]=specie`.  This returns the same cultivars as before, but we only get the information contained in the cultivars table.  In particular, while we will get the value of `specie_id` for each returned cultivar, we won't get the corresponding species name.

Some examples will make the query syntax clearer. In all of these examples, you can interchange `.json` with `.xml` or `.csv` depending on the format that you want.

 
### Examples

1. Return all trait data for "Panicum virgatum" without having to know its species id number:

        https://www.betydb.org/traits.csv?include[]=specie&species.scientificname=Panicum+virgatum

    This will produce exactly the same result file as the "easy" query above that used the specie_id number.  As mentioned above, the XML and JSON formats of the same query give more information than the CSV form does.  Since XML and JSON are more highly-structured that CSV, it is easy to include full species information with each trait item returned, and queries using these formats do so.  Because of this, CSV-format queries are invariable faster.
    
2. An alternative way of obtaining all trait data for "Panicum virgatum" whithout having to know its species id number:

    Note that the results of the previous query in XML or JSON formats are quite redundant: full information about species Panicum virgatum is included with each trait returned.  The following query will only show the Panicum virgatum species information once:
    
         https://www.betydb.org/species.xml?scientificname=Panicum+virgatum&include[]=traits
         
    This returns a single result from the species table--the row information for Panicum virgatum--but nested inside this result is a list of all trait rows associated with that species.

    In CSV mode, this option is not available to us.  CSV format only shows information extracted from the primary table.  In CSV mode, an "include[]=other\_table" clause is useless unless you are going to use the included table to filter the returned results by also including a clause of the form "other\_table.column\_name=column\_value".

3. Return all citations in json format (replace json with xml or csv for those formats):

        https://www.betydb.org/citations.json
    
3. Return all yield data for the genus ‘Miscanthus’:
  
        https://www.betydb.org/yields.json?include[]=specie&species.genus=Miscanthus    

    If we're only interested in Miscanthus having species name "sinensis", we can do:

        https://www.betydb.org/yields.json?include[]=specie&species.genus=Miscanthus&species.species=sinensis
    
    As in the first example, this query will show the same species information multiple times--once for each yield.

    An alternative way of extracting the same information in a different format is:

        https://www.betydb.org/species.json?genus=Miscanthus&include[]=yields       
        https://www.betydb.org/species.json?genus=Miscanthus&species=sinensis&include[]=yields
    
    These each return a list of Miscanthus species (a list of length one in the second case) where each list item itself contains a list of yields for the species of the item. Since species and yields are in a one-to-many relationship, each species is only listed once.

4. Return all yield data from the citation with author = Heaton and year = 2008 (can also be queried by title):

        https://www.betydb.org/citations.xml?include[]=yields&author=Heaton&year=2008
        
    To get this information in CSV format, we have to use yields as the primary table:
    
        https://www.betydb.org/yields.xml?include[]=citation&citations.author=Heaton&citations.year=2008
        
    Note that we use the singular form "citation" in the include clause (since there is one citation per yield), but the qualified column names "citations.author" and "citations.year" must always use the actual database table name.

5. Find species associated with the `salix` pft:


        https://www.betydb.org/pfts.xml?pfts.name=salix&include[]=specie

    You can also do the query like so:

        https://www.betydb.org/species.xml?pfts.name=salix&include[]=pfts
    
    The results of these two queries contain essentially the same information--and to emphasize that we only need to interchange the primary and included table names to get from one query to the other, we have used the fully-qualified column name "pfts.name" in both (though just "name" would suffice in the first); but the form of those results will be rather different.  It is instructive to compare them.


6. Return all citations with their associated sites: 

        https://www.betydb.org/citations.json?include[]=sites
    
    (**Note**: When using `include[]=`, you use the singular version of the associated table's name when the relationship is many to one, and the plural—as we do here—when it is many to many. **Hint**: if the main table has a foreign key that references the table you are attempting to include—that is, something like `relatedtable_id`—then you need to use the singular version.) 

7. Return all citations with their associated sites and yields (working on ability to nest this deeper):  

        https://www.betydb.org/citations.json?include[]=sites&include[]=yields
    
    **_Note that this will take considerable time since the information for all yields rows will be displayed._**

8. Return all citations with the field journal equal to ‘Agronomy Journal’ and author equal to ‘Adler’ with their associated sites and yields. 

        https://www.betydb.org/citations.json?journal=Agronomy%20Journal&author=Adler&include[]=sites&include[]=yields
    
9. Return citation 1 in json format: 

        https://www.betydb.org/citations/1.json
    
    Alternatively, we can do:

        https://www.betydb.org/citations.json?id=1
    
    This result is slightly different in that it returns a JSON array with a single item instead of the item itself.

10. Return citation 1 in json format with it’s associated sites  

        https://www.betydb.org/citations/1.json?include[]=sites 

11. Return citation 1 in json format with it’s associated sites and yields 

        https://www.betydb.org/citations/1.json?include[]=sites&include[]=yields 

## API keys

Using an API key allows access to data without having to enter a login. To use an API key, simply append `?key=<your key>` to the end of the URL. If the URL already contains a query string, append `&key=<your key>` instead.  Each user must obtain a unique API key.

### For Admins

Users who signed up on previous releases may not have an API key in the database. To create an API key for every existing user, run the command below

    rake bety:make_keys

This command will only be needed once.  To quickly make an API key for a single user, or to change a user's API key, log in to BETYdb, go to the users page, and click on the "key" button in the row for that user.


