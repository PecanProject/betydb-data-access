# The BETYdb Web API \label{sec:betyapi}

The BETYdb URL-based API allows users to Query data. 

The BETYdb Application Programming Interface (API) is a means of obtaining search or query results in CSV, JSON, or XML format from URL-based queries entered into a Web browser or called from a scripting language such as R, Matlab, or Python (e.g. the rOpenSci traits package). All the tables in BETYdb are RESTful, which allows you to use GET, POST, PUT, or DELETE methods without interacting with the web-browser-based GUI interface. The primary advantage of this approach is the ability to submit complex queries that access information and tables without having to do so through the GUI interface: text-based queries can be recorded with more precision than instructions for interacting with the GUI interface and can be constructed automatically within a scripting language. In the future, this feature will be used to access BETYdb by the [`traits` package](https://github.com/ropensci/traits/issues/3) under development by rOpenSci. It would be straightforward to translate functions in the PEcAn.DB package to use the API. See the appendix for examples. Each registered user has an API key that allows access to restricted data without requiring a login or password.
 

The Web API for querying BETYdb supports both simple single-table queries and complex queries involving two or more tables. 

## Simple API Queries

[Note: In all the examples in this section, we have written the query URLs as though they are to be run in the browser after having logged in to the BETYdb web site.  To run these queries programmatically, the URLs used will have to be modified to include the API key.  See the section on API keys below.]

The simpler URL-based queries provide a way to extract useful information from a single database table in CSV (comma-separated values) format, which is easy to use in any spreadsheet software or scripting language.  (Other possible formats are JSON and XML; see below).


Data can be downloaded as a `.csv` file, and data from previously published syntheses can be downloaded without login.  In the simplest case, we can use a single key-value pair to filter the table, restricting the result to the set of rows having a given value in a given column.  For example, to download all of the trait data for the switchgrass species Panicum virgatum, we must first look up the id number of the Panicum virgatum species.  We can do this by querying the species table:

    https://www.betydb.org/species.csv?scientificname=Panicum+virgatum
    
and examining the "id" column value of the one-row result.  Once we have the id, we can use it to query the traits table:

    https://www.betydb.org/traits.csv?specie_id=938

The reason we must use this two-stage process is that the traits table doesn't contain the species name information directly.  **Caveat! _Note that there is no guarantee that these id numbers will not change!_**  Although it is rather unlikely that the id number for Panicum virgatum will change between the time we query the species table to look it up and the time we use it to query the traits table, it entirely possible that if we run the query `https://www.betydb.org/traits.csv?specie_id=938` a year from now, the results will be for an entirely different species!  For this and other reasons, it is worthwhile learning how to do cross-table queries.



## Complex API Queries

The API allows more complex queries and faster programmatic access by including multiple search terms to the query URL. 
This feature is (for example) used to access BETYdb via the [Ropensci `traits` package](https://github.com/ropensci/rotraits/issues/3).

### A brief summary of the syntax of URL-based queries:

* The portion of the URL directly following `https://www.betydb.org/` determines the primary table being queried and the format of the query result.  For example, `https://www.betydb.org/traits.json` would obtain results from the traits table in JSON format and `https://www.betydb.org/yields.xml` would get results from the yields table in XML format.
* As a special case, to query the traits\_and\_yields\_view, use "search" in place of the table name.  For example, `https://www.betydb.org/search.json` returns the rows of this view in JSON format.  Note that multiple-table URL-based queries are not currently possible with `traits_and_yields_view` as the primary table.
* The URL `https://www.betydb.org/traits.csv` will download the entire traits table (or rather, that portion of the table which the user is permitted to access) in CSV format.  To restrict the results, we use a _query string_, which is the portion of the URL after the question mark.  The query string consists of one or more clauses of the form `key=value` separated by `&` characters.  For example, to obtain only the portion of the traits table associated with the site having id 99, the species having id 938, and the citation having id 45, we could write `https://www.betydb.org/traits.csv?site_id=99&specie_id=938&citation_id=45`.  Note that restrictions are cummulative: each clause further restricts the result of applying the previous restriction.  In general, there is (currently) no way of taking the disjunction of multiple clauses—that is, there is not way of "OR-ing" the clauses together (but see the next item).
* In queries on `traits_and_yields_view`, in addition to being able to use column names as keys, you can also use the special key `search`.  This matches against multiple columns at once, and the query succeeds if each word in the search string matches any portion of one of the column values in the list of searched columns.  Moreover, these matches are not case-sensitive.  For details, see \ref{sec:basicsearch} above.
*  URLs can not contain spaces.  If the value you are querying against contains a space, substitute `+` or `%20` in the URL.  Thus, above we had to write the query URL as `https://www.betydb.org/species.csv?scientificname=Panicum+virgatum`.  We couldn't have written it as `https://www.betydb.org/species.csv?scientificname=Panicum virgatum`.


### Cross-table queries

It is possible to write queries involving multiple tables, but compared with the full expressive power of SQL, this ability is somewhat limited.  Nevertheless, most common queries of interest should be possible.  Here is a short outline of the scope and syntax of such queries:

* In any multiple-table query, there is always a "primary" table.  This corresponds to the name directly following the hostname portion of the URL.  For example, in a query of the form `https://www.betydb.org/yields.csv?specie_id=938&...`, "yields" is the primary table of the query.
* Other tables involved in the query must be related to the primary table in one of the following three ways: (1) The primary table has a foreign key column that refers to the other table.  For example, the `citation_id` column of the yields table refers to the citations table, so we can include the citations table in any query on the yields table.  (2) The other table has a foreign key referring to the primary table.  For example, we could involve the cultivars table in any query where species is the primary table because the cultivars table has a `specie_id` column.  (3) There is a join table connecting the primary table to the other table.  For example, because the `citations_sites` table joins the citations table with the sites table, a query with `citations` as the primary table is allowed to include the sites table.  Visit https://www.betydb.org/schemas to view a list of the tables (including join tables) of BETYdb.  Click on a table name to see a list of its columns.
* For each "other" table involved in the query, there must be a clause in the query string of the URL of the form `include[]=other`.  The "other" portion of this clause is either (1) the name of the other table; (2) the singular form of the name of the other table.  Which of these two to use depends on whether a row of the primary table may be associated with multiple rows of the other table (case 1) or whether a row of the primary table is always associated with at most one row of the associated table (case 2).  An easy rule of thumb here is to use the singular form if the primary table has a foreign key column referring to the other table and to use the bona fide (plural) table name otherwise.  Note that for the purposes of this syntactical requirement and contrary to reality, "specie" is the singular form of "species".  _Note you must include the square brackets after "include"!_
* "include[]-ing" another table in a query allows the query to filter query results based on column values in that other table.  But to do so, the "key" portion of the filter clause must be of the form "\<other table name>.\<column name>".  (Note that keys referring to column values in the primary table may use, but do not require, the table name qualifier.)
* "include[]-ing" another table in a query has another effect in the case of XML and JSON-formatted results: The associated row(s) from the included table are included with each entity of the primary table the query returns.  For example, consider the query `https://www.betydb.org/cultivars.xml?species.genus=Salix&include[]=specie`.  Not only will this return all cultivars for any species with genus Salix, it will return detailed species information for each cultivar returned.  Contrast this with the CSV-format query `https://www.betydb.org/cultivars.csv?species.genus=Salix&include[]=specie`.  This returns the same cultivars as before, but we only get the information contained in the cultivars table.  In particular, while we will get the value of `specie_id` for each returned cultivar, we won't get the corresponding species name.

A few points need to be made about how cross-table queries work.

1. If multiple rows of the "other" table may be assoicated with each row of the primary table, and we include a clause of the form "\<other table name>.\<column name>=value", then a row of the primary table shows up in the search result if and only if the column value of at least one associated row from the other table is equal to "value".  For example, in the query `https:/www.betydb.org/citations.xml?author=Clifton-Brown&include[]=sites&sites.city=Lisbon`, the citations returned will be all and only those where the author is Clifton-Brown and where at least one of the associated sites is in the city Lisbon.
2. As mentioned above, in the case of XML and JSON-formatted results, full information is given about associated rows from the other table(s).  In the example just given, for each citation of Clifton-Brown associated with some site(s) in Lisbon, we will see full information about those sites in the results.  But information about other sites not in Lisbon associated with the same citation will not be shown.
3. Adding an `include[]=other` clause without any corresponding filter clauses will not restrict the search results in any way.  In particular, any row from the primary table that showed up before the `include[]=other` clause was added will continue to show up after it is added, even if it is not associated with any rows from the other table.
4. Even if a table name must be singular in the `include[]=other` clause, the actual (plural) table name must be used in the "\<other table name>.\<column name>=value" filtering clause.


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
    
    (Note that we use the plural form "sites" in the include clause since citations and sites are in a many to many relationship.) 

7. Return all citations with their associated sites and yields:  

        https://www.betydb.org/citations.json?include[]=sites&include[]=yields
    
    _Note that this will take considerable time since the information for all yields rows will be displayed._  Note also that the result of this query will not tell us directly which site is associated with which yield (although the yield result will have a site_id column, which will tell us indirectly).

8. Return all citations in the field journal ‘Agronomy Journal’ by author ‘Adler’ with their associated sites and yields. 

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
        
Regarding the last three examples, although the syntax for returning data associated with a single entity (citation 1 in these examples) is very convenient, in general it is best not to rely on fixed id numbers for entities.  "The citation in _Agronomy Journal_ with author Adler" is a more reliable locator than "The citation with id 1".

## Using the Traits and Yields View to Avoid Complex Cross-Table Queries

The database view `traits_and_yields_view` provides summary information about traits and yields: It combines information from the traits and the yields tables and it includes information from six associated tables—namely, the sites, species, citations, treatments, variables, and users tables.  Whereas the traits and the yields tables contain only pointers to these tables (foreign keys), the `traits_and_yields_view` directly contains information associated with a trait or yields such as the species name of the trait measured, the name of the measured variable, and the author and year of the citation associated with the trait or yield.  This means that in many cases a query of the `traits_and_yields_view` may be used to extract information that otherwise would require a complex cross-table query with traits or yields as the primary table.

Moreover, by using the special `search=` key in place of column names, one can avoid the strict matching that is used when the key is a bona fide column name.  For example,
```
https://www.betydb.org/search.xml?search=cottongrass
```
will return all traits and yields for which the common name of the species includes the word "cottongrass".  To get the same rows using `commonname` as the key, we would have to do three separate searches:
```
https://www.betydb.org/search.xml?commonname=tussock+cottongrass
https://www.betydb.org/search.xml?commonname=white+cottongrass
https://www.betydb.org/search.xml?commonname=tall+cottongrass
```
This is because when we use a column name as the search key, the value must match the column value exactly.


## API keys

Using an API key allows access to data without having to enter a login. To use an API key, simply append `?key=<your key>` to the end of the URL. If the URL already contains a query string, append `&key=<your key>` instead.  Each user must obtain a unique API key.

### For Admins

Users who signed up on previous releases may not have an API key in the database. To create an API key for every existing user, run the command below

    rake bety:make_keys

This command will only be needed once.  To quickly make an API key for a single user, or to change a user's API key, log in to BETYdb, go to the users page, and click on the "key" button in the row for that user.



  
  
  
  