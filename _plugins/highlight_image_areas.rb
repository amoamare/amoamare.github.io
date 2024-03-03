
#usage:
#{% highlight_img_areas directory:images iterator:image filter:*.jpg sort:descending %}
#   <img src="{{ image }}" />
#{% highlight_img_areas %}


module Jekyll
  class HighlightImageAreasBlock < Liquid::Block
    include Liquid::StandardFilters

    def initialize(tag_name, markup, tokens)
      super
      @attributes = parse_attributes(markup)
      @image = @attributes['img']
      @highlighted_areas = "0,1,3,4"
      @site_highlight_areas = context.registers[:site].data['highlight_areas'] || []
    end

    def render(context)
      context['highlighted_areas'] = highlighted_areas
      context['site_highlight_areas'] = site_highlight_areas
      context['image'] = image

      output = File.read(File.join(context.registers[:site].config['source'], '_includes', 'highlight_img_areas.html'))
      rendered_output = Liquid::Template.parse(output).render(context)

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
  end
end

Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)