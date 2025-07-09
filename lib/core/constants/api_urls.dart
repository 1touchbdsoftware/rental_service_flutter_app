
class ApiUrls{
  static const baseURL = "https://api.promatrix.com.tr/api/";

  // static const baseURL = "http://152.89.106.226:9094/api/";

  static const register = '${baseURL}auth/register';

  static const signin = '${baseURL}access/login/';

  static const getComplainInfo = '${baseURL}Complain/GetComplainInfo';
  static const getComplainImages = '${baseURL}Complain/GetComplainImages';

  static const getComplainInfoLandlord = '${baseURL}Complain/GetComplainInfoForLandlord';

  static const propertyWiseSegment = '${baseURL}Segment/GetSegmentsExtension';

  static const saveComplain = '${baseURL}Complain/SaveComplain';
  static const editComplain = '${baseURL}Complain/EditComplain';
  static const updateComplain = '${baseURL}Complain/SaveComplain';
  static const reComplain = '${baseURL}Complain/Recomplain';
  static const markComplainCompleted = '${baseURL}Complain/UpdateCompletionStatus';

  static const getAssignedTechnician = '${baseURL}TechnicianAssign/GetAssignedTechnicianInfos';
  static const acceptAssignedTechnician = '${baseURL}TechnicianAssign/SaveAcceptAssignTechnician';
  static const rescheduleTechnician = '${baseURL}TechnicianAssign/SaveRescheduleAssignTechnician';

  static const getHistory = '${baseURL}Complain/GetComplainHistory';

  static const approveComplaints = '${baseURL}Complain/SaveComplainApproval';
  static const resetPassword = '${baseURL}Access/ResetPassword';
  static const forgotPassword = '${baseURL}Access/ForgotPassword';
  static const verifyOtp = '${baseURL}Access/OTPVerification';




}