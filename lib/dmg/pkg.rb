module DMG
  class Pkg
    include OutputHelpers

    class << self
      def list
        all.map(&:name).sort
      end

      def install(pkg_names)
        pkgs = pkg_names.map { |pkg_name| find!(pkg_name) }
        pkgs.each(&:install!)
      end

      def find!(pkg_name)
        pkg = all.detect { |pkg| pkg.name == pkg_name }
        pkg || raise(PackageNotFound, "Can't find a package called '#{pkg_name}'")
      end

      def all
        @all ||= hash_from_yaml.map do |key, values|
          Pkg.new({'name' => key}.merge!(values))
        end
      end

      def hash_from_yaml
        YAML.load_file(DMG.combined_pkgs_file)
      end
    end

    attr_reader :name, :package, :url, :volume_dir, :mpkg

    def initialize(args)
      @name = args['name']
      @package = args['package'] || @name.capitalize
      @url = args['url']
      @volume_dir = args['volume_dir'] || @package
      @mpkg = args['mpkg']
    end

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
      !!`hdiutil info`[/image-path.*#{volume_dir}/]
    end

    def download
      run_cmd "curl -L #{url} -o '#{dmg_file}'"
    end

    def mount
      run_cmd "hdid '#{dmg_file}' -mountpoint #{mountpoint}"
    end

    def mountpoint
      "/Volumes/#{volume_dir}"
    end

    def open_mpkg
      run_cmd "open /Volumes/#{volume_dir}/#{mpkg}.mpkg"
    end

    def copy_app
      run_cmd "sudo rsync -avzq '/Volumes/#{volume_dir}/#{package}.app' '#{destination}'"
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
