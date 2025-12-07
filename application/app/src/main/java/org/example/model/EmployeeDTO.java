package org.example.model;

public class EmployeeDTO {
    private String employmentId;
    private String managerId;
    private String personId;
    private String jobId;
    private String departmentId;

    public EmployeeDTO() {
    }

    public EmployeeDTO(String employmentId, String managerId, String personId, 
                      String jobId, String departmentId) {
        this.employmentId = employmentId;
        this.managerId = managerId;
        this.personId = personId;
        this.jobId = jobId;
        this.departmentId = departmentId;
    }

    public String getEmploymentId() {
        return employmentId;
    }

    public String getManagerId() {
        return managerId;
    }

    public String getPersonId() {
        return personId;
    }

    public String getJobId() {
        return jobId;
    }

    public String getDepartmentId() {
        return departmentId;
    }
}