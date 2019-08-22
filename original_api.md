# Original API

[_Skip to the examples_](#examples).

The original version of the BETYdb API was tightly integrated with the BETYdb
browser interface.  In general, for every BETYdb Web page displaying a list of
some kind of database entity (or one particular item from that list), there is a
corresponding URL to request that same information in CSV, JSON, or XML format.
Usually, this is a simple matter of deleting the ".html" extension from the Web
page URL path (if present) and appending ".csv", ".json", or ".xml" to the path
instead.

**Note:** All of the URLs in the examples below are for the BETYdb instance at
  www.betydb.org.  To try the examples at a different BETYdb site, replace
  "https\://www.betydb.org" with the
  top-level URL for the desired site.

## Simple API queries


The simplest kind of API request extracts information from a single database
table.  Various result formats can be requested.  CSV (comma-separated values)
format is of particular interest: it is a format that is easy to view and use in
any spreadsheet software and in R.  Other possible formats are JSON and XML.

In the discussion that follows, most URLs given as examples are clickable; the
results of the various HTTP requests represented by these URLs will then be
viewable in a browser.

In most of these calls, we will write the URLs to request results in XML format
rather than in CSV format.  This is mainly for convenience: requests for XML
format will usually display the result in the browser whereas requests for CSV
format will download a CSV file.  If, however, you want to see what the result
would be in either of the other two formats, this is easy to do: After clicking
the link and seeing the XML result in the browser, go into the browser's address
box and manually edit the URL there, replacing the .xml extension with .json or
.csv as desired.

### A simple example

Data can be requested as a CSV, XML, or JSON file, and data from previously
published syntheses can be requested without logging in.  In the simplest case,
we can use a single key-value pair to filter the table, restricting the result
to the set of rows having a given value in a given column.  For example, to
download all of the trait data for the switch-grass species _Panicum virgatum_,
we must first look up the id number of the Panicum virgatum species.  We can do
this by querying the species table by sending a request to this
URL[^apikey-note]

[https://www.betydb.org/species.xml?scientificname=Panicum+virgatum](https://www.betydb.org/species.xml?scientificname=Panicum+virgatum){target="_blank"}

and then examining the "id" value of the one species in the result.  Once we
have the id, we can use it to query the traits table:

[https://www.betydb.org/traits.xml?specie_id=938](https://www.betydb.org/traits.xml?specie_id=938){target="_blank"} [^specie_id_note]

The reason we must use this two-stage process is that the traits table doesn't
contain the species name information directly.

_**Caveat!** There is no guarantee that these id numbers will not change!_
Although it is unlikely that the id number for Panicum virgatum will change
between the time we look it up in the species table and the time we use it to
query the traits table, it entirely possible that if we run the query
[https://www.betydb.org/traits.xml?specie_id=938](https://www.betydb.org/traits.xml?specie_id=938){target="_blank"} a year from now, the result will be
for an entirely different species!  For this and other reasons, it is worthwhile
learning how to do cross-table queries.



## Complex API Queries

The API allows more complex queries and faster programmatic access by including
multiple search terms in the query string of the URL.  This feature is (for
example) used to access BETYdb via the [Ropensci `traits`
package](https://github.com/ropensci/rotraits/issues/3){target="_blank"}.

### A brief summary of the syntax of URL-based queries:

* The portion of the URL directly following https\://www.betydb.org/ determines the
  primary table being queried and the format of the query result.  For example,
  use [https://www.betydb.org/citations.json](https://www.betydb.org/citations.json){target="_blank"} to get results from the citations table
  in JSON format and [https://www.betydb.org/cultivars.xml](https://www.betydb.org/cultivars.xml){target="_blank"} to get results from the
  cultivars table in XML format.

* As a special case, to query the SQL view `traits_and_yields_view`, use
  "search" in place of the table name.  For example,
  [https://www.betydb.org/search.json?search=Salix+caprea](https://www.betydb.org/search.json?search=Salix+caprea){target="_blank"} [^limiting_results] returns
  all the rows of this view pertaining to species Salix caprea.

* The URL [https://www.betydb.org/traits.csv](https://www.betydb.org/traits.csv){target="_blank"} will download the entire traits table
  (or rather, that portion of the table which the current user is permitted to
  access) in CSV format.  To restrict the results, we use a _query string_,
  which is the portion of the URL after the question mark.  The query string
  consists of one or more clauses of the form `<key>=<value>` separated by `&`
  characters.  For example, to obtain only the portion of the traits table
  associated with the site having id 99, the species having id 938, and the
  citation having id 45, we could write
  [https://www.betydb.org/traits.csv?site_id=99&specie_id=938&citation_id=45](https://www.betydb.org/traits.csv?site_id=99&specie_id=938&citation_id=45){target="_blank"}.  Note
  that restrictions are cumulative: each clause further restricts the result of
  applying the previous restriction.  In general, there is no way of taking the
  disjunction of multiple clauses—that is, there is not way of "OR-ing" the
  clauses together (but see the next item).

* In queries on `traits_and_yields_view`, in addition to being able to use
  column names as keys, you can also use the special key `search`.[^search_note]
  This matches against multiple columns at once, and the query succeeds if each
  word in the search string matches any portion of one of the column values in
  the list of searched columns.  Moreover, these matches are not case-sensitive.
  For full details, see the [appendix](#appendix).

* URLs can not contain spaces.  If the value you are querying against contains a
   space, substitute `+` or `%20` in the URL.  Thus, in our very first example
   above we had to write the query URL as
   [https://www.betydb.org/species.csv?scientificname=Panicum+virgatum](https://www.betydb.org/species.csv?scientificname=Panicum+virgatum){target="_blank"}.  We could
   not have written it as
   [https://www.betydb.org/species.csv?scientificname=Panicum&nbsp;virgatum](https://www.betydb.org/species.csv?scientificname=Panicum&nbsp;virgatum){target="_blank"} and
   expect to get the result we wanted.


### Cross-table queries

It is possible to write queries involving multiple tables.  Compared with the
full expressive power of SQL, this ability is somewhat limited.  Nevertheless,
most common queries of interest should be possible.  Here is a short outline of
the scope and syntax of such queries:

* In any multiple-table query, there is always a "primary" table.  This
  corresponds to the name directly following the hostname portion of the URL.
  For example, in a query of the form
  https\://www.betydb.org/yields.csv?specie_id=938&..., "yields" is the primary
  table of the query.

* Other tables involved in the query must be related to the primary table in one
  of the following three ways:

  1. **The primary table has a foreign key column that refers to the other
  table.** For example, the `citation_id` column of the yields table refers to
  the citations table, so we can include the citations table in any query on the
  yields table.[^associations]

  1. **The other table has a foreign key referring to the primary table.** For
  example, we could involve the cultivars table in any query where species is
  the primary table because the cultivars table has a `specie_id` column.

  1. **There is a join table connecting the primary table to the other table.**
  For example, because the `citations_sites` table joins the citations table
  with the sites table, a query with `citations` as the primary table is allowed
  to include the sites table.  Visit [https://www.betydb.org/schemas](https://www.betydb.org/schemas){target="_blank"} to view a list
  of the tables (including join tables) of BETYdb.  Click on a table name to see
  a list of its columns.

* For each "other" table involved in the query, there must be a clause in the
  query string of the URL of the form `include[]=other`.  The "other" portion of
  this clause is either (1) the name of the other table, or (2) the singular
  form of the name of the other table.  Which of these two to use depends on
  whether a row of the primary table may be associated with multiple rows of the
  other table (case 1) or whether a row of the primary table is always
  associated with at most one row of the associated table (case 2).  An easy
  rule of thumb here is to use the singular form[^specie_vs_species] if the primary table has a
  foreign key column referring to the other table and to use the actual (plural)
  table name otherwise.[^table_relation_rule] Note you
  _must_ include the square brackets after "include"!

* "include[]-ing" another table in a query allows the query to filter query
  results based on column values in that other table.  But to do so, the "key"
  portion of the filter clause must be of the form
  `<other-table-name>.<column-name>`.  (Note that for keys referring to column
  values in the _primary_ table, using the table name qualifier is optional.)

* "include[]-ing" another table in a query has another effect in the case of XML
  and JSON-formatted results: The associated row(s) from the included table are
  included with each entity of the primary table the query returns.  For
  example, consider the query
  [https://www.betydb.org/cultivars.xml?species.genus=Salix&include[]=specie](https://www.betydb.org/cultivars.xml?species.genus=Salix&include[]=specie){target="_blank"}.  Not
  only will this return all cultivars for any species with genus Salix, it will
  return detailed species information for each cultivar returned.  Contrast this
  with the _CSV_-format query
  [https://www.betydb.org/cultivars.csv?species.genus=Salix&include[]=specie](https://www.betydb.org/cultivars.csv?species.genus=Salix&include[]=specie){target="_blank"}.  This
  returns the same cultivars as before, but we only get the information
  contained in the cultivars table.  In particular, while we will get the value
  of `specie_id` for each returned cultivar, we won't get the corresponding
  species name.

A few points need to be made about how cross-table queries work.

1. Suppose the _primary_ table is in a many-to-one relationship with the _other_
table.  Then if we include a clause of the form
`<other-table-name>.<column-name>=value`, a row of the primary table is selected
precisely when `<other-table-name>.<column-name>=value` for at least one
associated row from the other table.  For example, in the query
[https://www.betydb.org/citations.xml?author=Clifton-Brown&include[]=sites&sites.city=Lisbon](https://www.betydb.org/citations.xml?author=Clifton-Brown&include[]=sites&sites.city=Lisbon){target="_blank"},
the citations returned will be all and only those where the author is
Clifton-Brown and where at least one of the associated sites is in the city
Lisbon.

2. As mentioned above, in the case of XML and JSON-formatted results, full
information is given about associated rows from the other table(s).  In the
example just given, for each citation of Clifton-Brown associated with some
site(s) in Lisbon, we will see full information about those sites in the
results.  Other sites associated with the same citation but not in Lisbon,
however, will not be shown.

3. You can add an `include[]=other` clause without any corresponding filter
clauses.  This will not filter out any results but _will_ add in information
from the other table (except when the return format is CSV).  For example, the
query
[https://www.betydb.org/citations.xml?author=Clifton-Brown&include[]=sites](https://www.betydb.org/citations.xml?author=Clifton-Brown&include[]=sites){target="_blank"}
shows the same citations as the query
[https://www.betydb.org/citations.xml?author=Clifton-Brown](https://www.betydb.org/citations.xml?author=Clifton-Brown){target="_blank"}.
But it will, in addition, show full information about all of the sites
associated with each of the selected citations.

4. Even if the singular form of the table name must be used in the
`include[]=other` clause, the _actual_ table name must be used in the
`<other-table-name>.<column-name>=value` filtering clause.


Some examples will make the query syntax clearer. In all of these examples, you
can interchange `.json` with `.xml` or `.csv` depending on the format that you
want.


### Examples

1. Return all trait data for "Panicum virgatum" without having to know its species id number:

    [https://www.betydb.org/traits.xml?include[]=specie&species.scientificname=Panicum+virgatum](https://www.betydb.org/traits.xml?include[]=specie&species.scientificname=Panicum+virgatum){target="_blank"}

    This will return exactly the same traits as the query in [simple
    example](#a-simple-example) above that used the specie\_id number, but with
    the species information included.  (If CSV format is used instead, _exactly_
    the same result files are returned).

1. Note that the result of the previous query contains much redundancy: full
information about species _Panicum virgatum_ is included with each trait
returned.  The following query will show the Panicum virgatum species
information only once:

     [https://www.betydb.org/species.xml?scientificname=Panicum+virgatum&include[]=traits](https://www.betydb.org/species.xml?scientificname=Panicum+virgatum&include[]=traits){target="_blank"}

    This returns a single result from the species table—the row information for
    Panicum virgatum—but nested inside this result is a list of all trait rows
    associated with that species.

    In CSV mode, this option is not available to us.  CSV format only shows
    information extracted from the primary table.  In CSV mode, an
    "include[]=other\_table" clause is useless unless you are going to filter
    the returned results using column values in the included table.

1. Return all citations in JSON format (replace .json with .xml or .csv for
those formats):

    [https://www.betydb.org/citations.json](https://www.betydb.org/citations.json){target="_blank"}

1. Return all yield data for the genus _Miscanthus_:

    [https://www.betydb.org/yields.xml?include[]=specie&species.genus=Miscanthus](https://www.betydb.org/yields.xml?include[]=specie&species.genus=Miscanthus){target="_blank"}

    If we're only interested in Miscanthus having species name "sinensis", we can do:

    [https://www.betydb.org/yields.xml?include[]=specie&species.genus=Miscanthus&species.species=sinensis](https://www.betydb.org/yields.xml?include[]=specie&species.genus=Miscanthus&species.species=sinensis){target="_blank"}

    As in the first example, this query will show the same species information multiple times—once for each yield.

    Once again, we may remedy this by making _species_ the primary table:

    [https://www.betydb.org/species.xml?genus=Miscanthus&include[]=yields](https://www.betydb.org/species.xml?genus=Miscanthus&include[]=yields){target="_blank"}
    [https://www.betydb.org/species.xml?genus=Miscanthus&species=sinensis&include[]=yields](https://www.betydb.org/species.xml?genus=Miscanthus&species=sinensis&include[]=yields){target="_blank"}

    These each return a list of Miscanthus species, and each species item itself
    contains a list of yields for that species.  In these query results, each
    species is only listed once.

1. Return all yield data associated with the citation Heaton 2008:

    [https://www.betydb.org/citations.xml?include[]=yields&author=Heaton&year=2008](https://www.betydb.org/citations.xml?include[]=yields&author=Heaton&year=2008){target="_blank"}

    To get this information in CSV format, we have to use yields as the primary table:

    [https://www.betydb.org/yields.csv?include[]=citation&citations.author=Heaton&citations.year=2008](https://www.betydb.org/yields.csv?include[]=citation&citations.author=Heaton&citations.year=2008){target="_blank"}

    Note that we use the singular form "citation" in the include clause (since
    there is one citation per yield), but the qualified column names
    "citations.author" and "citations.year" must always use the actual database
    table name.

1. Find species associated with the _salix_ plant functional type:

    [https://www.betydb.org/pfts.xml?include[]=specie&pfts.name=salix](https://www.betydb.org/pfts.xml?include[]=specie&pfts.name=salix){target="_blank"}

    You can also do the query like so:

    [https://www.betydb.org/species.xml?include[]=pfts&pfts.name=salix](https://www.betydb.org/species.xml?include[]=pfts&pfts.name=salix){target="_blank"}

    The results of these two queries contain essentially the same
    information.  And to emphasize that we only need to interchange the primary
    and included table names to get from one query to the other, we have used
    the fully-qualified column name "pfts.name" in both (though just "name"
    would suffice in the first).

    The form of the result of the two queries is rather different.  It is
    instructive to compare them.  The first form is better for use with XML and
    JSON.  It doesn't repeat the same PFT information over and over again inside
    each species listing.  But the second form is the only one we can use with
    CSV format if we want to get any species information at all.

1. Return all citations with their associated sites:

    [https://www.betydb.org/citations.xml?include[]=sites](https://www.betydb.org/citations.xml?include[]=sites){target="_blank"}

    (Note that we use the plural form "sites" in the include clause since each
    citation may be associated with many sites.)

1. Return all citations with their associated sites and yields:

    [https://www.betydb.org/citations.xml?include[]=sites&include[]=yields](https://www.betydb.org/citations.xml?include[]=sites&include[]=yields){target="_blank"}

    _Note that this will take considerable time since the information for all
    yields rows will be displayed._ If the query times out, try adding a
    restriction such as `year=1990`:

    [https://www.betydb.org/citations.xml?year=1990&include[]=sites&include[]=yields](https://www.betydb.org/citations.xml?year=1990&include[]=sites&include[]=yields){target="_blank"}

    Note also that the result of this query will not tell us which site is
    associated with which yield.

1. Return all citations by author Lewandowski in the journal _European Journal
of Agronomy_ along with their associated sites and yields:

    [https://www.betydb.org/citations.xml?journal=European+Journal+of+Agronomy&author=Lewandowski&include[]=sites&include[]=yields](https://www.betydb.org/citations.xml?journal=European+Journal+of+Agronomy&author=Lewandowski&include[]=sites&include[]=yields){target="_blank"}

1. Return citation 1 in JSON format:

    [https://www.betydb.org/citations/1.json](https://www.betydb.org/citations/1.json){target="_blank"}

    Alternatively, we can do:

    [https://www.betydb.org/citations.json?id=1](https://www.betydb.org/citations.json?id=1){target="_blank"}

    This second result is slightly different: It returns a JSON array with a
    single item instead of the item itself.

10. Return citation 1 in JSON format with its associated sites:

    [https://www.betydb.org/citations/1.json?include[]=sites](https://www.betydb.org/citations/1.json?include[]=sites){target="_blank"}

11. Return citation 1 in JSON format with its associated sites and yields:

    [https://www.betydb.org/citations/1.json?include[]=sites&include[]=yields](https://www.betydb.org/citations/1.json?include[]=sites&include[]=yields){target="_blank"}

Regarding the last three examples, although the syntax for returning data
associated with a single entity (citation 1 in these examples) is very
convenient, in general it is best not to rely on fixed id numbers for entities.
"The citation in _Agronomy Journal_ with author Adler" is a more reliable
locator than "The citation with id 1".

## Avoiding Cross-Table Queries: Using the Traits and Yields View

The database view `traits_and_yields_view` provides summary information about
traits and yields: It combines information from the traits and the yields
tables, and it includes information from six associated tables—namely, the
_sites_, _species_, _citations_, _treatments_, _variables_, and _users_ tables.
Whereas the traits and the yields tables contain only pointers to these tables
(foreign keys in the form of id numbers), the `traits_and_yields_view` directly
contains information associated with a trait or yield, such as the _name of the
species_ of the plant whose trait was measured, the _name of the measured
variable_, and the _author and year of the citation_ associated with the trait
or yield.  This means that in many cases, a query of the
`traits_and_yields_view` may be used to extract information that otherwise would
require a complex cross-table query.

Furthermore, looser match rules are possible by using the special key called
`search` instead of a column name.  For example,

[https://www.betydb.org/search.xml?search=cottongrass](https://www.betydb.org/search.xml?search=cottongrass){target="_blank"}

will return all traits and yields for which the common name of the species
includes the word "cottongrass".  To get the same rows using `commonname` as the
key, we would have to do three separate searches:

[https://www.betydb.org/search.xml?commonname=tussock+cottongrass](https://www.betydb.org/search.xml?commonname=tussock+cottongrass){target="_blank"}

[https://www.betydb.org/search.xml?commonname=white+cottongrass](https://www.betydb.org/search.xml?commonname=white+cottongrass){target="_blank"}

[https://www.betydb.org/search.xml?commonname=tall+cottongrass](https://www.betydb.org/search.xml?commonname=tall+cottongrass){target="_blank"}

This is because when we use a column name as the search key, the value must
match the column value _exactly_, including the letter case and the number of
spaces between words.[^fuzzy_matching_in_v1_api]

### Including Unchecked Data in the Traits and Yields View

By default, searches on `traits_and_yields_view` return only checked data.  The
Web interface now has a checkbox labelled "include unchecked records" that the
user may check to override this default.  To do the same thing through the API,
the user must include a clause of the form `include_unchecked=true` in the query
string.  (Any of "TRUE", "yes", "YES", "y", "Y", "1", "t", "T" may be used in
place of "true" here.)

### A Few Notes about Searching the Traits and Yields View

1. The base URL to use is https\://www.betydb.org/search

1. You can use _column name_ keys only when the result format is XML or JSON.
If the result format is CSV or HTML, any query-string clause of the form
`<columnname>=<value>` is ignored.

1. The query-string clauses of the form `search=<value>` and
`include_unchecked=true` may be used with all result formats.

1. If multiple `search=<value>` clauses are included, only last one is used.
**Don't do this!** To search on multiple terms, separate them in the query
string by `+` signs.  For example,
[https://www.betydb.org/search.xml?search=LTER+cottongrass&include_unchecked=true](https://www.betydb.org/search.xml?search=LTER+cottongrass&include_unchecked=true){target="_blank"}
will likely find traits and yields results for cottongrass species at LTER
(Long-term Ecological Research) sites, including those that have not been
checked.

1. As noted in the [Advanced Search Box][Basic search: Searching from the Home
Page] chapter, each word in the value of a `search=<value>` clause must match
one of the columns `sitename`, `city`, `scientificname`, `commonname`,
`cultivar` `author`, `trait`, `trait_description`, `citation_year`, or `entity`
in order for a given row to be included in the search result.  Recall that a
word in the value of the search string _matches_ a column value if it is
textually included in it.

1. Remember that values for column name keys are treated very differently from
the way the value of the `search` key is treated.  In particular, the value is
treated as one unit.  Consider the difference between these two examples: In the
search

    [https://www.betydb.org/search.xml?commonname=white+willow](https://www.betydb.org/search.xml?commonname=white+willow){target="_blank"}

    the search string "white willow" is treated as a unit, and this search will
    return only rows pertaining to the species with commonname "white willow".
    But in the search

    [https://www.betydb.org/search.xml?search=white+willow](https://www.betydb.org/search.xml?search=white+willow){target="_blank"}

    the words "white" and "willow" are considered separately.  So this search
    will, in addition, return (for example) rows for white ash at a site called
    Willow Creek (US-WCr) because "white" matches the species name and "willow"
    matches the site name.


[^apikey-note]: In all of the examples in this section, we have written the
query URLs as though they are to be run in a Web browser after having logged in
to the BETYdb Web site.  To run these queries from the command line or in a
script, you must either pass login credentials with the HTTP call or include a
valid API key in the URL (see the section on [API keys]).

    Using the command-line program `curl` as an example, we could issue the `curl` command

    `curl -u <your login>:<your password> "https://www.betydb.org/species.xml?scientificname=Panicum+virgatum"`

    instead of visiting the given URL in a Web browser.  Or, using an API key
    instead of the `-u` option, we could use the command

    `curl "https://www.betydb.org/species.xml?scientificname=Panicum+virgatum?key=<your API key>"`

[^specie_id_note]: Note the name of the key `specie_id` (which should rightfully be called `species_id`).  This naming is an unfortunate artifact of Rails default schema for naming foreign keys.

[^limiting_results]: Here we have filtered the request response by adding the query string "?search=Salix+caprea".  Otherwise, the response would have tried to include _all_ of the rows in the view.  This may take an inordinately long time and might even time out.

[^search_note]: When searching in HTML format (the normal format when using the search page in the browser) column name parameters are ignored; only the value of the "search" parameters is significant.  For a full list of which columns can be search in which contexts, and of all the search parameters that may be used, consult the [appendix](#appendix).

[^associations]: In reality, it is not `citation_id`'s being a foreign key referencing the `id` column of the `citations` table which is the determining factor here.  Rather, it is a Rails construct that determines whether one table is associated with another.  In this example, it is a line in the Yield model—`belongs_to :citation`—that connects the citations table with the yields table.  Similarly, it is the fact that the `Specie` model has the `has_many :cultivars` that allows us to bring in columns from the cultivars table when querying the species table.  In general, the Rails relations correspond to the SQL ones, but this isn't always the case.  For a full listing of Rails associations, see the [appendix](#appendix).

[^specie_vs_species]: Note that for the purposes of this syntactical requirement (and contrary to reality), "specie" is the singular form of "species".

[^table_relation_rule]: The "real" rule is: use the singular form if the Rails model for the table has a line of the form `belongs_to <singular form of other table>`, and use the actual table name if the Rails model has a line of the form `has_many <other table>`.  See footnote [^associations].

[^fuzzy_matching_in_v1_api]: The newer [v1 api](#v1_api) offers less strict methods of matching by column values.
