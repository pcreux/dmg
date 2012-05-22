class DMG::CLI
  class << self
    include OutputHelpers

    def run!

      DMG.setup!

      case ARGV[0]
      when "install"
        DMG::Pkg.install(ARGV[1..-1])
      when "list"
        puts DMG::Pkg.list
      else
        puts <<-EOF
  Usage: 
    dmg install PACKAGE
    dmg list
  EOF
      end

    rescue DMG::DMGError => e
      alert(e.message)
    end
  end
end
