module LocalUnfuddleNotebook
  class App < Valuable
    has_value :args

    def execute
      puts "TODO: " + args.inspect
    end
  end
end

