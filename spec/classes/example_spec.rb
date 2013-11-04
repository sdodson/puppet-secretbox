require 'spec_helper'

describe 'secretbox' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "secretbox class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should include_class('secretbox::params') }

        it { should contain_class('secretbox::install') }
        it { should contain_class('secretbox::config') }
        it { should contain_class('secretbox::service') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'secretbox class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
