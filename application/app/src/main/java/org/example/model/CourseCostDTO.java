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
    
    // Add Getters and a toString() method to print it easily
    public String toString() {
        return "Course Code: " + courseCode + "Course Instance: "
         + instanceId + " | Period: " + studyPeriod + "| Planned: " 
         + plannedCost + " | Actual: " + actualCost;
    }
}