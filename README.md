Volusion API - Ruby Client
==========================

This library provides a wrapper around the Volusion REST API for use within
Ruby apps or via the console.

Note
----

**
- Volusion api will allow only one request of an api call. Afterwards, a reset action should by done in the admin panel
However, currently when using api calls with a "WHERE" clause, the calls are re-usable
**

Requirements
------------

- Ruby 1.8.7+
- Rubygems
- multi_xml

To connect to the API, you need the following credentials:

- volusion store domain
- Username of an authorized admin user of the store
- encrypted password for the above admin user

#Important: Admin password is changed every 90 days, resulting in the need to change the encrypted password for the api authentication



Installation
------------

Download the lib folder and copy it to a path accessible within your app, or
install the package directly from Rubygems:

```
gem install volusion
```

Configuration
-------------

To use the API client in your Ruby code, provide the required credentials as
follows:

```
require 'volusion'

api = Volusion::Api.new({
	:store_url => "http://store.myvolusionstore.com",
	:username  => "admin",
	:encrypted_password   => "d81aada4c19c34d913e18f07fd7f36ca"
})
```

Connecting to the store
-----------------------

Ping: the ping method allows to check that your configuration is working and you
can connect successfully to the store:

```
api.ping
```

will raise a Volusion::Error:InvalidCredentials Exception when credentials are wrong

Usage
-----

The supports the following exports:
1. get_products
2. get_orders
3. get_customers

each of the above functions receives hash with the following optional values:
1. select_fields - an array or a comma separated string of Volusion available select fields
2. conditions - an hash (one element, since for now Volusion supports only one condition per request) with the Volusion field as a key
   and the wanted value as the hash value

For Example:

```
$ irb
>
> api = Volsuion::Api.new(...)
>
> api.get_products({:select_fields => ['p.ProductID', 'p.ProductName'], :conditions => {:p.ProductID => 2}})
>
>
```

will result in returning the product id and name of product with id 2
#By default each request will return all available fields

