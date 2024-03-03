
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
      super
    end

    def render(context)      
      context.registers[:highlight_img_areas] ||= Hash.new(0)      
      site = context.registers[:site]    
      site_highlight_areas = site.data['highlight_areas'] || []
      
      highlighted_areas = "0,1,3,4"
      context['highlighted_areas'] = highlighted_areas      
      context['site_highlight_areas'] = site_highlight_areas       
      image = @attributes['img']

      output = <<~HTML
      <div class="highlight_image_areas_container">
        <img class="img_highlight_image_areas" src="#{image}" alt="Background Image">
        <div name="highlights">
          {% if highlighted_areas %}
            {% assign selected_areas = highlighted_areas | split: ',' %}
            {% for area_id in selected_areas %}
              {% assign area_info = site_highlight_areas | where: "id", area_id | first %}              
              {% if area_info %}
              <div class="highlight" style="top: {{ area_info.top }}%; left: {{ area_info.left }}%; width: {{ area_info.width }}%; height: {{ area_info.height }}%;">
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
  end
end

Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)
