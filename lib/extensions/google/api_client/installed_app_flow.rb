# Source: http://stackoverflow.com/questions/25694742/is-there-a-pure-command-line-oauth-flow-for-installed-apps
#
Google::APIClient::InstalledAppFlow.class_eval do
  def authorize_cli(storage)
    puts "Please visit: #{@authorization.authorization_uri.to_s}"
    printf "Enter the code: code="
    code = gets
    @authorization.code = code
    @authorization.fetch_access_token!
    if @authorization.access_token
      if storage.respond_to?(:write_credentials)
        storage.write_credentials(@authorization)
      end
      @authorization
    else
      nil
    end
  end
end
