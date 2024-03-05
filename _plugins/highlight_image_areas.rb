#usage:
#{% highlight_img_areas %}
#   <img src="{{ image }}" />
#{% highlight_img_areas %}


module Jekyll
  class HighlightImageAreasBlock < Liquid::Block

    include Liquid::StandardFilters
    Syntax = /(#{Liquid::QuotedFragment}+)?/

    def initialize(tag_name, markup, tokens)
      @attributes = parse_attributes(markup)
      super
    end

    def render(context)

      super
      
    end

    # Override blank? method to always return true, indicating that the block is blank
    def blank?
      false
    end

    

    private

    def parse_attributes(markup)
      attributes = {}
      markup.scan(Liquid::TagAttributes) do |key, value|
        attributes[key] = value
      end
      attributes
    end
    
  end
end

Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)
