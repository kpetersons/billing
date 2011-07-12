require 'spec_helper'

describe ProfilesController do

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end

  describe "GET 'change_password'" do
    it "should be successful" do
      get 'change_password'
      response.should be_success
    end
  end

end
