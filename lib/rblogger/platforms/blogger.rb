require 'google/api_client'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/file_storage'
require 'extensions/google/api_client/installed_app_flow'
require 'rblogger/platforms/blogger/blog'
require 'rblogger/platforms/blogger/configuration'
require 'rblogger/platforms/blogger/document_repository'
require 'rblogger/platforms/blogger/authorizer'


module RBlogger
  class Blogger
    def initialize
      @client = Google::APIClient.new(
        application_name: 'RBlogger',
        application_version: RBlogger::VERSION
      )
      @configuration = Configuration.new

      yield(configuration) if block_given?
    end

    attr_reader :client, :configuration

    def fetch_blog(blog_id)
      authorize!
      build_blog(blog_id)
    end

    private

    def authorize!
      authorizer = Authorizer.new(configuration)
      client.authorization = authorizer.authorize!
    end

    def build_blog(blog_id)
      Blog.new(client, api, blog_id)
    end

    def api
      DocumentRepository.new(client, configuration).fetch
    end
  end
end
