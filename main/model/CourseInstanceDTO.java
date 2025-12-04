package main.model;

/**
 * A course instance in the university.
 */
public class CourseInstanceDTO {
    private final int instanceId;
    private int numStudents;
    private String studyPeriod; //TODO: put special type study period?
    private int studyYear;

    private final int courseLayoutId;
    private int courseCode;
    private String courseName;
    private int minStudents;
    private int maxStudents;
    private int hp;  // Credits (högskolepoäng)
    private final int layoutVersion;

    /**
     * Counstructor creates a course instance
     */
    public CourseInstanceDTO(int instanceId, int numStudents, String studyPeriod, int studyYear,
                             int courseLayoutId, int courseCode, String courseName,
                             int minStudents, int maxStudents, int hp, int layoutVersion){
        this.instanceId = instanceId;
        this.numStudents = numStudents;
        this.studyPeriod = studyPeriod;
        this.studyYear = studyYear;
        this.courseLayoutId = courseLayoutId;
        this.courseCode = courseCode;
        this.courseName = courseName;
        this.minStudents = minStudents;
        this.maxStudents = maxStudents;
        this.hp = hp;
        this.layoutVersion = layoutVersion;
    }

    //getters:
    public int getInstanceId() {return instanceId;}
    public int getNumStudents() {return numStudents;}
    public String getStudyPeriod() {return studyPeriod;}
    public int getStudyYear() {return studyYear;}
    public int getCourseLayoutId() {return courseLayoutId;}
    public String getCourseCode() {return courseCode;}
    public String getCourseName() {return courseName;}
    public int getMinStudents() {return minStudents;}
    public int getMaxStudents() {return maxStudents;}
    public int getHp() {return hp;}
    public int getLayoutVersion() {return layoutVersion;}

    /**
     * Returns a new CourseInstanceDTO with updated student count.
     *
     * @param newStudentCount
     * @return A new CourseInstanceDTO with updated student count
     */
    public CourseInstanceDTO withUpdatedStudents(int newStudentCount) {
        return new CourseInstanceDTO(
                this.instanceId,
                newStudentCount,
                this.studyPeriod,
                this.studyYear,
                this.courseLayoutId,
                this.courseCode,
                this.courseName,
                this.minStudents,
                this.maxStudents,
                this.hp,
                this.layoutVersion
        );
    }

    /**
     * Checks if the course instance can accept more students.
     *
     * @return true if there is available capacity, false otherwise
     */
    public boolean hasAvailableCapacity() {
        return numStudents<maxStudents;
    }

    /**
     * Checks if the course has enough students to run.
     *
     * @return true if minimum student requirement is met
     */
    public boolean meetsMinimumStudents() {
        return numStudents>=minStudents;
    }

    /**
     * Calculates the percentage of capacity filled.
     *
     * @return Percentage filled (0-100)
     */
    public double getCapacityPercentage() {
        if (maxStudents==0) return 0.0;
        return ((double)numStudents/maxStudents)*100;
    }

    /**
     * Returns a detailed string including student counts.
     */
    @Override
    public String toDetailedString() {
        return String.format(
                "Course Instance: %s\n" +
                        "Course: IV%s - %s (v%d)\n" +
                        "Year: %d, Period: %s\n" +
                        "Students: %d (Min: %d, Max: %d, %.1f%% full)\n" +
                        "Credits: %d HP",
                instanceId,
                courseCode,
                courseName,
                layoutVersion,
                studyYear,
                studyPeriod,
                numStudents,
                minStudents,
                maxStudents,
                getCapacityPercentage(),
                hp
        );
    }
}