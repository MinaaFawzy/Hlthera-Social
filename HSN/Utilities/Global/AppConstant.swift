//
//  AppConstant.swift
//  CommonCode
//
//  Created by Shubham Kaliyar on 6/10/17.
//  Copyright © 2017 Shubham Kaliyar. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Global Variables

let sharedSceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

// MARK: - Structure

//typealias  JSON = [String:Any]?

let kAppName                    = "Hlthera"
let kIsTutorialAlreadyShown     = "isTutorialAlreadyShown"
let kIsUserLoggedIn             = "isUserLoggedIn"
let kHealthStatus               = "healthStatus"
let kLoggedInAccessToken        = "access_token"
let kLoggedInUserDetails        = "loggedInUserDetails"
let kLoggedInUserId             = "loggedInUserId"
let kLatitude                   = "latitude"
let kLongitude                  = "longitude"
let kIsOtpVerified              = "is_mobile_verified"
let kIsProfileCreated           = "is_profile_create"
let kIs_Active                  = "is_active"
let kIs_Notification            = "is_notification"
let kIsAppInstalled             = "isAppInstalled"
let kAccessToken                = "access_token"
let kDeviceToken                = "device_token"
let kPostDraft                  = "post_draft"
let kExclusiveActive = "exclusive_active"
let kLounge                = "lounge"
let iosDeviceType               = "1"
let iosDeviceTokan              = "123456789"
var kBucketUrl                  = "https://hlthera-s3.s3-ap-southeast-2.amazonaws.com/"
let kSharedAppDelegate          = UIApplication.shared.delegate as? AppDelegate
let kSharedInstance             = SharedClass.sharedInstance
let kSharedSceneDelegate        = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
let kSharedUserDefaults         = UserDefaults.standard
let kScreenWidth                = UIScreen.main.bounds.size.width
let kScreenHeight               = UIScreen.main.bounds.size.height
let kRootVC                     = UIApplication.shared.windows.first?.rootViewController
let kBundleID                   = Bundle.main.bundleIdentifier!


struct APIUrl {
    //    static let kBaseUrl = "18.217.107.168:3010/user/"
    //    static let videoUrl = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
}

struct Keys {
    static let kDeviceToken     = "deviceToken"
    static let kAccessToken     = "access_token"
    static let kFirebaseId      = "firebaseId"
    static let kMobileVerified  = "isMobileVerified"
    static let kUserName        = "username"
    static let alphabet         = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
}

struct ServiceName {
    static let checkUserName                 = "check_username_exists"
    static let signup                        = "signup"
    static let check_mobile_email_exists     = "check_mobile_email_exists"
    static let verifyotp                     = "otpVerify"
    static let update_account_type           = "update-account-type"
    static let login                         = "login"
    static let socialSignin                  = "socialSignin"
    static let resendOtp                     = "resendOtp"
    static let forgot_password               = "user-forgot-password"
    static let myAddress                     = "my_address"
    static let insurance_companies           = "insurance-companies"
    static let update_password               = "user-reset-password"
    static let userUpdateProfile           = "user-update-profile"
    static let save_experience             = "save_experience"
    static let addPost                     = "add-post"
    static let change_avtar                  = "change-avtar"
    static let create_profile                = "create-profile"
    static let addPoll                       = "add-poll"
    static let nationality                   = "nationality"
    static let specialities                  = "specialties-option"
    static let stories                       = "stories"
    static let homePost                     = "home-post"
    static let active_type_post              = "active_type_post"
    static let follow_unfollow_list_hashTag = "follow_unfollow_list_hashTag"
    static let notify_list                  = "notify_list"
    static let notifymarkread_countread     = "notifymarkread_countread"
    static let listing_data                 = "listing_data"
    static let type_of_post                  = "type_of_post"
    static let add_story                     = "add_story"
    static let employement_type              = "employement_type"
    static let celebration_images            = "celebration_images"
    static let delete_post_picture           = "delete_post_picture"
    static let recommand_rating              = "recommand_rating"
    static let invitations                   = "invitations"
    static let favourite_unfavourite_post_list    = "favourite_unfavourite_post_list"
    static let favourite_unfavourite_candidate    = "job-apply-fav"
    static let lounge_notification = "lounge-notification-list"
    
    static let favourite_unfavourite_job = "company_job/save_unsave_job"
    static let apply_company_job            = "company_job/apply_company_job"
    static let notify_job                   = "company_job/notify_for_company_job"
    static let accept_connecation_request    = "accept_connecation_request"
    static let group_accept                   = "group_accept"
    static let make_connecation              = "make_connecation"
    static let reject_connecation_request_from_receiver = "reject_connecation_request_from_receiver"
    static let reject_connecation_request_from_sender = "reject_connecation_request_from_sender"
    static let like_dislike_post            = "like_dislike_post"
    static let votes_on_pollPost            = "votes_on_pollPost"
    static let follow_unfollow_user         = "follow_unfollow_user"
    static let follow_company               = "follow_company"
    static let block_user                   = "block_user"
    static let send_invitation              = "send_invitation"
    static let send_company_invitation      = "company_event/send_invitation"
    static let join_event                   = "join_event"
    static let join_company_event           = "company_event/join_event"
    static let send_group_invitation        = "send_group_invitation"
    static let save_school                  = "save_school"
    static let save_certificate             = "save_certificate"
    static let comment_on_post              = "comment_on_post"
    static let add_company                  = "add_company"
    
