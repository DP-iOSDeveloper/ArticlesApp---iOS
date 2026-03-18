platform :ios, '18.0'
use_frameworks!

  target 'ArticlesApp' do
    pod 'Alamofire',                        '~> 5.9'
    pod 'AlamofireNetworkActivityIndicator','~> 3.1'
    pod 'Cache',                            '~> 6.0'
    pod 'XCGLogger',                        '~> 7.0'
    pod 'Swinject',                         '~> 2.9'
    pod 'ReachabilitySwift',                '~> 5.0'
    pod 'Kingfisher',                       '~> 8.0'
    pod 'FTLinearActivityIndicator'
    pod 'KMNavigationBarTransition',        '~> 1.1'
    pod 'Loaf',                             '~> 0.7'
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        # Fix sandbox rsync issue
        config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
        # Fix code signing for all pod frameworks
        config.build_settings['CODE_SIGNING_ALLOWED']          = 'NO'
        config.build_settings['CODE_SIGNING_REQUIRED']         = 'NO'
        config.build_settings['CODE_SIGN_IDENTITY']            = ''
        # Ensure deployment target matches app
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']    = '18.0'
      end
    end
  end

