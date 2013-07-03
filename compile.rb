require 'bundler'
Bundler.require
require 'fileutils'

class FoundationAssets

    BUNDLES = [
      "vendor/custom.modernizr.js", "vendor/zepto.js", "vendor/jquery.js", 
      "docs.js", "docs.css", "normalize.css"
    ]

    def initialize
      @env = Sprockets::Environment.new
      @env.append_path File.expand_path('../../scss', FileUtils.pwd)
      @env.append_path File.expand_path('../css', FileUtils.pwd)
      @env.append_path File.expand_path('../../js', FileUtils.pwd)
      @env.append_path File.expand_path('../js', FileUtils.pwd)
    end

    def compile
      assets_path = File.expand_path(File.join(File.dirname(__FILE__), 'Contents/Resources/Documents/assets'))
      FileUtils.mkdir_p("#{assets_path}/vendor")
      BUNDLES.each do |bundle|
        pth = "#{assets_path}/#{bundle}"
        File.delete(pth) if File.exists?(pth)
        code = @env[bundle].to_s
        p bundle, pth, @env[bundle]
        File.open(pth, "w") {|f| f.puts code}
      end
    end
end

Stasis.new(File.expand_path('.'), File.expand_path(File.join(File.dirname(__FILE__), 'Contents/Resources/Documents/')), {:asset_path => "assets"}).render
assets = FoundationAssets.new
assets.compile

FileUtils.rm_r File.join(File.dirname(__FILE__), 'Contents/Resources/Documents/public'), :force => true
