require 'crack'
require 'rest-client'

module LocalUnfuddleNotebook
  class Notebook < RestClient::Resource
    class << self
      def attributes_path
        ".local_unfuddle_notebook.yaml"
      end

      def local
        with_attributes(saved_attributes)
      end

      def local_pages_path
        "pages"
      end

      def saved_attributes
        YAML::load(Pow(attributes_path).read) if Pow(attributes_path).file?
      end

      def with_attributes(attributes)
        url = "http://#{attributes[:subdomain]}.unfuddle.com/api/v1/projects/#{attributes[:project_id]}/notebooks/#{attributes[:notebook_id]}"
        Notebook.new(url, attributes[:username], attributes[:password]).tap do |notebook|
          notebook.last_pulled_at = attributes[:last_pulled_at]
        end
      end
    end

    attr_accessor :last_pulled_at

    def local_attributes
      {
        :subdomain => subdomain,
        :username => user,
        :password => password,
        :project_id => project_id,
        :notebook_id => notebook_id,
        :last_pulled_at => last_pulled_at
      }
    end

    def local_pages
      Pow(Notebook.local_pages_path).files.map do |file|
        Page.new(YAML.load(file.read)).tap do |page|
          page.notebook = self
          page.local_file = file
        end
      end
    end

    def notebook_id
      url.match(%r{notebooks/(\d+)})[1].to_i
    end

    def project_id
      url.match(%r{projects/(\d+)})[1].to_i
    end

    def pull
      if Pow(self.class.local_pages_path).exists?
        Pow(self.class.local_pages_path).delete!
      end

      remote_pages.each do |page|
        page.save
      end

      self.last_pulled_at = Time.now

      self.update_attributes_file
    end

    def remote_pages
      Crack::XML.parse(self["pages/unique"].get)['pages'].map do |remote_page_hash|
        page_attributes = remote_page_hash.delete_if{|k, v| ! Page.attributes.include?(k.to_sym) }
        Page.new(page_attributes).tap do |page|
          page.notebook = self
        end
      end
    end

    def subdomain
      url.match(%r{http.*://(.*)\.unfuddle.com})[1]
    end

    def update_attributes_file
      Pow(self.class.attributes_path).write local_attributes.to_yaml
    end

    def url_with_basic_auth(suburl)
      self[suburl].url.sub("http://", "http://#{user}:#{password}@")
    end
  end
end
