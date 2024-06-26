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
      width = "700px";
      height = "700px";
      output = <<~HTML
        <table width="100%" height="100%" style="border-collapse: collapse;">
            <tr>
                <td align="center" valign="middle" style="border: none;">
                    <!-- Your PDF display code here -->
                    <object title="#{@input}" data="#{pdf_url}" type="application/pdf" width="#{width}" height="#{height}">
                        <!-- Display a download link if <object> is not supported -->
                        <p>This browser does not support displaying PDFs. Please download the PDF to view it: <a href="#{pdf_url}">Download PDF</a>.</p>
                        
                        <!-- If <object> is not supported, try displaying PDF using <iframe> -->
                        <iframe title="#{@input}" src="#{pdf_url}" width="#{width}" height="#{height}" hidden>
                            <!-- If <iframe> is not supported, try displaying PDF using <embed> -->
                            <embed title="#{@input}" src="#{pdf_url}" width="#{width}" height="#{height}" hidden>
                                <!-- Display a download link if <embed> is not supported -->
                                <p>This browser does not support displaying PDFs. Please download the PDF to view it: <a href="#{pdf_url}">Download PDF</a>.</p>
                            </embed>
                        </iframe>
                    </object>
                </td>
            </tr>
        </table>
        HTML

    Liquid::Template.parse(output).render(context)
    end

  end
end

Liquid::Template.register_tag('pdf', Jekyll::PDFEmbedTag)