#!/usr/bin/env ruby -S rspec

require 'spec_helper'

describe 'the secretbox function' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    Puppet::Parser::Functions.function('secretbox').should == 'function_secretbox'
  end

  it 'should raise a ParseError if there is less than 1 argument' do
    lambda { scope.function_secretbox([]) }.should raise_error(Puppet::ParseError)
  end

  def secretbox(index)
    Puppet[:vardir] = SECRETS_FIXTURES_DIR
    scope.stubs(:lookupvar).with('fqdn').returns('localhost')

    scope.function_secretbox([index])
  end

  def secretbox_length_method(index, length, method)
    Puppet[:vardir] = SECRETS_FIXTURES_DIR
    scope.stubs(:lookupvar).with('fqdn').returns('localhost')
    scope.function_secretbox([index, length, method])
  end

  def secretbox_length(index, length)
    Puppet[:vardir] = SECRETS_FIXTURES_DIR
    scope.stubs(:lookupvar).with('fqdn').returns('localhost')
    scope.function_secretbox([index, length])
  end

  it 'should generate a value' do
    secretbox(['generate_a_value'])
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

  it 'should generate proper base64 string with length specified ' do
    # ruby1.8.7 doesn't include strict_decode64 but lets assume if the length of the decoded string
    # is what we asked for it's all good
    # TODO: figure out how to conditionally call Base64.strict_decode64 on Ruby > 1.9.3
    value_1 = secretbox_length_method('base64_test_1', 32, 'base64')
    value_2 = secretbox_length_method('base64_test_2', 9, 'base64')
    expect(Base64.decode64(value_1).length).to eq(32)
    expect(Base64.decode64(value_2).length).to eq(9)
  end

  it 'should generate random_bytes with appropriate length' do
    value_1 = secretbox_length('length_test1', 9)
    value_2 = secretbox_length('length_test2', 32)
    expect(value_1.length).to eq(9)
    expect(value_2.length).to eq(32)
  end

end
