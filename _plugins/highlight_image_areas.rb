
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
      output = read_template_file('highlight_img_areas.html')
      rendered_output = Liquid::Template.parse(output).render(build_context)

      super + rendered_output
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
      File.read(File.join('_includes', filename))
    end
  end
end

Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)