    static let add_company_product          = "add_company_product"
    static let delete_company_life          = "delete_company_life"
    static let upload_product_media         = "upload_product_media"
    static let upload_resume    = "company_job/upload_resume"
    static let get_post_comment             = "get_post_comment"
    static let users_list                   = "users_list"
    static let remove_my_connecation = "remove_my_connecation"
    static let addCeleration                = "add-celeration"
    static let add_company_life             = "add_company_life"
    static let update_company_life          = "update_company_life"
    static let update_company_photos        = "update_company_photos"
    static let update_company_testimonial   = "update_company_testimonial"
    static let update_company_spotlight     = "update_company_spotlight"
    static let group_list                   = "group_list"
    static let all_group_list                   = "all_group_list"
    static let company_follow_by_me         = "company_follow_by_me"
    static let total_company_page         = "total_company_page"
    static let event_list                   = "event_list"
    static let company_product_list         = "company_product_list"
    static let company_life_list            = "company_life_list"
    static let get_company_events               = "company_event/event_list"
    
    static let view_group                   = "view_group"
    static let view_job                     = "company_job/"
    static let allJobs                      = "company_job/all_jobs"
    static let allFavoriteJobs              = "company_job/saved_job"
    static let allFitness              = "get-challenges?type=1&limit=10&pages=1"
    static let MyChallenges              = "my-challenges?pages=1&limit=10"
    static let AcceptedChallenges              = "accepted-challenges"
    static let Search              = "search"
    static let deletechalenges = "delete-chalenges"
    static let DescriptionChallenge = "description-chalenges"
    static let allCandidatesList              = "company_job/get-apply-user"
    static let favoriteJobList = "favourite-job-lists"
    static let jobsByCompany                = "company_job/company_jobs"
    static let view_event                   = "view_event"
    static let view_company_event           = "company_event/view_event"
    static let upload_banner                = "upload_banner"
    static let userCountryList             = "user-country-list"
    static let userStateList             = "user-state-list"
    static let userCityList             = "user-city-list"
    static let add_group                = "add_group"
    static let edit_group                = "edit_group"
    static let create_event             = "create_event"
    static let addChallenges           = "add-challenges"
    static let create_job               = "company_job"
    static let kprofile_lifestyle_options    = "profile-lifestyle-options"
static let kGetProfileDetails       = "get-profile-details"
    static let emergencyContactRemove = "emergency-contact-remove"
    static let medicationLifestyleOptionRemoved = "medication-lifestyle-option-removed"
    static let updatePasswordWithOld  = "update-password-with-old"
    static let searchDoctor                  = "search-doctor"
    static let doctorList              = "doctor-list"
    static let hospitalList              = "hospital-list"
    static let all_users                 = "all_users"
    static let user_profile              = "user_profile"
    static let company_page             = "company_page"
    static let company_event            = "company_event"
    static let update_company_event = "company_event/update_event/"
    static let editProfile              = "edit_profile"
    static let myDoctors = "my_doctors"
    static let my_connecation = "my_connecation"
    static let adminList = "company-page-admin"
    static let addAdminList = "add-company-page-admin"
    static let plans = "plans"
    static let chat_room_list = "chat_room_list"
    static let homeSearch = "home_search"
    static let user_list_for_company_leader = "user_list_for_company_leader"
    static let reactionsList = "users_react_on_post"
    static let hash_tags_list = "hash_tags_list"
    static let delete_exp   = "delete_exp"
    static let delete_event   = "delete_event"
    static let issueReportByUser          = "issue-report-by-user"
    static let nearMeHospital           = "near-me-hospital"
    static let searchHospital           = "search-hospital"
    static let doLike                   = "do-like"
    static let uploadPrescription      = "upload-prescription"
    static let doUnlike                 = "do-unlike"
    static let doctorFilter             = "apply-filter-doctor"
    static let logOut                   = "logout"
    static let contactUs               = "contact_us"
    static let addPatientAddress     = "add-patient-address"
    static let country_list = "country_list"
    static let state_list = "state_list"
    static let city_list = "city_list"
    static let savedCards              = "save_card"
    static let orderPlace            = "order-place"
    static let getPatientAddress      = "get-patient-address"
    static let bookAppointment        = "book-appointment"
    static let getCouponsList         = "get-coupons"
    static let checkSlotAvailablity = "check-slot-availablity"
    static let deleteAddress          = "remove-address"
    static let getLanguage           = "get-language"
    static let ongoingBookings      = "ongoing-bookings"
    static let updateBookingStatus = "update-booking-status"
    static let cancellationReasons = "cancellation-reasons"
    static let getDoctorDetails           = "reschedule"
    static let surveyQuestions = "survey-questions"
    static let saveUserSurvey = "save-user-survey"
    static let rateYourAppointment = "rate-your-appointment"
    static let ratingList = "rating-list"
    static let pharmacyCategories = "categories"
    static let top_order_products = "top_order_products"
    static let recommended_product = "recommended_product"
    static let new_users = "new_users"
    static let product_list = "product_list"
    static let product_detail = "product_detail"
    static let cart_list = "cart_list"
    static let viewOrderDetail = "view-order-detail"
    static let add_cart = "add_cart"
    static let remove_from_cart = "remove_from_cart"
    static let search_product = "search_product"
    static let add_wishlist = "add_wishlist"
    static let notificationList = "notification-list"
    static let myOrders = "my-orders"
    static let cancelOrders = "cancel-orders"
    static let getNotifications          = "/getNotification/"
    static let deleteNotification        = "/deleteNotification/"
    static let sendMessageNotification   = "send_chat_notify"
    static let getChatContacts           = "/getChatContacts/"
    static let logout                    = "/signOut/"
    static let getSubscriptionPlan       = "/getSubscription"
    static let updateSubscription        = "/updateSubscription/"
    static let enableDisableUser         = "/enableOrDisableUser/"
    static let delete_post_comment        = "delete_post_comment"
    static let delete_story               = "delete_story"
    static let delete_company_life_module = "delete_company_life_module"
    static let getInterests             = "interests"
    static let getInterestsTopics       = "intereststopics"
    static let get_health_wellness      = "get-health-wellness"
    static let calculate_user_views     = "calculate_user_views"
    static let create_promotion         = "create_promotion"
    static let stripe_payment           = "stripe_payment"
    static let payment_intent           = "payment_intent"
    static let retrieve_payment_intent = "retrive_payment_intent"
    static let add_interest             = "add_interest"
    static let add_health_wellness      = "add-health-wellness"
    static let payment_request          = "payment_request"
    static let payment_status           = "payment_status"
    static let insight_promotation_post     = "Insight_promotation_post"
    static let purchase_subscription    = "purchase_subscription"
    static let public_event_list    = "public_event_list"
    static let event_views_impression    = "event_views_impression"
    static let event_interested    = "event_interested"
    static let event_interest    = "event_interest"
    static let my_event_interested    = "my_event_interested"
    static let send_notification = "send-notification-myconnection"
    //Admin Exclusive
    static let exlusive_post = "admin-post"
    static let admin_post_like = "admin-post-like"
    static let admin_get_comment = "admin-get-comment"
    static let admin_post_comment = "admin-post-comment"
    static let total_reaction = "total-reaction"
    static let admin_share_post = "share-post"
    static let purchase_exclusive = "purchase-exclusive"
    static let active_exclusive   = "active-exclusive"
    
}

