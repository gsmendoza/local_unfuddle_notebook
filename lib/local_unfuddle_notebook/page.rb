require 'valuable'

module LocalUnfuddleNotebook
  class Page < Valuable
    has_value :body
    has_value :id
    has_value :notebook
    has_value :message
    has_value :title
    has_value :updated_at

    def basename
      "#{id}-#{title.gsub(/\W/, '-')}.yaml".downcase
    end

    def local_attributes
      {
        :title => title,
        :body => body,
        :message => message,
        :updated_at => updated_at
      }
    end

    def save
      (Pow(Notebook.local_pages_path)/basename).write(local_attributes.to_yaml)
      #.do |file|
        #file.touch :mtime => updated_at
      #end
    end
  end
end
