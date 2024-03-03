
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
        img = @attributes['img']
        @attributes = {}

        @attributes['img'] = '';
        @attributes['areas'] = '';

        # Parse parameters
        if markup =~ Syntax
            markup.scan(Liquid::TagAttributes) do |key, value|
                @attributes[key] = value
            end
        else
            raise SyntaxError.new("Bad parameters given to 'highlight_img_areas' plugin.")
        end

        #if @attributes['img'].nil?
        #   raise SyntaxError.new("You did not specify a directory for highlight_img_areas.")
        #end
        
        super
      end

      def render(context)
        context.registers[:highlight_img_areas] ||= Hash.new(0)

        image = Dir.glob(@attributes['img'])
        puts "Markup: #{image}"
        
      # Access custom data via context
      page_data = context['page']
      highlighted_areas = page_data['highlighted_areas']

  content = super
  output = <<~EOS
  <div class="container">
    <img class="image" src="#{image}" alt="Background Image">
    {% if highlighted_areas %}
      {% assign selected_areas = highlighted_areas | split: ',' %}
      {% for area_id in selected_areas %}
        {% assign area_info = site.data.highlight_areas | where: "id", area_id | first %}
        {% if area_info %}
        <div class="highlight" style="top: {{ area_info.top }}%; left: {{ area_info.left }}%; width: {{ area_info.width }}%; height: {{ area_info.height }}%;">
        {{ area_info.id }}
        </div>  
        {% endif %}
      {% endfor %}
    {% endif %}
  </div>
  EOS

  output
      end
  
    end
  end
  
  Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)