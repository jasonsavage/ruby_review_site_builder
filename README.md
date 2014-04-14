# review_site_builder v0.3.2

A simple ruby gem that will auto-generate a website so that clients can review flash banners and comp images.

*NOTE: project is not currently published to [http://rubygems.org](http://rubygems.org/), but hopefully in the future it will be.*

## Basic Usage

The first step is to install the gem from the root of this repo:

~~~sh
gem install ./review_site_builder-0.3.2.gem
~~~

After the gem is installed, you can run it from the command line by specifying a path to the folder where your config.yml file is or root of your project

~~~sh
review_site_builder path/to/project
~~~


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

* [client] - string (optional) 
	* displays client name on index.html page 
	* default: client not shown
* [project] - string (optional) 
	* displays project name on index.html page 
	* default: project not shown
* [logo] - filepath (optional)
	* path to client logo to be displayed on index.html page (
	* default: logo not shown
* [src] - relative filepath (optional)
	* root path to media files
	* default: ./src/
* [dest] - relative filepath (optional)
	* Where to save generated review site files (
	* default: ./build/
* [files] - array (optional)
	* list of files or groups of files to display in the review site (
	* default: all files found in [src], listed in one group called "Project Files"
* [files > string] - object/string (optional)
	* file path is added to group called "Project Files"
* [files > object] - object/string (optional)
	* [title] - string (optional) 
		* title of this section 
		* default: Project Files
	* [dir] - string (optional)
		* directory for these files, added to [src] (
		* default: "" (empty string)
	* [comps] - string (optional) 
		* list of files to use for this section (
		* default: no files selected
		* NOTE: file names can use the "|" (pipe) symbol to specifiy a related file to add to project (example: expanable banners)


## Using with Ruby

```ruby

require 'review_site_builder'

ReviewSiteBuilder.build!("test/example_project/")

```

## License

Copyright (c) 2014 Jason Savage
Licensed under the MIT license.