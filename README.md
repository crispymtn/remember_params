# RememberParams
Rails gem that makes actions remember GET params like keywords and page.

## Scenario

Say you have that index action where you can search, filter and
paginate through records. Once you click on one of the records
you lose track of the exact location (e.g. search keywords,
filter settings or page).

RememberParams will bring users back to that exact location when
they return to the index page by remembering the search keywords,
filter settings and page.

## Usage

To make a controller action remember its params simply add the
`remember_params` line on top like this:

```ruby
class BooksController < ApplicationController
  remember_params :keywords, :page # defaults are on: index and duration: 1.hour
  remember_params :client_id, on: :client_list, duration: 1.minute
end
```

Browsing the action without any params will automatically try to restore
params and redirect to the same route but with previously set params.

If for example you have the `keywords` params remembered and follow a link
with only a `page` param, the remembered `keywords` param and the newly set
`page` param will be mixed.

Reset all remembered params like this:

```ruby
link_to 'Books', books_path(reset_params: true)
```

You can also mix reset_params and setting new params.

```ruby
link_to 'Books', books_path(reset_params: true, page: 2)
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'remember_params'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install remember_params
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
