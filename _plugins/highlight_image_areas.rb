
#usage:
#{% highlight_img_areas directory:images iterator:image filter:*.jpg sort:descending %}
#   <img src="{{ image }}" />
#{% highlight_img_areas %}


module Jekyll
    class HighlightImageAreasBlock < Liquid::Block

      def initialize(tag_name, markup)
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

        text = super
        "<p>#{text} #{Time.now}</p>"
       
      end
  
    end
  end
  
  Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)