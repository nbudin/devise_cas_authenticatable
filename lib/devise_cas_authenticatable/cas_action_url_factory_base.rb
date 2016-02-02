module Devise
  class CasActionUrlFactoryBase
    attr_reader :base_url, :mapping, :action

    def self.prepare_class
      Class.new(self) do
        include Rails.application.routes.url_helpers

        if Rails.application.routes.respond_to?(:mounted_helpers) && Rails.application.routes.mounted_helpers
          include Rails.application.routes.mounted_helpers
        end
      end
    end

    def initialize(base_url, mapping, action)
      @base_url = base_url
      @mapping  = mapping
      @action   = action
    end

    def call
      uri      = URI.parse(base_url).tap { |uri| uri.query = nil }
      uri.path = load_base_path
      uri.to_s
    end

    alias_method :build, :call

    private
    def load_base_path
      load_routes_path || load_mapping_path
    end

    def load_routes_path
      router_name = mapping.router_name || Devise.available_router_name
      context     = send(router_name)

      route = "#{mapping.singular}_#{action}_path"
      if context.respond_to? route
        context.send route
      else
        nil
      end
    rescue NameError, NoMethodError
      nil
    end

    def load_mapping_path
      path = mapping_fullpath || mapping_raw_path
      path << "/" unless path =~ /\/$/
      path << action
      path
    end

    def mapping_fullpath
      return nil unless mapping.respond_to?(:fullpath)
      "#{rails_relative_url_root}#{mapping.fullpath}"
    end

    def mapping_raw_path
      "#{rails_relative_url_root}#{mapping.raw_path}"
    end

    def rails_relative_url_root
      ENV['RAILS_RELATIVE_URL_ROOT']
    end
  end
end
