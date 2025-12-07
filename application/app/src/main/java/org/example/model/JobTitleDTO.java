package org.example.model;

public class JobTitleDTO {
    private String jobId;
    private String jobTitle;

    public JobTitleDTO() {
    }

    public JobTitleDTO(String jobId, String jobTitle) {
        this.jobId = jobId;
        this.jobTitle = jobTitle;
    }

    public String getJobId() {
        return jobId;
    }

    public String getJobTitle() {
        return jobTitle;
    }
}