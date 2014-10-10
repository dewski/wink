require "test_helper"

describe Wink::Config do
  before do
    Wink.reset
  end

  it "can set configuration options" do
    Wink.configure do |wink|
      wink.client_id     = "client_id"
      wink.client_secret = "client_secret"
      wink.access_token  = "access_token"
      wink.refresh_token = "refresh_token"
    end

    assert_equal "client_id", Wink.client_id
    assert_equal "client_secret", Wink.client_secret
    assert_equal "access_token", Wink.access_token
    assert_equal "refresh_token", Wink.refresh_token
  end

  it "can set configuration option manually" do
    Wink.client_id = "winky"

    assert_equal "winky", Wink.client_id
  end

  it "can be reset" do
    Wink.client_id = "winky"
    assert_equal "winky", Wink.client_id

    Wink.reset
    assert_nil Wink.client_id
  end
end
