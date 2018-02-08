module SreTool
  module Commands

    API = SreTool::BroadbandMapAPI.new

    def retrieve_demographic_data(list_of_states)
      list_of_states.split(',')
        .map {|state| API.state_census(state) }
        .map {|census_data| census_data['fips'] }
        .map {|census_id| API.demographics(census_id) }
    end

    # take a demographcs data array, extract a set of keys and display in CSV format
    def display_csv(demographics_data)
      keys = ['geographyName', 'population', 'households', 'incomeBelowPoverty', 'medianIncome']
      csv = demographics_data
        .map { |row| row.fetch_values(*keys) }
        .map { |row| row.join(',')}

      puts keys.join(',')
      csv.each { |row| puts row }
    end

    # take the output of demographics data, and display the average of
    # incomeBelowPovertyLevel
    def display_averages(demographics_data)
      poverty_levels = demographics_data
        .map { |row| row.fetch_values('incomeBelowPoverty')}
        .flatten

      puts "Average Povery Level: "
      puts poverty_levels.inject(0.0) { |a,b| a+b } / demographics_data.length
    end
  end
end
