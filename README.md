# activerecord-time-scope

[![Gem Version][gem-image]][gem-link]
[![Dependency Status][deps-image]][deps-link]
[![Build Status][build-image]][build-link]
[![Coverage Status][cov-image]][cov-link]
[![Code Climate][gpa-image]][gpa-link]

Add various time-related scopes for ActiveRecord!

## Installation

Add the activerecord-time-scope gem to your Gemfile.

```ruby
gem "activerecord-time-scope"
```

And run `bundle install`.

## Usage

### Time

This gem automatically create scopes for time-related columns of your ActiveRecord model such as 'created_at'.

```ruby
class Foo < ActiveRecord::Base
end
```

Then,

```ruby
Foo.created_before 3.days.ago
Foo.created_after 3.days.ago
Foo.created_within 3.days.ago, 3.days.from_now
```

Any columns with `_at`, `_on`, `_time` and `_date` postfix are considered as time-related columns.

### Time Range

If you want scopes for time ranges, you can create it manually.

```
class Round < ActiveRecord::Base
  create_time_range_scope :run, :start_at, :end_at
end
```

Then,

```
Round.run_before 3.days.ago
Round.run_after 3.days.ago
Round.run_within 3.days.ago, 3.days.from_now
```

will be available for the class!

## TODO

- Handle overwrapped cases
- Include equal operators

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2014 Daisuke Taniwaki. See [LICENSE](LICENSE) for details.




[gem-image]:   https://badge.fury.io/rb/activerecord-time-scope.svg
[gem-link]:    http://badge.fury.io/rb/activerecord-time-scope
[build-image]: https://secure.travis-ci.org/dtaniwaki/activerecord-time-scope.png
[build-link]:  http://travis-ci.org/dtaniwaki/activerecord-time-scope
[deps-image]:  https://gemnasium.com/dtaniwaki/activerecord-time-scope.svg
[deps-link]:   https://gemnasium.com/dtaniwaki/activerecord-time-scope
[cov-image]:   https://coveralls.io/repos/dtaniwaki/activerecord-time-scope/badge.png
[cov-link]:    https://coveralls.io/r/dtaniwaki/activerecord-time-scope
[gpa-image]:   https://codeclimate.com/github/dtaniwaki/activerecord-time-scope.png
[gpa-link]:    https://codeclimate.com/github/dtaniwaki/activerecord-time-scope

