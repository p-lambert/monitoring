require 'json'

module Monitoring
  class FileReport
    BLANK_JSON = {}.to_json

    def initialize(path = Monitoring.configuration.output_file)
      @mutex = Mutex.new
      @path = path
    end

    def write(result)
      mutex.synchronize { update_with(result) }
    end

    def read
      mutex.synchronize { read_from_file }
    end

    private

    attr_reader :mutex, :path

    def read_from_file
      return BLANK_JSON unless File.size?(path)

      File.read(path)
    end

    def update_with(result)
      contents = results_hash.merge(result).to_json
      File.open(path, 'w') { |f| f.write(contents) }
    end

    def results_hash
      JSON.parse(read_from_file) rescue {}
    end
  end
end
