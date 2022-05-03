require 'spec_helper'

describe 'Xdelivery::API::Response::Base' do
  describe "當沒有登入的情況 ..." do
    before do
      @body = "{\"status\":false}"
      @http_response = fake_resp(body: @body, status: 401)
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
      @body = "{\"status\":true}"
      @http_response = fake_resp(body: @body, status: 200)
      @response = Xdelivery::API::Response::Orders.new(@http_response)
    end

    it "#auth? == true" do
      assert @response.auth?
    end

    it "#status? == false" do
      assert @response.status?
    end
  end

  describe '當回傳不是 json 時...' do
    before do
      @body = <<-HTML
        <!DOCTYPE html>
        <html>
        <head></head>
        <body></body>
        </html>
      HTML
    end

    it 'should raise Xdelivery::Client::UnknownResponse, when status code = 401' do
      e = assert_raises Xdelivery::Client::UnknownResponse do
        Xdelivery::API::Response::Orders.new(fake_resp(body: @body, status: 401))
      end
      assert_equal('401, Response is not json.', e.message)
    end

    it 'should raise Xdelivery::Client::UnknownResponse, when status code = 200' do
      e = assert_raises Xdelivery::Client::UnknownResponse do
        Xdelivery::API::Response::Orders.new(fake_resp(body: @body, status: 200))
      end
      assert_equal('200, Response is not json.', e.message)
    end

    it 'should raise Xdelivery::Client::UnknownResponse, when status code = 600' do
      e = assert_raises Xdelivery::Client::UnknownResponse do
        Xdelivery::API::Response::Orders.new(fake_resp(body: @body, status: 600))
      end
      assert_equal('Unexpected response status code: 600.', e.message)
    end
  end

  describe "當回傳不明 500.html 時..." do
    before do
      @body = <<-HTML
        <!DOCTYPE html>
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
      @http_response = fake_resp(body: @body, status: 500)
    end

    it 'shoud raise Xdelivery::Client::InternalServerError' do
      e = assert_raises(Xdelivery::Client::InternalServerError) {
        Xdelivery::API::Response::Orders.new(@http_response)
      }
      assert_equal('500, Internal Server Error', e.message)
    end
  end

  describe "當回傳不明 404.html 時..." do
    before do
      @body = <<-HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>The page you were looking for doesn't exist (404)</title>
        <meta name="viewport" content="width=device-width,initial-scale=1">
      </head>

      <body class="rails-default-error-page">
        <!-- This file lives in public/404.html -->
        <div class="dialog">
          <div>
            <h1>The page you were looking for doesn't exist.</h1>
            <p>You may have mistyped the address or the page may have moved.</p>
          </div>
          <p>If you are the application owner check the logs for more information.</p>
        </div>
      </body>
      </html>
      HTML

      @http_response = fake_resp(body: @body, status: 404)
    end

    it 'shoud raise Xdelivery::Client::NotFound' do
      e = assert_raises(Xdelivery::Client::NotFound) {
        Xdelivery::API::Response::Orders.new(@http_response)
      }
      assert_equal('404, Not Found', e.message)
    end
  end
end
