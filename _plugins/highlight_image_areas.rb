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
      @region = markup.strip
    end

    def render(context)
      region_data = context[@region]

      
      # Create an array to hold the HTML for each area
      area_html = []

      # Check if region_data is a Hash
      if region_data.is_a?(Hash)
        # Output each location within the region
          region_data["Locations"].each do |area_info|
          area_html << "<div class='highlight' name='bank-#{area_info['id']}' style='top: #{area_info['top']}%; left: #{area_info['left']}%; width: #{area_info['width']}%; height: #{area_info['height']}%;'>#{area_info['id']}</div>"
        end
      end

      # Combine all area HTML into a single string
      area_html_string = area_html.join("\n")


      # Generate the output HTML
      output = <<~HTML
      <div class="highlight_image_areas_container">
        <img class="img_highlight_image_areas" src="#{region_data['image']}">
        <div name="highlights">
          #{area_html_string}
        </div>
      </div>
      HTML

      # Parse the output string with Liquid to render any Liquid syntax
      rendered_output = Liquid::Template.parse(output).render(context)

      # Return the rendered output
      super
      rendered_output
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
