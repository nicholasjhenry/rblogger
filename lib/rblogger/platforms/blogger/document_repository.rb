module RBlogger
  class Blogger
    class DocumentRepository
      def initialize(client, configuration)
        @client = client
        @configuration = configuration
      end

      attr_reader :client, :configuration

      # Load cached discovered API, if it exists. This prevents retrieving the
      # discovery document on every run, saving a round-trip to API servers.
      #
      def fetch
        if File.exists?(configuration.cached_api_file)
          load_document
        else
          client.discovered_api(configuration.api_name, configuration.api_version).tap do |document|
            save_document(document)
          end
        end
      end

      private

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
    end
  end
end
