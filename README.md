ruby_review_site_builder
========================

A simple ruby gem that will auto-generate a website so that clients can review flash banners and comp images.

To run simply create a *.rb file with the following code:
(paths are relative to this file)

```ruby

require 'review_site_builder'

ReviewSiteBuilder::Publish.run!(
  :client => "Company Name",
  :project => "Flash Banners",
  :logo => "Client Logos\\company_logo.png",
  :files => [
	  {
		:group => "Project Concept 1",
		:comps => [
			"120x600_banner.swf",
			"160x600_banner.swf",
			"300x250_banner.swf",
			"468x60_banner.swf",
			"728x90_banner.swf"
		]
	  },
	  {
		:group => "Project Concept 1 Backup JPGs",
		:comps => [
			"120x600_banner_backup.jpg",
			"160x600_banner_backup.jpg",
			"300x250_banner_backup.jpg",
			"468x60_banner_backup.jpg",
			"728x90_banner_backup.jpg"
		]
	  }
  ],
  :dest => "../review"
)

```