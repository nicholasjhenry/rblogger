require 'google/api_client'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/file_storage'
require 'extensions/google/api_client/installed_app_flow'

module RBlogger
  class Blogger
    require 'rblogger/platforms/blogger/blog'
    require 'rblogger/platforms/blogger/configuration'
    require 'rblogger/platforms/blogger/document'

    def initialize
      @client = Google::APIClient.new(
        application_name: 'RBlogger',
        application_version: RBlogger::VERSION
      )
      @configuration = Configuration.new

      yield(configuration) if block_given?
    end

    attr_reader :client, :configuration

    def api
      Document.new(client, configuration).fetch
    end

    def fetch_blog(blog_id)
      authorize!
      Blog.new(client, api, blog_id)
    end

    private

    def authorize!
      file_storage = Google::APIClient::FileStorage.new(configuration.credential_stored_file)
      if file_storage.authorization.nil?
        client_secrets = Google::APIClient::ClientSecrets.load(configuration.client_secrets_file)
        # The InstalledAppFlow is a helper class to handle the OAuth 2.0 installed
        # application flow, which ties in with FileStorage to store credentials
        # between runs.
        flow = Google::APIClient::InstalledAppFlow.new(
          :client_id => client_secrets.client_id,
          :client_secret => client_secrets.client_secret,
          :scope => 'https://www.googleapis.com/auth/blogger'
        )
        client.authorization = flow.authorize_cli(file_storage)
      else
        client.authorization = file_storage.authorization
      end
    end
  end
end
