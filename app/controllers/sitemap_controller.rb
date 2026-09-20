class SitemapController < ApplicationController
  layout false

  def sitemap
    @albuns = Album.order(updated_at: :desc).limit(10_000)
    render "sitemap/sitemap", formats: [:xml], content_type: "text/xml"
  end
end
