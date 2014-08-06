# Overview

Instant-API automatically creates a REST API from a Rails project
Configuration
---

Instant-API works with Rails (it has been tested with Rails 4.0)

Add the gem to your Gemfile
```ruby
gem 'instant-api'
```

Create an initializer: config/initializers/instant_api.rb
```ruby
require 'instant_api'
InstantApi::Controller::Routes.new.build_controllers
```


Example
---

Let's say, you have these models
```ruby
class Movie < ActiveRecord::Base
  has_and_belongs_to_many :countries
end

class Country < ActiveRecord::Base
  has_and_belongs_to_many :movies
  validates :name, uniqueness: true
end
```

And you want to access these though a Rest API, for instance, your config/routes.rb is

```ruby
YourApp::Application.routes.draw do
  resources :countries do
    resources :movies, only: [:index, :show]
  end
end
```

Be aware that you must create the associations needed in the models to access the data.

The routes generated are

```
                 Prefix Verb   URI Pattern                                                     Controller#Action
         country_movies GET    /countries/:country_id/movies(.:format)                         movies#index
          country_movie GET    /countries/:country_id/movies/:id(.:format)                     movies#show
              countries GET    /countries(.:format)                                            countries#index
                        POST   /countries(.:format)                                            countries#create
            new_country GET    /countries/new(.:format)                                        countries#new
           edit_country GET    /countries/:id/edit(.:format)                                   countries#edit
                country GET    /countries/:id(.:format)                                        countries#show
                        PATCH  /countries/:id(.:format)                                        countries#update
                        PUT    /countries/:id(.:format)                                        countries#update
                        DELETE /countries/:id(.:format)                                        countries#destroy
```

Start your app and then you can make the following calls:

* Create
```bash
> curl -X POST -d "country[name]=Japón;country[english_name]=Japan" http://localhost:3000/countries
{
  "id": 87,
  "name": "Japón",
  "created_at": "2014-08-03T15:09:35.611Z",
  "updated_at": "2014-08-03T15:09:35.611Z",
  "english_name": "Japan"
}
```


* Index, pagination paremeters: page, per_page
````bash
> curl -s -X GET http://localhost:3000/countries?page=2&per_page=4
{
  "collection": [
    {
      "id": 5,
      "name": "Netherlands",
      "created_at": "2010-09-16T23:46:07.000Z",
      "updated_at": "2013-01-28T17:32:01.000Z",
      "english_name": "Netherlands"
    },
    {
      "id": 6,
      "name": "Germany",
      "created_at": "2010-10-21T16:53:52.000Z",
      "updated_at": "2013-01-28T17:29:12.000Z",
      "english_name": "Germany"
    },
    {
      "id": 7,
      "name": "New Zealand",
      "created_at": "2010-10-21T16:55:30.000Z",
      "updated_at": "2013-01-28T17:32:01.000Z",
      "english_name": "New Zealand"
    },
    {
      "id": 8,
      "name": "Japan",
      "created_at": "2010-10-21T16:59:02.000Z",
      "updated_at": "2013-01-28T17:32:00.000Z",
      "english_name": "Japan"
    }
  ],
  "pagination": { "count": 84, "page": 2, "per_page": 4 }
}
```

* Show
```bash
> curl -s -X GET http://localhost:3000/countries/5
{
  "id": 5,
  "name": "Netherlands",
  "created_at": "2010-09-16T23:46:07.000Z",
  "updated_at": "2013-01-28T17:32:01.000Z",
  "english_name": "Netherlands"
}
```

* Delete
```bash
> curl -s -X DELETE http://localhost:3000/countries/87
```

* Update
```bash
> curl -s -X PUT -d "country[name]=Holanda" http://localhost:3000/countries/5
{
  "id": 5,
  "name": "Holanda",
  "created_at": "2010-09-16T23:46:07.000Z",
  "updated_at": "2014-08-03T16:18:03.215Z",
  "english_name": "Netherlands"
}
```

* New
```bash
> curl -s -X GET http://localhost:3000/countries/new
```

* Edit
```bash
> curl -s -X GET http://localhost:3000/countries/3/edit
{
  "id": 3,
  "name": "United States",
  "created_at": "2010-09-16T23:45:48.000Z",
  "updated_at": "2013-01-28T17:32:00.000Z",
  "english_name": "United States"
}
```


All these methods works at any level:

```bash
> curl -s -X GET http://localhost:3000/countries/1/movies?page=2&per_page=3
{
  "collection": [
    {
      "id": 202,
      "title": "Good Night. And Good Luck",
      "original_title": "Good Night. And Good Luck",
      "year": 2005,
      "duration": 90,
    },
    {
      "id": 207,
      "title": "L'amant",
      "original_title": "L'amant",
      "year": 1992,
      "duration": 115,
    },
    {
      "id": 239,
      "title": "Tess",
      "original_title": "Tess",
      "year": 1979,
      "duration": 170,
    }
  ],
  "pagination": { "count": 64, "page": 2, "per_page": 3 }
}

> curl -s -X GET http://localhost:3000/countries/1/movies/202
{
  "id": 202,
  "title": "Good Night. And Good Luck",
  "original_title": "Good Night. And Good Luck",
  "year": 2005,
  "duration": 90
}
````

Errors

If there's any error creating or updating, it will be return with a 422 HTTP error

```bash
> curl -s -X POST -d "name=Japan" http://localhost:3000/countries
{ "errors": [["name", ["has already been taken"]]] }

> curl -s -X PUT -d "country[name]=Holanda" http://localhost:3000/countries/6
{ "errors": [["name", ["has already been taken"]]] }
```

If we ask for a resource that doesn't exists, a 404 HTTP error will be return

```bash
> curl -s -X GET http://localhost:3000/countries/666
{ "errors": { "field": "id", "message": "Couldn't find Country with id=666" } }
```



# TODO

- Integration with a authentication mechanism, API only available to authenticated users
- Implementation of a cache
- Configure the response json
- Any request/opinion/PR is more than welcome


# License

Instant-API is released under the [MIT License](http://www.opensource.org/licenses/MIT).


![Code Climate](https://codeclimate.com/github/miquelbarba/instant-api.png)

