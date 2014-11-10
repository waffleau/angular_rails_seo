module AngularRailsSeo
  module ViewHelpers

    ##
    # Returns SEO data as defined in in seo.json
    def seo_data
      if @seo_data.nil?
        Rails.configuration.seo.each do |key, value|
          regex = Regexp.new(value["regex"]).match(request.path)

          unless regex.nil?
            data = Rails.configuration.seo[key]
            fallback = data["parent"].blank? ? seo_default : seo_default.merge(Rails.configuration.seo[data["parent"]])

            unless data["model"].blank?
              response = seo_dynamic(data["model"], regex[1..(regex.size - 1)])
              data = response.nil? ? {} : response
            end

            @seo_data = fallback.merge(data)
          end
        end
      end

      @seo_data ||= seo_default
    end

    def seo_default
      Rails.configuration.seo["default"]
    end

    def seo_dynamic(class_name, matchdata)
      begin
        klass = class_name.constantize
      rescue
        logger.warn "SEO: unable to retrieve SEO data for #{class_name}"
        return nil
      end

      begin
        response = klass.send(:seo_match, matchdata)
      rescue
        logger.warn "SEO: couldn't call seo_match method of #{class_name}"
        return nil
      end

      return response
    end

    ##
    # Author meta tags
    def seo_meta_author
      tag :meta, name: "author", content: seo_data["author"]
    end

    ##
    # Description meta tags
    def seo_meta_description
      tag :meta, name: "description", content: seo_data["description"]
    end

    ##
    # Inserts all SEO tags
    def seo_tags
      seo_title + seo_meta_author + seo_meta_description
    end

    ##
    # Title tag
    def seo_title
      content_tag :title, seo_data["title"], "ng-bind" => "pageTitle"
    end

  end
end
