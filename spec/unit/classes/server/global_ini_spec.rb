require 'spec_helper'

describe 'puppetdb::server::global', :type => :class do
  context 'on a supported platform' do
    on_supported_os.each do |os, os_facts|
      let(:facts) do
        os_facts
      end
      context "on #{os}" do

        describe 'it should compile with all deps, but upstream makes a poor use of require => File["${confdir}/config.ini"]' do
          pending("is_expected.to compile.with_all_deps")
        end

        it { is_expected.to contain_class('puppetdb::server::global') }

        describe 'when using default values' do
          it { is_expected.to contain_ini_setting('puppetdb_global_vardir').
            with(
              'ensure' => 'present',
              'path' => 'opt/puppetlabs/server/data/puppetdb',
              'path' => '/etc/puppetlabs/puppetdb/conf.d/config.ini',
              'section' => 'global',
              'setting' => 'vardir',
              'value' => '/opt/puppetlabs/server/data/puppetdb'
          )}

        end

        describe 'when using a legacy puppetdb version' do
          let (:pre_condition) { 'class { "puppetdb::globals": version => "2.2.0", }' }
          it {is_expected.to contain_ini_setting('puppetdb_global_vardir').
            with(
              'ensure' => 'present',
              'path' => 'opt/puppetlabs/server/data/puppetdb',
              'path' => '/etc/puppetdb/conf.d/config.ini',
              'section' => 'global',
              'setting' => 'vardir',
              'value' => '/var/lib/puppetdb'
          )}
        end
      end
    end
  end
end
