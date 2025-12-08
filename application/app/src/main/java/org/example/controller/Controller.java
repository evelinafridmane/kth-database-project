package org.example.controller;

import org.example.dao.TeachingCostDAO;
import org.example.model.CourseCostDTO;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Controller {
    private Connection connection;

    
    public void connect() throws SQLException {
        
        String url = "jdbc:postgresql://localhost:5432/project";
        String user = "postgres";
        String password = "evelina"; 

        connection = DriverManager.getConnection(url, user, password);
        connection.setAutoCommit(false); // ACID Transactions
    }

    // compute teaching cost
    public void computeTeachingCost(String instanceId) {
        TeachingCostDAO dao = new TeachingCostDAO(connection);

        try {
            
            double hourlyRate = dao.calculateAverageHourlyRate();
            CourseCostDTO result = dao.getTeachingCost(instanceId, hourlyRate);

            connection.commit();

            if (result != null) {
                System.out.println(result.toString());
            } else {
                System.out.println("No data for Instance ID: " + instanceId);
            }

        } catch (SQLException e) {
            try {
                System.out.println("Error.");
                connection.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
        }
    }
}