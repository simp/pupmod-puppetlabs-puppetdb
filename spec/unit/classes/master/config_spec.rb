require 'spec_helper'

describe 'puppetdb::master::config', :type => :class do
  context 'on a supported platform' do
    on_supported_os.each do |os, os_facts|
      let(:facts) do
        os_facts
      end
      context "on #{os}" do

        context 'when PuppetDB on remote server' do
          context 'when using default values' do
            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_class('puppetdb::master::config') }
          end
        end

        context 'when PuppetDB and Puppet Master are on the same server' do
    
          context 'when using default values' do
            let(:pre_condition) { 'class { "puppetdb": }' }
    
            it { is_expected.to contain_puppetdb_conn_validator('puppetdb_conn').with(
                          :puppetdb_server => "#{facts[:fqdn]}",
                          :puppetdb_port => '8081',
                          :use_ssl => 'true') }
          end
    
          context 'when puppetdb class is declared with disable_ssl => true' do
            let(:pre_condition) { 'class { "puppetdb": disable_ssl => true }' }
    
            it { is_expected.to contain_puppetdb_conn_validator('puppetdb_conn').with(
                          :puppetdb_port => '8080',
                          :use_ssl => 'false')}
          end
    
          context 'when puppetdb_port => 1234' do
            let(:pre_condition) { 'class { "puppetdb": }' }
            let(:params) do { :puppetdb_port => '1234' } end
    
            it { is_expected.to contain_puppetdb_conn_validator('puppetdb_conn').with(
                          :puppetdb_port => '1234',
                          :use_ssl => 'true')}
          end
    
          context 'when puppetdb_port => 1234 AND the puppetdb class is declared with disable_ssl => true' do
            let(:pre_condition) { 'class { "puppetdb": disable_ssl => true }' }
            let(:params) do {:puppetdb_port => '1234'} end
    
            it { is_expected.to contain_puppetdb_conn_validator('puppetdb_conn').with(
                          :puppetdb_port => '1234',
                          :use_ssl => 'false')}
    
          end
    
          context 'when using default values' do
            it { is_expected.to contain_package('puppetdb-termini').with( :ensure => 'present' )}
            it { is_expected.to contain_puppetdb_conn_validator('puppetdb_conn').with(:test_url => '/pdb/meta/v1/version')}
          end
    
          context 'when using an older puppetdb version' do
            let (:pre_condition) { 'class { "puppetdb::globals": version => "2.2.0", }' }
            it { is_expected.to contain_package('puppetdb-terminus').with( :ensure => '2.2.0' )}
            it { is_expected.to contain_puppetdb_conn_validator('puppetdb_conn').with(:test_url => '/v3/version')}
          end
    
          context 'when upgrading to from v2 to v3 of PuppetDB on RedHat' do
            let(:facts) do
              {
                :osfamily => 'RedHat',
                :operatingsystem => 'RedHat',
                :operatingsystemrelease => '7.0',
                :kernel => 'Linux',
                :concat_basedir => '/var/lib/puppet/concat',
              }
            end
            let (:pre_condition) { 'class { "puppetdb::globals": version => "3.1.1-1.el7", }' }
    
            it { is_expected.to contain_exec('Remove puppetdb-terminus metadata for upgrade').with(:command => 'rpm -e --justdb puppetdb-terminus')}
          end 
        end
      end
    end
  end
end
