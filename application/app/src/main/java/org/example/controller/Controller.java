package org.example.controller;

import org.example.dao.CourseInstanceDAO;
import org.example.dao.TeachingCostDAO;
import org.example.dao.TeachingLoadsDAO;
import org.example.model.CourseCostDTO;
import org.example.model.CreateActivityDTO;
import org.example.model.DisplayNewActivityDTO;
import org.example.model.TeacherAllocationDTO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Controller {
    private Connection connection;

    public void connect() throws SQLException {

        String url = "jdbc:postgresql://localhost:5432/university";
        String user = "postgres";
        String password = "evelina";

        connection = DriverManager.getConnection(url, user, password);
        connection.setAutoCommit(false); // ACID Transactions
    }

    // task one - compute the teaching cost
    public CourseCostDTO computeTeachingCost(String instanceId) throws SQLException {
        TeachingCostDAO dao = new TeachingCostDAO(connection);

        try {

            double hourlyRate = dao.calculateAverageHourlyRate();
            return dao.getTeachingCost(instanceId, hourlyRate);

        } catch (SQLException e) {
            handlException(e);
            throw e;
        }
    }

    // task 2 - modify the course instance
    public CourseCostDTO modifyStudentCount(String instanceId) throws SQLException {

        CourseInstanceDAO courseDAO = new CourseInstanceDAO(connection); // modify
        TeachingCostDAO costDAO = new TeachingCostDAO(connection); // check updated cost

        try {
            int currentCount = courseDAO.getStudentCount(instanceId);
            int newCount = currentCount + 100; // logic here
            courseDAO.updateStudentCount(instanceId, newCount);

            double hourlyRate = costDAO.calculateAverageHourlyRate();
            CourseCostDTO newCost = costDAO.getTeachingCost(instanceId, hourlyRate);

            connection.commit();

            return newCost;

        } catch (SQLException e) {
            handlException(e);
            throw e;
        }
    }

    // task 3 - allocate and deallocate teaching loads (max 4 courses per period)
    // allocate
    public String allocateTeachingActivity(TeacherAllocationDTO dto) throws SQLException {
        TeachingLoadsDAO dao = new TeachingLoadsDAO(connection);

        try {

            dao.lockTeacherForUpdate(dto.getTeacherId());

            Integer plannedId = dao.getPlannedActivityId(dto.getInstanceId(), dto.getActivityName());
            if (plannedId == null) {
                return "Error" + dto.getActivityName() + "not found";
            }
            // chech if fullfils max 4 requrement
            validateTeacherLoad(dao, dto.getTeacherId(), dto.getInstanceId());

            // allocate if everything is right
            dao.allocateActivity(dto.getTeacherId(), plannedId);

            connection.commit();
            return "Allocated activity " + dto.getActivityName() + " to " + dto.getTeacherId();

        } catch (SQLException e) {
            handlException(e);
            throw e;
        }
    }

    // deallocate
    public String deallocateTeachingActivity(TeacherAllocationDTO dto) throws SQLException {
        TeachingLoadsDAO dao = new TeachingLoadsDAO(connection);

        try {

            Integer plannedId = dao.getPlannedActivityId(dto.getInstanceId(), dto.getActivityName());

            if (plannedId == null) {
                return "Error";
            }

            int rowsDeleted = dao.deallocateActivity(dto.getTeacherId(), plannedId);

            connection.commit();

            if (rowsDeleted > 0) {
                return "Removed Teacher " + dto.getTeacherId() + " from " + dto.getActivityName();
            } else {
                return "There wasn't assigned this teacher";
            }

        } catch (SQLException e) {
            handlException(e);
            throw e;
        }
    }

    // task 4
    public DisplayNewActivityDTO addTeachingActivity(CreateActivityDTO dto) throws SQLException {
        TeachingLoadsDAO dao = new TeachingLoadsDAO(connection);

        try {
            // ACID
            dao.lockTeacherForUpdate(dto.getTeacherId());

            // create activity
            Integer activityId = dao.getTeachingActivityId(dto.getActivityName());
            if (activityId == null) {
                activityId = dao.createTeachingActivity(dto.getActivityName(), dto.getFactor());
                if (activityId == -1)
                    throw new SQLException("Failed to create activity");
            }

            // planned activity
            int plannedId = dao.createPlannedActivity(dto.getInstanceId(), activityId, dto.getPlannedHours());
            if (plannedId == -1)
                throw new SQLException("Failed to create planned activity");

            // check limitation of max 4 courses per teacher
            validateTeacherLoad(dao, dto.getTeacherId(), dto.getInstanceId());

            dao.allocateActivity(dto.getTeacherId(), plannedId);

            DisplayNewActivityDTO report = dao.getNewActivityReport(plannedId);

            connection.commit();
            return report;

        } catch (SQLException e) {
            handlException(e);
            throw e;
        }
    }

    // helpers

    private void validateTeacherLoad(TeachingLoadsDAO dao, String teacherId, String instanceId) throws SQLException {

        String[] timeInfo = dao.getCoursePeriod(instanceId);
        if (timeInfo == null) {
            throw new SQLException("Course instance " + instanceId + " not found");
        }

        String period = timeInfo[0];
        String year = timeInfo[1];

        boolean alreadyInCourse = dao.isTeacherAlreadyInCourse(teacherId, instanceId);

        if (!alreadyInCourse) {
            int currentLoad = dao.countActiveCoursesForTeacher(teacherId, period, year);
            if (currentLoad >= 4) {
                throw new SQLException(
                        "Teacher " + teacherId + " already has " + currentLoad + " courses in " + period);
            }
        }
    }

    private void handlException(SQLException e) {
        try {
            if (connection != null) {
                connection.rollback();
            }
        } catch (SQLException rollbackEx) {
        }
    }
}
