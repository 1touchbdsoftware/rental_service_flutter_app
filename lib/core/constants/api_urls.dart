
class ApiUrls{
  static const baseURL = "http://152.89.106.226:9097/api/";

  static const register = '${baseURL}auth/register';

  static const signin = '${baseURL}access/login';

  static const getComplainInfo = '${baseURL}Complain/GetComplainInfo';

  static const propertyWiseSegment = '${baseURL}Segment/GetSegmentsExtension';

  static const saveComplain = '${baseURL}Complain/SaveComplain';

  static const updateComplain = '${baseURL}Complain/SaveComplain';

  static const getAssignedTechnician = '${baseURL}TechnicianAssign/GetAssignedTechnicianInfos';

  static const getHistory = '${baseURL}Complain/GetComplainHistory';

  static const acceptAssignedTechnician = '${baseURL}TechnicianAssign/SaveAcceptAssignTechnician';

  static const rescheduleAssignedTechnician = '${baseURL}';



}