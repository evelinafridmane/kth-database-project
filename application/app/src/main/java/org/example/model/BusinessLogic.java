package org.example.model;

public class BusinessLogic {

    // Task 2: Pure math.
    // The Controller gives the number, this Logic gives the answer.
    public int calculateNewStudentCount(int currentCount) {
        return currentCount + 100;
    }

    // Task 3: Pure Validation.
    // The Controller provides the 'situation' (load, alreadyInCourse),
    // The Logic decides if it passes or fails.
    public void validateTeacherLoad(int currentLoad, boolean alreadyInCourse) throws Exception {
        if (!alreadyInCourse) {
            // The "Business Rule" (Max 4) lives here, not in the Controller
            if (currentLoad >= 4) {
                throw new Exception("Teacher limit reached: already has " + currentLoad + " courses.");
            }
        }
    }
}