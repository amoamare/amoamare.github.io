Module Jekyll
  class PDFEmbedTag < Liquid::Tag
    def initialize(tag_name, input, tokens)
      super
      @input = input.strip
    end

    def render(context)
      # Fetch the base URL of the site
      baseurl = context.registers[:site].config['baseurl']
      # Construct the full URL to the PDF file
      pdf_url = "#{baseurl}/assests/documents/#{@input}"
      # Embed the PDF using an <iframe> tag
      "<iframe src='#{pdf_url}' width='100%' height='500px' frameborder='0'></iframe>"
      "<object data='#{pdf_url}' type="application/pdf" width="700px" height="700px">
      <embed src='#{pdf_url}'>
          <p>This browser does not support PDFs. Please download the PDF to view it: <a href='#{pdf_url}'>Download PDF</a>.</p>
      </embed>
  </object>"
    end
  end
end

Liquid::Template.register_tag('pdf', Jekyll::PDFEmbedTag)