struct Notifications {
    static let kDOB                             = "Please Enter Date of Birth"
    static let kEnterMobileNumber               = "Please Enter Mobile Number"
    static let kEnterValidMobileNumber          = "Please Enter Valid Mobile Number"
    static let kEnterEmail                      = "Please Enter your Email Id"
    static let kEnterValidEmail                 = "Please Enter Valid Email Id"
    static let kName                            = "Please Enter  Name"
    static let kValidName                       = "Please Enter  Valid Name"
    static let kPassword                        = "Please Enter  Password"
    static let kValidPassword                   = "Password Should be of Minimum 8 characters Including Alphabets, Numbers & Special Characters."
    static let kNewPassword                     = "Please Enter  New Password"
    static let kSamePassword                    = "Passwords should be Same"
    static let kMatchPassword                   = "Password & Confirm Password doesn't Match"
    static let kTermsNCond                      = "Please Accept Terms & Conditions"
    static let kAppointment                     = "Please Enter Appointment Type"
    static let kUserType                        = "Please Enter Your User Type"
    static let kAppointmentDate                 = "Please Enter Appointment Date & Time"
    static let kAdditionalNotes                 = "Please Enter Additional Note for Appointment"
    static let kChatNotificationReceived        = "ChatNotificationReceived"
        static var kAddress                         = "Please Enter Address"
        static let kEnterOTP                        = "OTP Can't be Empty"
        static let kEnterInsuranceCompany           = "Please Enter Insurance Company"
        static let kEnterInsuranceNo                = "Please Enter Insurance Number"
    static let kEnterValidInsuranceNo                 = "Please Enter Valid Insurance Number"
        static let kEnterFirstName                  = "Please Enter Full Name"
        static let kEnterFullName                   = "Please Enter Full Name"
        static let kEnterLastName                   = "Please Enter Last Name"
      
