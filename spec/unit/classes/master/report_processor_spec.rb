require 'spec_helper'

describe 'puppetdb::master::report_processor', :type => :class do
  context 'on a supported platform' do
    on_supported_os.each do |os, os_facts|
      let(:facts) do
        os_facts
      end
      context "on #{os}" do

        it { is_expected.to contain_class('puppetdb::master::report_processor') }
        it { is_expected.to compile.with_all_deps }

        describe 'when using default values' do
          it { is_expected.to contain_ini_subsetting('puppet.conf/reports/puppetdb').
            with(
            'ensure'                => 'absent',
            'path'                  => '/etc/puppet/puppet.conf',
            'section'               => 'master',
            'setting'               => 'reports',
            'subsetting'            => 'puppetdb',
            'subsetting_separator'  => ','
            )}
        end

        describe 'when enabling reports' do
          let(:params) do
            {
                'enable' => true
            }
          end

          it { is_expected.to contain_ini_subsetting('puppet.conf/reports/puppetdb').
              with(
              'ensure'                => 'present',
              'path'                  => '/etc/puppet/puppet.conf',
              'section'               => 'master',
              'setting'               => 'reports',
              'subsetting'            => 'puppetdb',
              'subsetting_separator'  => ','
          )}
        end
      end
    end
  end
end
