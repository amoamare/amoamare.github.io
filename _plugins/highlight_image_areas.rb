module Jekyll
    class HighlightImageAreasBlock < Liquid::Block
  
      def render(context)
        text = super
        "<p>#{text} #{Time.now}</p>"
      end
  
    end
  end
  
  Liquid::Template.register_tag('highlight_img_areas', Jekyll::HighlightImageAreasBlock)