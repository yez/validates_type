## validates_type

### Rails type validating for fields

#### Purpose

Most Rails applications will have types coerced by their ORM connection adapters (like the `pg` gem or `mysql2`). However, this only useful for applications with very well defined schemas. If your application has a legacy storage layer that you can no longer modify or a lot of `store_accessor` columns, this solution is a nice middle ground to ensure your data is robust.

#### Usage

```ruby
class Foo < ActiveRecord::Base

  # validate that attribute :bar is a String
  validates_type :bar, :string

  # validate that attribute :baz is an Integer
  validates_type :baz, :integer

  # validate that attribute :qux is an Array
  validates_type :qux, :array

  # validate that attribute :whatever is a Boolean
  validates_type :whatever, :boolean
end
```

#### Supported types

- `:array`
- `:boolean`
- `:float`
- `:hash`
- `:integer`
- `:string`
- `:symbol`
