
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
      <div class="card-header" id="#{headingID}">
        <h4 class="mb-0">
          <button class="btn btn-link collapsed" data-toggle="collapse" data-target="##{collapsedID}" aria-expanded="false" aria-controls="#{collapsedID}">
            <span class="plus-minus-wrapper"><div class="plus-minus"></div></span><span class="collapse-title">#{@title}</span>
          </button>
        </h4>
      </div>
      <div id="#{collapsedID}" class="collapse" aria-labelledby="#{headingID}" data-parent="##{accordionID}">
        <div class="card-body">#{content}</div>
      </div>
    </div>
  EOS

  output
      end
  
    end
  end
  
  Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)