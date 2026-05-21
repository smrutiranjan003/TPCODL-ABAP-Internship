# PROJECT OBJECT LIST
-----------------------------

## 1. Data Dictionary Tables

`ZSTUDENTT`

`ZSTUDENT_ADDRESS`

`ZCOURSE`

`ZREGISTRATION`

`ZFEEDETAILS`


## 2. Report Programs

### Report 1 :
`ZR_STUDENT_REG_REPORT`
→ Student Registration Report

### Report 2 :
`ZR_COURSE_INFO`
→ Course Information Report


## 3. Module Pool Program

**Program Name :**
`ZMODCOURSE_REG`

**Transaction Code :**
`ZCOURSE_REG`


## 4. SmartForm

**SmartForm Name :**
`ZSF_COURSE_REG`

**Purpose :**
Course Registration Confirmation
(Student Details + Parent Details + Course Details + Fee Details + Total Fee)


## 5. SmartForm Driver Program

**Program Name :**
`ZR_COURSE_REG_SMART`

Purpose :
Fetch data and call SmartForm for printing Course Registration Confirmation
