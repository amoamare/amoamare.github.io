
#usage:
#{% highlight_img_areas directory:images iterator:image filter:*.jpg sort:descending %}
#   <img src="{{ image }}" />
#{% highlight_img_areas %}


module Jekyll
  class HighlightImageAreasBlock < Liquid::Block

    include Liquid::StandardFilters
    Syntax = /(#{Liquid::QuotedFragment}+)?/

    def initialize(tag_name, markup, tokens)
      puts "Markup: #{markup}"
      @attributes = {}
      # Parse parameters
      markup.scan(Liquid::TagAttributes) do |key, value|
        @attributes[key] = value
      end
      


      #if @attributes['img'].nil?
      #   raise SyntaxError.new("You did not specify a directory for highlight_img_areas.")
      #end
      
      super
    end

    def render(context)      
      context.registers[:highlight_img_areas] ||= Hash.new(0)
      
# Retrieve site object from context
site = context.registers[:site]
    
# Retrieve image path from attributes
image = @attributes['img']

puts "Markup: #{image}"

# Access data from the _data folder
highlight_areas_data = site.data['highlight_areas'] || []

puts "Data: #{highlight_areas_data}"

# Define areas to be highlighted
highlighted_areas = [0, 1, 3, 4]  # Example highlighted areas

# Generate HTML output
output = <<~HTML
<div class="container">
  <img class="image" src="#{image}" alt="Background Image">
  {% if highlight_areas_data %}
    {% for area_id in highlighted_areas %}
      {% assign area_info = highlight_areas_data[area_id] %}
      {% if area_info %}
      <div class="highlight" style="top: {{ area_info['top'] }}%; left: {{ area_info['left'] }}%; width: {{ area_info['width'] }}%; height: {{ area_info['height'] }}%;">
        {{ area_info['id'] }}
      </div>  
      {% else %}
        <div>No area info found for ID: {{ area_id }}</div>
      {% endif %}
    {% endfor %}
  {% else %}
    <div>No highlight areas data found</div>
  {% endif %}
</div>
HTML

      # Parse the output string with Liquid to render any Liquid syntax
      rendered_output = Liquid::Template.parse(output).render(context)

      # Return the rendered output
      rendered_output
    end

    # Override blank? method to always return true, indicating that the block is blank
    def blank?
      false
    end
  end
end

Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)
