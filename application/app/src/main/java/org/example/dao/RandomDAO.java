package org.example.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class RandomDAO {
    private Connection connection;

    public RandomDAO(Connection connection) {
        this.connection = connection;
    }

    public ResultSet getCalculatedExaminationHours() throws SQLException {
        String sql = """
            SELECT
                NULL AS planned_activity_id, 
                ci.instance_id,
                'Examination' AS activity_name,
                NULL AS factor,
                NULL AS planned_nb_hours,
                (32 + 0.725 * ci.num_students) AS total_teachers_hours 
            FROM
                course_instance ci
            """;
        
        Statement statement = connection.createStatement();
        return statement.executeQuery(sql);
    }

    public ResultSet updateStudents(int newNumberOfStudents, int courseCode) throws SQLException {
        String sql = """
            
            """;
        
        Statement statement = connection.createStatement();
        return statement.executeQuery(sql);
    }
}