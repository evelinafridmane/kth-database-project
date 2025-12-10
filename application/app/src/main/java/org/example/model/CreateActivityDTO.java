package org.example.model;

public class CreateActivityDTO {
    private String activityName; // "Exercise"
    private double factor;
    private String instanceId;
    private int plannedHours;
    private String teacherId; // teacher to allocate

    public CreateActivityDTO(String activityName, double factor, String instanceId, int plannedHours,
            String teacherId) {
        this.activityName = activityName;
        this.factor = factor;
        this.instanceId = instanceId;
        this.plannedHours = plannedHours;
        this.teacherId = teacherId;
    }

    public String getActivityName() {
        return activityName;
    }

    public double getFactor() {
        return factor;
    }

    public String getInstanceId() {
        return instanceId;
    }

    public int getPlannedHours() {
        return plannedHours;
    }

    public String getTeacherId() {
        return teacherId;
    }
}