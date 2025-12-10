package org.example.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TeachingLoadsDAO {
    private Connection connection;

    public TeachingLoadsDAO(Connection connection) {
        this.connection = connection;
    }

    // task 3
    // ID for a specific activity
    public Integer getPlannedActivityId(String instanceId, String activityName) throws SQLException {
        String sql = """
                SELECT pa.planned_activity_id
                FROM planned_activity pa
                JOIN teaching_activity ta ON pa.teaching_activity_id = ta.teaching_activity_id
                WHERE pa.instance_id = ? AND ta.activity_name = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(instanceId));
            stmt.setString(2, activityName);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("planned_activity_id");
                }
            }
        }
        return null;
    }

    // study period and year
    public String[] getCoursePeriod(String instanceId) throws SQLException {
        String sql = "SELECT study_period, study_year FROM course_instance WHERE instance_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(instanceId));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new String[] {
                            rs.getString("study_period"),
                            String.valueOf(rs.getInt("study_year"))
                    };
                }
            }
        }
        return null;
    }

    // counts the courses for teacher
    public int countActiveCoursesForTeacher(String teacherId, String period, String year) throws SQLException {
        String sql = """
                SELECT COUNT(DISTINCT ci.instance_id)
                FROM employee_activity ea
                JOIN planned_activity pa ON ea.planned_activity_id = pa.planned_activity_id
                JOIN course_instance ci ON pa.instance_id = ci.instance_id
                WHERE ea.employment_id = ?
                  AND ci.study_period = ?::study_period
                  AND ci.study_year = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(teacherId));
            stmt.setString(2, period);
            stmt.setInt(3, Integer.parseInt(year));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // if the teacher is already in course, true if not
    public boolean isTeacherAlreadyInCourse(String teacherId, String instanceId) throws SQLException {
        String sql = """
                SELECT 1
                FROM employee_activity ea
                JOIN planned_activity pa ON ea.planned_activity_id = pa.planned_activity_id
                WHERE ea.employment_id = ? AND pa.instance_id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(teacherId));
            stmt.setInt(2, Integer.parseInt(instanceId));

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    // for ACID reasons
    public void lockTeacherForUpdate(String teacherId) throws SQLException {

        String sql = "SELECT employment_id FROM employee WHERE employment_id = ? FOR UPDATE";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(teacherId));
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    throw new SQLException("Teacher " + teacherId + " not found.");
                }
            }
        }
    }

    public void allocateActivity(String teacherId, int plannedActivityId) throws SQLException {
        String sql = "INSERT INTO employee_activity (employment_id, planned_activity_id) VALUES (?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(teacherId));
            stmt.setInt(2, plannedActivityId);
            stmt.executeUpdate();
        }
    }

    public int deallocateActivity(String teacherId, int plannedActivityId) throws SQLException {
        String sql = "DELETE FROM employee_activity WHERE employment_id = ? AND planned_activity_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(teacherId));
            stmt.setInt(2, plannedActivityId);
            return stmt.executeUpdate();
        }
    }

    // task 4

    // check if teaching activity already exists
    public Integer getTeachingActivityId(String activityName) throws SQLException {
        String sql = "SELECT teaching_activity_id FROM teaching_activity WHERE activity_name = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, activityName);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("teaching_activity_id");
                }
            }
        }
        return null;
    }

    // create new teaching activity
    public int createTeachingActivity(String activityName, double factor) throws SQLException {
        String sql = "INSERT INTO teaching_activity (activity_name, factor) VALUES (?, ?) RETURNING teaching_activity_id";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, activityName);
            stmt.setDouble(2, factor);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1; // return invalid ID in case of fail
    }

    // link teaching activity to the course
    public int createPlannedActivity(String instanceId, int teachingActivityId, int hours) throws SQLException {
        String sql = "INSERT INTO planned_activity (instance_id, teaching_activity_id, planned_nb_hours) VALUES (?, ?, ?) RETURNING planned_activity_id";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(instanceId));
            stmt.setInt(2, teachingActivityId);
            stmt.setInt(3, hours);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    // "write a query to display the course layout/instance and allocation for the
    // teacher which is affected by this new activity."
    public org.example.model.DisplayNewActivityDTO getNewActivityReport(int plannedActivityId) throws SQLException {
        String sql = """
                SELECT
                    cl.course_code,
                    cl.course_name,
                    ci.instance_id,
                    ta.activity_name,
                    p.first_name || ' ' || p.last_name AS teacher_name
                FROM planned_activity pa
                JOIN course_instance ci ON pa.instance_id = ci.instance_id
                JOIN course_layout cl ON ci.course_layout_id = cl.course_layout_id
                JOIN teaching_activity ta ON pa.teaching_activity_id = ta.teaching_activity_id
                JOIN employee_activity ea ON pa.planned_activity_id = ea.planned_activity_id
                JOIN employee e ON ea.employment_id = e.employment_id
                JOIN person p ON e.person_id = p.person_id
                WHERE pa.planned_activity_id = ?
                """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, plannedActivityId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new org.example.model.DisplayNewActivityDTO(
                            String.valueOf(rs.getInt("course_code")),
                            rs.getString("course_name"),
                            String.valueOf(rs.getInt("instance_id")),
                            rs.getString("activity_name"),
                            rs.getString("teacher_name"));
                }
            }
        }
        return null;
    }
}
