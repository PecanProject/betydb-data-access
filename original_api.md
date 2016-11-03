Gitbook version {{gitbook.version}}

# Original API


## Simple API queries


The simpler of the available API calls provide a way to extract useful
information from a single database table in various formats.  CSV
(comma-separated values) format is of particular interest, as it is a format
that is easy to view and use in any spreadsheet software and in R.  Other
possible formats are JSON and XML.

In the discussion that follows, most URLs given as examples are clickable, and
the results of the various API calls represented by these URLs will then be
viewable in a browser.  In most of these calls, we will write the URLs to
request results in XML format rather than in CSV format.  This is mainly for
convenience: requests for XML format will usually display the result in the
browser whereas requests for CSV format will result in a CSV file being produced
and downloaded; this would require the additional step of opening the CSV file
in a suitable application program.

If, however, you want to see what the result would be in either of the other two
formats, this is easy to do: After clicking the link and seeing the XML result
in the browser, go into the browser's address box and manually edit the URL
there, replacing the .xml extension with .json or .csv as desired.

### A simple example

Data can be downloaded as a CSV, XML, or JSON file, and data from previously
published syntheses can be downloaded without logging in.  In the simplest case,
we can use a single key-value pair to filter the table, restricting the result
to the set of rows having a given value in a given column.  For example, to
download all of the trait data for the switchgrass species Panicum virgatum, we
must first look up the id number of the Panicum virgatum species.  We can do
this by querying the species table by issuing a call to this URL[^apikey-note]

{{book.BETYdb_URL}}/species.xml?scientificname=Panicum+virgatum

and then examining the "id" value of one species in the result.  Once we have
the id, we can use it to query the traits table by visiting this URL:

{{book.BETYdb_URL}}/traits.xml?specie_id=938

The reason we must use this two-stage process is that the traits table doesn't
contain the species name information directly.

_**Caveat!** There is no guarantee that these id numbers will not change!_
Although it is rather unlikely that the id number for Panicum virgatum will
change between the time we query the species table to look it up and the time we
use it to query the traits table, it entirely possible that if we run the query
{{book.BETYdb_URL}}/traits.xml?specie_id=938 a year from now, the results will
be for an entirely different species!  For this and other reasons, it is
worthwhile learning how to do cross-table queries.



## Complex API Queries

