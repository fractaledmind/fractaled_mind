module PaginationHelpers
  def pagination_links(posts_total, posts_per_page)
    @pages_total = (posts_total / posts_per_page.to_f).ceil

    prev_link = pagination_item('« Prev', prev_page_for(current_page).try(:url))
    next_link = pagination_item('Next »', next_page_for(current_page).try(:url))

    items = []

    # Add the current page
    items << pagination_item_for(current_page)

    # Add the prior pages
    page = current_page
    while page = prev_page_for(page)
      items.unshift pagination_item_for(page)
    end

    # # Add all subsequent pages
    page = current_page
    while page = next_page_for(page)
      items << pagination_item_for(page) if page
    end

    # Combine the items with the prev/next links
    items = [prev_link, items, next_link].flatten

    content_tag(:ul, items.join)
  end

  def posts_for_page(posts, page_number, per_page)
    posts.each_slice(per_page).drop(page_number - 1).first
  end

  def pagination_item_for(page)
    link_title = page.metadata[:locals]['page_number']
    pagination_item(link_title, page.url)
  end

  def pagination_item(link_title, link_path, options = {})
    if link_path == current_page.url
      content = content_tag(:span, link_title)
      options[:class] = 'active'
    elsif link_path
      content = link_to(link_title, link_path)
    else
      content = content_tag(:span, link_title)
      options[:class] = 'disabled'
    end

    content_tag(:li, content, options)
  end

  def next_page_for(page)
    next_page = locals_for(page, 'next_page')
    page_number(page&.url) == @pages_total ? nil : next_page
  end

  def prev_page_for(page)
    locals_for(page, 'prev_page')
  end

  def page_number(page_link)
    /(\d)(\.html|\/)/.match(page_link)&.captures&.first&.to_i
  end

  def locals_for(page, key)
    page && page.metadata[:locals][key]
  end
end
