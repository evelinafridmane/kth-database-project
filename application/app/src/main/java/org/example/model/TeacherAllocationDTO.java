package org.example.model;

public class TeacherAllocationDTO {
    private String teacherId;    
    private String instanceId;   
    private String activityName; 

    public TeacherAllocationDTO(String teacherId, String instanceId, String activityName) {
        this.teacherId = teacherId;
        this.instanceId = instanceId;
        this.activityName = activityName;
    }

    public String getTeacherId() {
         return teacherId; 
        }
    public String getInstanceId() { 
        return instanceId;
     }
    public String getActivityName() {
         return activityName;
         }
}