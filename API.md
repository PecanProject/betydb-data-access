# The BETYdb Web API

The BETYdb URL-based API allows users to Query data. 

The BETYdb Application Programming Interface (API) is a means of obtaining search or query results in CSV, JSON, or XML format from URL-based queries entered into a Web browser or called from a scripting language such as R, Matlab, or Python (e.g. the rOpenSci traits package). All the tables in BETYdb are RESTful, which allows you to use GET, POST, PUT, or DELETE methods without interacting with the web-browser-based GUI interface. The primary advantage of this approach is the ability to submit complex queries that access information and tables without having to do so through the GUI interface: text-based queries can be recorded with more precision than instructions for interacting with the GUI interface and can be constructed automatically within a scripting language. 


## Versions

* **original**: works but is a little bit clunky and limited.
* **beta** supports inserts and is more standardized than the original. 
* **v1** (November 2011) will work the same as beta, but with additional features


## API keys

Using an API key allows access to data without having to enter a login. To use an API key, simply append `?key=<your key>` to the end of the URL. If the URL already contains a query string, append `&key=<your key>` instead.  Each user must obtain a unique API key.

### For Admins

Users who signed up on previous releases may not have an API key in the database. To create an API key for every existing user, run the command below

    rake bety:make_keys

This command will only be needed once.  To quickly make an API key for a single user, or to change a user's API key, log in to BETYdb, go to the users page, and click on the "key" button in the row for that user.



  
  
  
  