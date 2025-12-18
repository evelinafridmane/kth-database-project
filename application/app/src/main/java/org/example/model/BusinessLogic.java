package org.example.model;

public class BusinessLogic {

    // task 2
    public int calculateNewStudentCount(int currentCount) {
        return currentCount + 100;
    }

    // task 3
   public void validateTeacherLoad(int currentLoad, int maxLimit, boolean alreadyInCourse) throws Exception {
        if (!alreadyInCourse) {
            // now i compare against the variable maxLimit, not the 4
            if (currentLoad >= maxLimit) {
                throw new Exception("Teacher limit reached: already has " + currentLoad + " courses. (Max allowed: " + maxLimit + ")");
            }
        }
    }
}
