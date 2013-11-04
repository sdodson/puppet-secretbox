#!/usr/bin/env ruby -S rspec

require 'spec_helper'

describe 'the secretbox function' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    Puppet::Parser::Functions.function('secretbox').should == 'function_secretbox'
  end

  it 'should raise a ParseError if there is less than 1 argument' do
    lambda { scope.function_secretbox([]) }.should raise_error(ArgumentError)
  end

  def secretbox(index)
    scope = Puppet::Parser::Scope.new_for_test_harness('localhost')
    libdir = Puppet[:libdir]
    Puppet.stubs(:[]).with(:vardir).returns(SECRETS_FIXTURES_DIR)
    Puppet.stubs(:[]).with(:libdir).returns(libdir)
    scope.stubs(:lookupvar).with('fqdn').returns('localhost')

    scope.function_secretbox([index])
  end

  it 'should generate a value' do
    secretbox('generate_a_value')
  end

  it 'should not regenerate a value' do
    value_1 = secretbox('some_key')
    value_2 = secretbox('some_key')
    expect(value_1).to eq(value_2)
  end

  it 'should use what is on disk' do
    value_1 = secretbox('premade')
    expect(value_1).to eq('premade value')
  end

  it 'handle leading & trailing spaces' do
    value_1 = secretbox('value_with_leading_space')
    expect(value_1).to eq(' look ma a space')

    value_1 = secretbox('value_with_trailing_space')
    expect(value_1).to eq('look ma a space ')
  end
end
