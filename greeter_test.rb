require 'rubygems'
require 'rack'
require 'minitest/autorun'
require File.expand_path('../lib/greeter', __FILE__ )

describe Greeter do

  before do
    @request = Rack::MockRequest.new(Greeter)
  end

  it 'Returns a 404 request for unknown requests ' do
    @request.get('/uknown').status.must_equal 404
  end

  it '/ displays Hello world as default ' do
    @request.get('/').body.must_include 'Hello World!'
  end

  it '/ displays the name passed from cookie ' do
    @request.get('/','HTTP_COOKIE'=>'greet=Ruby').body.must_include 'Hello Ruby'
  end

  it '/change sets cookie and redirect to root' do
    response = @request.post('/change',params: {'name'=>'Ruby'})
    response.status.must_equal 302
    response['location'].must_equal '/'
    response['Set-Cookie'].must_include 'greet=Ruby'
  end

end

