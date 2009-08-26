require 'net/ftp'

module BackupFu
  class LocalProvider
    def initialize(options={})
      @dir = options[:dump_base_path] || File.join(RAILS_ROOT, 'tmp', 'backup')
    end

    def delete(file)
      File.delete(file)
    end

    def put(file)
    end

    def get(file, &block)
      Dir.chdir(@dir) do
        File.open(file, "r", &block)
      end
    end

    def list
      Dir.chdir(@dir){Dir.glob("*")}
    end
  end
end

