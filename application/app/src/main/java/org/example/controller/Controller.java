package org.example.controller;

import org.example.model.CourseCostDTO;
import org.example.model.CreateActivityDTO;
import org.example.model.DisplayNewActivityDTO;
import org.example.model.TeacherAllocationDTO;
import org.example.service.Service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Controller {
    private Connection connection;
    private Service service; 

    public void connect() throws SQLException {
        String url = "jdbc:postgresql://localhost:5432/university";
        String user = "postgres";
        String password = "evelina";

        connection = DriverManager.getConnection(url, user, password);
        // Service handles transaction boundaries
        
        this.service = new Service(connection);
    }

    // task 1
    public CourseCostDTO computeTeachingCost(String instanceId) throws SQLException {
        return service.computeTeachingCost(instanceId);
    }

    // task 2
    public CourseCostDTO modifyStudentCount(String instanceId) throws SQLException {
        return service.modifyStudentCount(instanceId);
    }

    // task 3 Allocation
    public String allocateTeachingActivity(TeacherAllocationDTO dto) {
        try {
            return service.allocateTeachingActivity(dto);
        } catch (Exception e) {
            return "Failed: " + e.getMessage();
        }
    }

    // task 3 Deallocation
    public String deallocateTeachingActivity(TeacherAllocationDTO dto) {
        try {
            return service.deallocateTeachingActivity(dto);
        } catch (SQLException e) {
            return "Failed: " + e.getMessage();
        }
    }

    // task 4
    public DisplayNewActivityDTO addTeachingActivity(CreateActivityDTO dto) throws SQLException {
        try {
            return service.addTeachingActivity(dto);
        } catch (Exception e) {
            if (e instanceof SQLException) {
                throw (SQLException) e;
            } else {
                throw new SQLException(e.getMessage());
            }
        }
    }
}
