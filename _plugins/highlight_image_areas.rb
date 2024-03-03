
#usage:
#{% highlight_img_areas directory:images iterator:image filter:*.jpg sort:descending %}
#   <img src="{{ image }}" />
#{% highlight_img_areas %}


module Jekyll
    class HighlightImageAreasBlock < Liquid::Block

      include Liquid::StandardFilters
      Syntax = /(#{Liquid::QuotedFragment}+)?/

      def initialize(tag_name, markup, tokens)
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

        
  content = super
  output = <<~EOS
    <div class="card">
      <div class="card-header" id="">
        <h4 class="mb-0">
          <button class="btn btn-link collapsed" data-toggle="collapse" data-target="" aria-expanded="false" aria-controls="">
            <span class="plus-minus-wrapper"><div class="plus-minus"></div></span><span class="collapse-title"></span>
          </button>
        </h4>
      </div>
      <div id="" class="collapse" aria-labelledby="" data-parent="#">
        <div class="card-body"></div>
      </div>
    </div>
  EOS

  output
      end
  
    end
  end
  
  Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)