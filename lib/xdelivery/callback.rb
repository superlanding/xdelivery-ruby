module Xdelivery
  class Callback
    attr_accessor :params, :check_code, :merchant_no, :access_key

    PARAM_KEYS = [ :action, :title, :desc, :provider, :created_at ]

    def initialize(merchant_no, access_key, params)
      self.params = PARAM_KEYS.map do |key|
        [ key, params[key] ]
      end.to_h

      self.check_code = params[:check_code]
      self.merchant_no = merchant_no
      self.access_key = access_key
    end

    def valid?
      check_code == check_code!
    end

    def action
      params[:action]
    end

    def title
      params[:title]
    end

    def desc
      params[:desc]
    end

    def provider
      params[:provider]
    end

    def created_at
      if params[:created_at] == ''
        nil
      elsif Time.respond_to?(:zone)
        Time.zone.parse(params[:created_at])
      else
        Time.parse(params[:created_at])
      end
    end

    protected

    def query_string
      URI.encode_www_form(params.sort.to_h)
    end

    def check_code!
      query_string_with_salt = "merchant_no=#{merchant_no}&#{query_string}&access_key=#{access_key}"
      Digest::SHA256.hexdigest(query_string_with_salt).upcase
    end
  end
end

