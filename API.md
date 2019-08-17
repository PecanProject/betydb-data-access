# The BETYdb Web API

The BETYdb URL-based API allows users to fetch and query data.

The BETYdb _Application Programming Interface_ (API) is a means of obtaining
search or query results in CSV, JSON, or XML format using URL-based queries.
These queries may be entered into a Web browser or called from a scripting
language such as Bash, R, MATLAB, or Python.  BETYdb strives to be a RESTful Web
service, and nearly all the tables in BETYdb and the individual rows within
those tables are treated as Web-addressable resources having their own URL.

Note that although the Web browser-based GUI interface to BETYdb allows for the
full complement of common HTTP methods (GET, POST, PUT, and DELETE), at this
point, for most of these resources, the API supports only the GET method.  The
one exception is the API for inserting new traits into the traits table, which
uses the POST method.  This document treats only the GET methods of the API.
For information about _POST_-ing new data via the API, see [Inserting New Traits
Via the
API](https://pecanproject.github.io/bety-documentation/dataentry/inserting-new-traits-via-the-api.html){target="_blank"}
in the [BETYdb Data Entry
Workflow](https://pecanproject.github.io/bety-documentation/dataentry/index.html){target="_blank"}
manual.


While all of the GET requests provided by the API may be used inside a Web
browser, when we think of an _API_, we usually have some sort of programmatic
interaction in mind.  The primary advantage of this approach is the ability to
submit complex queries that access information without having to do so through
the GUI interface: text-based queries can be recorded with more precision than
can instructions for interacting with the GUI interface, and they can be
constructed automatically within a scripting language.  Entering the URL of an
API-provided resource into a Web browser's address box, however, is a convenient
way to get a feel for how the API works, what information it makes available,
and how that information is presented.


## Versions

* **original**: Works but is a little bit clunky and limited.
* **beta**: Is more standardized than the original; supports _inserting_ data as
    well as requesting data (see [Inserting New Traits Via the
    API](https://pecanproject.github.io/bety-documentation/dataentry/inserting-new-traits-via-the-api.html){target="_blank"}
    in the [BETYdb Data Entry
    Workflow](https://pecanproject.github.io/bety-documentation/dataentry/index.html){target="_blank"}
    documentation).
* **v1** (to be released): Will work the same as beta, but with additional features.


## API keys

Using an API key allows access to data without having to log in.

If you do not already have an API key, you may create one by logging in to the
BETYdb Web site, selecting "Users" from the Data menu, and clicking the "key"
button in the Action column of the row containing your name.  (Unless you are an
administrator, you will only see one row—the one containing your name.)  A new
key will then be displayed in the "Apikey" column.  You may also use this same
method to change your API key if your existing one should become compromised.

To use an API key, simply append `?key=<your API key>` to the end of the URL. If
the URL already contains a query string, append `&key=<your API key>` instead.

Your API key is unique to you and will have the same data-access permissions as
those associated with your account.

To view your API key at any time, log in to the BETYdb Web interface, go to the
users list page, and look in the _Apikey_ column.

---

### For administrators {-}

API keys are automatically generated for new users, but users who signed up on
previous releases may not have an API key in the database. To create an API key
for every existing user who doesn't already have one, run the command

    rake bety:make_keys

in the Rails root directory.  (You may need to prepend `bundle exec` to this
command, especially if you are not using a Ruby version manager.)

This command will not change existing keys.  If for some reason you _want_ to
change the keys of all existing users, you must first log in to the BETYdb
database and update the users table, setting the `apikey` column value for every
user to `null`.  After this, run the `rake` command to give all users a new API
key.
