require 'json'

module Monitoring
  class FileReport
    def initialize(path = Monitoring.configuration.output_file)
      @mutex = Mutex.new
      @path = path
    end

    def write(result)
      mutex.synchronize do
        contents = merge_with(result)
        write_to_file(contents)
      end
    end

    def read
      mutex.synchronize { read_from_file }
    end

    private

    attr_reader :mutex, :path

    def read_from_file
      File.read(path)
    end

    def write_to_file(contents)
      File.open(path, 'w') { |f| f.write(contents) }
    end

    def merge_with(result)
      content = parsed_tasks.delete_if { |task| result.same_probe?(task) }
      content << result
      content.to_json
    end

    def parsed_tasks
      return [] unless File.exists?(path)

      JSON.parse(read_from_file) rescue []
    end
  end
end
