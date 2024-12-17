# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'HSN' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

# Pods for HSN
pod 'FTIndicator'
pod 'SVProgressHUD'
pod 'Alamofire','~> 4.0'
pod 'SDWebImage', '~> 5.0'
pod 'AlamofireImage'
pod 'GoogleSignIn'
pod 'GooglePlacePicker'
pod 'FBSDKLoginKit'
pod 'DropDown'
pod 'IQKeyboardManagerSwift'
#pod 'ScalingCarousel'
pod 'Firebase/Core'
pod 'Firebase/Messaging'
pod 'Firebase/DynamicLinks'
pod 'Firebase/Database'
pod 'Firebase/Auth'
pod 'SwiftyGif'
pod "BSImagePicker", "~> 3.1"
pod 'AssetsPickerViewController'
pod 'Kingfisher', '~> 7.0'
pod 'FittedSheets'
pod 'Cosmos', '~> 23.0'
pod 'DPTagTextView'
pod 'AlignedCollectionViewFlowLayout'
pod 'NVActivityIndicatorView'
pod 'RealmSwift'
    #pod 'Blurberry'
pod 'ActiveLabel'
pod 'ImageViewer.swift', '~> 3.0'
pod 'Giphy'
pod 'QCropper'
pod 'iRecordView'
pod 'ISEmojiView'
pod 'Charts'
pod 'AgoraRtcEngine_iOS'
pod 'JellyGif'
pod 'SRFacebookAnimation'
pod 'Stripe', '~> 23.3.2'
pod 'StripePaymentSheet'
pod 'lottie-ios'
pod 'netfox'

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        config.build_settings["DEVELOPMENT_TEAM"] = "LCQQW3P3SL"
      end
    end
  end
end

#






