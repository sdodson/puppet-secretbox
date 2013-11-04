#!/usr/bin/env ruby -S rspec

require 'spec_helper'

describe "the secretbox function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("secretbox").should == "function_secretbox"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    lambda { scope.function_secretbox([]) }.should( raise_error(Puppet::ParseError))
  end

  def secretbox(args = [])
    scope = Puppet::Parser::Scope.new_for_test_harness('localhost')
    scope.stubs(:lookupvar).with("fqdn").returns('localhost')

    scope.function_secretbox(args)
  end
end
