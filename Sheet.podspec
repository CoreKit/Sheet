Pod::Spec.new do |s|
    s.name             = 'Sheet'
    s.version          = '1.0.0'
    s.summary          = 'A discardable action sheet.'
    s.description      = <<-DESC
			 It's just a discardable action sheet component,
			 like the one that Apple uses for displaying
			 battery status info for the AirPods on iOS.
                       DESC

    s.homepage         = 'https://theswiftdev.com/'
    s.license          = { :type => 'WTFPL', :file => 'LICENSE' }
    s.author           = { 'Tibor Bödecs' => 'mail.tib@gmail.com' }
    s.source           = { :git => 'https://github.com/CoreKit/Sheet.git', :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/tiborbodecs'

    s.ios.deployment_target = '11.0'
    s.swift_version = '4.2'
    s.source_files = 'Sources/**/*'
    s.frameworks = 'Foundation', 'UIKit'
end
