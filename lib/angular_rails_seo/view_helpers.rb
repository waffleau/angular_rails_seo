module AngularRailsSeo
  module ViewHelpers

    ##
    # Returns SEO data as defined in initializes/seo.rb
    def seo_data
      Rails.configuration.seo.each do |key, value|
        unless Regexp.new(value["regex"]).match(request.path).nil?
          return seo_default.merge(Rails.configuration.seo[key])
        end
      end

      seo_default
    end

    def seo_default
      Rails.configuration.seo["default"]
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
      content_tag :title, seo_data["title"]
    end

  end
end