        static let kEnterPassword                   = "Please Enter Password"
        static let kReEnterPassword                 = "Please Enter Confirm Password"
        static let kEnterValidPassword              = "Please Enter Valid Password"
        static let kFullName                        = "Please Enter Full Name"
        static let kFirstName                       = "Please Enter First Name"
        static let kLastName                        = "Please Enter Last Name"
        static let kPropertyType                    = "Please Select Property Type"
        static let kEnterValidEmailId               = "Please Enter Valid Email ID"
        static let kEmailId                         = "Please Enter Email ID"
        static let kAcceptTerms                     = "Please Accept Terms & Conditions"
        static let kPasswordRange                   = "Password Should be Minimum Of 8 digits"
        static let kPasswordMatch                   = "Password & Confirm Password Should Be Same"
//        static let kEnterEmail              = "Please Enter Mobile Number"
        static let kEnterMobile              = "Please Enter Mobile Number"
        static let kEnterValidEmailOrMobile         = "Please Enter Valid Email or Mobile Number"
        static let kBloodGroup                      = "Please Select Blood Group"
        static let kHeight                          = "Please Select Height"
        static let kWeight                          = "Please Select Weight"
        static let kDob                             = "Please Select Date Of Birth"
        static let kNationality                     = "Please Enter Nationality"
        static let kUaeResident                     = "Please Select You Are UAE Resident Or Not"
        static let kExpiryDate                      = "Please Select Expiry Date"
        static let kMaritalStatus                   = "Please Select Marital Status"
        static let kAcceptCond                      = "Please Accept terms and conditions"
}
struct ApiParameters {
    static let kvideo = "video"
    static let kRecordedAudio = "recordedAudio"
    static let kRecordedAudioName = "recordedAudioName"
    static let kvideoName = "videoName"
    static var ksteps                    = "steps"
    static var kfullName                 = "full_name"
    static var kusername                 = "username"
    static let emailNumber               = "emailNumber"
    static var kpassword                 = "password"
    static var ksocial_id                = "social_id"
    static var user_id                   = "user_id"
    static var is_post_like              = "is_post_like"
    static var post_id                   = "post_id"
    static var story_id                  = "story_id"
    static var company_job_id            = "company_job_id"
    static var posted_picture_ids        = "posted_picture_ids[]"
    static var country_name                   = "country_name"
    static var state_name                     = "state_name"
    static var city_name                      = "city_name"
    static var find_expert_title         = "find_expert_title"
    static var is_following              = "is_following"
    static var is_follow              = "is_follow"
    static var is_connected_with_me      = "is_connected_with_me"
    static var is_favourite              = "is_favourite"
    static var is_interest              = "is_interest"
    static var promotion_type              = "promotion_type"
    
    
static let facility = "facility"
static let job_description = "job_description"
static let employement_type = "employement_type"
static let skill_required = "skill_required"
static let industry_id = "industry_id"
static let apply_type = "apply_type"
static let latitude = "latitude"
static let longitude = "longitude"
static let website_link = "website_link"
    
    
    static let kFirstName                = "first_name"
    static let username                  = "username"
    static let klastName                 = "last_name"
    static let kgender                   = "gender"
    static let kdob                      = "date_of_birth"
    static let knationality              = "nationality"
    static let kis_country_resident      = "is_country_resident"
    static let kinsurance_expiry         = "insurance_expiry"
    static let kmarital_status           = "marital_status"
    static let kaddress                  = "address"
    static let kinsurance_back           = "insurance_back"
    static let kinsurance_front          = "insurance_front"
    static let kweight                   = "weight"
    static let kheight                   = "height"
    static let kblood_group              = "blood_group"
    static let kmedical_notes            = "medical_notes"
    static let kemail                    = "email"
    static let kcountryCode              = "country_code"
    static let kCountryCodes             = "contact_country_code"
    static let kMobileNumber             = "mobile_number"
    static let kdeviceToken              = "device_token"
    static let event_id                  = "event_id"
    static let group_id                  = "group_id"
    static let users_id                  = "user_ids"
    static let kdevice_type              = "device_type"
    static let kPassword                 = "password"
    static let kCurrentPassword          = "current_password"
    static let kconfirm_password         = "confirm_password"
    static let kConfirmPassword          = "confirmpassword"
    static let kcontact_us_by            = "contact_us_by"
    static let klogin_type               = "login_type"
    static let kLatitude                 = "lat"
    static let kLongitude                = "long"
    static let klang_id                  = "lang_id"
    static let id                        = "id"
    static let kChallengesId             = "challenges_id"
    static let kSearchName              = "name"
    static let challenges_id      = "challenges_id"
    static let currencyType = "currencyType"
    static let paymentIntent = "paymentIntent"
    static let amount = "amount"
    static let customerId = "customerId"
    static let stripeToken = "stripeToken"
    static let is_card_save = "is_card_save"
    static let is_company_post          = "is_company_post"
    static let recent_user               = "recent_user"
    static let kinsurance_company        = "insurance_company"
    static let kinsurance_number         = "insurance_number"
    static let kterms_and_condition      = "terms_and_condition"
    static let message                   = "Something went wrong"
    static let kotp                      = "otp"
    static let kprofile_picture          = "profile_pic"
    static let kcreate_profile           = "create-profile"
    static let kmedicalAllergies          = "allergies"
    static let kmedicalCurrentMedication  = "current_medication"
    static let kmedicalPastMedication    = "past_medication"
    static let kmedicalChronicDisease    = "chronic_disease"
    static let kmedicalInjuries          = "injuries"
    static let kmedicalSurgeries         = "surgeries"
    static let kmedicalSmokingHabit      = "smoking_habit"
    static let kmedicalAlcoholConsumption = "alcohol_consumption"
    static let kmedicalActivitylevel     = "activity_level"
    static let kmedicalfoodpreference    = "food_preference"
    static let kmedicalOccupation        = "occupation"
    static let kemergencyContactnumber   = "contact_number"
    static let kemergencyRelation        = "relation"
    static let kTitle                    = "title"
    static let kSpecialitiesId             = "specialties"
    static let kGender                   = "gender"
    static let kConnectionType           = "type"
    static let kRating                   = "rating"
    static let kAvailability              = "availability"
    static let kLocation                 = "location"
    static let kIsQuickSearch            = "is_quick_search"
    static let kDoctor_or_clinic_id       = "doctor_or_clinic_id"
    static let kMessage                   = "message"
    static let kLike                     = "like"
    static let kUnlike                   = "unlike"
    static let kType                     = "type"
    static let kTargetId                 = "target_id"
    static let kLanguage                  = "language"
    static let kCommunication_way         = "communication_way"
    static let kReportingType            = "reporting_type"
    static let kAddress                  = "address"
    static let kCity                     = "city"
    static let building                  = "building"
    static let flat                      = "flat"
    static let street                    = "street"
    static let kPincode                  = "pincode"
    static let address_type              = "address_type"
    static let mobile_no                 = "mobile_no"
    static let isHospitalBooking         = "isHospitalBooking"
    static let hospital_id               = "hospital_id"
    static let appointment_type         = "appointment_type"
    static let order_id = "order_id"
    static let coupon_id = "coupon_id"
    static let orderPlace              = "order-place"
    static let booking_type               = "booking_type"
    static let order_type = "order_type"
    static let slot_id         = "slot_id"
    static let date         = "date"
    static let resume_doc       = "resume_doc"
    static let doctor_id         = "doctor_id"
    static let satisfied_id = "satisfied_id"
    static let fees         = "fees"
    static let total_amount         = "total_amount"
    static let patient_name         = "patient_name"
    static let patient_age         = "patient_age"
    static let patient_gender         = "patient_gender"
    static let patient_email         = "patient_email"
    static let patient_mobile         = "patient_mobile"
    static let address_id         = "address_id"
    static let countryId          = "country_id"
    static let stateId            = "state_id"
    static let first_name = "first_name"
    static let last_name = "last_name"
    static let full_name = "full_name"
    static let headline = "headline"
    static let country = "country"
    static let school_name = "school_name"
    static let degree = "degree"
    static let field_of_study = "field_of_study"
    static let is_completed = "is_completed"
    static let start_date = "start_date"
    static let end_date = "end_date"
    static let share_with_network = "share_with_network"
    static let name = "name"
    static let about = "about"
    static let location = "location"
    static let rules = "rules"
    static let discoverability = "discoverability"
    static let permission = "permission"
    static let job_title = "job_title"
    static let job_type = "job_type"
    static let duration_type = "duration_type"
    static let distance = "distance"
    static let user_latitude = "user_latitude"
    static let user_longitude = "user_longitude"
    
static let product_name = "product_name"
static let product_url = "product_url"
static let tagline = "tagline"
    
