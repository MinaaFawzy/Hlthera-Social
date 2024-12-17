//
//  NetworkUrl.swift
//  TANetworkingSwift
//
//

import Foundation
import UIKit

/** --------------------------------------------------------
 * HTTP Basic Authentication
 *	--------------------------------------------------------
 */

let kHTTPUsername               = ""
let kHTTPPassword               = ""
let OS                          = UIDevice.current.systemVersion
let kAppVersion                 = "1.0"
let kDeviceModel                = UIDevice.current.model
let kRegularFont                = UIFont.init(name: "semi-regular", size: 14.0)
let kResult                     = "results"

/** --------------------------------------------------------
 *	 API Base URL defined by Targets.
 *	--------------------------------------------------------
 */


let kImageDownloadURL         = "http://localhost/foodandparcel-backend/api/"
//let kBASEURL                  = "http://62.210.203.134/hlthera_backend/api/"
let kBASEURL                  = "https://api.hlthera.com/api/"
let kAuthentication           = "Authentication"      // Header key of request  encrypt data
let kEncryptionKey            = ""                    // Encryption key replace this with your projectname

/** ************************************************************************** */
/* Entry/exit trace macros                                                   */
/** ************************************************************************** */
// #define TRC_ENTRY()    DDLogVerbose(@"ENTRY: %s:%d:", __PRETTY_FUNCTION__,__LINE__);
// #define TRC_EXIT()     DDLogVerbose(@"EXIT:  %s:%d:", __PRETTY_FUNCTION__,__LINE__);


/** --------------------------------------------------------
 *        Used Web Services Name
 *    --------------------------------------------------------
 */

let kSignup                     = "signup"
let kSignin                     = "signin"
let kotp                        = "verify_otp"
let kCreateProfile              = "create-profile"
let kforgetpassword             = "forgetPassword"
let kResendOtp                  = "resend_otp"
let kNotification_list          = "notification_list"
let kfavorite_list              = "favorite_list"
let kLogInType                  = "login_type"
let kDeactivate                 = "user_account_deactive"
let kVerifyOtp                  = "verify_otp"
let kchangepassword             = "changepassword"
let kResetPassword              = "resetpassword"
let kLogOut                     =  "logout"
let kCountryList                = "get_country_list"
let kbloglist                   = "blog-list"
let kshippinglocationlist       = "shipping-location-list"
let kshippingcompanydetail       = "shipping-company-detail"
let kfrenchiselist               = "frenchise-list"
let krequestchinesefranchise    = "request-chinese-franchise"
let kmakeFavouriteUnfavouriteLivingGuide = "make_favourite_unfavourite_livingguide"
let kmakeFavouriteUnfavouriteGovtUtility = "make_favourite_unfavourite_govtutility"
let kmakeFavouriteUnfavouriteBlog         = "make_favourite_unfavourite_blog"
let kMakeFavouriteUnfavouriteExhibition = "make_favourite_unfavourite_exhibition"
let kExhibitionId                        = "exhibition_id"
let kGovtUtilityId                       = "govt_utility_id"
let kRequestShippingCompany               = "request-shipping-company"
let kProjectSupport                      = "project-support"
let kExhibitionListByCity                = "exhibition-list-by-city"
let kblogimage                           = "blog-image"
let kAddUserPosts                      = "add_user_posts"
let kGetPostsList                        = "get_posts_list"
let kRequestinfoChinesefrenchise           = "requestinfo_chinesefrenchise"

/** --------------------------------------------------------
 *		API Request & Response Parameters Keys
 *	--------------------------------------------------------
 */
let kLoginUserID                 = "USERID"
let kKey                         = "key"
let kResponse                   = "result"
let kMessage                    = "message"
let kProfilePicture             = "profilePic"
let kMedia                      = "media"
let kMediaType                  = "media_type"
let kIsEmailVerified            = "is_email_verify"
let kIsProfileCreate            = "is_profile_create"
let kMediaFiles                 = "media_files"
let kLocation                   = "location"
let kIsProfilePicture           = "is_profile_picture"
let kMediafiles                 = "media_files"
let kOtpVerification            = "user/otp_verification"
let kSuggestions                = "suggestions"
let kAppLocation                = "currentLocation"
