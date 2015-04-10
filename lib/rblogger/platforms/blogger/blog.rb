module RBlogger
  class Blogger::Blog
    def initialize(client, api, blog_id)
      @client = client
      @blog_id = blog_id
      @api = api
    end

    def posts
      result = @client.execute!(:api_method => @api.posts.list, :parameters => {'blogId' => @blog_id})
      result.data.items
    end
  end
end
