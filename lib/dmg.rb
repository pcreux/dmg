require 'yaml'
require 'fileutils'

module DMG
  extend self

  def home_dir
    ENV['DMG_HOME'] || ENV['HOME']
  end

  def config_dir
    File.join(home_dir, '.dmg')
  end

  def sources_file
    File.join(config_dir, 'sources.yml')
  end

  def combined_pkgs_file
    File.join(config_dir, 'pkgs.yml')
  end

  def default_configuration
    ['https://raw.github.com/pcreux/dmg-pkgs/master/pkgs.yml']
  end

  def setup!
    create_dmg_directory_if_needed
    generate_default_source_file_if_needed
    download_sources
  end

  def create_dmg_directory_if_needed
    FileUtils.mkdir_p(config_dir)
  end

  def generate_default_source_file_if_needed
    unless File.exists? sources_file
      File.open(sources_file, 'w') { |f| f.write default_configuration.to_yaml }
    end
  end

  def download_sources
    DMG::Source.download_and_combine
  end
end

%w{errors output_helpers source pkg}.each do |file|
  require File.dirname(__FILE__) + "/dmg/#{file}"
end
