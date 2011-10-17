require 'valuable'

module LocalUnfuddleNotebook
  class Page < Valuable
    has_value :body
    has_value :id
    has_value :notebook
    has_value :local_file
    has_value :message
    has_value :title

    def basename
      "#{id}-#{title.gsub(/\W/, '-')}.yaml".downcase
    end

    def changed?
      notebook.last_pulled_at < local_file.mtime
    end

    def local_attributes
      {
        :body => body,
        :id => id,
        :title => title
      }
    end

    def save
      (Pow(Notebook.local_pages_path)/basename).write(local_attributes.to_yaml)
    end
  end
end
