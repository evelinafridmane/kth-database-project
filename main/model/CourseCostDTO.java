package main.model;

/**
 * DTO for teaching cost calculation results.
 */
public class CourseCostDTO {
    private final int courseCode;
    private final String courseName;
    private final int instanceId;
    private int studyYear;
    private String studyPeriod;
    private int numStudents;

    private double plannedCost;
    private double actualCost;
    private double averageSalary;
    private double costPerStudent;

    //constructor makes an instance of course cost
    public CourseCostDTO(String courseCode, String courseName, int instanceId,
                         int studyYear, String studyPeriod, int numStudents,
                         double plannedCost, double actualCost,
                         double averageSalary, double costPerStudent) {
        this.courseCode = courseCode;
        this.courseName = courseName;
        this.instanceId = instanceId;
        this.studyYear = studyYear;
        this.studyPeriod = studyPeriod;
        this.numStudents = numStudents;
        this.plannedCost = plannedCost;
        this.actualCost = actualCost;
        this.averageSalary = averageSalary;
        this.costPerStudent = costPerStudent;
    }

    //getters
    public String getCourseCode() {return courseCode;}
    public String getCourseName() {return courseName;}
    public int getInstanceId() {return instanceId;}
    public int getStudyYear() {return studyYear;}
    public String getStudyPeriod() {return studyPeriod;}
    public int getNumStudents() {return numStudents;}
    public double getPlannedCost() {return plannedCost;}
    public double getActualCost() {return actualCost;}
    public double getAverageSalary() {return averageSalary;}
    public double getCostPerStudent() {return costPerStudent;}

    public String toTableRow() {
        return String.format("| %-10s | %-15s | %-6s | %12.2f | %12.2f |",
                getFormattedCourseCode(),
                getFormattedInstanceId(),
                studyPeriod,
                plannedCost,
                actualCost
        );
    }

    @Override
    public String toString() {
        return String.format(
                "Course Cost Analysis:\n" +
                        "Course: IV%s - %s\n" +
                        "Instance: %s, Year: %d, Period: %s\n" +
                        "Students: %d\n" +
                        "Planned Cost: %.2f KSEK\n" +
                        "Actual Cost: %.2f KSEK\n" +
                        "Average Salary: %.2f SEK\n" +
                        "Cost per Student: %.2f SEK",
                courseCode, courseName, getFormattedInstanceId(), studyYear, studyPeriod,
                numStudents, plannedCost, actualCost, averageSalary, costPerStudent
        );
    }
}