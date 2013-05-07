Redis-Cleaner [![Build Status](https://travis-ci.org/lloydmeta/redis-cleaner.png?branch=master)](https://travis-ci.org/lloydmeta/redis-cleaner) [![Code Climate](https://codeclimate.com/github/lloydmeta/redis-cleaner.png)](https://codeclimate.com/github/lloydmeta/redis-cleaner)
-------------

A simple way of cleaning up a large number of Redis keys via [pattern matching](http://redis.io/commands/keys)

Example Usage
=========

Instantiating a redis_cleaner

```ruby
# Timeout needs to be set, because KEYS is run on the Redis-server
# side, which is potentially slow -> O(n) where n is the number of keys
redis_config = {
  host: "127.0.0.1",
  port: 6390,
  timeout: 60
}

redis_cleaner = RedisKeyCleaner.new(Redis.new(redis_config), "./borked_keys")
```

Separate dumping and cleaning

```ruby
redis_cleaner.dump_matching_keys_to_temp_file("resque:resque-retry*") #<-- can be skipped if you already have a file to read from
cleanup_job_stats = redis_cleaner.delete_keys_in_temp_file(verbose: false)
puts "Deleted #{cleanup_job_stats[:deleted_keys_count]} keys out of #{cleanup_job_stats[:total_keys_count]}"
```

Do everything in one go

```ruby
redis_cleaner.dump_matching_keys_to_temp_file("resque:resque-retry*", delete_temp_file: false, verbose: false, batch_size: 200)
```

## License

Copyright (c) 2013 by Lloyd Chan

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, and to permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.