# README

Fuzzy Search for finding items by search term and geolocation.

## Setup
#### Dependancies
This application requires Ruby version `2.5.1` and Postgres.
Please ensure both of these are installed before running the next steps.

#### Setup steps
`Clone` this repo and `cd` into project folder

Install gems: `bundle install`

Create and seed the development database:

`rake db:create`

`rake db:migrate`

`rake db:seed`

Start server using: `rails s`

Example query on development

`http://localhost:3000/v1/search?searchTerm=Sony+Camera&lat=51.948&lng=0.172943&radius=20`

### Run Tests
Ensure test database is migrated using 

`rake db:migrate RAILS_ENV=test`

Run tests: `rspec spec`

## Using the API

### GET /search

Usage:
`/v1/search?searchTerm=Example+Term&lat=51.948&lng=0.172943&radius=20`

```
Params
======
searchTerm: a list of words to search on (seperate by + or %20)
lat: latitude
lng: longitude
radius: limits returned results to items within the radius (in km)

* both lat and lng need to be provided to do any sort of geo location search and ordering.
```

## Motivation
#### Rails 5 - API
I used rails-api because it is familiar, quick to get started and provides good support for building JSON APIs.

#### Getting sample data
I generated a `seeds/development.rb` file using `seed_dump` gem and the sample sqlite database provided. This allows us to generate the sample data in the database by running `rake db:seed`

#### Text Search
I started out using a sqlite database with a naive self-rolled `fuzzy_search` scope on the `Item` model. This simply split out the words from the search_string and created multiple LIKE operators for each word. (I tried the `fuzzily` gem which provides Trigram support in SQLite, but hasn't been updated in 3 years and does not have great support for Rails 5).

I then switched to using Postgres as the underlying database to utilise the built in Full Text Search. Leveraging `pg_search` gem to create a new scope called `item_name_search`. This is more performant than the first scope and can easily extend to other fields down the line.

#### Distance Search
I created a `nearby` scope that takes an origin point and finds the closest items to it, ordering by distance away. A radius parameter (optional) will restrict returned items to within that radius. The `geokit` gem provides methods to filter/order results based on a calculated virtual attribute - distance. I indexed item_name, lat and lng fields to improve performance. 


#### Structure and Design
Controllers (and middleware) handle extracting params, caching, rate limiting and returning json response.


`Item` model defines scopes on the Item table and handles validation. The `Item` model is also transformed into acts_as_mappable so that it can use the Geokit `distance_to` method. 

The `Item` model has 3 scopes:

`fuzzy_search` was an initial naive approach using multiple `LIKE` statements (not used)

`item_name_search` uses the `pg_search` gem and postgres’ built in full text search

`nearby` uses `Geokit` gem to order by distance from a supplied origin.


`ItemSearch` model validates the params and decides which scopes to execute. For example if `lat/lng` are not provided it doesn’t execute the `nearby` scope. It returns the results sorted by their relevance score. It separates the responsibility of calculating the scores for each item to a `RelevanceEvaluator` object. This supports open/close principle as we can easily swap in different `RelevanceEvaluators` to calculate the score differently. Without making changes to the `ItemSearch` class.


`RelevanceEvaluator` contains weightings and mechanisms for working out an item’s score. Defaulting to equal weighting between distance and word matching.

#### Improvements
`ItemSearch` currently gets records from the database and then sorts them by score in memory. This gives us a lot of control on how the score is calculated. To combat loading huge results sets in memory, the initial query is limited to 100 records.


Calculating the score in the query itself would be more efficient. It would be great to use something like `PostGis` to dynamically calculate score based on a distance_to function and search_term relevancy in the query.