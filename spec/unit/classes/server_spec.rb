require 'spec_helper'

describe 'puppetdb::server', :type => :class do
  context 'on a supported platform' do
    on_supported_os.each do |os, os_facts|
      let(:facts) do
        os_facts
      end
      context "on #{os}" do

        describe 'with default args' do
          it { is_expected.to contain_class('puppetdb::server') }
          it { is_expected.to compile.with_all_deps }
        end

        describe 'when not specifying JAVA_ARGS' do
          it { is_expected.to_not contain_ini_subsetting('Xms') }
        end


          describe 'when specifying JAVA_ARGS' do
            let(:params) do
            {
              'java_args' => {'-Xms' => '2g'},
            }
            end
            context 'on standard PuppetDB' do 
              it do
                if ['RedHat', 'Suse', 'Archlinux'].include?(facts[:osfamily])
                  is_expected.to contain_ini_subsetting("'-Xms'").with({
                    'ensure'            => 'present',
                    'path'              => '/etc/sysconfig/puppetdb',
                    'section'           => '',
                    'key_val_separator' => '=',
                    'setting'           => 'JAVA_ARGS',
                    'subsetting'        => '-Xms',
                    'value'             => '2g'
                  })
                elsif ['Debian'].include?(facts[:osfamily])
                  is_expected.to contain_ini_subsetting("'-Xms'").with({
                    'ensure'            => 'present',
                    'path'              => '/etc/default/puppetdb',
                    'section'           => '',
                    'key_val_separator' => '=',
                    'setting'           => 'JAVA_ARGS',
                    'subsetting'        => '-Xms',
                    'value'             => '2g'
                  })
                elsif ['OpenBSD', 'FreeBSD'].include?(facts[:osfamily])
                  is_expected.to contain_ini_subsetting("'-Xms'").with({
                    'ensure'            => 'present',
                    'path'              => 'undef',
                    'section'           => '',
                    'key_val_separator' => '=',
                    'setting'           => 'JAVA_ARGS',
                    'subsetting'        => '-Xms',
                    'value'             => '2g'
                  })
                end
              end
            end
          end

        describe 'when specifying JAVA_ARGS with merge_default_java_args false' do
          let (:params) do
          {
            'java_args' => {'-Xms' => '2g'},
            'merge_default_java_args' => false,
          }
          end
          context 'on standard PuppetDB' do
            it do
              if ['RedHat', 'Suse', 'Archlinux'].include?(facts[:osfamily])
                is_expected.to contain_ini_setting('java_args').with({
                  'ensure'  => 'present',
                  'path'    => '/etc/sysconfig/puppetdb',
                  'section' => '',
                  'setting' => 'JAVA_ARGS',
                  'value'   => '"-Xms2g"'
                })
              elsif ['Debian'].include?(facts[:osfamily])
                is_expected.to contain_ini_setting('java_args').with({
                  'ensure'  => 'present',
                  'path'    => '/etc/default/puppetdb',
                  'section' => '',
                  'setting' => 'JAVA_ARGS',
                  'value'   => '"-Xms2g"'
                })
              elsif ['OpenBSD','FreeBSD'].include?(facts[:osfamily])
                is_expected.to contain_ini_setting('java_args').with({
                  'ensure'  => 'present',
                  'path'    => 'undef',
                  'section' => '',
                  'setting' => 'JAVA_ARGS',
                  'value'   => '"-Xms2g"'
                })
              end
            end
          end
        end
      end
    end
  end
end
