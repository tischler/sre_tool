require "sre_tool/version"
require "sre_tool/nbm_api"
require "sre_tool/validations"

require 'thor'

module SreTool
  # Your code goes here...
  class Command < Thor
    include Validations

    API = SreTool::BroadbandMapAPI.new

    desc "retrieve_data", "Do it!"
    option  :format,
            :aliases => '-f',
            :default => 'csv',
            :type => :string,
            :desc => "[csv, averages]"
    option :states,
            :aliases => '-s',
            :type => :string,
            :required => true,
            :desc => "Comma delimited list of states"
    def retrieve_data
      validate_state_array(options[:states])

      options[:states].split(',').each do |state|
        result = API.state_census(state)
        
      end
    end

    desc "version", "Print version number"
    def version
      puts "My version is #{SreTool::VERSION}"
    end
  end
end
