Fresh Redis
===========

A simple, JSON-oriented wrapper around Redis that provides easy mechanisms for keeping your cache fresh.

### Retrieve a cached value stored under key "foo"
```ruby
FreshRedis.get("foo")
```

### Set a cached an evaluated value under key "foo" with an expiration time of 5 minutes
```ruby
FreshRedis.freshen("foo", 5.minutes, :ruby) do
  {your_age: 30}
end
```

This will return the value as a Ruby object (Hash, Array, etc)

* 'freshen' will freshen the value if the expiration time has expired and will return the cached value if it hasn't.
* 'freshen' will always return the value whether it's retrieved from the cache or it's evaluated in the block.  That means it's a great choice for wrapping existing expensive code in a block for out-of-the-box caching.

If you know you'll be returning JSON, you can skip the parsing of the stored JSON into a Ruby object by specifying the format as :json for extra performance.

```ruby
FreshRedis.freshen("foo", 5.minutes, :json) do
  {your_age: 30}
end
```

### Set a value under key "foo" with no expiration
```ruby
  FreshRedis.set("foo", {your_age: 30})
```

### Unset the value under key "foo"
```ruby
  FreshRedis.unset("foo")
```

That's it!

My most common use-case is this:

```ruby
response.content_type = "application/json"

return render text: FreshRedis.freshen("dude_this_is_expensive", 5.minute, :json) do
  calculate_and_return_some_expensive_thing
end
```
