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
      pdf_url = "#{baseurl}/assets/documents/#{@input}"

      output = <<~HTML
        <object title="#{@input}" data="#{pdf_url}" type='application/pdf' width='700px' height='700px'>
         <iframe src='#{pdf_url}'>
            <embed src="#{pdf_url}" width='700px' height='700px'>
                <p>
                    This browser does not support PDFs. Please download the PDF to view it: <a href="#{pdf_url}">Download PDF</a>.
                </p>
        
            </iframe>
        </object>
        HTML

    Liquid::Template.parse(output).render(context)
    end

  end
end

Liquid::Template.register_tag('pdf', Jekyll::PDFEmbedTag)