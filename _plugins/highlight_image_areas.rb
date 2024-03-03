
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
      markup.scan(Liquid::TagAttributes) do |key, value|
        @attributes[key] = value      
      super
    end

    def render(context)      
      context.registers[:highlight_img_areas] ||= Hash.new(0)
      site = context.registers[:site]
    
      site_highlight_areas = site.data['highlight_areas']
      
      @highlighted_areas = "0,1,3,4";
      image = @attributes['img']
      
      
      puts "S: #{site_highlight_areas}"
      puts "s: #{highlighted_areas}"
      
      output = <<~HTML
      <div class="container">
        <img class="image" src="#{image}" alt="Background Image">
      

      </div>
      HTML
      
      puts "s: #{output}"
    
      # Parse the output string with Liquid to render any Liquid syntax
      rendered_output = Liquid::Template.parse(output).render(context)
      #rendered_output = Liquid::Template.parse(output).render('highlighted_areas' => highlighted_areas, 'context' => context)
      # Return the rendered output
      rendered_output
    end
        
  end
end

Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  doc.output = Liquid::Template.parse(doc.output).render("site" => doc.site)
end