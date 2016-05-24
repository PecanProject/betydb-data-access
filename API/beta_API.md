# The Beta API

This page provides a general description of how to access data via the new beta
version of the BETYdb API.  For a list of URLs of API endpoints, visit
https://www.betydb.org/api/docs.

## API endpoints for table listings

The paths for these endpoints are generally of the form `/api/beta/<table
name>[.<extension>]`.  Most tables of interest are exposed.  The extension
determines the format of the returned result and may be either "json" or "xml".
The extension is optional, and if not given, the result is returned in JSON
format.

## Format of table listing requests

A GET request may be sent to any of the paths listed on the /api/docs page (see
above).  (The path should be preceded by the HTTP protocol (http or https) and
the hostname of course.)  The only required parameter is "key" which is the
user's API key.[^1] (To view your API key, log in to the BETYdb Web interface,
go to the users list page, and look in the Apikey column.)

##### Example

To get all[^2] of the trait information from the traits table on the betydb.org
site using `curl`, do
```bash
curl "https://www.betydb.org/api/beta/traits?key=<your api key>"
```

In examples from now on, we will put simply `key=` in the query string instead
of `key=<your api key>`.  This way, if you are logged in to www.betydb.org, the
example can be run simply by pasting the URL shown into your browser's address
box (see footnote [^1]).


### Implicit restriction of results

#### Limit and Offset

Be default, the size of returned results is limited to 200 rows.  To get around
this limit, or to impose a smaller limit, use the `limit` parameter.

##### Example

To get a list of _all_ citations, do
```bash
curl "https://www.betydb.org/api/beta/citations?key=&limit=none"
```

The `limit` parameter may be combined with an `offset` parameter to "shift the
window" of returned results.

##### Example

The following three requests should[^3] return three distinct groups of results
of 10 rows each:
```bash
curl "https://www.betydb.org/api/beta/species?key=&limit=10"
curl "https://www.betydb.org/api/beta/species?key=&limit=10&offset=10"
curl "https://www.betydb.org/api/beta/species?key=&limit=10&offset=20"
```

#### Filtering out restricted information

Unless the account associated with the specified API key has administrative
access, certain information is filtered out of the traits, yields, and users
tables.  In particular, non-administrators visiting the path `/api/beta/users`
will only see the single row corresponding to their own account.

### Filtering results with exact matching

In order to filter the returned results, parameters specifying required column
values can be added to the query string.

##### Example

To find all species in the family Orchidaceae, add `Family=Orchidaceae` to the
query string:

```bash
curl "https://www.betydb.org/api/beta/species?key=&Family=Orchidaceae&limit=none
```

Exact matching may be used on any column of the table being queried.  I works
best with integer and textual data types.

#### Exact Matching Caveats

1. Textual matchings are case- and whitespace-sensitive.

##### Example

To find full information about sweet orange, you could do the API call
```
http://bety-dev:3000/api/beta/species?key=&limit=250&scientificname=Citrus+×+sinensis
```

(Note here that the spaces in the name must be URL-encoded as a `+` symbol when
used in the query string.)  But if you do

```
http://bety-dev:3000/api/beta/species?key=&limit=250&scientificname=Citrus+×sinensis
```

instead (with no space between the `×` and the species name), you won't get the
result you want.

2. Certain symbols that look very much alike are not interchangeable.

In the previous example, if you had used the letter "x" instead of the times
symbol "×", the API call wouldn't have returned the desired result.  (You could
have, however, used "%C3%97" in place of "×": "%C3%97" is the URL encoding of
"×".)

3. Date/Time may not match as expected.

To match a column value having data type "timestamp", you must exactly match the
PostgreSQL textual representation of that timestamp.  In general, this is not
the same as the representation display by the query result.  For example, a
query that filters by creation time using the key-value string
"created_at=2010-10-22+13:59:26" may return results where the "created_at" value
is "2010-10-22T08:59:26-05:00".  This is because the "created_at" column has
type "timestamp without time zone" and because Rails stores timestamps in UTC
but displays them in local time showing the timezone offset.  Moreover, Rails
displays the timestamp with a "T" between the date and time parts where SQL has
a space.

4. Numerical types match as numbers.

For integers, this means that could (somewhat perversely) match an id number of
26536 using the key-value pair "id=+++%2B26536+++" in the query string.  Here,
"%2B" is the URL-encoded version of the plus sign, and the "+" symbols are
URL-encodings of spaces.

For floating point numbers, some rounding is done when matching values, but not
much.  For example, the key-value string "stat=0.18299999999999999" may return a
trait having stat value 0.183 whereas the string "stat=0.1829999999999" may not.

### Matching using regular expressions

To turn on regular expression matching, use the symbol "~" as the first symbol
of the value in any key-value pair.

##### Example

To find all sites with the string "University" in their sitename, do the API call

```
curl "https://www.betydb.org/api/beta/sites?sitename=~University&key="
```

Note that regular expressions are not anchored by default.  To return only those
sites whose sitename begins with "University", use the regular-expression anchor
symbol "^" at the beginning of the string:

```
curl "https://www.betydb.org/api/beta/sites?sitename=~%5EUniversity&key="
```

(Here, "%5E" is the URL-encoding of "^".)

We can use regular expression matching to alleviate some of the problems with
exact matching mentioned above.  For example, to find all trait rows that were
updated in the middle part of March 2015, we could do an API call like

```
curl "https://www.betydb.org/api/beta/traits?key=&limit=250&updated_at=~2015-03-1
```

This will find all traits updated from March 10 through March 19, 2015 UTC.

## Format of Returned Results



---
[^1] If you enter these API URLs in a browser after logging into the host site,
you don't actually need to use a valid API key.  The `key` parameter must still
be present, but you don't need to use a corresponding value.  Thus, to see a
list of traits, you could just enter
`https://www.betydb.org/api/beta/traits?key=` into your browser's address box
after logging in to www.betydb.org.  This will save much typing as you try out
examples.

[^2] Actually, this retrieves only the first 200 rows, 200 being
the default size limit of the response.  To get more than 200 results, set an
explicit limit using the `limit` parameter; for example,
```bash
curl "https://www.betydb.org/api/beta/traits?key=&limit=550"
```

Note that it is especially important to quote the URL here as otherwise the `&`
symbol will be interpreted by the shell instead of as part of the URL.

If you want to ensure that _all_ rows are returned, use the special limit value
"all" (or equivalently, "none", that is, _no limit_):

```bash
curl "https://www.betydb.org/api/beta/traits?key=&limit=all"
```

[^3] Use of offset may not give consistent results.  To quote from the PostgreSQL documentation:

> The query optimizer takes LIMIT into account when generating query plans, so
> you are very likely to get different plans (yielding different row orders)
> depending on what you give for LIMIT and OFFSET. Thus, using different
> LIMIT/OFFSET values to select different subsets of a query result will give
> inconsistent results unless you enforce a predictable result ordering with
> ORDER BY.

The beta API does not (yet) support specifying the order of results.


