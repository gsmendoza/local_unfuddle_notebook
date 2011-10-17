module LocalUnfuddleNotebook
  class Notebook < RestClient::Resource
    def self.connection_settings_path
      ".local_unfuddle_notebook.yaml"
    end

    def self.init(connection_settings)
      Pow(connection_settings_path).write connection_settings.to_yaml
      with_connection_settings(connection_settings)
    end

    def self.with_connection_settings(connection_settings)
      url = "http://#{connection_settings[:subdomain]}.unfuddle.com/api/v1/projects/#{connection_settings[:project_id]}/notebooks/#{connection_settings[:notebook_id]}"
      Notebook.new(url, connection_settings[:username], connection_settings[:password])
    end
  end
end