    static let business_type = "business_type"
    static let website_url = "website_url"
    static let page_name = "page_name"
    static let description = "description"
    static let industry = "industry"
    static let company_type = "company_type"
    static let company_size = "company_size"
    static let company_id = "company_id"
    static let product_media = "product_media[]"
    static let resume   = "resume"
    static let is_delete = "is_delete"
    static let is_event_online = "is_event_online"
    static let registration_link = "registration_link"
    static let goal = "goal"
    static let broadcast_link = "broadcast_link"
    static let event_type = "event_type"
    static let interest_type = "interest_type"
    static let start_time = "start_time"
    static let end_time = "end_time"
    static let Ktype     = "type"
    
    
    
static let view_name = "view_name"
static let pixel_tracker_url = "pixel_tracker_url"
static let media = "media"
static let image_url_link = "image_url_link"
static let company_leader_headline = "company_leader_headline"
static let company_leader_content = "company_leader_content"
static let members_of_company_leader = "members_of_company_leader"
static let company_leader_visibility = "company_leader_visibility"
static let company_photos_visibility = "company_photos_visibility"
static let company_testimonials_visibility = "company_testimonials_visibility"
static let spotlight_media = "spotlight_media"
static let caption = "caption"
static let title = "title"
static let content = "content"
static let url_link = "url_link"
static let spotlight_visibility = "spotlight_visibility"
static let company_photos_media = "company_photos_media"
static let employee_ids = "employee_ids"
static let employee_quote = "employee_quote"
    static let company_lifes_id = "company_lifes_id"
    
    
    
    
    
    
    
    
    
    
    
    
    static let edu_id = "edu_id"
    static let grade = "grade"
    static let state = "state"
    static let like_type = "like_type"
    static let member_id = "member_id"
    static let join_group = "join_group"
    
