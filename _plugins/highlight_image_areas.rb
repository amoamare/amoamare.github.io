module Jekyll
  class HighlightImageAreasBlock < Liquid::Block
    include Liquid::StandardFilters

    def initialize(tag_name, markup, tokens)
      @attributes = parse_attributes(markup)
      super
      @region = markup.strip
    end

    def render(context)
      region_data = context[@region]
      return nil unless region_data && region_data['Regions']

      # Access the page front matter directly
      page = context.registers[:page]
      highlighted_regions = page['highlighted_regions']
      puts "highlighted_regions: #{highlighted_regions.inspect}"

      puts "Region Data: #{region_data['Regions'].inspect}"

      area_html = region_data['Regions'].select do |area_info|
        puts "Highlighted Regions: #{highlighted_regions.include?(area_info['id'])}"
        highlighted_regions.include?(area_info['id'])
      end.map do |area_info|
        
          id_html = area_info['displayId'] == true ? area_info['id'] : ''
          "<div class='highlight' name='bank-#{area_info['id']}' style='top: #{area_info['top']}%; left: #{area_info['left']}%; width: #{area_info['width']}%; height: #{area_info['height']}%;'>#{id_html}</div>"
      end

      output = <<~HTML
        <div class="highlight_image_areas_container">
          <img class="img_highlight_image_areas" alt="img" src="#{region_data['Image']}">
          <div name="highlights">
            #{area_html.join("\n")}
          </div>
        </div>
      HTML

      Liquid::Template.parse(output).render(context)
    end

    # Override blank? method to always return true, indicating that the block is blank
    def blank?
      false
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
