require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
require 'extensions/google/api_client/installed_app_flow'

module RBlogger
  class Blogger
    class Authorizer
      def initialize(configuration)
        @configuration = configuration
      end

      attr_reader :configuration

      def authorize!
        if file_storage.authorization.nil?
          oauth_flow.authorize_cli(file_storage)
        else
          file_storage.authorization
        end
      end

      private

      def file_storage
        Google::APIClient::FileStorage.new(configuration.credential_stored_file)
      end

      # The InstalledAppFlow is a helper class to handle the OAuth 2.0 installed
      # application flow, which ties in with FileStorage to store credentials
      # between runs.
      #
      def oauth_flow
        Google::APIClient::InstalledAppFlow.new(
          client_id: client_secrets.client_id,
          client_secret: client_secrets.client_secret,
          scope: configuration.api_scope
        )
      end

      def client_secrets
        @client_secrets ||= Google::APIClient::ClientSecrets.load(configuration.client_secrets_file)
      end
    end
  end
end
