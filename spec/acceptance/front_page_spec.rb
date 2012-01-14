require 'spec_helper'

describe "Front page" do
  it 'should load' do
    visit "/"
    click_on "News"
    click_on "Galleries"
    click_on "Register"
  end

end
