require 'rblogger'

platform = RBlogger::Blogger.new
blog = platform.fetch_blog(blog_id = ARGV.first)
blog.posts.each do |post|
  puts post.title
  puts post.content
end
