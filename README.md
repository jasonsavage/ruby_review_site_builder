# review_site_builder v0.3.2

A simple ruby gem that will auto-generate a website so that clients can review flash banners and comp images.

NOTE: project is not currently published to http://rubygems.org, but hopefully in the future it will be.

## Basic Usage

review_site_builder can be used from the command line. The
first step is to install the gem from the root of this repo:

~~~sh
gem install ./review_site_builder-0.3.2.gem
~~~

After the gem is installed you can run it by specifying a path to the folder where your config.yml file is (or root of your project)

~~~sh
review_site_builder path/to/project
~~~

NOTE: if no config.yml file exists or 'src' is not specified within config.yml then, review_site_builder will default to all file sin the "src/" directory.


## config.yml Settings

The yaml config file allows you to specifiy what files to use and how to lay them out within the review site. All settings are optional (including the config.yml file itself)

```yaml
client: Test Project
project: Flash Banners
logo: src/logo_green.png

dest: /review
src: /src

files:
- 
  title: Spoon Concept Phase 1
  dir: /Phase 1
  comps:
  - 120x600_banner_shell.swf|120x600_banner.swf
  - 120x600_banner.jpg
  - 300x250_banner.swf
-
  title: Calendar Concept Phase 1
  dir: /Phase 2
  comps:
  - 500x500_calendar.swf
  - 500x500_calendar.jpg
-
  title: Calendar Concept Phase 2
  dir: /
  comps:
  - 300x250_banner.swf
  - 300x250_banner.jpg
```

## Using with Ruby

```ruby

require 'review_site_builder'

ReviewSiteBuilder.build!("test/example_project/")

```

## License

Copyright (c) 2014 Jason Savage
Licensed under the MIT license.