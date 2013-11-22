# Master Slave

Mysql separate read and write.

# Supported versions

* Ruby 1.9.2 +
* Rails >= 3.0.0, < 3.2.0

# Install

Put this line in your Gemfile:
```
gem 'master_slave', github: 'tumayun/master_slave', branch: 'rails_3_0_0'
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
