# RememberParams
Rails gem that makes actions remembers GET params like keywords and page.

## Scenario

Say you have that index action where you can search, filter and
paginate through records. Once you click on one of the records
you lose track of the exact location (that is search keywords,
filter settings and page).

RememberParams will bring users back to that location when they
return to the index page by remembering the search keywords,
filter settings and page.

## Usage

To make a controller action remember its params simply add the
`remember_params` line on top like this:

```ruby
class BooksController < ApplicationController
  remember_params :keywords, :page # defaults are index and 1 hour
  remember_params :client_id, on: :client_list, for: 1.minute
end
```

Browsing the action without any params will automatically try to restore
params and redirect to the same location but with previously set params.

To reset params set them to empty string:

```ruby
link_to 'Books', books_path(keywords: '', page: '')
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
