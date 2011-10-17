module LocalUnfuddleNotebook
  class Notebook < RestClient::Resource
    def self.config_path
      ".local_unfuddle_notebook.yaml"
    end

    def self.init(options)
      Pow(config_path).write options.to_yaml
      #local
    end
  end
end
