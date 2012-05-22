require 'spec_helper'

describe DMG::Source do

  let(:pkgs_1_path) { File.join(File.dirname(__FILE__), '..', 'data', 'pkgs_1.yml') }
  let(:pkgs_2_path) { File.join(File.dirname(__FILE__), '..', 'data', 'pkgs_2.yml') }
  let(:pkgs_1_url) { 'https://github.com/versapay/dmg/raw/master/spec/data/pkgs_1.yml' }

  describe "#initialize" do
    context "when given a path to a yaml file" do
      subject { DMG::Source.new(pkgs_1_path) }

      its(:pkgs_hash) { should == YAML.load_file(pkgs_1_path) }
    end

    context "when given a url" do
      subject { DMG::Source.new(pkgs_1_url) }

      its(:pkgs_hash) { should == YAML.load_file(pkgs_1_path) }
    end
  end

  describe "#download_and_combine" do
    before do
      File.open(DMG.sources_file, 'w') { |f| f.write [pkgs_1_path, pkgs_2_path].to_yaml }
      DMG::Source.download_and_combine
    end

    describe "generated combined packages file" do
      let(:combined_pkgs) { YAML.load_file(DMG.combined_pkgs_file) }

      subject { combined_pkgs }

      it { should include("launchbar") } # in pkgs_1.yml only
      it { should include("virtualbox") } # in pkgs_2.yml only
    end

  end

end
