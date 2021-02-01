[![Build Status](https://travis-ci.com/tcollier/whirled_peas.svg?branch=main)](https://travis-ci.com/tcollier/whirled_peas)

```
                ██╗   ██╗██╗███████╗██╗   ██╗ █████╗ ██╗     ██╗███████╗███████╗
                ██║   ██║██║██╔════╝██║   ██║██╔══██╗██║     ██║╚══███╔╝██╔════╝
                ██║   ██║██║███████╗██║   ██║███████║██║     ██║  ███╔╝ █████╗
                ╚██╗ ██╔╝██║╚════██║██║   ██║██╔══██║██║     ██║ ███╔╝  ██╔══╝
                 ╚████╔╝ ██║███████║╚██████╔╝██║  ██║███████╗██║███████╗███████╗
                  ╚═══╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝╚══════╝╚══════╝

                                   your code's execution with

    ██╗    ██╗██╗  ██╗██╗██████╗ ██╗     ███████╗██████╗    ██████╗ ███████╗ █████╗ ███████╗
    ██║    ██║██║  ██║██║██╔══██╗██║     ██╔════╝██╔══██╗   ██╔══██╗██╔════╝██╔══██╗██╔════╝
    ██║ █╗ ██║███████║██║██████╔╝██║     █████╗  ██║  ██║   ██████╔╝█████╗  ███████║███████╗
    ██║███╗██║██╔══██║██║██╔══██╗██║     ██╔══╝  ██║  ██║   ██╔═══╝ ██╔══╝  ██╔══██║╚════██║
    ╚███╔███╔╝██║  ██║██║██║  ██║███████╗███████╗██████╔╝   ██║     ███████╗██║  ██║███████║
     ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═════╝    ╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝
```

Easily create terminal-based graphics to visualize the execution of your code. Whirled Peas offers templating inspired by HTML and CSS and provides a lightweight tie-in for your code to produce visual animations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'whirled_peas'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install whirled_peas

## Usage

A Whirled Peas application consists of the following required pieces

- [The application](doc/application.md) - the code that is to be visualized, it dictates the frame contents and playback speed
- [The template factory](doc/template_factory.md) - builds templates to convert frames from the application into terminal graphics

These pieces are configured as follows

```ruby
# visualize.rb
require 'whirled_peas'

class TemplateFactory
  def build(frame, args)
    WhirledPeas.template do |composer|
      composer.add_box('Title') do |_, settings|
        settings.underline = true
        "Hello #{args[:name]}"
      end
      # ...
    end
  end
end

class Application
  def start(producer)
    producer.add_frame('starting', args: { name: 'World' })
    # ...
  end
end

WhirledPeas.configure do |config|
  config.application = Application.new
  config.template_factory = TemplateFactory.new
end
```

Then the visualizer is started on the [command line](doc/cli.md) with

```
$ whirled_peas play visualize.rb
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Tests inclued standard RSpec tests for application logic as well as custom [screen tests](doc/screen_test.md) to validate the rendered graphics.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tcollier/whirled_peas. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/tcollier/whirled_peas/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WhirledPeas project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/tcollier/whirled_peas/blob/master/CODE_OF_CONDUCT.md).
