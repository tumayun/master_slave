# Master Slave
By [Tumayun](http://tumayun.com/).

[![Gem Version](https://badge.fury.io/rb/master_slave.png)](http://badge.fury.io/rb/master_slave)

Rails separate read and write.

# Supported versions

* Ruby >= 2.0.0
* Rails >= 4.1.0

# Install

Put this line in your Gemfile:
```
gem 'master_slave'
```
Then bundle:
```
% bundle
```

# Usage

1. Run command `bundle exec rails g master_slave:config`.

2. Modify config/shards.yml.

```ruby
Class User < ActiveRecord::Base
  ...
end
```

### Random Slave
```ruby
ActiveRecord::Base.slave do
  User.all
end
```
### Specified Slave
```ruby
ActiveRecord::Base.using(:slave_name) do
  User.all
end
```

# Questions, Feedback

Feel free to message me on Github ([tumayun](https://github.com/tumayun/master_slave)) or Gmail (tumayun.2010@gmail.com).

# Contributing to master_slave
* Fork, fix, then send me a pull request.
