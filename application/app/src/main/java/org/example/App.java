package org.example;

//import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.ResultSet;
//import java.sql.SQLException;

//import org.example.dao.TeachingCostDAO;

public class App {
    public String getGreeting() {
        return "Hello!";
    }

    public static void main(String[] args) {
     //   String url = "jdbc:postgresql://localhost:5432/project";
       // String user = "postgres";
       // String password = "evelina";

        System.out.println("Trying to connect to database...");

       // try (Connection conn = DriverManager.getConnection(url, user, password)) {
         //   System.out.println("Connected!");

         //   TeachingCostDAO randomDAO = new TeachingCostDAO(conn);

         //   ResultSet result = randomDAO.calculateAverageHourlyRate();
            
          //  while (result.next()) {
          //      int instanceId = result.getInt("instance_id");
          //      String activityName = result.getString("activity_name");
           //     double totalTeachersHours = result.getDouble("total_teachers_hours");
                
             //   System.out.println("Instance ID: " + instanceId + 
              //                   " | Activity: " + activityName + 
              //                   " | Total Hours: " + totalTeachersHours);
            }
            
          //  result.close();
        } //catch (SQLException e) {
           // e.printStackTrace();
       // }
   // }
//}