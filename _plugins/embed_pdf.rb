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


    Liquid::Template.parse(output).render(context)

    # Custom HTML for embedding PDF
    end
  end
end

Liquid::Template.register_tag('pdf', Jekyll::PDFEmbedTag)