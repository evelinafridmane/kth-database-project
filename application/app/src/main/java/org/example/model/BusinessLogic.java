package org.example.model;

public class BusinessLogic {

    // task 2
    public int calculateNewStudentCount(int currentCount) {
        return currentCount + 100;
    }

    // task 3 
    public void validateTeacherLoad(int currentLoad, boolean alreadyInCourse) throws Exception {
        if (!alreadyInCourse) {
            // max 4 rule
            if (currentLoad >= 4) {
                throw new Exception("Teacher limit reached: already has " + currentLoad + " courses.");
            }
        }
    }
}
