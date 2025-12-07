package org.example.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.example.model.CourseInstanceDTO;

public class CourseInstanceDAO {
    private Connection connection;

    public CourseInstanceDAO(Connection connection) {
        this.connection = connection;
    }

    public List<CourseInstanceDTO> getAllCourseInstances() throws SQLException {
        List<CourseInstanceDTO> instances = new ArrayList<>();
        String sql = "SELECT * FROM course_instance";
        
        try (Statement statement = connection.createStatement();
             ResultSet result = statement.executeQuery(sql)) {
            
            while (result.next()) {
                CourseInstanceDTO instance = new CourseInstanceDTO(
                    result.getString("instance_id"),
                    result.getString("num_students"),
                    result.getString("study_period"),
                    result.getString("study_year"),
                    result.getString("course_layout_id")
                );
                instances.add(instance);
            }
        }
        
        return instances;
    }
}