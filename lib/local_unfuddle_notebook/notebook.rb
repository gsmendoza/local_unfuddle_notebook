require 'crack'
require 'rest-client'

module LocalUnfuddleNotebook
  class Notebook < RestClient::Resource
    class << self
      def connection_settings_path
        ".local_unfuddle_notebook.yaml"
      end

      def init(connection_settings)
        Pow(connection_settings_path).write connection_settings.to_yaml
        with_connection_settings(connection_settings)
      end

      def local
        with_connection_settings(saved_connection_settings)
      end

      def local_pages_path
        "pages"
      end

      def saved_connection_settings
        YAML::load(Pow(connection_settings_path).read) if Pow(connection_settings_path).file?
      end

      def with_connection_settings(connection_settings)
        url = "http://#{connection_settings[:subdomain]}.unfuddle.com/api/v1/projects/#{connection_settings[:project_id]}/notebooks/#{connection_settings[:notebook_id]}"
        Notebook.new(url, connection_settings[:username], connection_settings[:password])
      end
    end

    def pull
      if Pow(self.class.local_pages_path).exists?
        Pow(self.class.local_pages_path).delete!
      end

      remote_pages.each do |page|
        page.save
      end
    end

    def remote_pages
      Crack::XML.parse(self["pages/unique"].get)['pages'].map do |remote_page_hash|
        page_attributes = remote_page_hash.delete_if{|k, v| ! Page.attributes.include?(k.to_sym) }
        Page.new(page_attributes).tap do |page|
          page.notebook = self
        end
      end
    end

    def url_with_basic_auth(suburl)
      self[suburl].url.sub("http://", "http://#{user}:#{password}@")
    end
  end
end
