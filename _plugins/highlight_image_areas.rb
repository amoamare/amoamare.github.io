
#usage:
#{% highlight_img_areas directory:images iterator:image filter:*.jpg sort:descending %}
#   <img src="{{ image }}" />
#{% highlight_img_areas %}


module Jekyll
  class HighlightImageAreasBlock < Liquid::Block

    include Liquid::StandardFilters    
    Syntax = /(#{Liquid::QuotedFragment}+)?/

    def initialize(tag_name, markup, tokens)
      super
      @attributes = parse_attributes(markup)
    end

    def render(context)
      @context = context
      @context.registers[:highlight_img_areas] ||= Hash.new(0)     
      UpdatePageTitle("whattt")
      output = read_template_file('highlight_image_areas.html')
      rendered_output = Liquid::Template.parse(output).render(build_context)
      # Return the rendered output
      super
      rendered_output
    end

    private

    def parse_attributes(markup)
      attributes = {}
      markup.scan(Liquid::TagAttributes) do |key, value|
        attributes[key] = value
      end
      attributes
    end

    def build_context
      {
        'image' => @attributes['img'],
        'highlighted_areas' => '0,1,3,4',
        'site_highlight_areas' => @context.registers[:site].data['highlight_areas'] || []
      }
    end

    def read_template_file(filename)
      includes_dir = @context.registers[:site].in_source_dir('_includes')
      file_path = File.join(includes_dir, filename)
      <<~HTML
      <div class="highlight_image_areas_container">
        <img class="img_highlight_image_areas" src="#{image}" alt="Background Image">
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
    end
    
    def UpdatePageTitle(title)        
      # Update page title
      page = @context.registers[:page]
      page['title'] = title     
    end
  end
end

Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)