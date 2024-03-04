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
      # Access the page front matter directly
      page = context.registers[:page]
      
      # Get the highlighted_areas attribute from the page front matter
      highlighted_areas = page['highlighted_areas'].to_s.strip.gsub(/^\"|\"$/, '')
      highlight_image = page['highlight_image']            
      site = context.registers[:site]    
      site_highlight_areas = site.data['highlight_areas'] || []

      # Output the value of highlighted_areas for debugging
      puts "site_highlight_areas: '#{site_highlight_areas}'"

      # Split the string into individual areas
      selected_areas = highlighted_areas.split(',')

      # Output the individual areas for debugging
      puts "Individual areas: #{selected_areas.inspect}"

      # Create an array to hold the HTML for each area
      area_html = []

      puts "before loop"
      # Loop through selected areas and build HTML for each
      selected_areas.each do |area_id|
        puts "before loo1p #{|area| area['id']}"
        puts "before loo1p #{area_id['id']}"
        area_info = site_highlight_areas.find { |area| area['id'] == area_id }
        
      puts "before l123oop"
        if area_info
          area_html << "<div class='highlight' name='bank-#{area_info['id']}' style='top: #{area_info['top']}%; left: #{area_info['left']}%; width: #{area_info['width']}%; height: #{area_info['height']}%;'>#{area_info['id']}</div>"
        end
      end

      # Combine all area HTML into a single string
      area_html_string = area_html.join("\n")

      # Generate the output HTML
      output = <<~HTML
      <div class="highlight_image_areas_container">
        <img class="img_highlight_image_areas" src="#{highlight_image}">
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
