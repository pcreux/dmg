require 'net/https'
require 'uri'

module DMG
  class Source
    class << self
      def download_and_combine
        combine(Source.all)
      end

      protected

      def combine(sources)
        combined_pkgs_hash = {}

        sources.each do |source|
          combined_pkgs_hash.merge!(source.pkgs_hash)
        end

        File.open(DMG::combined_pkgs_file, 'w') { |f| f.write(combined_pkgs_hash.to_yaml) }
      end

      def all
        YAML.load_file(DMG::sources_file).map do |path_or_url|
          Source.new(path_or_url)
        end
      end
    end  # class << self

    attr_reader :pkgs_hash

    def initialize(path_or_url)
      @pkgs_hash = YAML.load(get(path_or_url))
    end

    # Return content from path or url
    def get(path_or_url)
      case path_or_url
      when /^http(s):\/\//
        get_file(path_or_url)
      else
        read_file(path_or_url)
      end
    end

    protected

    # Get file content from a url
    def get_file(url)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.port == 443
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)
      response.body
    end

    # Return file content from a path
    def read_file(path)
      File.read(File.expand_path(path, DMG.config_dir))
    end
  end
end
