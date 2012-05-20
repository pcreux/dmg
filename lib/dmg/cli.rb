require 'thor'

module DMG
  class CLI < Thor
    desc "install PACKAGES", "Install supplied packages"
    def install(*packages)
      DMG::Pkg.install(packages)
    end

    desc "list", "List available packages"
    def list
      puts DMG::Pkg.list
    end
  end
end
