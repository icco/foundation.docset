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
      @env.append_path File.expand_path('../../scss', __FILE__)
      @env.append_path File.expand_path('../css', __FILE__)
      @env.append_path File.expand_path('../../js', __FILE__)
      @env.append_path File.expand_path('../js', __FILE__)
    end

    def compile
      assets_path = "public/assets"
      FileUtils.mkdir_p("#{assets_path}/vendor")
      BUNDLES.each do |bundle|
        pth = "#{assets_path}/#{bundle}"
        File.delete(pth) if File.exists?(pth)
        code = @env[bundle].to_s
        File.open(pth, "w") {|f| f.puts code}
      end
    end
end

Stasis.new(File.expand_path('.'), File.expand_path(File.join(File.dirname(__FILE__), 'Contents/Resources/Documents/')), {:asset_path => "assets"}).render
assets = FoundationAssets.new
assets.compile

FileUtils.rm_r File.join(File.dirname(__FILE__), 'Contents/Resources/Documents/assets'), :force => true
FileUtils.mv File.join(File.dirname(__FILE__), 'Contents/Resources/Documents/public/assets'), File.join(File.dirname(__FILE__), 'Contents/Resources/Documents/assets')
FileUtils.rm_r File.join(File.dirname(__FILE__), 'Contents/Resources/Documents/public'), :force => true