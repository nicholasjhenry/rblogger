module RBlogger
  class Blogger
    class Blog
      def initialize(client, api, blog_id)
        @client = client
        @blog_id = blog_id
        @api = api
      end

      attr_reader :client, :api, :blog_id

      def posts
        result = client.execute!(api_method: api.posts.list, parameters: {'blogId' => blog_id})
        result.data.items
      end
    end
  end
end
