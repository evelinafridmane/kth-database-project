package main.model;

/**
 * DTO for a teaching activity in a course instance
 */
public class TeachingActivityDTO {
    private final int teachingActivityId;
    private final String activityName;
    private double factor;

    public TeachingActivityDTO(int teachingActivityId, String activityName, double factor) {
        this.teachingActivityId = teachingActivityId;
        this.activityName = activityName;
        this.factor = factor;
    }

    //getters
    public int getTeachingActivityId() {return teachingActivityId;}
    public String getActivityName() {return activityName;}
    public double getFactor() {return factor;}

    @Override
    public String toString() {
        return String.format("%s (ID: %d, Factor: %.2f)",
                activityName, teachingActivityId, factor);
    }
}