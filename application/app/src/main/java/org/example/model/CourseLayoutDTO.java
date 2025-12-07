package org.example.model;

public class CourseLayoutDTO {
    private String courseLayoutId;
    private String courseCode;
    private String layoutVersion;
    private String courseName;
    private String minStudents;
    private String maxStudents;
    private String hp;

    public CourseLayoutDTO() {
    }

    public CourseLayoutDTO(String courseLayoutId, String courseCode, String layoutVersion, 
                          String courseName, String minStudents, String maxStudents, String hp) {
        this.courseLayoutId = courseLayoutId;
        this.courseCode = courseCode;
        this.layoutVersion = layoutVersion;
        this.courseName = courseName;
        this.minStudents = minStudents;
        this.maxStudents = maxStudents;
        this.hp = hp;
    }

    public String getCourseLayoutId() {
        return courseLayoutId;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public String getLayoutVersion() {
        return layoutVersion;
    }

    public String getCourseName() {
        return courseName;
    }

    public String getMinStudents() {
        return minStudents;
    }

    public String getMaxStudents() {
        return maxStudents;
    }

    public String getHp() {
        return hp;
    }
}