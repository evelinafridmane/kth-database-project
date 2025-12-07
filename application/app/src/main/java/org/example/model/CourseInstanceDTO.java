package org.example.model;

public class CourseInstanceDTO {
    private String instanceId;
    private String numStudents;
    private String studyPeriod;
    private String studyYear;
    private String courseLayoutId;

    public CourseInstanceDTO() {
    }

    public CourseInstanceDTO(String instanceId, String numStudents, String studyPeriod, 
                            String studyYear, String courseLayoutId) {
        this.instanceId = instanceId;
        this.numStudents = numStudents;
        this.studyPeriod = studyPeriod;
        this.studyYear = studyYear;
        this.courseLayoutId = courseLayoutId;
    }

    public String getInstanceId() {
        return instanceId;
    }

    public String getNumStudents() {
        return numStudents;
    }

    public String getStudyPeriod() {
        return studyPeriod;
    }

    public String getStudyYear() {
        return studyYear;
    }

    public String getCourseLayoutId() {
        return courseLayoutId;
    }
}