ruby_review_site_builder
========================

A simple ruby gem that will auto-generate a website so that clients can review flash banners and comp images.

To run simply create a *.rb file with the following code:
(paths are relative to this file)

```ruby

require 'review_site_builder'

ReviewSiteBuilder::Publish.run!(
  :client => "Honey Baked",
  :project => "Flash Banners",
  :logo => "C:\\Users\\jsavage\\Desktop\\Client Logos\\honeybaked.png",
  :files => [
	  {
		:group => "MDay Ham Concept",
		:comps => [
			"120x600_MDayHam_banner.swf",
			"160x600_MDayHam_banner.swf",
			"300x250_MDayHam_banner.swf",
			"468x60_MDayHam_banner.swf",
			"728x90_MDayHam_banner.swf"
		]
	  },
	  {
		:group => "MDay Ham Backup JPGs",
		:comps => [
			"120x600_MDayHam_banner.jpg",
			"160x600_MDayHam_banner.jpg",
			"300x250_MDayHam_banner.jpg",
			"468x60_MDayHam_banner.jpg",
			"728x90_MDayHam_banner.jpg"
		]
	  }
  ],
  :dest => "../review"
)

```