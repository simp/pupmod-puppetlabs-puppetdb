require 'spec_helper'

describe 'puppetdb::server::jetty', :type => :class do
  context 'on a supported platform' do
    on_supported_os.each do |os, os_facts|
      let(:facts) do
        os_facts
      end
      context "on #{os}" do

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('puppetdb::server::jetty') }

        describe 'when using default values' do
          it { is_expected.to contain_ini_setting('puppetdb_host').
            with(
                 'ensure'  => 'present',
                 'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'host',
                 'value'   => 'localhost'
                 )}
          it { is_expected.to contain_ini_setting('puppetdb_port').
            with(
                 'ensure'  => 'present',
                 'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'port',
                 'value'   => 8080
                 )}
          it { is_expected.to contain_ini_setting('puppetdb_sslhost').
            with(
                 'ensure'  => 'present',
                 'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'ssl-host',
                 'value'   => '0.0.0.0'
                 )}
          it { is_expected.to contain_ini_setting('puppetdb_sslport').
            with(
                 'ensure'  => 'present',
                 'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'ssl-port',
                 'value'   => 8081
                 )}
          it { is_expected.to_not contain_ini_setting('puppetdb_sslprotocols') }
        end

        describe 'when using a legacy PuppetDB version' do
          let (:pre_condition) { 'class { "puppetdb::globals": version => "2.2.0", }' }
          it { is_expected.to contain_ini_setting('puppetdb_host').
            with(
                 'ensure'  => 'present',
                 'path'    => '/etc/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'host',
                 'value'   => 'localhost'
                 )}
          it { is_expected.to contain_ini_setting('puppetdb_port').
            with(
                 'ensure'  => 'present',
                 'path'    => '/etc/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'port',
                 'value'   => 8080
                 )}
          it { is_expected.to contain_ini_setting('puppetdb_sslhost').
            with(
                 'ensure'  => 'present',
                 'path'    => '/etc/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'ssl-host',
                 'value'   => '0.0.0.0'
                 )}
          it { is_expected.to contain_ini_setting('puppetdb_sslport').
            with(
                 'ensure'  => 'present',
                 'path'    => '/etc/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'ssl-port',
                 'value'   => 8081
                 )}
          it { is_expected.to_not contain_ini_setting('puppetdb_sslprotocols') }
        end

        describe 'when disabling ssl' do
          let(:params) do
            {
              'disable_ssl' => true
            }
          end
          it { is_expected.to contain_ini_setting('puppetdb_host').
            with(
                 'ensure'  => 'present',
                 'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'host',
                 'value'   => 'localhost'
                 )}
          it { is_expected.to contain_ini_setting('puppetdb_port').
            with(
                 'ensure'  => 'present',
                 'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'port',
                 'value'   => 8080
                 )}
          it { is_expected.to contain_ini_setting('puppetdb_sslhost').
            with(
                 'ensure'  => 'absent',
                 'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'ssl-host'
                 )}
          it { is_expected.to contain_ini_setting('puppetdb_sslport').
            with(
                 'ensure'  => 'absent',
                 'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'ssl-port'
                 )}
        end

        describe 'when setting max_threads' do
          let(:params) do
            {
              'max_threads' => 150
            }
          end
          it { is_expected.to contain_ini_setting('puppetdb_max_threads').
            with(
                 'ensure'  => 'present',
                 'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'max-threads',
                 'value'   => '150'
                 )}
        end

        describe 'when setting ssl_protocols' do
          context 'to a valid string' do
            let(:params) { { 'ssl_protocols' => 'TLSv1, TLSv1.1, TLSv1.2' } }

            it {
              is_expected.to contain_ini_setting('puppetdb_sslprotocols').with(
                'ensure' => 'present',
                'path' => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
                'section' => 'jetty',
                'setting' => 'ssl-protocols',
                'value' => 'TLSv1, TLSv1.1, TLSv1.2'
              )
            }
          end

          context 'to an invalid type (non-string)' do
            let(:params) { { 'ssl_protocols' => ['invalid','type'] } }

            it 'is_expected.to fail' do
              expect {
                is_expected.to contain_class('puppetdb::server::jetty')
              }.to raise_error(Puppet::Error)
            end
          end
        end

        describe 'when disabling the cleartext HTTP port' do
          let(:params) do
            {
              'disable_cleartext' => true
            }
          end
          it { is_expected.to contain_ini_setting('puppetdb_host').
            with(
                 'ensure'  => 'absent',
                 'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'host',
                 'value'   => 'localhost'
                 )}
          it { is_expected.to contain_ini_setting('puppetdb_port').
            with(
                 'ensure'  => 'absent',
                 'path'    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
                 'section' => 'jetty',
                 'setting' => 'port',
                 'value'   => 8080
                 )}
        end
      end
    end
  end
end
