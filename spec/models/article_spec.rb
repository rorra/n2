require 'spec_helper'

describe Article do
  it "should create a new instance given valid attributes" do
    Factory.create(:article)
  end

  it "should require a body" do
    article = Factory.build(:article, :body => nil)
    article.should_not be_valid
    article.errors[:body].should be_present
    article.body = random_string
    article.should be_valid
  end

  describe "#details" do
    before(:each) do
      @article = Factory.create(:article)
    end

    it "should set a valid user" do
      @article.author.should == @article.content.user
    end

    it "should set a valid title" do
      @article.item_title.should == @article.content.item_title
    end

    it "should set a valid link" do
      @article.item_link.should == @article.content
    end

    it "should set a valid description" do
      @article.item_description.should == @article.content.item_description
    end

    it "should set a valid preamble" do
      @article.create_preamble.should_not be_nil
    end
  end
end
