module DMG
  class Pkg
    def self.list
      all.map(&:name).sort
    end

    def self.install(pkg_names)
      pkgs = pkg_names.map { |pkg_name| find!(pkg_name) }
      pkgs.each(&:install!)
    end

    def self.find!(pkg_name)
      pkg = all.select { |pkg| pkg.name == pkg_name }.first
      raise PackageNotFound, "Can't find a package called '#{pkg_name}'" unless pkg

      pkg
    end

    attr_reader :name, :package, :url, :volume_dir, :mpkg

    def initialize(args)
      @name = args['name']
      @package = args['package']
      @url = args['url']
      @volume_dir = args['volume_dir'] || @package
      @mpkg = args['mpkg']
    end

    def self.all
      return @@all if defined?(@@all)
      @@all = []
      hash_from_yaml.each do |key, values|
        @@all << Pkg.new({'name' => key}.merge(values))
      end

      @@all
    end

    def self.hash_from_yaml
      YAML.load_file(File.dirname(__FILE__) + '/pkgs.yml')
    end

    include OutputHelpers

    def install!
      if downloaded?
        info "#{name} already downloaded in #{dmg_file}"
      else
        download
      end

      mount unless mounted?
      if mpkg
        open_mpkg
        info "I've just launched #{name} installer!"
        info ""
        info "Don't forget to unmount the volume once done. Just run the following command:"
        info "  hdiutil detach '/Volumes/#{volume_dir}'"
        info ""
      else
        copy_app
        info "#{name} is now installed!"
      end
    end

    def dmg_file
      "#{ENV['HOME']}/Downloads/#{package}.dmg"
    end

    def destination
      '/Applications'
    end

    def mounted?
      !!`hdiutil info`[/image-path.*#{dmg_file}/]
    end

    def download
      run_cmd "curl -L #{url} -o '#{dmg_file}'"
    end

    def mount
      run_cmd "hdid '#{dmg_file}'"
    end

    def open_mpkg
      run_cmd "open /Volumes/#{volume_dir}/#{mpkg}.mpkg"
    end

    def copy_app
      run_cmd "sudo cp -fr '/Volumes/#{volume_dir}/#{package}.app' '#{destination}'"
      run_cmd "hdiutil detach '/Volumes/#{volume_dir}'"
      run_cmd "sudo chmod 755 '#{destination}/#{package}.app/Contents/MacOS/#{package}'"
    end

    def downloaded?
      File.exist?(dmg_file)
    end

    def run_cmd(cmd)
      debug cmd
      raise DMGError, "Failed to run a command" unless system(cmd)
    end
  end
end
