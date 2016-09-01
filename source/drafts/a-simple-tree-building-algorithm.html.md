---
title: 'A Simple Tree Building Algorithm'
# date: TBD When publishing
tags: code
---

It is, unfortunately, not that often that I get the opportunity to devise an algorithm to solve a problem at work. Most work simply doesn't require that kind of thinking. But I thoroughly enjoy that kind of thinking, and thus thoroughly enjoyed the most recent opportunity I had to employ it. The problem was simple (though I have simplified and abstracted it for this post as well): we have a database table of `things`, and these `things` have a parent-child hierarchy, and we need to display a tree of these `things` in our UI. So, let's dig in.

First, let's examine the basic shape of the database table. Each `thing` has an _id_, _name_, and _parent\_id_, like so:

| id | name | parent_id |
|----|------|-----------|
|  1 | A    | nil       |
|  2 | B    | 1         |
|  3 | C    | 1         |
|  4 | D    | 2         |
|  5 | E    | 4         |
|  6 | F    | 3         |
|  7 | G    | nil       |

Each row in the table gives us a "node" for our tree and tells us about that node's parent. This means that we cannot know by looking at a single row whether or not that "node" will have any children, but we can know if that "node" has a parent and what other "node" that parent is. If we want to think of this data in Ruby, this would be an array of hashes:

~~~ruby
[
  {id: 1, name: 'A', parent_id: nil},
  {id: 2, name: 'B', parent_id: 1},
  {id: 3, name: 'C', parent_id: 1},
  {id: 4, name: 'D', parent_id: 2},
  {id: 5, name: 'E', parent_id: 4},
  {id: 6, name: 'F', parent_id: 3},
  {id: 7, name: 'G', parent_id: nil}
]
~~~

That is the shape of the data that we are starting with, but what is the shape of the data that we want? We want a nested tree in the UI, so I think that is best represented in Ruby as a nested hash:

~~~ruby
{
  1: {
    name: 'A',
    children: {
      2: {
        name: 'B',
        children: {
          4: {
            name: 'D',
            children: {
              5: {
                name: 'E'
              }
            }
          }
        }
      },
      3: {
        name: 'C',
        children: {
          6: {
            name: 'F'
          }
        }
      },
    }
  },
  7: {
    name: 'G'
  }
}
~~~

We now know where we are coming from and where we are going; the only thing left to do is to get there.

I like to start with simple facts, things that I know to be true. For example, if we are starting with an array of hashes, our solution is going to need to iterate over that array. It is also a fact that any "node" in the tree can be described as one of three things: a "root", a "leaf", or a "branch". Here I may be stretching the tree metaphor a bit too far, but bear with me. A "root" is a top level object; it has children but no parent. A "leaf" is the exact opposite; it has a parent but no children. A "branch", then, is simply a node that has both a parent and children. Now, we said earlier that we cannot know by looking at a simple node whether or not it has children. This means that we cannot determine if a particular node is a "branch" or a "leaf" just by examining it. We _can_, however, determine if a particular node is a "root" or not on its own. A final thing that we know is that an efficient algorithm to solve this problem will only scan the initial array once. We want to iterate over that array of hashes once and build up our nested hash as we go.

We have some basic facts before us so let's start actually trying to write some code. We need to iterate over the array of hashes, so let's start there:

~~~ruby
# `nodes` = the array of hashes
nodes.each do |node|
  # some computation
end
~~~

We also know that we want to get a hash out at the end, and that we will need to build that hash as we iterate over the array, so let's initialize that hash as well:

~~~ruby
tree = {}
# `nodes` = the array of hashes
nodes.each do |node|
  # some computation
end
~~~

We know that as we iterate over the `nodes`, we need to insert each node into the `tree`. Let's start with a naive implementation:

~~~ruby
tree = {}
# `nodes` = the array of hashes
nodes.each do |node|
  tree[node[:id]] = node.reject { |k, v| k == :id }
end
~~~

I call this "naive" not to be condescending; it is literally where I started and I think it is a healthy place to start. Iteration is at the heart of good programming, good thinking. We know where we are going but not how quite to get there, so let's experiment and learn as we go. Here, we start to learn something important. For, while this will turn an array of hashes into a single hash, it gets us nowhere near a nested hash. If we were to run this code, we would simply get:

~~~ruby
{
  1 => { name: 'A', parent_id: nil},
  2 => { name: 'B', parent_id: 1},
  3 => { name: 'C', parent_id: 1},
  4 => { name: 'D', parent_id: 2},
  5 => { name: 'E', parent_id: 4},
  6 => { name: 'F', parent_id: 3},
  7 => { name: 'G', parent_id: nil}
}
~~~

Our array is now a hash, but the basic shape of the data hasn't changed at all. Moreover, this naive approach has shown us that we really need to do something with the `parent_id` of each node as we process it. Also, I for one am noticing a key difference between our starting data and our desired output data: our starting data focuses on the "parent" of the "parent-child" relationship (via `parent_id`), while our output data focuses on the "child" (with the `children` key). Making this switch will prove to be difficult, but let's examine why.

We said earlier that we can tell by looking at a single node whether or not it is a "root" or not, that is, whether or not it has a parent. This means we could build the first level of our nested hash quite simply:

~~~ruby
tree = {}
# `nodes` = the array of hashes
nodes.each do |node|
  tree[node[:id]] = node.reject { |k, v| k.to_s.include? 'id' } if node[:parent_id] == nil
end
~~~

This would produce a `tree` with this shape:

~~~ruby
{
  1 => { name: "A" },
  7 => { name: "G" }
}
~~~

This, at least, is _starting_ to look like our desired output. But what do we do about the possible children? We don't know if either of these nodes has children just by looking at them; we only that a node is a child if it has a `parent_id`. So this switch from a parent-centric perspective to a children-centric perspective is going to be difficult. In fact, spoiler warning, if we want to get the nested hash output we described initially **and** only parse the array once, _we are screwed_. We are screwed because we can't insert a node into an arbitrary place in the nested hash.

We could create an auto-vivifying hash and insert a node arbitrarily deep in the hash:

~~~ruby
autovivifying_tree = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
autovivifying_tree.dig(*[1, 2, 4, 5])
# autovivifying_tree => {1=>{2=>{4=>{5=>{}}}}}
~~~

The problem here is that we have to have the path to the nested node; we need to know that nodes ancestors. But, in our data, we can only learn the ancestor paths by parsing the whole array. This data model also fails to give us the `name` of each node

