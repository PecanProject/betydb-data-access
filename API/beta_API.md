# The Beta API

This page provides a general description of how to access data using the (newer)
beta version of the BETYdb API.  For a list of URLs of API endpoints, visit
{{book.BETYdb_URL}}/api/docs.

## API endpoints for table listings

The paths for these endpoints are generally of the form `/api/beta/<table
name>[.<extension>]`.  Most tables of interest are exposed.  The extension
determines the format of the returned result and may be either "json" or "xml".
The extension is optional; if not given, the result is returned in JSON format.

### Format of table listing requests

A GET request may be sent to any of the paths listed on the `/api/docs` page
(see above).  (The path should of course be preceded by the HTTP protocol (http
or https) and the hostname.)  To authenticate, you may use the parameter _key_,
setting it to the user's API key (see the section on [API
keys](../Api.html#api-keys)).[^apikey_details]

###### Example

To get all[^default_limit] of the trait information from the traits table on the
betydb.org site, send a request to

{{book.BETYdb_URL}}/api/beta/traits

(As in the previous section, [Original API](../original_api.md), we write the
example URLs as though they are to be visited in a browser after having logged
in to www.betydb.org.  For more information, including how to send the HTTP
requests using curl, visit [this footnote](../original_api.md#fn_1) on that
page.)


#### Implicit restriction of results

##### Limit and Offset

Be default, the size of returned results is limited to 200 rows.  To get around
this limit, or to impose a smaller limit, use the `limit` parameter.

###### Example

To get a list of _all_ citations, visit
{{book.BETYdb_URL}}/api/beta/citations?limit=none

The `limit` parameter may be combined with an `offset` parameter to "shift the
window" of returned results.

###### Example

Requests to the following three URLs should[^offset_caveat] return three
distinct groups of results of 10 rows each:

{{book.BETYdb_URL}}/api/beta/species?limit=10

{{book.BETYdb_URL}}/api/beta/species?limit=10&offset=10

{{book.BETYdb_URL}}/api/beta/species?limit=10&offset=20

##### Restricted data

Unless the account associated with the specified API key has administrative
access, certain rows are filtered out of the traits, yields, and users tables.
In particular, non-administrators visiting the path `/api/beta/users` will only
see the single row corresponding to their own account.

#### Filtering results with exact matching

In order to filter the returned results, parameters specifying required column
values can be added to the query string.

###### Example

To find all species in the family Orchidaceae, add `Family=Orchidaceae` to the
query string:

{{book.BETYdb_URL}}/api/beta/species?Family=Orchidaceae&limit=none

Exact matching may be used on any column of the table being queried.  It works
best with integer and textual data types.

##### Exact Matching Caveats

1. Textual matchings are case- and whitespace-sensitive.

 ##### Example

 To find full information about sweet orange, you could do the API call

 {{book.BETYdb_URL}}/api/beta/species?limit=250&scientificname=Citrus+×+sinensis

 (Note here that the spaces in the name must be URL-encoded as a `+` symbol when
 used in the query string.)  But if you do

 {{book.BETYdb_URL}}/api/beta/species?limit=250&scientificname=Citrus+×sinensis

 instead (with no space between the `×` and the species name), you won't get the
 result you want.

2. Certain symbols that look very much alike are not interchangeable.

 In the previous example, if you had used the letter "x" instead of the times
symbol "×", the API call wouldn't have returned the desired result.  (You could
have, however, used "%C3%97" in place of "×": "%C3%97" is the URL encoding of
"×".)

3. Date/Time may not match as expected.

 To match a column value having data type "timestamp", you must exactly match
the PostgreSQL textual representation of that timestamp.  In general, this is
not the same as the representation displayed by the query result.  For example,
a query that filters by creation time using the key-value string
`created_at=2010-10-22+13:59:26` may return results where the "created_at" value
is `2010-10-22T08:59:26-05:00`.  This is because the "created_at" column has
type "timestamp without time zone" and because Rails stores timestamps in UTC
but displays them in local time showing the timezone offset.  Moreover, whereas
SQL separates the date and time parts of a timestamp with a space, Rails
displays a "T" between the two parts.

4. Numerical types match as numbers.

 For integers, this means that could (somewhat perversely) match an id number of
26536 using the key-value pair `id=+++%2B26536+++` in the query string.  Here,
"%2B" is the URL-encoded version of the plus sign, and the "+" symbols are
URL-encodings of spaces.

 For floating point numbers, some rounding is done when matching values, but not
much.  For example, the key-value string "stat=0.18299999999999999" may return a
trait having stat value 0.183 whereas the string "stat=0.1829999999999" may not.

#### Matching using regular expressions

To turn on regular expression matching, use the symbol "~" as the first symbol
of the value in any key-value pair.

###### Example

To find all sites with the string "University" in their sitename, do the API call

{{book.BETYdb_URL}}/api/beta/sites?sitename=~University

Note that regular expressions are not anchored by default.  To return only those
sites whose sitename begins with "University", use the regular-expression anchor
symbol "^" at the beginning of the string:

{{book.BETYdb_URL}}/api/beta/sites?sitename=~%5EUniversity

(Here, "%5E" is the URL-encoding of "^".)

We can use regular expression matching to alleviate some of the problems with
exact matching mentioned above.  For example, to find all trait rows that were
updated in the middle part of March 2015, we could do an API call like

{{book.BETYdb_URL}}/api/beta/traits?limit=250&updated_at=~2015-03-1


This will find all traits updated from March 10 through March 19, 2015 UTC.

### Format of Returned Results

The beta API suports two response formats: JSON and XML.  This is a very brief
description of the information contained in the response and how that
information is presented in each format.

#### General outline of information returned.

Every response is divided into two or more of the following main sections:

* metadata

  The metadata in the response contains the following three items:

  * URI: The URI requested in the GET request.
  
  * timestamp: The date and time of the request.

  * count: The number of rows of data represented in the response or `null` if
    there was an error in the request.

* errors

  The error or list of errors associated with the request.  If no errors
  occurred, the item will be omitted.

* warnings

  Any warnings associated with the request.  This item is omitted if there are
  no warnings.

* data

  This is main item of interest in a successful request.  (It is omitted if the
  request is unsuccessful.)  It contains all the rows of the table associated
  with the URI path that are not filtered out by request parameters (subject to
  access restrictions and the default size limit).

#### Content of returned data: JSON format

The value of the "data" property will be a JSON array consisting of zero or more
JSON objects, each of which represents one row of the database table
corresponding to the API endpoint in the request.  Each of these objects has a
single property whose name is usually the singular form of the table being
represented.  For example, in a request to the API path `/api/beta/traits`, the
property name will be "trait".  The value of this property is itself a JSON
object, one having a property for each column of the represented database table.
The data portion of a typical trait request will look something like this:
```json
"data": [
    {
        "trait": {
            "id": 36854,
            "site_id": 593,
            "specie_id": 19066,
            "citation_id": 375,
            "cultivar_id": null,
            "treatment_id": 1199,
            "date": "2002-07-21T19:00:00-05:00",
            "dateloc": "5.0",
            ...
            ...
        },
        "trait": {
            "id": 22320,
            "site_id": 76,
            "specie_id": 938,
            "citation_id": 18,
            "cultivar_id": 10,
            "treatment_id": 743,
            "date": "2006-04-25T19:00:00-05:00",
            "dateloc": "5.5",
            ...
            ...
        },
        ...
        ...
    }
]
```


##### Additional properties

In addition to a property for each column of the represented database table, the
data JSON objects will also contain the following:

* A property for certain associated tables that are in a many-to-many or
  many-to-one relationship with this table.

  For example, the value of each _site_ property returned in a request to path
  `/api/beta/sites` will be an object containing the properties "number of associated
  citations", "number of associated sitegroups", "number of associated yields", etc.

  Note that properties corresponding to join tables are generally omitted.  For
  example, a "site" object will have a property "number of associated citations"
  but not "number of associated citations\_sites".

* A `view_url` property.

  This property shows the "show" URL for the Web page that displays the item in
  HTML format.  This page will usually contain an "Edit" link for editing the
  item.

##### Representation of column values

For the property values corresponding to table columns, there are at least two
cases where the form in which they are represented in the JSON response is
slightly different from the form returned by a direct query of the database
using a client such as psql.

1. timestamps

  The form returned by the API is `YYYY-MM-DDTHH:MM:SS[+|-]HH:MM` whereas psql
  will display a timestamp in the form `YYYY-MM-DD HH:MM:SS.nnnnnn`.  That is,
  the API (a) separates the date and the time with the character "T" where psql
  uses a space, (b) shows a timezone offset where psql simply returns a time
  with no offset (assumed to be UTC), and (c) does not show fractional seconds.

2. geometries

  The API displays the sites.geometry column in human-readable form (for example,
  "POINT (-68.1069 44.8708 265.0)") whereas psql does not.

#### Content of returned data: XML format

The information content of the data in an XML response is exactly the same as
that of a JSON response.  In general, where JSON has a property name and a
property value, XML will have an XML element with a corresponding name and
content corresponding to the value.  But note the following:

1. The root element of the XML response is named "hash" (this may change).

2. For JSON properties having non-textual simple values, the corresponding XML
element will have a "type" attribute stating the type of the value.

  For example, the start tag for the element representing the "id" column is `<id
  type="integer">`.  The start tag for the "created_at" column is `<created-at
  type="datetime">`.  Note that the types shown are Ruby types, not SQL types.

3. For JSON properties whose values are JSON arrays, the corresponding XML
element will have an attribute `type="array"`.

4. Underscores in property names become hyphens in XML element names.

5. Both NULLs and empty string values in the database are represented in XML by
empty elements having the attribute `nil="true"`.[^null_vs_empty]

6. The XML response has an element whose name matches the database table name.

  For example, a request to the path `/api/beta/sites.xml` returns a result whose
  data portion looks like

  ```xml
  <data>
    <sites type="array">
      <site>
        <id type="integer">...
        ...
        ...
      </site>
      <site>
        <id type="integer">...
        ...
        ...
      </site>
      ...
      ...
      ...
    </sites>
  </data>
  ```

## API endpoints for individual items

The paths for these endpoints are generally of the form

```
/api/beta/<table name>/<id number>[.<extension>]
```

Again, most tables of interest are exposed, and the extension (if given)
determines the format of the returned result (JSON by default).

### Parameters for individual-item API endpoints

The only required parameter—indeed, the only _recognized_ parameter—is the "key"
parameter specifying the user's API key.

### Format of Returned Results

In general, a request of the form

```bash
curl "http[s]://<hostname>/api/beta/<table name>/nnn.json?key=<your api key>
```

will return nearly the same result as the request

```bash
curl "http[s]://<hostname>/api/beta/<table name>.json?key=<your api key>&id=nnn
```

Here are the main differences:

1. There will be no _count_ property in the metadata.  If the request is
  successful, the response will contain data about exactly one item.

2. The value of the "data" property will be a single JSON object rather than a JSON array.

3. If the table being queried is in a many-to-one relationship to some other
table, full information will be included about the referred-to item.  For
example, {{book.BETYdb_URL}}/api/beta/cultivars.json?id=55 will show the id of
the species associated with cultivar 55, but
{{book.BETYdb_URL}}/api/beta/cultivars/55.json will show full information about
the species.

4. For one-to-many or many-to-many associations, the _individual item_ form of
the request will return a list of associated items, not just a count of the
number of associated items.

These differences carry over _mutatis mutandis_ to XML-format requests.


---
<!-- IMPORTANT: Keep footnotes to a single line if you want the "return" link to appear at the end of the footnote. -->
[^apikey_details]: If you enter these API URLs in a browser after logging into the host site, you needn't include the API key in the query string.  Thus, to see a list of traits, you could just enter {{book.BETYdb_URL}}/api/beta/traits into your browser's address box after logging in to www.betydb.org.  This will save much typing as you try out examples.

[^default_limit]: Actually, this retrieves only the first 200 rows, 200 being the default size limit of the response.

To get more than 200 results, set an explicit limit using the `limit` parameter;
for example,
{{book.BETYdb_URL}}/api/beta/traits?limit=550

If you want to ensure that _all_ rows are returned, use the special limit value
"all" (or equivalently, "none", that is, _no limit_):

{{book.BETYdb_URL}}/api/beta/traits?limit=all

[^offset_caveat]: Use of _offset_ may not give consistent results.  To quote from the PostgreSQL documentation:

> The query optimizer takes LIMIT into account when generating query plans, so
> you are very likely to get different plans (yielding different row orders)
> depending on what you give for LIMIT and OFFSET. Thus, using different
> LIMIT/OFFSET values to select different subsets of a query result will give
> inconsistent results unless you enforce a predictable result ordering with
> ORDER BY.

The beta API does not (yet) support specifying the order of results.

[^null_vs_empty]: This is one case in which the XML response contains less information that the JSON response.  Whereas JSON displays `""` and `null` respectively for empty strings and NULLs, XML shows `nil="true"` in both cases.

