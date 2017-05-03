module SitemapHelpers
  def sitemap_nested_resources
    sitemap.resources
           .select do |r|
             r.respond_to?(:slug) &&
               r.slug.include?('/')
           end
  end

  def site_sections
    sitemap_nested_resources.map { |r| r.slug.split('/').first }
                            .uniq
  end

  def slug_section(slug)
    slug.split('/').first
  end
end
