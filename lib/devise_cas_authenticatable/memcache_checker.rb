require 'net/telnet'

module DeviseCasAuthenticatable
  class MemcacheChecker
    attr_reader :rails_configuration

    def initialize(rails_configuration)
      @rails_configuration = rails_configuration
    end

    def session_store_memcache?
      session_store_class.name =~ /memcache/i
    end

    def alive?
      memcache_servers = rails_configuration.session_options[:memcache_server] || ["127.0.0.1:11211"]
      memcache_servers.each do |server|
        host, port = server.split(":")
        begin
          Net::Telnet.new("Host" => host, "Port" => port, "Timeout" => 1)
          return true
        rescue Errno::ECONNREFUSED
          return false
        end
      end
    end

    private

    def session_store_class
      @session_store_class ||= DeviseCasAuthenticatable::SessionStoreIdentifier.new.session_store_class
    end
  end
end