
#usage:
#{% highlight_img_areas directory:images iterator:image filter:*.jpg sort:descending %}
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
      context.registers[:highlight_img_areas] ||= Hash.new(0)
      
      # Access the page front matter directly
page = context.registers[:page]

# Get the highlighted_areas attribute from the page front matter
highlighted_areas = page['highlighted_areas'].to_s.strip.gsub(/^\"|\"$/, '')

highlight_image = page['highlight_image']

      
      site = context.registers[:site]    
      site_highlight_areas = site.data['highlight_areas'] || []
      
      
      # Output the value of highlighted_areas for debugging
puts "highlighted_areas: '#{highlighted_areas}'"

# Split the string into individual areas
selected_areas = highlighted_areas.split(',')

# Output the individual areas for debugging
puts "Individual areas: #{selected_areas.inspect}"

      
      
      context['highlighted_areas'] = highlighted_areas      
      context['site_highlight_areas'] = site_highlight_areas       
      image = @attributes['img']

      output = <<~HTML
      <div class="highlight_image_areas_container">
        <img class="img_highlight_image_areas" src="#{highlight_image}" ">
        <div name="highlights">
          {% if highlighted_areas %}
            {% assign selected_areas = highlighted_areas | split: ',' %}
            {% for area_id in selected_areas %}
              {% assign area_info = site_highlight_areas | where: "id", area_id | first %}              
              {% if area_info %}
              <div class="highlight" name="bank-{{ area_info.id }}" style="top: {{ area_info.top }}%; left: {{ area_info.left }}%; width: {{ area_info.width }}%; height: {{ area_info.height }}%;">
                {{ area_info.id }}
              </div>  
              {% endif %}
            {% endfor %}        
          {% endif %}
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
