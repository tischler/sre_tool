require 'thor'

module SreTool

  class Command < Thor
    include ServiceFunctions

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
      demographics_data = retrieve_demographic_data(options[:states])

      if options[:format].eql?('csv')
        puts format_csv(demographics_data)
      else
        puts format_averages(demographics_data)
      end
    rescue StateNotFoundError => sree
      puts "ERROR:  Cannot find state '#{sree.message}'.  Cannot continue."
    rescue InvalidCensusIDError => icie
      puts "ERROR:  Consistency issue with APIs. Cannot find the census data for #{icie.message}.  Cannot continue."
    rescue SreToolHTTPError => httpe
      puts "ERROR: Http Error, Cannot continue."
      puts httpe.message
    rescue StandardError => se
      puts "ERROR: Unknown Error. Cannot continue."
      puts se.message
    end

    desc "version", "Print version number"
    def version
      puts "My version is #{SreTool::VERSION}"
    end
  end
end
