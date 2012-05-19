require 'spec_helper'

describe DMG::Pkg do
  before do
    DMG::Pkg.stub!(:hash_from_yaml) do
      {
       "launchbar"=> {"url"=>"http://example.com/launchbar.dmg", "package"=>"LaunchBar"},
       "virtualbox"=> {"url"=> "http://example.com/virtualbox.dmg", "package"=>"VirtualBox", "mpkg"=>"VirtualBox"},
       "picasa"=> {"url"=>"http://example.com/picasa.dmg", "package"=>"Picasa", "volume_dir"=>"Picasa 3.8.9"}
      }
    end

    DMG::Pkg.stub!(:install!)
  end

  describe "##all" do
    subject { DMG::Pkg.all }

    it "should return an array of DMG::Pkg" do
      subject.should have(3).items
      subject.each do |pkg|
        pkg.should be_a(DMG::Pkg)
      end
    end

    describe "one of the packages" do
      subject { DMG::Pkg.all.select { |p| p.name == "launchbar" }.first }
      its(:name) { should == "launchbar" }
      its(:url)  { should == "http://example.com/launchbar.dmg" }
      its(:package) { should == "LaunchBar"}
    end
  end

  describe "##list" do
    subject { DMG::Pkg.list }

    it "should return an array of packages names" do
      subject.should be_an(Array)
      subject.first.should be_a(String)
      subject.sort.should == subject
    end
  end

  describe "##install" do
    let(:launchbar)  { DMG::Pkg.find!("launchbar")  }
    let(:picasa)     { DMG::Pkg.find!("picasa")     }
    let(:virtualbox) { DMG::Pkg.find!("virtualbox") }

    context "all the packages passed in exist" do
      it "should call install on the packages with a name matching the ones passed in" do
        launchbar.should_receive :install!
        picasa.should_receive :install!
        virtualbox.should_not_receive :install!

        DMG::Pkg.install(%w(launchbar picasa))
      end
    end

    context "one of the package does not exist" do
      it "should raise PackageNotFound" do
        expect { DMG::Pkg.install(%w(launchbar coffeemaker)) }.should raise_error(DMG::PackageNotFound)
      end

      it "should not install any package" do
        launchbar.should_not_receive :install!
        DMG::Pkg.install(%w(launchbar coffeemaker)) rescue nil
      end
    end
  end

  describe "#initialize" do
    context %{when passing in { "name" => "launchbar", "url" => "http://example.com/launchbar.dmg", "package" => "LaunchBar"} } do
      subject { DMG::Pkg.new({ "name" => "launchbar", "url" => "http://example.com/launchbar.dmg", "package" => "LaunchBar"}) }

      its(:name) { should == "launchbar" }
      its(:package) { should == "LaunchBar" }
      its(:url) { should == "http://example.com/launchbar.dmg" }
      its(:volume_dir) { should == "LaunchBar" }
      its(:mountpoint) { should == "/Volumes/LaunchBar" }
      its(:mpkg) { should be_nil }
    end

    context %{when passing in { "package" => "LaunchBar", "volume_dir" => "LaunchBarDMG", "mpkg" => "install.mpkg"} } do
      subject { DMG::Pkg.new({ "package" => "LaunchBar", "volume_dir" => "LaunchBarDMG", "mpkg" => "install.mpkg"}) }

      its(:package) { should == "LaunchBar" }
      its(:volume_dir) { should == "LaunchBarDMG" }
      its(:mpkg) { should == "install.mpkg" }
      its(:mountpoint) { should == "/Volumes/LaunchBarDMG" }
    end

    context "when the name, package or url is missing" do
      it "should raise an exception"
    end
  end

  describe "#install! (protected)" do
    # This method runs a bunch of system commands that can only be
    # tested in integration tests only
    # We should refactor it as it contains a few switches:
    context "when dmg not installed yet"
    context "when dmg already installed"
    context "when dmg not downloaded yet"
    context "when dmg already downloaded"
    context "when dmg has a mpkg"
    context "when dmg does not have a mpkg"
  end
end