    static let city = "city"
    static let cover_pic = "cover_pic"
    static let image = "image"
    static let group_pic = "group_pic"
    static let profile_pic = "profile_pic"
    static let industries = "industries"
    static let is_cover_pic_delete = "is_cover_pic_delete"
    static let is_profile_pic_delete = "is_profile_pic_delete"
    static let cityId             = "city_id"
    static let card_number        = "card_number"
    static let card_name        = "card_name"
    static let expiry_date        = "expiry_date"
    static let cvv        = "cvv"
    static let question = "question"
    static let answer = "answer"
    static let answer_id = "answer_id"
    static let poll_duration = "poll_duration"
    static let is_save_adress    = "is_save_adress"
    static let other_patient_name         = "other_patient_name"
    static let other_patient_age         = "other_patient_age"
    static let other_patient_relation         = "other_patient_relation"
    static let other_patient_mobile         = "other_patient_mobile"
    static let other_patient_insurance         = "other_patient_insurance"
    static let other_patient_imageFront         = "other_patient_imageFront"
    static let other_patient_imageBack         = "other_patient_imageBack"
    static let other_notes                     = "other_notes"
    static let isOtherKey                    = "is_other"
    static let other_patient_gender           = "other_patient_gender"
    static let other_patient_email           = "other_patient_email"
    static let other_patient_countryCode    = "other_patient_countryCode"
    static let patient_countryCode          = "patient_countryCode"
    static let booking_id = "booking_id"
    static let status = "status"
    static let cancellation_reason = "cancellation_reason"
    static let is_future_address = "is_future_address"
    static let comm_service_id = "comm_service_id"
    static let old_slot_id = "old_slot_id"
    static let old_date = "old_date"
    static let slot_time = "slot_time"
    static let is_reschedule = "is_reschedule"
    static let question_ids = "question_id"
    static let ratings = "ratings"
    static let rating = "rating"
    static let rating_type = "rating_type"
    static let comments = "comments"
    static let comment = "comment"
    static let type = "type"
    static let product_id = "product_id"
    static let quantity = "quantity"
    static let pharmacy_id = "pharmacy_id"
    static let cart_id = "cart_id"
    static let sort_type = "sort_type"
    static let hashTag = "hashTag"
    static let hashTag_id = "hashTag_id"
    static let postType = "postType"
    static let post_type = "post_type"
    static let is_post_favourite = "is_post_favourite"
    static let tagPeople = "tagPeople"
    static let gif_url = "gif"
    static let is_post_type = "is_post_type"
    static let reply_id = "reply_id"
    static let share_with = "share_with"
    static let recipient_id = "recipient_id"
    static let celebrate_type = "celebrate_type"
    static let img_url = "img_url"
    static let mediaUpload = "pictures[]"
    static let picture = "picture"
    static let certificate = "certificate"
    static let org_name = "org_name"
    static let is_certificate_expire = "is_certificate_expire"
    static let cert_id = "cert_id"
    static let promotion_goal = "promotion_goal"
    static let promotion_goal_type = "promotion_goal_type"

    static let target_audience_type = "target_audience_type"
    static let interest = "interest"
    static let interests = "interests"
    static let health_wellness_id = "health_wellness_id"
    static let gender = "gender"
    static let age_group_from = "age_group_from"
    static let age_group_to = "age_group_to"
    static let price = "price"
    static let duration = "duration"
    static let audience_reach = "audience_reach"
    static let tax = "tax"
    static let tran_ref = "tran_ref"
    static let insight_tabs = "insight_tabs"
    static let filter_type = "filter_type"
    static let from = "from"
    static let to = "to"
    
    static let subscription_id = "subscription_id"
  
}
enum CommunicationType{
    case audio,video,chat,none
}
struct CustomColor {
    
    static let kGreen               = UIColor.init(red: 50/255,  green: 185/255, blue: 113/255, alpha: 1)
    static let kRed                 = UIColor.init(red: 229/255,  green: 49/255, blue: 38/255, alpha: 1)
    static let kSenderPlay          = UIColor.init(red: 198/255,  green: 212/255, blue: 225/255, alpha: 0.4)
    static let kReceiverPlay        = UIColor.init(red: 115/255,  green: 120/255, blue: 128/255, alpha: 1)
    static let kBlack               = UIColor.init(red: 0/255,  green: 0/255, blue: 0/255, alpha: 0.05)
    static let kGray                = UIColor.init(red: 158/255,  green: 161/255, blue: 167/255, alpha: 1)
    static let kLightRed            = UIColor.init(red: 89/255,  green: 124/255, blue: 236/255, alpha: 1)
    static let kDarkRed             = UIColor.init(red: 57/255,  green: 83/255, blue: 164/255, alpha: 1)
    static let kChatHeader          = UIColor.init(red: 142/255,  green: 148/255, blue: 156/255, alpha: 1)
    
}

struct NumberContants {
    static let kMinPasswordLength = 8
}


