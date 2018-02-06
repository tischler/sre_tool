require 'httparty'

module SreTool

  class BrandbandMapAPI
    include HTTParty
    base_uri 'https://www.broadbandmap.gov'

    format :json

    # broadbandmap doesn't like content-type.  it prefers a format parameter of 'json'
    OPTIONS = { query: {
        format: 'json'
      }
    }

    STATE_CENSUS_PATH = '/broadbandmap/census/state/'

    def state_census(state, opts = {})
      self.class.get(self.state_census_path(state), self.options(opts)).to_s
    end

    ## Path generators ##################
    def state_census_path(state)
      STATE_CENSUS_PATH + state
    end

    # merge request options into our constant API options
    def options(opts = {})
      OPTIONS.merge(opts)
    end

  end
end
