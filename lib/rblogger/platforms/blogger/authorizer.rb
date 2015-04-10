module RBlogger
  class Blogger::Authorizer
    def initialize(configuration)
      @configuration = configuration
    end

    attr_reader :configuration

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
        flow.authorize_cli(file_storage)
      else
        file_storage.authorization
      end
    end
  end
end
