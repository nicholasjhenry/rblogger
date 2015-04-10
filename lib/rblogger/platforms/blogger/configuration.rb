module RBlogger
  class Blogger::Configuration
    attr_reader :api_version, :cached_api_file, :credential_stored_file, :client_secrets_file

    def initialize
      @api_version = "v3"
      @root_path = "#{Dir.home}/.rblogger/"
      @credential_stored_file = "#{@root_path}/oauth2.json"
      @cached_api_file = "#{@root_path}/api_#{@api_version}.cache"
      @client_secrets_file = "#{@root_path}/client_secrets.json"
    end
  end
end
