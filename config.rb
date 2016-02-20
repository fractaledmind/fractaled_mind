# For custom domains on github pages
page 'CNAME', layout: false

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
    summary  # return
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
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = ""
  blog.default_extension = '.md'

  # Matcher for blog source files (originals have `default_extension`)
  blog.sources = 'articles/{title}.html'
  # Template for article URL slugs
  blog.permalink = 'articles/{title}.html'
  # blog.layout = "layout"
  blog.summary_separator = /DUMMY SEPARATOR/
  blog.summary_length = 250
  blog.summary_generator = setup_summary_generator(@readmore_separator)
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"

  # Tag URL slugs
  blog.taglink = '/topics/{tag}.html'
  # Template for Tag pages
  blog.tag_template = 'templates/topic.html'
  # blog.calendar_template = "calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"

  # Custom Projects collection
  # blog.custom_collections = {
  #     project: {
  #       link: '/projects/{project}.html',
  #       template: '/project.html'
  #     }
  #   }
end

# Methods defined in the helpers block are available in templates
helpers do
  def markdownify(content)
    Tilt['markdown'].new { content }.render
  end

  def cleanup_readmore(html)
    html.sub(@readmore_separator, "<span id='readmore'></span>")
  end

  def project_tags
    project_tags = Hash.new []
    data.projects.each do |slug, project|
      if project.tags?
        project.tags.each do |tag|
          project['slug'] = slug
          project_tags[tag] += [project]
        end
      end
    end
    project_tags
  end

  def newest_comic_post
    blog.articles.group_by { |a| a.date.day }.each do |_, articles|
      articles.each do |article|
        article if article.tags.include?('pair-of-ducks')
      end
    end
    nil
  end
end

# Directory Structure configuration
set :layouts_dir,  'layouts'
set :partials_dir, 'partials'
set :css_dir,      'stylesheets'
set :js_dir,       'javascripts'
set :images_dir,   'images'

# Layouts
page '/feed.xml', layout: false
# Wrap articles in proper HTML
page 'articles/*', layout: 'page'

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

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

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
proxy 'articles.html', 'templates/articles.html', ignore: true
proxy 'projects.html', 'templates/projects.html', ignore: true
proxy 'about.html',    'templates/about.html',    ignore: true
proxy 'topics.html',   'templates/topics.html',   ignore: true
# Create a Project page for each project listed in `data/projects/`
# Use `project.html.erb` as the template for this project page
data.projects.each do |slug, project|
  proxy "projects/#{slug}.html", 'templates/project.html',
        locals: { project: project }, ignore: true
end

project_tags.each do |tag, projects|
  proxy "topics/#{tag}.html", 'templates/project_topic.html',
        locals: { tag: tag, projects: projects }, ignore: true
end

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

activate :deploy do |deploy|
  deploy.method = :git
  # Optional Settings
  # deploy.remote   = 'custom-remote' # remote name or git url, default: origin
  # deploy.branch   = 'custom-branch' # default: gh-pages
  # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.strategy = :submodule
  # commit message (can be empty), default: Automated commit at `timestamp`
  # by middleman-deploy `version`
  # deploy.commit_message = 'custom-message'
end
