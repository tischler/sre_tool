# SreTool

## Project setup

  This tool requires ruby 2.4.0+ and does not pin down a .ruby-version file.
  You will need to make sure that you have 2.4.0+ as your current ruby.

  To set up the project
  $ bundle install

## Usage

  To run the tests:
  $ bundle exec rspec

  To run an averages report:
  $ bundle exec sre_tool retrieve_data -f averages --states texas,oregon,florida

  To run a CSV report:
  $ bundle exec sre_tool retrieve_data -f csv --states texas,oregon,florida

  Since this uses Thor, you can install the gem system wide and use Thor, but that's beyond the scope of this exercise.

## Assumptions

The versions of gems should be pinned down in sre_tool.gemspec, but it isn't critical for this use case.
The API site should up, and if there are any problems with it, the tool will fail fast.
The rspec tests are making live calls, not mocked calls.  If I were truly locking this thing down, I would disallow any HTTP requests from my tests through WebMock, and then mock out the responses.
