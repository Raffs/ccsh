require 'spec_helper'

describe CCSH::Utils do

    context '#get_options' do
        let ( :host ) {{
            'name' => 'example',
        }}

        it 'should return the host value' do
            expect(CCSH::Utils.get_options('name', host, 'default_example')).to eq 'example'
        end

        it 'should return the default value' do
            expect(CCSH::Utils.get_options('hostname', host, 'default_hostname')).to eq 'default_hostname'
        end
    end

    context "#verbose" do
        let ( :message ) { 'ccsh message' }

        describe "turn on verbose mode" do
            it 'should display message' do
                allow(ENV).to receive(:[]).with('CCSH_VERBOSE').and_return('true')
                expect{ CCSH::Utils.verbose message }.to output(/ccsh message/).to_stdout
            end
        end

        describe "turn off verbose mode" do
            it 'should not display message' do
                allow(ENV).to receive(:[]).with('CCSH_VERBOSE').and_return('false')

                expect{ CCSH::Utils.verbose message }.to output(//).to_stdout
                expect{ CCSH::Utils.verbose message }.to_not output(/ccsh message/).to_stdout
            end
        end
    end

    context "#debug" do
        let ( :message ) { 'debug message' }

        describe "turn on verbose mode" do
            it 'should display message' do
                allow(ENV).to receive(:[]).with('CCSH_DEBUG').and_return('true')

                expect{ CCSH::Utils.debug message }.to output(/debug message/).to_stdout
            end
        end

        describe "turn off verbose mode" do
            it 'should not display message' do
                allow(ENV).to receive(:[]).with('CCSH_DEBUG').and_return('false')

                expect{ CCSH::Utils.debug message }.to output(//).to_stdout
                expect{ CCSH::Utils.debug message }.to_not output(/debug message/).to_stdout
            end
        end
    end
end