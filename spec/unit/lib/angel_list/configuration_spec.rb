require 'spec_helper'

describe AngelList::Configuration do
  class ExtendedClass; extend  AngelList::Configuration; end
  class IncludedClass; include AngelList::Configuration; end

  describe "#extended" do
    it "has all configuration variables set to the default values by default" do
      AngelList::Configuration::VALID_OPTIONS_KEYS.each do |key|
        ExtendedClass.send(key).should == AngelList::Configuration.const_get("DEFAULT_#{key.to_s.upcase}")
      end
    end
  end

  describe "#configure" do
    it "allows configuration variables to be set in a block" do
      object = IncludedClass.new
      object.configure do |o|
        o.access_token = "my oauth token"
      end
      object.access_token.should == "my oauth token"
    end
  end

  describe "#options" do
    it "returns a hash of all configuration options" do
      object = IncludedClass.new
      config = { :access_token => "123-token" }
      config.each { |k,v| object.send("#{k.to_s}=", v) }
      config.each { |k,v| object.options[k].should == v }
    end
  end

  describe "#reset" do
    it "sets all config variables to the defaults" do
      object = IncludedClass.new
      AngelList::Configuration::VALID_OPTIONS_KEYS.each_with_index do |key, i|
        object.send("#{key}=", i)
        object.send(key).should == i
      end

      object.reset

      AngelList::Configuration::VALID_OPTIONS_KEYS.each do |key|
        object.send(key).should == AngelList::Configuration.const_get("DEFAULT_#{key.to_s.upcase}")
      end
    end
  end
end
