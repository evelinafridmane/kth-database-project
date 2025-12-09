package org.example.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CourseInstanceDAO {
    private Connection connection;

    public CourseInstanceDAO(Connection connection) {
        this.connection = connection;
    } //conctructor


    public int getStudentCount(String instanceId) throws SQLException { 
        String sql = "SELECT num_students FROM course_instance WHERE instance_id = ? FOR UPDATE"; 
       // lock the row
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            stmt = connection.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(instanceId));//convert from string to int
            
            rs = stmt.executeQuery(); //results
            
            if (rs.next()) {
                return rs.getInt(1);//column 1 (which is 'num_students')
            } else {
                throw new SQLException("Course not found: " + instanceId);
            }
        } finally {
            if (rs != null) {
                rs.close(); //close result table 
            }
            if (stmt != null) {
                stmt.close(); 
            }
        }
    }

    public void updateStudentCount(String instanceId, int newCount) throws SQLException {
        String sql = "UPDATE course_instance SET num_students = ? WHERE instance_id = ?";
        PreparedStatement stmt = null;

        try {
            stmt = connection.prepareStatement(sql);
            stmt.setInt(1, newCount);
            stmt.setInt(2, Integer.parseInt(instanceId));
            
            stmt.executeUpdate();
        } finally {
            if (stmt != null) {
                stmt.close();
            }
        }
    }
}