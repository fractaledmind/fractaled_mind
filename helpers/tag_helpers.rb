module TagHelpers
  def raw_tags
    blog.tags.keys
  end

  def tag_set
    raw_tags.flat_map { |k| k.split('>') }.uniq
  end

  def tag_branches
    raw_tags.flat_map { |k| k.split('>')[1..-1] }
            .uniq
  end

  def tag_roots
    raw_tags.flat_map { |k| k.split('>').first }
            .uniq
            .reject { |r| tag_branches.include?(r) }
  end

  def tag_tree
    {}.tap do |tree|
      raw_tags.flat_map do |k|
        tagpath = k.split('>')
        slicer = tagpath.length >= 2 ? 'each_cons' : 'each_slice'
        tagpath.send(slicer, 2).to_a
      end.each do |tagpair|
        parent, child = tagpair
        children = tree.fetch(parent) { |key| tree[key] = [] }
        children.push(child) unless child.nil? || children.include?(child)
      end
    end
  end

  def tag_roots_for(tag:)
    raw_tags.select { |t| t.split('>').include?(tag) }
            .flat_map { |k| k.split('>').first }
            .uniq
            .reject { |r| tag_branches.include?(r) }
  end

  def posts_for(tag:)
    blog.articles
        .select do |a|
          a.tags
           &.flat_map { |t| t.split('>') }
           .include?(tag)
        end
  end
end
