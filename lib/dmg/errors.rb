module DMG
  class DMGError < StandardError
  end

  class PackageNotFound < DMGError
  end
end
