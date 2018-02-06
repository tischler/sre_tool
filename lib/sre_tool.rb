require "sre_tool/version"
require "sre_tool/nbm_api"

require 'thor'

module SreTool
  # Your code goes here...
  class Command < Thor
    desc "Print hello NAME", "say hello to NAME"

    def hello(name)
      puts "Hello #{name}"
      puts "My version is #{SreTool::VERSION}"
    end
  end

end
