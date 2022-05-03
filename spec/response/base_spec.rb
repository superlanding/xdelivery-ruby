require 'spec_helper'

describe 'Xdelivery::API::Response::Base' do
  describe "當沒有登入的情況 ..." do
    before do
      @data = "{\"status\":false}"
      stub_request(:any, Xdelivery::API::Base::BASE_URL).to_return(body: @data, status: 401)
      @http_response = begin
        RestClient.get(Xdelivery::API::Base::BASE_URL)
      rescue RestClient::ExceptionWithResponse => e
        e.response  
      end

      @response = Xdelivery::API::Response::Orders.new(@http_response)
    end

    it "#auth? == false" do
      assert_equal false, @response.auth?
    end

    it "#status? == false" do
      assert_equal false, @response.status?
    end
  end

  describe "當正常登入的情況 ..." do
    before do
      @data = "{\"status\":true}"
      stub_request(:any, Xdelivery::API::Base::BASE_URL).to_return(body: @data, status: 200)
      @http_response = begin
        RestClient.get(Xdelivery::API::Base::BASE_URL)
      rescue RestClient::ExceptionWithResponse => e
        e.response  
      end

      @response = Xdelivery::API::Response::Orders.new(@http_response)
    end

    it "#auth? == true" do
      assert @response.auth?
    end

    it "#status? == false" do
      assert @response.status?
    end
  end

  describe "當回傳不明 500.html 時..." do
    before do
      @body = <<-HTML
        <html>
          <head>
            <title>We're sorry, but something went wrong (500)</title>
            <meta name="viewport" content="width=device-width,initial-scale=1">
          </head>
          <body class="rails-default-error-page">
            <!-- This file lives in public/500.html -->
            <div class="dialog">
              <div>
                <h1>We're sorry, but something went wrong.</h1>
              </div>
              <p>If you are the application owner check the logs for more information.</p>
            </div>
          </body>
        </html>
      HTML
      stub_request(:any, Xdelivery::API::Base::BASE_URL).to_return(body: @body, status: 500)
      @http_response = begin
        RestClient.get(Xdelivery::API::Base::BASE_URL)
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    end

    it 'shoud raise Xdelivery::InternalServerError' do
      e = assert_raises(Xdelivery::InternalServerError) do
        @response = Xdelivery::API::Response::Orders.new(@http_response)
      end
      assert_equal('500, Internal Server Error', e.message)
    end
  end
end
