package org.example.model;

public class CourseCostDTO {
    private String courseCode;
    private String instanceId;
    private String studyPeriod;
    private double plannedCost;
    private double actualCost;

    public CourseCostDTO(String courseCode , String instanceId, String studyPeriod, double plannedCost, double actualCost) {
        this.courseCode = courseCode;
        this.instanceId = instanceId;
        this.studyPeriod = studyPeriod;
        this.plannedCost = plannedCost;
        this.actualCost = actualCost;
    }
    
public String getCourseCode() {
     return courseCode; 
    }
    public String getInstanceId() { 
        return instanceId; 
    }
    public String getStudyPeriod() {
         return studyPeriod; 
        }
    public double getPlannedCost() {
         return plannedCost;
         }
    public double getActualCost() { 
        return actualCost;
     }
}