module Jekyll
  class HighlightImageAreasBlock < Liquid::Block

    include Liquid::StandardFilters
    Syntax = /(#{Liquid::QuotedFragment}+)?/

    def initialize(tag_name, markup, tokens)
  
    end

    def render(context)      
      context.registers[:highlight_img_areas] ||= Hash.new(0)
      output
    end
  end
end

Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  doc.output = Liquid::Template.parse(doc.output).render("site" => doc.site)
end