struct  AlertMessage {
    static let kDefaultError                  = "Something went wrong. Please try again."
    static let knoNetwork                     = "Please check your internet connection !"
    static let kSessionExpired                = "Your session has expired. Please login again. -> 🚀 "
    static let kNoInternet                    = "Unable to connect to the Internet. Please try again."
    static let kInvalidUser                   = "Oops something went wrong. Please try again later."
    static let knoData                        = "No Data Found 🎈"
    static let noName                         = "Empty name 🚀"
    static let Under_Development              = "Under Development 👨‍🏫"
    static let logout                         = "Are you sure you want to logout?"
    static let signin                         = "Please sign in first."
    static let currentPagealert               = "you are already on this page 🤣 -> 🚀"
}

struct Identifiers {
    static let kLoginVc                               = "LoginVC"
    static let kSelectLangVc                          = "SelectLangViewController"
    static let kWalkthroughCVC                        = "WalkthroughCVC"
    static let kPersonalDetailsVC                     = "PersonalDetailsViewController"
    static let kMedicalIDVC                           = "MedicalIDViewController"
    static let kLifeStyleVC                           = "LifeStyleViewController"
    static let kbannerCVC                             = "BannerCollectionViewCell"
    static let kResetPassVC                           = "ResetPassViewController"
    static let kForgotPassVC                          = "ForgotPassViewController"
    static let kOtpVerificationVC                     = "OtpVerificationViewController"
    static let kSignUpVC                              = "SignUpViewController"
    static let kCartController                        = "MyCartViewController"
    static let kPromoCodeController                   = "PromoCodeListViewController"
    static let kMapController                         = "MapViewController"
    static let kAddOnsController                      = "AddOnsViewController"
    static let kMenuController                        = "MenuViewController"
    static let kPaymentController                     = "MakePaymentViewController"
    static let kOrderPlacedPopUpController            = "OrderPlacedPopUpViewController"
    static let kHome                                  = "HomeVC"
    static let kMedicalDetailsVC                      = "MedicalDetailsViewController"
    static let kSearchMedicalInfoVC                   = "SearchMedicalInfoViewController"
    //MARK:- tableView cell Constants
    static let kEmergencyContactsTVCell        = "EmergencyContactsTableViewCell"
}

struct Storyboards {
    static let kMain                           = "Main"
    static let kHome                           = "Home"
    static let kDoctor                         = "MyDoctors"
    static let kHospitals                      = "Hospitals"
    static let kOrders                         = "Orders"
    static let kChat                            = "Chat"
    static let kPromotions                      = "Promotions"
    static let kLounge                          = "Lounge"
    static let kPages                          = "Pages"
    static let kJobs                           = "Jobs"
    static let kFitness                           = "Fitness"
}
struct ServiceIconIdentifiers {
    static let video = "video_call_sm"
    static let home = "home_visit"
    static let chat = "chat_sm"
    static let audio = "call_sm"
    static let clinic = "clinic_visit_sm"
}
struct ServicesIdentifiers{
    static let video = "video"
    static let home = "home"
    static let chat = "chat"
    static let audio = "audio"
    static let clinic = "visit"
}

enum Post{
    case admin,user
}
enum HasCameFrom{
    case signUp, login, forgotPass, none, tagPeople,recipient,editProfile,viewProfile,createProfile,updateProfile, viewGroup, editGroup, viewGroupAdmin,invitePeopleGroup,invitePeopleEvent,createPost,editPost,createPagePost,editPagePost,createGroupPost,editGroupPost,createEvent,createCompanyEvent,viewCompanyEvent,viewEventCompanyAdmin,editCompanyEvent,viewEvent,viewEventAdmin,editEvent,createGroup,viewMembers,findExpert,sharePost,homeFeed,selfFeed,insights,createPromotion,lounge,celebrateOccassion,createPage,viewPage,viewPageAdmin,editPage,addProduct,editProduct,DeleteProduct,addLife,editLife,deleteLife,searchHome,searchLeader,createJob,editJob, tabBar
}
enum PostTypes{
    case text,media,poll,findExpert,share,insights
}
enum PageMediaType{
    case lifeMedia,productMedia,jobMedia
}
enum profileData{
    case education,certificate,experience
}
enum listingData{
    case degree,industry,organization,company
}
enum likeType{
    case post,comment
}
enum rejectionType{case receiver,sender}

enum addSymptomsEnum{
    case allergie,currentMedications,pastMedications,chronicDisease,injuries,surgeries,none
}

