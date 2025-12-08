package org.example.dao;

import org.example.model.CourseCostDTO;
import java.sql.*;

public class TeachingCostDAO {
    private Connection connection;

    public TeachingCostDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * Calculates the real average hourly rate from the DB.
     * Logic: 
     * 1. Selects only 'current' salaries (where to_date IS NULL).
     * 2. Casts the text salary to a number (::numeric).
     * 3. Averages them and divides by 160 (standard work hours).
     */
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

    public CourseCostDTO getTeachingCost(String instanceId, double hourlyRate) throws SQLException {
       
        String sql = """
    SELECT 
        cl.course_code, 
        ci.instance_id, 
        ci.study_period,
        
        -- 1. PLANNED COST (Total Hours from View * Hourly Rate)

        (SELECT SUM(total_teachers_hours) 
         FROM v_full_course_workload 
         WHERE instance_id = ci.instance_id) * ? AS planned_cost,

        -- 2. ACTUAL COST CALCULATION

        (
          --  Teacher Hours (Sum of all assigned work)
          SUM(ta.factor * pa.planned_nb_hours) 
          + 
          --  Admin Formula (Added once using MAX)
          MAX(2 * cl.hp + 28 + 0.2 * ci.num_students) 
          + 
          --  Exam Formula (Added once using MAX)
          MAX(32 + 0.725 * ci.num_students)
        ) * ? AS actual_cost

    FROM course_instance ci
    JOIN course_layout cl ON ci.course_layout_id = cl.course_layout_id
    JOIN planned_activity pa ON ci.instance_id = pa.instance_id
    JOIN teaching_activity ta ON pa.teaching_activity_id = ta.teaching_activity_id
    JOIN employee_activity ea ON pa.planned_activity_id = ea.planned_activity_id
    
    WHERE ci.instance_id = ?
    GROUP BY cl.course_code, ci.instance_id, cl.hp, ci.num_students, ci.study_period
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
                    rs.getDouble("actual_cost")
                );
            }
        }
        return null;
    }
}