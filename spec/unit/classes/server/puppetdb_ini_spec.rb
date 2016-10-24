require 'spec_helper'

describe 'puppetdb::server::puppetdb', :type => :class do
  context 'on a supported platform' do
    on_supported_os.each do |os, os_facts|
      let(:facts) do
        os_facts
      end
      context "on #{os}" do

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('puppetdb::server::puppetdb') }

        describe 'when using default values' do
          it { is_expected.to contain_ini_setting('puppetdb-connections-from-master-only').
            with(
                 'ensure'  => 'absent',
                 'path'    => '/etc/puppetlabs/puppetdb/conf.d/puppetdb.ini',
                 'section' => 'puppetdb',
                 'setting' => 'certificate-whitelist',
                 'value'   => '/etc/puppetlabs/puppetdb/certificate-whitelist'
                 )}
          it { is_expected.to contain_file('/etc/puppetlabs/puppetdb/certificate-whitelist').
            with(
                 'ensure'  => 'absent',
                 'owner'   => 0,
                 'group'   => 0,
                 'mode'    => '0644',
                 'content' => ''
                 )}
        end

        describe 'when restricting access to puppetdb' do
          let(:params) do
            {
              'certificate_whitelist' => [ 'puppetmaster' ]
            }
          end
          it { is_expected.to contain_ini_setting('puppetdb-connections-from-master-only').
            with(
                 'ensure'  => 'present',
                 'path'    => '/etc/puppetlabs/puppetdb/conf.d/puppetdb.ini',
                 'section' => 'puppetdb',
                 'setting' => 'certificate-whitelist',
                 'value'   => '/etc/puppetlabs/puppetdb/certificate-whitelist'
                 )}
          it { is_expected.to contain_file('/etc/puppetlabs/puppetdb/certificate-whitelist').
            with(
                 'ensure'  => 'present',
                 'owner'   => 0,
                 'group'   => 0,
                 'mode'    => '0644',
                 'content' => "puppetmaster\n"
                 )}
        end
      end
    end
  end
end