//struct Notifications {
//    static var kAddress                         = "Please Enter Address"
//    static let kEnterOTP                        = "OTP Can't be Empty"
//    static let kEnterInsuranceCompany           = "Please Enter Insurance Company"
//    static let kEnterInsuranceNo                = "Please Enter Insurance Number"
//    static let kEnterFirstName                  = "Please Enter Full Name"
//    static let kEnterFullName                   = "Please Enter Full Name"
//    static let kEnterLastName                   = "Please Enter Last Name"
//    static let kEnterMobileNumber               = "Please Enter Mobile Number"
//    static let kEnterValidMobileNumber          = "Please Enter Valid Mobile Number"
//    static let kEnterPassword                   = "Please Enter Password"
//    static let kReEnterPassword                 = "Please Enter Confirm Password"
//    static let kEnterValidPassword              = "Please Enter Valid Password"
//    static let kFullName                        = "Please Enter Full Name"
//    static let kFirstName                       = "Please Enter First Name"
//    static let kLastName                        = "Please Enter Last Name"
//    static let kPropertyType                    = "Please Select Property Type"
//    static let kEnterValidEmailId               = "Please Enter Valid Email ID"
//    static let kEmailId                         = "Please Enter Email ID"
//    static let kAcceptTerms                     = "Please Accept Terms & Conditions"
//    static let kPasswordRange                   = "Password Should be Minimum Of 8 digits"
//    static let kPasswordMatch                   = "Password & Confirm Password Should Be Same"
//    static let kEnterEmailOrMobile              = "Please Enter Email ID or Mobile Number"
//    static let kEnterValidEmailOrMobile         = "Please Enter Valid Email or Mobile Number"
//    static let kBloodGroup                      = "Please Select Blood Group"
//    static let kHeight                          = "Please Select Height"
//    static let kWeight                          = "Please Select Weight"
//    static let kDob                             = "Please Select Date Of Birth"
//    static let kNationality                     = "Please Enter Nationality"
//    static let kUaeResident                     = "Please Select You Are UAE Resident Or Not"
//    static let kExpiryDate                      = "Please Select Expiry Date"
//    static let kMaritalStatus                   = "Please Select Marital Status"
//    static let kAcceptCond                      = "Please Accept terms and conditions"
//}


struct AlertTitle {
    static let kOk                = "OK"
    static let kCancel            = "Cancel"
    static let kDone              = "Done"
    static let ChooseDate         = "Choose Date"
    static let SelectCountry      = "Select Country"
    static let logout             = "Logout"
    
}


struct Cellidentifier {
    
    static let IntroductionCell    = "IntroductionCell"
    static let SidebarMenuCell     = "SidebarMenuCell"
    
    
}

struct OtherConstant {
    static let kAppDelegate        = UIApplication.shared.delegate as? AppDelegate
    // static let kRootVC             = UIApplication.shared.keyWindow?.rootViewController
    static let kBundleID           = Bundle.main.bundleIdentifier!
    static let kGenders: [String]  = ["Male", "Female", "Other"]
    static let kReviewsSortBy: [String] = ["Recent", "Last Month", "Last Year"]
}

func Localised(_ aString:String) -> String {
    
    return NSLocalizedString(aString, comment: aString)
}



struct Indicator {
    
    static func showToast(message aMessage: String)
    {
        DispatchQueue.main.async
            {
                showAlertMessage.alert(message: aMessage)
        }
    }
}

// Enums
enum PhotoSource {
    case library
    case camera
}

enum MessageType {
    case photo
    case text
    case video
    case audio
}

enum MessageOwner {
    case sender
    case receiver
}

enum BottomOptions: Int {
    case search = 0
    case match
    case message
    case post
}

//enum HasCameFrom{
//    case Forgot // forgot Password flow
//    case SignUp
//    case ResetPassword
//}

enum AppColor {
    case Blue, Red
    var color : UIColor {
        switch self {
        case .Blue:
            return UIColor.blue
        case .Red:
            return UIColor.init(hexString: "#C7003B")
        }
    }
}


enum OpenMediaType: Int {
    case camera = 0
    case photoLibrary
    case videoCamera
    case videoLibrary
}



enum AppFonts {
    case bold(CGFloat),regular(CGFloat)
    var font:UIFont {
        switch self {
        case .bold(let size):
            return UIFont (name: "System", size: size)!
        case .regular(let size):
            return UIFont.systemFont(ofSize: size)
        }
    }
}



//// MARK: ---------Color Constants---------

let appThemeUp               = UIColor.init(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
let appThemeDown             = UIColor.init(red: 251/255, green: 136/255, blue: 51/255, alpha: 1)

//MARK: ---------Method Constants---------


func print_debug(items: Any) {
    print(items)
}

func print_debug_fake(items: Any) {
}

struct EmojisGifNames{
    static let clap = "clap"
    static let heart = "heart"
    static let handHeart = "handHeart"
    static let light = "light"
    static let thinking = "thinking"
    static let thumbsUp = "like"
}
struct LottieEmojisGifNames{
    static let clap = "lottieClap"
    static let heart = "lottieHeart"
    static let handHeart = "lottieHandHeart"
    static let light = "lottieBulb"
    static let thinking = "lottieThink"
    static let thumbsUp = "lottieLike"
}
//struct EmojisGifNames{
//    static let clap = "clap.gif"
//    static let heart = "heart.gif"
//    static let handHeart = "handHeart.gif"
//    static let light = "light.gif"
//    static let thinking = "thinking.gif"
//    static let thumbsUp = "like.gif"
//}

struct EmojisNames{
    static let clap = "clap"
    static let heart = "heart-1"
    static let handHeart = "handHeart"
    static let light = "light"
    static let thinking = "thinking"
    static let thumbsUp = "thumbsUp"
}

