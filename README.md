# rcalc

rcalc is a set of tools to do stuff on the terminal. It is written in pure Ruby. It has no dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rcalc'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rcalc

## Usage

Main documentation is at: https://rcalc.davidsiaw.net/

### Terminal colors

```ruby
t = Rcalc::Terminal.new
t.color_white!
puts "white text"
```

```ruby
t = Rcalc::Terminal.new
t.color_black!
t.bgcolor_white!
puts "black text on white background"
```

### Listen for keypresses / mouse

```ruby
c.start_mouse!
c.listen! do |k|
  print "#{k.inspect}\r\n"
  if k == "\u0003"
    true # quit when receiving Ctrl+C
  elsif k == "q"
    p c.pos # show cursor position
    false
  elsif k == "s"
    p c.size # get console size
    false
  elsif k == "c"
    c.clear! # clear console
    false
  elsif k == "h"
    c.home! # go to top left
    false
  else
    false
  end
end
c.stop_mouse!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davidsiaw/rcalc. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/davidsiaw/rcalc/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Base project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/davidsiaw/rcalc/blob/master/CODE_OF_CONDUCT.md).
