package org.example.model;

public class DisplayNewActivityDTO {
    private String courseCode;
    private String courseName;
    private String instanceId;
    private String activityName;
    private String teacherName;

    public DisplayNewActivityDTO(String courseCode, String courseName, String instanceId, String activityName,
            String teacherName) {
        this.courseCode = courseCode;
        this.courseName = courseName;
        this.instanceId = instanceId;
        this.activityName = activityName;
        this.teacherName = teacherName;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public String getCourseName() {
        return courseName;
    }

    public String getInstanceId() {
        return instanceId;
    }

    public String getActivityName() {
        return activityName;
    }

    public String getTeacherName() {
        return teacherName;
    }
}
