import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
    Locale('ru'),
    Locale('tr')
  ];

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'AC not working properly'**
  String get acNotWorkingProperly;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Accept Declined Complaint'**
  String get acceptDeclinedComplaint;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Accept functionality coming soon'**
  String get acceptFunctionalityComingSoon;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Accept Technician'**
  String get acceptTechnician;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'accepted schedule'**
  String get acceptedSchedule;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Accepted Schedule'**
  String get acceptedSchedule_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotos;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'admin'**
  String get admin;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Agency ID'**
  String get agencyId;

  /// No description provided for @agency.
  ///
  /// In en, this message translates to:
  /// **'Agency'**
  String get agency;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Approval failed'**
  String get approvalFailed;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Approve Comment'**
  String get approveComment;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get areYouSureYouWantToLogOutOfYourAccount;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Assigned Technician'**
  String get assignedTechnician;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Attach Images'**
  String get attachImages;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Be specific about the issue for faster resolution'**
  String get beSpecificAboutTheIssueForFasterResolution;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Cannot complete declined complaints. Please reconsider first.'**
  String get cannotCompleteDeclinedComplaintsPleaseReconsiderFirst;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Cannot edit solved complaints'**
  String get cannotEditSolvedComplaints;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Cannot fetch complaints: tenantID is null or empty'**
  String get cannotFetchComplaintsTenantidIsNullOrEmpty;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Cannot reschedule solved complaints'**
  String get cannotRescheduleSolvedComplaints;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Cannot resubmit solved complaints'**
  String get cannotResubmitSolvedComplaints;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'code'**
  String get code;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Comment is Required'**
  String get commentIsRequired;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'comment text...'**
  String get commentText;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complaint approved successfully'**
  String get complaintApprovedSuccessfully;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complaint Created'**
  String get complaintCreated;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complaint Declined'**
  String get complaintDeclined;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complaint Declined successfully'**
  String get complaintDeclinedSuccessfully;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complaint Details'**
  String get complaintDetails;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complaint History'**
  String get complaintHistory;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complaint is already accepted and solved'**
  String get complaintIsAlreadyAcceptedAndSolved;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complaint is already completed'**
  String get complaintIsAlreadyCompleted;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complaint marked as complete'**
  String get complaintMarkedAsComplete;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complaint Resolved'**
  String get complaintResolved;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'complaint resubmitted'**
  String get complaintResubmitted;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complaint submitted successfully'**
  String get complaintSubmittedSuccessfully;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complaints List'**
  String get complaintsList;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Complete functionality coming soon'**
  String get completeFunctionalityComingSoon;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get completed;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// Localized string with parameters: e
  ///
  /// In en, this message translates to:
  /// **'Could not initiate call: {e}'**
  String couldNotInitiateCallE(String e);

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Create Complaint'**
  String get createComplaint;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Decline Comment'**
  String get declineComment;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Decline Reason'**
  String get declineReason;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Decline request failed'**
  String get declineRequestFailed;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'DECLINED'**
  String get declined;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Declined Complaint Action'**
  String get declinedComplaintAction;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Declined Complaints'**
  String get declinedComplaints;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Declined List'**
  String get declinedList;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get declined_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionIsRequired;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Do you want to reconsider and accept this complaint?'**
  String get doYouWantToReconsiderAndAcceptThisComplaint;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Do you want to reconsider this complaint and schedule it?'**
  String get doYouWantToReconsiderThisComplaintAndScheduleIt;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Edit Declined Complaint'**
  String get editDeclinedComplaint;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Edit functionality for landlord coming soon'**
  String get editFunctionalityForLandlordComingSoon;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Email:'**
  String get email_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Enter text here...'**
  String get enterTextHere;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Failed to determine user type. Please try logging in again.'**
  String get failedToDetermineUserTypePleaseTryLoggingInAgain;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Failed to load technician information'**
  String get failedToLoadTechnicianInformation;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Feedback is required'**
  String get feedbackIsRequired;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'flag'**
  String get flag;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Localized string for resubmitting a complaint
  ///
  /// In en, this message translates to:
  /// **'Resubmit Complaint'**
  String get resubmitComplaint;

  /// Localized string for mentioning missing or unclear details in a previous complaint
  ///
  /// In en, this message translates to:
  /// **'Mention what was missing or unclear in your last complaint'**
  String get mentionMissingOrUnclear;

  /// Localized string for original comment label
  ///
  /// In en, this message translates to:
  /// **'Original Comment:'**
  String get originalComment;

  /// Localized string for resubmission failure message
  ///
  /// In en, this message translates to:
  /// **'Resubmission failed'**
  String get resubmissionFailed;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Getting Technician info...'**
  String get gettingTechnicianInfo;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Getting Technician Info...'**
  String get gettingTechnicianInfo_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Hold on, bringing everything together...'**
  String get holdOnBringingEverythingTogether;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Hold on, Getting history...'**
  String get holdOnGettingHistory;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Localized string with parameters: imageCount
  ///
  /// In en, this message translates to:
  /// **'Image Gallery ({imageCount})'**
  String imageGalleryComplaintImagecount(String imageCount);

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Image loading cancelled'**
  String get imageLoadingCancelled;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'in progress'**
  String get inProgress;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Initial images'**
  String get initialImages;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Invalid Time'**
  String get invalidTime;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Issue List'**
  String get issueList;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Kitchen cabinet repair'**
  String get kitchenCabinetRepair;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Landlord'**
  String get landlord;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Landlord Dashboard'**
  String get landlordDashboard_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Landlord ID'**
  String get landlordId;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Landlord Information'**
  String get landlordInformation;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Landlord Name'**
  String get landlordName;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'LANDLORD'**
  String get landlord_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'LandlordID is null or empty, cannot fetch complaints'**
  String get landlordidIsNullOrEmptyCannotFetchComplaints;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Last Comment'**
  String get lastComment;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Last Comment Details'**
  String get lastCommentDetails;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Last Comments'**
  String get lastComments;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Loading Complaints...'**
  String get loadingComplaints;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Loading Declined Complaints...'**
  String get loadingDeclinedComplaints;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Loading images...'**
  String get loadingImages;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Loading Pending Complaints...'**
  String get loadingPendingComplaints;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Loading Solved Complaints...'**
  String get loadingSolvedComplaints;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Loading User Info...'**
  String get loadingUserInfo;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get login;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Login in progress...'**
  String get loginInProgress;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// Localized string with parameters: e
  ///
  /// In en, this message translates to:
  /// **'Login successful but failed to load dashboard: {e}'**
  String loginSuccessfulButFailedToLoadDashboardE(String e);

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Maintenance Scheduled'**
  String get maintenanceScheduled;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get markAsComplete;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get nA;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get name;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Navigating to Landlord Dashboard'**
  String get navigatingToLandlordDashboard;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Navigating to Tenant Dashboard'**
  String get navigatingToTenantDashboard;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'New Complaint'**
  String get newComplaint;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategoriesAvailable;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No comments'**
  String get noComments;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No comments available'**
  String get noCommentsAvailable;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No Comments Yet'**
  String get noCommentsYet;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No complaints to Show'**
  String get noComplaintsToShow;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No decline reason provided'**
  String get noDeclineReasonProvided;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No Declined Complaints to Show'**
  String get noDeclinedComplaintsToShow;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No details provided.'**
  String get noDetailsProvided;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No history records found'**
  String get noHistoryRecordsFound;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No options available'**
  String get noOptionsAvailable;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No Pending Complaints to Show'**
  String get noPendingComplaintsToShow;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No resolution comments available'**
  String get noResolutionCommentsAvailable;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No Segment'**
  String get noSegment;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No segments available'**
  String get noSegmentsAvailable;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'No Solved Complaints to Show'**
  String get noSolvedComplaintsToShow;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// Localized string with parameters: number
  ///
  /// In en, this message translates to:
  /// **'{number}nd'**
  String numberNd(String number);

  /// Localized string with parameters: number
  ///
  /// In en, this message translates to:
  /// **'{number}rd'**
  String numberRd(String number);

  /// Localized string with parameters: number
  ///
  /// In en, this message translates to:
  /// **'{number}st'**
  String numberSt(String number);

  /// Localized string with parameters: number
  ///
  /// In en, this message translates to:
  /// **'{number}th'**
  String numberTh(String number);

  /// Localized string with parameters: length
  ///
  /// In en, this message translates to:
  /// **'Only added {length} images. Maximum limit reached.'**
  String onlyAddedImagestoaddLengthImagesMaximumLimitReached(String length);

  /// Message showing the maximum number of images allowed.
  ///
  /// In en, this message translates to:
  /// **'Maximum {maxImages} images allowed.'**
  String maximumImagesAllowed(String maxImages);

  /// Localized string with parameters: page
  ///
  /// In en, this message translates to:
  /// **'{page}'**
  String page(String page);

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get pending;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Pending Complaints'**
  String get pendingComplaints;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Phone:'**
  String get phone_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again.'**
  String get pleaseCheckYourConnectionAndTryAgain;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Please enter both username and password'**
  String get pleaseEnterBothUsernameAndPassword;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get pleaseEnterYourUsername;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get pleaseFillAllRequiredFields;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Please provide your feedback'**
  String get pleaseProvideYourFeedback;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Please select a segment'**
  String get pleaseSelectASegment;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Please write a Comment'**
  String get pleaseWriteAComment;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Preparing...'**
  String get preparing;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Pro Matrix Needs Internet Connection'**
  String get proMatrixNeedsInternetConnection;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'PROBLEM'**
  String get problem;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Property ID'**
  String get propertyId;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Property Name'**
  String get propertyName;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Property Owner'**
  String get propertyOwner;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Read Less'**
  String get readLess;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Reconsider'**
  String get reconsider;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Reconsider & Accept'**
  String get reconsiderAccept;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Reconsider functionality coming soon'**
  String get reconsiderFunctionalityComingSoon;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Reconsider & Schedule'**
  String get reconsiderSchedule;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Registration Type'**
  String get registrationType;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'rejected'**
  String get rejected;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get reschedule;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Reschedule Date'**
  String get rescheduleDate;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Reschedule Declined Complaint'**
  String get rescheduleDeclinedComplaint;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Reschedule functionality coming soon'**
  String get rescheduleFunctionalityComingSoon;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Reschedule Request'**
  String get rescheduleRequest;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Reschedule Time'**
  String get rescheduleTime;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'rescheduled'**
  String get rescheduled;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Resolution Comments'**
  String get resolutionComments;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Resolved List'**
  String get resolvedList;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'resolved'**
  String get resolved_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Resubmit'**
  String get resubmit;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Resubmit functionality coming soon'**
  String get resubmitFunctionalityComingSoon;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'resubmitted'**
  String get resubmitted;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Schedule Date:'**
  String get scheduleDate;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Schedule Time:'**
  String get scheduleTime;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Segment'**
  String get segment;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Select an option'**
  String get selectAnOption;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'sent to landlord'**
  String get sentToLandlord;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Sent to Landlord'**
  String get sentToLandlord_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'SOLVED'**
  String get solved;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Solved Complaints'**
  String get solvedComplaints;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'solved'**
  String get solved_1;

  /// Localized string with parameters: source
  ///
  /// In en, this message translates to:
  /// **'{source} permission denied'**
  String sourcePermissionDenied(String source);

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'SUBMIT'**
  String get submit;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'SUBMIT COMPLAINT'**
  String get submitComplaint;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'SUBMIT FEEDBACK'**
  String get submitFeedback;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Submit Reschedule Request'**
  String get submitRescheduleRequest;

  /// Localized string with parameters: images
  ///
  /// In en, this message translates to:
  /// **'Successfully fetched {images} images'**
  String successfullyFetchedImagesLengthImages(String images);

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'technician'**
  String get technician;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Technician accepted successfully'**
  String get technicianAcceptedSuccessfully;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'technician assigned'**
  String get technicianAssigned;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Technician Assigned'**
  String get technicianAssigned_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Technician data not available. Please try again.'**
  String get technicianDataNotAvailablePleaseTryAgain;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Technician Details'**
  String get technicianDetails;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Technician Name:'**
  String get technicianName;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Technician rescheduled successfully'**
  String get technicianRescheduledSuccessfully;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get tenant;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Submission failed: Something Went Wrong'**
  String get submissionFailed;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Tenant Dashboard'**
  String get tenantDashboard_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Tenant Info ID'**
  String get tenantInfoId;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Tenant Information'**
  String get tenantInformation;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Tenant Name'**
  String get tenantName;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'TENANT'**
  String get tenant_1;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'tenant'**
  String get tenant_2;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'This complaint has been declined. What would you like to do?'**
  String get thisComplaintHasBeenDeclinedWhatWouldYouLikeToDo;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'This complaint has been declined. Would you like to resubmit it with modifications?'**
  String get thisComplaintHasBeenDeclinedWouldYouLikeToResubmitItWithModifications;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Ticket# {num}'**
  String ticket(String num);

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Unnamed Segment'**
  String get unnamedSegment;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'UPDATE COMPLAINT'**
  String get updateComplaint;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'User info not loaded. Try again.'**
  String get userInfoNotLoadedTryAgain;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Water leakage in bathroom'**
  String get waterLeakageInBathroom;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Write Comment or Instructions'**
  String get writeCommentOrInstructions;

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Write your Comment Here:'**
  String get writeYourCommentHere;

  /// Localized string with parameters: year, month, day
  ///
  /// In en, this message translates to:
  /// **'{year}-{month}-{day}'**
  String yearMonthDay(String year, String month, String day);

  /// Localized string
  ///
  /// In en, this message translates to:
  /// **'Your Feedback'**
  String get yourFeedback;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'bn', 'en', 'hi', 'ru', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return SAr();
    case 'bn': return SBn();
    case 'en': return SEn();
    case 'hi': return SHi();
    case 'ru': return SRu();
    case 'tr': return STr();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