The API allows more complex queries and faster programmatic access by including
multiple search terms in the query string of the URL.  This feature is (for
example) used to access BETYdb via the [Ropensci `traits`
package](https://github.com/ropensci/rotraits/issues/3).

### A brief summary of the syntax of URL-based queries:

* The portion of the URL directly following {{book.BETYdb_URL}}/ determines the primary table being queried and the format of the query result.  For example, {{book.BETYdb_URL}}/traits.json would obtain results from the traits table in JSON format and {{book.BETYdb_URL}}/yields.xml would get results from the yields table in XML format.

* As a special case, to query the traits\_and\_yields\_view, use "search" in place of the table name.  For example, {{book.BETYdb_URL}}/search.json returns the rows of this view in JSON format.  Note that multiple-table URL-based queries are not currently possible with `traits_and_yields_view` as the primary table.

* The URL {{book.BETYdb_URL}}/traits.csv will download the entire traits table (or rather, that portion of the table which the user is permitted to access) in CSV format.  To restrict the results, we use a _query string_, which is the portion of the URL after the question mark.  The query string consists of one or more clauses of the form `key=value` separated by `&` characters.  For example, to obtain only the portion of the traits table associated with the site having id 99, the species having id 938, and the citation having id 45, we could write {{book.BETYdb_URL}}/traits.csv?site_id=99&specie_id=938&citation_id=45.  Note that restrictions are cummulative: each clause further restricts the result of applying the previous restriction.  In general, there is (currently) no way of taking the disjunction of multiple clauses—that is, there is not way of "OR-ing" the clauses together (but see the next item).

* In queries on `traits_and_yields_view`, in addition to being able to use column names as keys, you can also use the special key `search`.  This matches against multiple columns at once, and the query succeeds if each word in the search string matches any portion of one of the column values in the list of searched columns.  Moreover, these matches are not case-sensitive.  For details, see \ref{sec:basicsearch} above.

*  URLs can not contain spaces.  If the value you are querying against contains a space, substitute `+` or `%20` in the URL.  Thus, above we had to write the query URL as {{book.BETYdb_URL}}/species.csv?scientificname=Panicum+virgatum.  We couldn't have written it as {{book.BETYdb_URL}}/species.csv?scientificname=Panicum virgatum.


### Cross-table queries

It is possible to write queries involving multiple tables, but compared with the full expressive power of SQL, this ability is somewhat limited.  Nevertheless, most common queries of interest should be possible.  Here is a short outline of the scope and syntax of such queries:

* In any multiple-table query, there is always a "primary" table.  This corresponds to the name directly following the hostname portion of the URL.  For example, in a query of the form {{book.BETYdb_URL}}/yields.csv?specie_id=938&..., "yields" is the primary table of the query.
* Other tables involved in the query must be related to the primary table in one of the following three ways: (1) The primary table has a foreign key column that refers to the other table.  For example, the `citation_id` column of the yields table refers to the citations table, so we can include the citations table in any query on the yields table.  (2) The other table has a foreign key referring to the primary table.  For example, we could involve the cultivars table in any query where species is the primary table because the cultivars table has a `specie_id` column.  (3) There is a join table connecting the primary table to the other table.  For example, because the `citations_sites` table joins the citations table with the sites table, a query with `citations` as the primary table is allowed to include the sites table.  Visit {{book.BETYdb_URL}}/schemas to view a list of the tables (including join tables) of BETYdb.  Click on a table name to see a list of its columns.
* For each "other" table involved in the query, there must be a clause in the query string of the URL of the form `include[]=other`.  The "other" portion of this clause is either (1) the name of the other table; (2) the singular form of the name of the other table.  Which of these two to use depends on whether a row of the primary table may be associated with multiple rows of the other table (case 1) or whether a row of the primary table is always associated with at most one row of the associated table (case 2).  An easy rule of thumb here is to use the singular form if the primary table has a foreign key column referring to the other table and to use the bona fide (plural) table name otherwise.  Note that for the purposes of this syntactical requirement and contrary to reality, "specie" is the singular form of "species".  _Note you must include the square brackets after "include"!_
* "include[]-ing" another table in a query allows the query to filter query results based on column values in that other table.  But to do so, the "key" portion of the filter clause must be of the form "\<other table name>.\<column name>".  (Note that keys referring to column values in the primary table may use, but do not require, the table name qualifier.)
* "include[]-ing" another table in a query has another effect in the case of XML and JSON-formatted results: The associated row(s) from the included table are included with each entity of the primary table the query returns.  For example, consider the query {{book.BETYdb_URL}}/cultivars.xml?species.genus=Salix&include[]=specie.  Not only will this return all cultivars for any species with genus Salix, it will return detailed species information for each cultivar returned.  Contrast this with the CSV-format query {{book.BETYdb_URL}}/cultivars.csv?species.genus=Salix&include[]=specie.  This returns the same cultivars as before, but we only get the information contained in the cultivars table.  In particular, while we will get the value of `specie_id` for each returned cultivar, we won't get the corresponding species name.

A few points need to be made about how cross-table queries work.

1. If multiple rows of the "other" table may be assoicated with each row of the primary table, and we include a clause of the form "\<other table name>.\<column name>=value", then a row of the primary table shows up in the search result if and only if the column value of at least one associated row from the other table is equal to "value".  For example, in the query `https:/www.betydb.org/citations.xml?author=Clifton-Brown&include[]=sites&sites.city=Lisbon`, the citations returned will be all and only those where the author is Clifton-Brown and where at least one of the associated sites is in the city Lisbon.
2. As mentioned above, in the case of XML and JSON-formatted results, full information is given about associated rows from the other table(s).  In the example just given, for each citation of Clifton-Brown associated with some site(s) in Lisbon, we will see full information about those sites in the results.  But information about other sites not in Lisbon associated with the same citation will not be shown.
3. Adding an `include[]=other` clause without any corresponding filter clauses will not restrict the search results in any way.  In particular, any row from the primary table that showed up before the `include[]=other` clause was added will continue to show up after it is added, even if it is not associated with any rows from the other table.
4. Even if a table name must be singular in the `include[]=other` clause, the actual (plural) table name must be used in the "\<other table name>.\<column name>=value" filtering clause.


Some examples will make the query syntax clearer. In all of these examples, you can interchange `.json` with `.xml` or `.csv` depending on the format that you want.


### Examples

1. Return all trait data for "Panicum virgatum" without having to know its species id number:

    {{book.BETYdb_URL}}/traits.csv?include[]=specie&species.scientificname=Panicum+virgatum

    This will produce exactly the same result file as the "easy" query above that used the specie_id number.  As mentioned above, the XML and JSON formats of the same query give more information than the CSV form does.  Since XML and JSON are more highly-structured that CSV, it is easy to include full species information with each trait item returned, and queries using these formats do so.  Because of this, CSV-format queries are invariable faster.

2. An alternative way of obtaining all trait data for "Panicum virgatum" whithout having to know its species id number:

    Note that the results of the previous query in XML or JSON formats are quite redundant: full information about species Panicum virgatum is included with each trait returned.  The following query will only show the Panicum virgatum species information once:

     {{book.BETYdb_URL}}/species.xml?scientificname=Panicum+virgatum&include[]=traits

    This returns a single result from the species table--the row information for Panicum virgatum--but nested inside this result is a list of all trait rows associated with that species.

    In CSV mode, this option is not available to us.  CSV format only shows information extracted from the primary table.  In CSV mode, an "include[]=other\_table" clause is useless unless you are going to use the included table to filter the returned results by also including a clause of the form "other\_table.column\_name=column\_value".

3. Return all citations in json format (replace json with xml or csv for those formats):

    {{book.BETYdb_URL}}/citations.json

3. Return all yield data for the genus ‘Miscanthus’:

    {{book.BETYdb_URL}}/yields.json?include[]=specie&species.genus=Miscanthus

    If we're only interested in Miscanthus having species name "sinensis", we can do:

    {{book.BETYdb_URL}}/yields.json?include[]=specie&species.genus=Miscanthus&species.species=sinensis

    As in the first example, this query will show the same species information multiple times--once for each yield.

    An alternative way of extracting the same information in a different format is:

    {{book.BETYdb_URL}}/species.json?genus=Miscanthus&include[]=yields
    {{book.BETYdb_URL}}/species.json?genus=Miscanthus&species=sinensis&include[]=yields

    These each return a list of Miscanthus species (a list of length one in the second case) where each list item itself contains a list of yields for the species of the item. Since species and yields are in a one-to-many relationship, each species is only listed once.

4. Return all yield data from the citation with author = Heaton and year = 2008 (can also be queried by title):

    {{book.BETYdb_URL}}/citations.xml?include[]=yields&author=Heaton&year=2008

    To get this information in CSV format, we have to use yields as the primary table:

    {{book.BETYdb_URL}}/yields.xml?include[]=citation&citations.author=Heaton&citations.year=2008

    Note that we use the singular form "citation" in the include clause (since there is one citation per yield), but the qualified column names "citations.author" and "citations.year" must always use the actual database table name.

5. Find species associated with the `salix` pft:

    {{book.BETYdb_URL}}/pfts.xml?pfts.name=salix&include[]=specie

    You can also do the query like so:

    {{book.BETYdb_URL}}/species.xml?pfts.name=salix&include[]=pfts

    The results of these two queries contain essentially the same information--and to emphasize that we only need to interchange the primary and included table names to get from one query to the other, we have used the fully-qualified column name "pfts.name" in both (though just "name" would suffice in the first); but the form of those results will be rather different.  It is instructive to compare them.


6. Return all citations with their associated sites:

    {{book.BETYdb_URL}}/citations.json?include[]=sites

    (Note that we use the plural form "sites" in the include clause since citations and sites are in a many to many relationship.)

7. Return all citations with their associated sites and yields:

    {{book.BETYdb_URL}}/citations.json?include[]=sites&include[]=yields

    _Note that this will take considerable time since the information for all yields rows will be displayed._  Note also that the result of this query will not tell us directly which site is associated with which yield (although the yield result will have a site_id column, which will tell us indirectly).

8. Return all citations in the field journal ‘Agronomy Journal’ by author ‘Adler’ with their associated sites and yields.

    {{book.BETYdb_URL}}/citations.json?journal=Agronomy%20Journal&author=Adler&include[]=sites&include[]=yields

9. Return citation 1 in json format:

    {{book.BETYdb_URL}}/citations/1.json

    Alternatively, we can do:

    {{book.BETYdb_URL}}/citations.json?id=1

    This result is slightly different in that it returns a JSON array with a single item instead of the item itself.

10. Return citation 1 in json format with it’s associated sites

    {{book.BETYdb_URL}}/citations/1.json?include[]=sites

11. Return citation 1 in json format with it’s associated sites and yields

    {{book.BETYdb_URL}}/citations/1.json?include[]=sites&include[]=yields

Regarding the last three examples, although the syntax for returning data associated with a single entity (citation 1 in these examples) is very convenient, in general it is best not to rely on fixed id numbers for entities.  "The citation in _Agronomy Journal_ with author Adler" is a more reliable locator than "The citation with id 1".

## Using the Traits and Yields View to Avoid Complex Cross-Table Queries

The database view `traits_and_yields_view` provides summary information about traits and yields: It combines information from the traits and the yields tables and it includes information from six associated tables—namely, the sites, species, citations, treatments, variables, and users tables.  Whereas the traits and the yields tables contain only pointers to these tables (foreign keys in the form of id numbers), the `traits_and_yields_view` directly contains information associated with a trait or yield such as the name of the species of the plant whose trait was measured, the name of the measured variable, and the author and year of the citation associated with the trait or yield.  This means that in many cases a query of the `traits_and_yields_view` may be used to extract information that otherwise would require a complex cross-table query with traits or yields as the primary table.

Moreover, by using the special `search=` key in place of column names, one can avoid the strict matching that is used when the key is a bona fide column name.  For example,

{{book.BETYdb_URL}}/search.xml?search=cottongrass

will return all traits and yields for which the common name of the species includes the word "cottongrass".  To get the same rows using `commonname` as the key, we would have to do three separate searches:

{{book.BETYdb_URL}}/search.xml?commonname=tussock+cottongrass

{{book.BETYdb_URL}}/search.xml?commonname=white+cottongrass

{{book.BETYdb_URL}}/search.xml?commonname=tall+cottongrass

This is because when we use a column name as the search key, the value must match the column value exactly (including the letter case and the number of spaces between words).

### Including Unchecked Data in the Traits and Yields View

By default, searches on `traits_and_yields_view` return only checked data.  The Web interface now has a checkbox labelled "include unchecked records" that the user may check to override this default.  To do the same thing through the API, the user must include a clause of the form `include_unchecked=true` in the query string.  (Any of 'TRUE', 'yes', 'YES', 'y', 'Y', '1', 't', 'T' may be used in place of 'true' here.)

### A Few Notes about Searching the Traits and Yields View

1. The base URL to use is {{book.BETYdb_URL}}/search
2. You can only use columnname keys when the result format is XML or JSON.  If the result format is CSV or HTML, any query-string clause of the form `columnname=value` is ignored.
3. The query-string clauses of the form `search=value` and `include_unchecked=true` may be used with all result formats.
4. If multiple `search=value` clauses are included, only last one is used.  **Don't do this!**  To search on multiple terms, separate them in the query string by `+` signs.  For example, {{book.BETYdb_URL}}/search.xml?search=LTER+cottongrass&include_unchecked=true will likely find traits and yields results for cottongrass species at LTER (Long-term Ecological Research) sites, including those that have not been checked.
5. As noted above, each word in the value of a `search=value` clause must match one of the columns `sitename`, `city`, `scientificname`, `commonname`, `author`, `trait`, `trait_description`, or `citation_year` in order for a given row to be included in the search results.  Here, "match" means "be textually included in the column value".
6. Remember that values for column name keys are treated very differently from the way the value of the `search` key is treated.  In particular, the value is treated as one unit.  Consider the difference between these two examples:

    {{book.BETYdb_URL}}?commonname=white+willow

    will return only rows pertaining to the species with commonname "white willow",

    {{book.BETYdb_URL}}?search=white+willow

    will in addition return rows for white ash at a site called Willow Creek.

---

[^apikey-note]: In all of the examples in this section, we have written the query URLs as though they are to be run in a web browser after having logged in to the BETYdb web site.  To run these queries from the command line or in a script, you must either pass login creditials with the HTTP call or the URLs used will have to be modified to include the API key (see the section on [API keys](Api.html#api-keys)).

Using the command-line program `curl` as an example, we could, instead of
visiting {{book.BETYdb_URL}}/species.csv?scientificname=Panicum+virgatum in
a Web browser, issue the `curl` command

<!--- See https://github.com/GitbookIO/gitbook/issues/707 for why we can't use the usual Markdown syntax --->
<pre><code class="lang-bash">
curl -u &lt;your login&gt;:&lt;your password&gt; "{{book.BETYdb_URL}}/species.csv?scientificname=Panicum+virgatum"
</code></pre>
or, using an API key instead of the `-u` option,

<pre><code class="lang-bash">
curl "{{book.BETYdb_URL}}/species.csv?scientificname=Panicum+virgatum?key=yourAPIkey"
</code></pre>

