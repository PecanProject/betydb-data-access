# The BETYdb Web API

The BETYdb URL-based API allows users to query data.

The BETYdb Application Programming Interface (API) is a means of obtaining
search or query results in CSV, JSON, or XML format from URL-based queries
entered into a Web browser or called from a scripting language such as Bash, R,
Matlab, or Python. All the tables in BETYdb are RESTful, which allows you to use
GET, POST, PUT, or DELETE methods without interacting with the web browser-based
GUI interface. The primary advantage of this approach is the ability to submit
complex queries that access information and tables without having to do so
through the GUI interface: text-based queries can be recorded with more
precision than instructions for interacting with the GUI interface and can be
constructed automatically within a scripting language.


## Versions

* **original**: Works but is a little bit clunky and limited.
* **beta**: Is more standardized than the original; supports _inserting_ data as
    well as requesting data (see [Inserting New Traits Via the
    API](https://pecan.gitbooks.io/betydbdoc-dataentry/content/trait_insertion_api.html)
    in the [BETYdb Data Entry
    Workflow](https://pecan.gitbooks.io/betydbdoc-dataentry/content/)
    documentation).
* **v1** (to be released): Will work the same as beta, but with additional features.


## API keys

Using an API key allows access to data without having to log in.  If you do not
already have an API key, you may create one by logging in to the BETYdb Web
site, selecting Users from the Data menu, and clicking the "key" button in the
Action column of the row containing your name.  (Unless you are an adminstrator,
you will only see one row—the one containing your name.)  A new key will then be
displayed in the "Apikey" column.  You may also use this same method to change
your API key if your existing one should become compromised.

To use an API key, simply append `?key=<your key>` to the end of the URL. If the
URL already contains a query string, append `&key=<your key>` instead.

Your API key is unique to you and will have the same data-access permissions as
those associated with your account.

---

#### For administrators

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
