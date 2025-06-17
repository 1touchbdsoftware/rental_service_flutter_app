# **ProMatrix TL App - Developer Guide**

## **Project Overview**

Welcome to the **ProMatrix TL App** repository! This application serves as a platform for tenants and landlords to efficiently manage complaints, communication, and issue resolution. The app is designed to streamline the complaint process by allowing tenants to submit complaints with images and for landlords to review, accept, decline, and resolve those complaints.

This **README** serves as a guide to help future developers understand the app's architecture, setup, and core functionalities. It also provides the workflow for contributing to the project and maintaining its codebase.

---

## **App Details**

**App Name:** ProMatrix TL  
**Platform:** Android & iOS  
**Minimum Android Version:** 21 (Android 5.0 Lollipop, 2014)  
**Minimum iOS Version:** 12 (iOS 12, 2018)  

---

## **Project Structure**

### **Key Components**
1. **Tenant Dashboard:**
   - Allows tenants to create complaints, view their complaint status, and track history.
   - Includes the ability to attach multiple images (camera/gallery).
   - Tracks the status of complaints with options to edit, reschedule, accept, or mark as completed.

2. **Landlord Dashboard:**
   - Allows landlords to view assigned complaints, accept/decline them, and mark them as resolved.
   - Can also view declined complaints and track complaint history.

3. **Backend Architecture:**
   - The backend is designed to handle tenant complaints, landlord responses, and data storage.
   - Use of RESTful APIs to fetch, update, and manage complaints.
   
4. **Database:**
   - Complaint-related data is stored in a structured database, which tracks the status and history of each complaint.
   - Last comments from tenants and landlords are logged and accessible for review.

4. **Localization : Language :**
   - Multiple json arb files are maintained for showing different strings and messages instead of hardcoded strings.
   - Maintain this language convension where necessary.
---


### **Landlord Features**
- **Manage Complaints:**
   - Landlords can view all complaints assigned to them.
   - Complaints can be **Accepted** or **Declined**.

- **Resolved & Declined Lists:**
   - Similar to tenants, landlords can track the status of complaints they’ve resolved or declined.

---

## **Installation and Setup**

### **For Android:**
1. Clone the repository to your local machine.
2. Open Android Studio and import the project.
3. Ensure that you have the appropriate Android SDK version (min SDK 21).
4. Run the app on an emulator or physical device for testing.

### **For iOS:**
1. Clone the repository to your local machine.
2. Open the project using **Xcode**.
3. Ensure you have the required iOS SDK version (min iOS 12).
4. Build and run the app on an emulator or physical device.

---

## **Development Guidelines**

### **Code Quality & Standards**
- Follow standard Dart and Flutter best practices for both Android and iOS development.
- Ensure that code is well-documented with comments where necessary.
- Write unit tests for critical parts of the application, especially for business logic.
- Avoid adding hardcoded values; use constants or configuration files where applicable.
- For Better Commit messages, read this [Git Usage](https://mumin-ahmod.medium.com/git-conventions-the-developers-guide-to-writing-better-commits-and-workflows-840b5e3b830d)
- Follow the web version when implementing new feature, [Promatrix web](http://application.promatrix.com.tr/)

### **Branching Strategy**
- **Main branch:** The main branch is always production-ready and should reflect the latest stable version of the app.
- **Feature branches:** New features should be developed in separate feature branches. Once a feature is complete, it can be merged into the `main` branch via a pull request.
- **Bugfix branches:** For any urgent bugs, create a bugfix branch that addresses the issue. Once fixed, merge it back into `main`.
- **Personal Work branches:** For general working purpose of a dev in his/her name, commit regularly and then merge to `main`.

---

## **Contributing**

### **How to Contribute:**
1. Fork the repository and clone it to your local machine.
2. Create a new branch for your feature or bugfix.
3. Ensure that you follow the development guidelines and keep your code clean and well-documented.
4. Push the branch and create a pull request with a clear description of what has been changed.
5. Wait for review and approval from the lead developer.

### **Code Review:**
- All pull requests should be reviewed by a senior developer before merging.
- Focus on functionality, code quality, and readability.

---

## **Future Development**

### **New Features:**
- **Recent Activity:**  
   - Implement a feature to show recent activities and actions taken by tenants and landlords. This will help both parties track the history of actions in real time.

- **Push Notifications:**  
   - Future updates may include push notifications to notify tenants and landlords of new complaints or status updates.

- **Improved Security:**  
   - Future releases will focus on improving data security, such as encryption of sensitive data and enhancing user authentication.

---

## **Testing & Quality Assurance**

- **Unit Tests:**  
   - Unit tests should be written for key logic, including API integrations, complaint creation, and status transitions.
   
- **UI Testing:**  
   - Use Flutter’s testing framework to conduct UI testing for both Android and iOS platforms.

- **Continuous Integration (CI):**  
   - Set up a CI/CD pipeline (using services like GitHub Actions or Bitrise) to automate builds, testing, and deployment.

---

## **License**

This project is licensed under the **[Insert License Name]**.

---

## **Contact Information**

For any issues or inquiries, please reach out to the project lead or use the following contact information:  
**[Insert Contact Information]**

---

## **Acknowledgments**

Thank you for contributing to **ProMatrix TL App**. We hope you find the project straightforward to work on and continue building upon it to enhance the functionality and performance.

