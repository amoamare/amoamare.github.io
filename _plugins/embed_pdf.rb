module Jekyll
  class PDFEmbedTag < Liquid::Tag
    include Liquid::StandardFilters

    def initialize(tag_name, input, tokens)
      super
      @input = input.strip
    end

    def render(context)
      # Fetch the base URL of the site
      baseurl = context.registers[:site].config['baseurl']
      # Construct the full URL to the PDF file
      pdf_url = "#{baseurl}/assests/documents/#{@input}"

      output = <<~HTML
        <div class="highlight_image_areas_container">
        <embed srt="">
        </embed>
            <img class="img_highlight_image_areas" alt="img" src="#{region_data['Image']}">
            <div name="highlights">
            #{area_html.join("\n")}
            </div>
        </div>
        <object title='#{pdf_url}' data='#{pdf_url}' type='application/pdf' width='700px' height='700px'>
            <embed src='#{pdf_url}' width='700px' height='700px'>
                <p>
                    This browser does not support PDFs. Please download the PDF to view it: <a href='#{pdf_url}'>Download PDF</a>.
                </p>
            </embed>
        </object>
        HTML

        Liquid::Template.parse(output).render(context)
    end

    # Custom HTML for embedding PDF
    end
  end
end

Liquid::Template.register_tag('pdf', Jekyll::PDFEmbedTag)