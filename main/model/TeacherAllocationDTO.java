package main.model;

/**
 * DTO for a teacher's allocation to a teaching activity
 */
public class TeacherAllocationDTO {
    private final int employmentId;
    private String teacherName;
    private final int plannedActivityId;
    private final int instanceId;
    private String activityName;
    private String studyPeriod;
    private int studyYear;
    private int plannedHours;
    private double factor;
    private double totalTeacherHours;

    public TeacherAllocationDTO(int employmentId, String teacherName,
                                int plannedActivityId, int instanceId,
                                String activityName, String studyPeriod,
                                int studyYear, int plannedHours,
                                double factor, double totalTeacherHours) {
        this.employmentId = employmentId;
        this.teacherName = teacherName;
        this.plannedActivityId = plannedActivityId;
        this.instanceId = instanceId;
        this.activityName = activityName;
        this.studyPeriod = studyPeriod;
        this.studyYear = studyYear;
        this.plannedHours = plannedHours;
        this.factor = factor;
        this.totalTeacherHours = totalTeacherHours;
    }

    //getters
    public int getEmploymentId() {return employmentId;}
    public String getTeacherName() {return teacherName;}
    public int getPlannedActivityId() {return plannedActivityId;}
    public int getInstanceId() {return instanceId;}
    public String getActivityName() {return activityName;}
    public String getStudyPeriod() {return studyPeriod;}
    public int getStudyYear() {return studyYear;}
    public int getPlannedHours() {return plannedHours;}
    public double getFactor() {return factor;}
    public double getTotalTeacherHours() {return totalTeacherHours;}
}