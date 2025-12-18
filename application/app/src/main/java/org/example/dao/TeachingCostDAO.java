package org.example.dao;

import org.example.model.CourseCostDTO;
import java.sql.*;

public class TeachingCostDAO {
    private Connection connection;

    public TeachingCostDAO(Connection connection) {
        this.connection = connection;
    } // conctructor

    public double calculateAverageHourlyRate() throws SQLException {
        String sql = """
                SELECT AVG(CAST(monthly_salary_amount AS NUMERIC)) / 160.0
                FROM salary_history
                WHERE to_date IS NULL
                """;

        try (Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getDouble(1);

            }
        }
        throw new SQLException("Database empty");
    }
// fixed 
    public CourseCostDTO getTeachingCost(String instanceId, double hourlyRate) throws SQLException {

        String sql = """
                SELECT
                    cl.course_code,
                    ci.instance_id,
                    ci.study_period,

                    -- PLANNED COST (fixed)
                    (
                    (SELECT COALESCE(SUM(pa.planned_nb_hours * ta.factor), 0)
                     FROM planned_activity pa
                     JOIN teaching_activity ta ON pa.teaching_activity_id = ta.teaching_activity_id
                     WHERE pa.instance_id = ci.instance_id)
                     +
                    (2 * cl.hp + 28 + 0.2 * ci.num_students) -- admin formula
                    +
                    (32 + 0.725 * ci.num_students)           -- exam formula
                ) * ? AS planned_cost,

                    -- ACTUAL COST
                --fixed
                (
                    (SELECT COALESCE(SUM(ea.allocated_hours * ta.factor), 0) -- using allocated_hours!
                     FROM employee_activity ea
                     JOIN planned_activity pa ON ea.planned_activity_id = pa.planned_activity_id
                     JOIN teaching_activity ta ON pa.teaching_activity_id = ta.teaching_activity_id
                     WHERE pa.instance_id = ci.instance_id)
                    +
                    (2 * cl.hp + 28 + 0.2 * ci.num_students) -- admin 
                    +
                    (32 + 0.725 * ci.num_students)           -- exam 
                ) * ? AS actual_cost

            FROM course_instance ci
            JOIN course_layout cl ON ci.course_layout_id = cl.course_layout_id
            WHERE ci.instance_id = ?
            """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            int id = Integer.parseInt(instanceId);

            stmt.setDouble(1, hourlyRate);
            stmt.setDouble(2, hourlyRate);
            stmt.setInt(3, id);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new CourseCostDTO(
                        rs.getString("course_code"),
                        rs.getString("instance_id"),
                        rs.getString("study_period"),
                        rs.getDouble("planned_cost"),
                        rs.getDouble("actual_cost"));
            }
        }
        return null;
    }
}
