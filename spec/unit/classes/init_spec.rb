require 'spec_helper'

describe 'puppetdb', :type => :class do
  ttl_args = ['node_ttl','node_purge_ttl','report_ttl']

  context 'on a supported platform' do
    on_supported_os.each do |os, os_facts|
      let(:facts) do
        os_facts
      end

      context "on #{os}" do
        describe 'when using default values for puppetdb class' do
          it { is_expected.to compile.with_all_deps}
          it { is_expected.to contain_class('puppetdb') }
        end
  
        context 'with invalid arguments on a supported platform' do
          ttl_args.each do |ttl_arg|
            let(:params) do
              {
                ttl_arg => 'invalid_value'
              }
            end
            it "when using a value that does not match the validation regex for #{ttl_arg} puppetdb class" do
              expect { is_expected.to contain_class('puppetdb') }.to raise_error(Puppet::Error)
            end
          end
        end
      end
    end
  end
end
