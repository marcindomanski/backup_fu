require 'net/ftp'

module BackupFu
  class LocalProvider
    def initialize(options={})
      @dir = options[:dump_base_path] || File.join(RAILS_ROOT, 'tmp', 'backup')
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

    private
    def check_config(options)
      @options[:host] = options[:ftp_host]
      raise(FTPConfigError, "FTP hostname (ftp_host) is not set in config/backup_fu.yml. If you do not want to use FTP provider, change provider in config/backup_fu.yml to s3 or local") if @options[:host].blank?

      @options[:user] = options[:ftp_user] || "anonymous"
      @options[:password] = options[:ftp_password]
      @options[:backup_dir] = options[:remote_backup_dir] || "backups"
    end
  end
end

