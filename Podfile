# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

def config_pods
    pod 'SDWebImage', '~> 4.1'

    pod 'ISO8601DateFormatter', '~> 0.7'

    pod 'AFNetworking', '~> 3.1'
    pod 'AFNetworkActivityLogger', :git => 'https://github.com/AFNetworking/AFNetworkActivityLogger.git', :branch => '3_0_0'

    pod 'GoogleMaps', '~> 2.6'
    pod 'GooglePlaces', '~> 2.6'
    pod 'GoogleAnalytics', '~> 3.17'

    pod 'Fabric', '~> 1.6'
    pod 'Crashlytics', '~> 3.8'

    pod 'FBSDKLoginKit', '~> 4.26'
    pod 'FBSDKCoreKit', '~> 4.26'
    pod 'FBSDKShareKit', '~> 4.26'
end

target 'zup' do
    config_pods
end

target 'zup_sbc' do
    config_pods
end

target 'particity' do
    config_pods
end

target 'zupTests' do
    config_pods
end
