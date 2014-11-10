require 'angular_rails_seo/view_helpers'

module AngularRailsSeo
  class Railtie < Rails::Railtie
    initializer "angular_rails_seo.configure_rails_initialization" do
      begin
        file = File.read("#{Rails.root}/seo.json")
        seo = JSON.parse(file)

        seo.each_pair do |k,v|
          seo[k] = ActiveSupport::HashWithIndifferentAccess.new(v)
          seo[k][:regex] = "#{Regexp.quote(k).gsub('\*', "([^/]+)")}$"
        end

        Rails.configuration.seo = seo
      rescue => e
        Rails.logger.warn "Could not start AngularRailsSeo - please ensure your seo.json file is valid"
      end
    end

    initializer "angular_rails_seo.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end

    rake_tasks do
      load "tasks/seo.rake"
    end
  end
end
