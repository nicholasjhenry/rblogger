require 'google/api_client'
require 'google/api_client/auth/installed_app'
require 'google/api_client/auth/file_storage'
require 'extensions/google/api_client/installed_app_flow'

module RBlogger
  class Blogger
    require 'rblogger/platforms/blogger/blog'

    class Configuration
      attr_reader :api_version, :cached_api_file, :credential_stored_file, :client_secrets_file

      def initialize
        @api_version = "v3"
        @root_path = "#{Dir.home}/.rblogger/"
        @credential_stored_file = "#{@root_path}/oauth2.json"
        @cached_api_file = "#{@root_path}/api_#{@api_version}.cache"
        @client_secrets_file = "#{@root_path}/client_secrets.json"
      end
    end

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
      # Load cached discovered API, if it exists. This prevents retrieving the
      # discovery document on every run, saving a round-trip to API servers.
      if File.exists?(configuration.cached_api_file)
        load_document
      else
        @client.discovered_api('blogger', configuration.api_version).tap do |document|
          save_document(document)
        end
      end
    end

    def load_document
      File.open(configuration.cached_api_file) do |file|
        Marshal.load(file)
      end
    end

    def save_document(document)
      File.open(configuration.cached_api_file, 'w') do |file|
        Marshal.dump(document, file)
      end
    end

    def fetch_blog(blog_id)
      authorize!
      Blog.new(@client, api, blog_id)
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
        @client.authorization = flow.authorize_cli(file_storage)
      else
        @client.authorization = file_storage.authorization
      end
    end
  end
end
