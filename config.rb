# Directory Structure configuration
set :layouts_dir,  'layouts'
set :partials_dir, 'partials'
set :css_dir,      'stylesheets'
set :js_dir,       'javascripts'
set :images_dir,   'images'

# Layouts
# For custom domains on github pages
page 'CNAME', layout: false
page '/feed.xml', layout: false
# Wrap articles in proper HTML
page 'posts/*',   layout: 'page'

def setup_summary_generator(separator = /(READMORE)/i)
  Proc.new  do |resource, rendered, length, ellipsis|
    require 'middleman-blog/truncate_html'
    # determine which type of summary to use
    if resource.data.summary?
      summary = resource.data.summary
    elsif rendered =~ separator
      # The separator is found in the text
      summary = rendered.split(separator).first
    elsif length
      summary = TruncateHTML.truncate_html(rendered, length, ellipsis)
    else
      summary = rendered
    end
    # does the summary text include any footnotes?
    if summary.include?('</sup>')
      # find the footnotes div in HTML
      footnote_div = %r{<div class="footnotes">(.*?)<\/div>}m.match(rendered)
      # if no footnotes, emptry string
      footnotes = footnote_div.nil? ? '' : footnote_div
      summary += footnotes.to_s
    end
    summary # return
  end
end

# Separator used in Articles to end summary
@readmore_separator = %r{(<p>)?{{read more}}(<\/p>)?}i

###
# Blog settings
###
# Time.zone = "UTC"
activate :blog do |blog|
  blog.name = 'Fractaled Mind'
  blog.default_extension = '.md'

  # Matcher for blog source files (originals have `default_extension`)
  blog.sources = 'posts/{title}.html'
  # Template for article URL slugs
  blog.permalink = '{title}.html'
  # blog.layout = "layout"
  blog.summary_separator = /DUMMY SEPARATOR/
  blog.summary_length = 250
  blog.summary_generator = setup_summary_generator(@readmore_separator)

  # Tag URL slugs
  blog.taglink = '/topics/{tag}.html'
  # Template for Tag pages
  blog.tag_template = 'templates/topic.html'
  # blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

ready do
  sitemap_nested_resources.group_by { |r| r.slug.split('/').first }
                          .each do |category, posts|
    proxy "#{category}.html", "templates/#{category}.html",
          locals: { posts: posts }, ignore: true
    posts.each do |post|
      proxy "#{post.slug}.html", "templates/#{category.singularize}.html",
            locals: { post: post }, ignore: true
    end
  end
end

# Methods defined in the helpers block are available in templates
helpers do
  def markdownify(content)
    Tilt['markdown'].new { content }.render
  end

  def cleanup_readmore(html)
    html.sub(@readmore_separator, "<span id='readmore'></span>")
  end

  def locals_for(page, key)
    page && page.metadata[:locals][key]
  end

  end
end

# Set the Markdown rendering engine
set :markdown,
    fenced_code_blocks: true,
    smartypants: true,
    footnotes: true,
    tables: true,
    autolink: true,
    with_toc_data: true

# Turn this on for code highlighting (with line numbers)
activate :syntax, line_numbers: true

# Turn on draft plugin
activate :drafts

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# Root Level Pages
proxy 'search.html',   'templates/search.html',   ignore: true
proxy 'about.html',    'templates/about.html',    ignore: true
proxy 'topics.html',   'templates/topics.html',   ignore: true

page '/search.html', directory_index: false

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Build-specific configuration
configure :build do
  activate :autoprefixer
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  activate :relative_assets
  set :relative_links, true

  # Turn this on if you want to make your url's prettier, without the .html
  activate :directory_indexes

  # Optimize images on build
  activate :imageoptim

  # Add Disqus comments
  activate :disqus do |disqus|
    disqus.shortname = 'fractaledmind'
  end

  # Prettify HTML on build
  after_build do
    system('htmlbeautifier build/*/*.html')
  end

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
