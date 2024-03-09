module Jekyll
    module QueryParamsFilter
      def query_params(input)
        query_params = {}
        input.split("&").each do |param|
          key, value = param.split("=")
          query_params[key] = value
        end
        query_params
      end
    end
  end
  
  Liquid::Template.register_filter(Jekyll::QueryParamsFilter)