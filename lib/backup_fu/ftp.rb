require 'net/ftp'

module BackupFu
  class FTPConfigError < StandardError; end

  class FTPProvider
    def initialize(options={})
      check_config(options)
      @ftp = Net::FTP.new(@options[:host], @options[:user], @options[:password])
      begin
        @ftp.chdir @options[:backup_dir]
      rescue Net::FTPPermError
        @ftp.mkdir @options[:backup_dir]
        @ftp.chdir @options[:backup_dir]
      end
    end

    def delete(file)
      @ftp.delete(file)
    end

    def put(file)
      @ftp.put(file)
    end

    def get(file, &block)
      @ftp.get(file, &block)
    end

    def list
      @ftp.list("*").map{|f| f.split(" ").last}
    end

    private
    def check_config(options)
      @options = {}
      @options[:host] = options[:ftp_host]
      raise(FTPConfigError, "FTP hostname (ftp_host) is not set in config/backup_fu.yml. If you do not want to use FTP provider, change provider in config/backup_fu.yml to s3 or local") if @options[:host].blank?

      @options[:user] = options[:ftp_user] || "anonymous"
      @options[:password] = options[:ftp_password]
      @options[:backup_dir] = options[:remote_backup_dir] || "backups"
    end
  end
end

