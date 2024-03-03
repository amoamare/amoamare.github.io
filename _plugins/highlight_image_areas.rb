module Jekyll
  class HighlightImageAreasBlock < Liquid::Block

    include Liquid::StandardFilters
    Syntax = /(#{Liquid::QuotedFragment}+)?/

    def initialize(tag_name, markup, tokens)
      super
      @attributes = {}
      # Parse parameters
      markup.scan(Liquid::TagAttributes) do |key, value|
        @attributes[key] = value
      end
    end

    def render(context)
      # Retrieve site object from context
      site = context.registers[:site]
      
      # Retrieve image path from attributes
      image_path = @attributes['img']

      # Access data from the _data folder
      highlight_areas_data = site.data['highlight_areas'] || []

      # Define areas to be highlighted
      highlighted_areas = [0, 1, 3, 4]  # Example highlighted areas

      # Generate HTML output
      output = <<~HTML
      <div class="container">
        <img class="image" src="#{image_path}" alt="Background Image">
        {% if highlight_areas_data %}
          {% for area_id in highlighted_areas %}
            {% assign area_info = highlight_areas_data | where: "id", area_id | first %}
            {% if area_info %}
            <div class="highlight" style="top: {{ area_info['top'] }}%; left: {{ area_info['left'] }}%; width: {{ area_info['width'] }}%; height: {{ area_info['height'] }}%;">
              {{ area_info['id'] }}
            </div>  
            {% endif %}
          {% endfor %}
        {% endif %}
      </div>
      HTML

      puts "HTML: #{output}"
      # Parse the output string with Liquid to render any Liquid syntax
      #rendered_output = Liquid::Template.parse(output).render(context)

      #puts "HTML: #{rendered_output}"
      # Return the rendered output
      output
    end

    # Override blank? method to always return false, indicating that the block is not blank
    def blank?
      false
    end
  end
end

Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)
