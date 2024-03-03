
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

      @attributes['img'] = '';
      @attributes['areas'] = '';
      puts "Markup: #{@attributes['img']}"
      # Parse parameters
          markup.scan(Liquid::TagAttributes) do |key, value|
              @attributes[key] = value
       


      #if @attributes['img'].nil?
      #   raise SyntaxError.new("You did not specify a directory for highlight_img_areas.")
      #end
      
      super
    end

    def render(context)
      image = Dir.glob(@attributes['img']).first

      puts "Markup: #{image}"
      


#  content = super

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

Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)