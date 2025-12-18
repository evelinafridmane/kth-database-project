package org.example.service;

import org.example.dao.CourseInstanceDAO;
import org.example.dao.TeachingCostDAO;
import org.example.dao.TeachingLoadsDAO;
import org.example.model.BusinessLogic;
import org.example.model.CourseCostDTO;
import org.example.model.CreateActivityDTO;
import org.example.model.DisplayNewActivityDTO;
import org.example.model.TeacherAllocationDTO;

import java.sql.Connection;
import java.sql.SQLException;

public class Service {
    private Connection connection;
    private BusinessLogic businessLogic;

    public Service(Connection connection) {
        this.connection = connection;
        this.businessLogic = new BusinessLogic();
    }

    // task 1 - compute the teaching cost
    public CourseCostDTO computeTeachingCost(String instanceId) throws SQLException {
        TeachingCostDAO dao = new TeachingCostDAO(connection);

        double hourlyRate = dao.calculateAverageHourlyRate();
        return dao.getTeachingCost(instanceId, hourlyRate);
    }

    // task 2 - modify the course instance
    public CourseCostDTO modifyStudentCount(String instanceId) throws SQLException {
        CourseInstanceDAO courseDAO = new CourseInstanceDAO(connection);
        TeachingCostDAO costDAO = new TeachingCostDAO(connection);

        connection.setAutoCommit(false);

        try {
            // logic moved from controller
            int currentCount = courseDAO.getStudentCount(instanceId);
            int newCount = businessLogic.calculateNewStudentCount(currentCount);

            courseDAO.updateStudentCount(instanceId, newCount);

            double hourlyRate = costDAO.calculateAverageHourlyRate();
            CourseCostDTO newCost = costDAO.getTeachingCost(instanceId, hourlyRate);

            connection.commit();
            return newCost;

        } catch (SQLException e) {

            handleRollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    // task 3 - allocate
    public String allocateTeachingActivity(TeacherAllocationDTO dto) throws Exception {
        TeachingLoadsDAO dao = new TeachingLoadsDAO(connection);
        connection.setAutoCommit(false);

        try {
            dao.lockTeacherForUpdate(dto.getTeacherId());

            Integer plannedId = dao.getPlannedActivityId(dto.getInstanceId(), dto.getActivityName());
            if (plannedId == null)
                return "Error: " + dto.getActivityName() + " not found";

            String[] timeInfo = dao.getCoursePeriod(dto.getInstanceId());
            if (timeInfo == null)
                throw new SQLException("Course not found");

            int currentLoad = dao.countActiveCoursesForTeacher(dto.getTeacherId(), timeInfo[0], timeInfo[1]);
            boolean alreadyInCourse = dao.isTeacherAlreadyInCourse(dto.getTeacherId(), dto.getInstanceId());

            int maxLimit = dao.getMaxCourseLimit();

            businessLogic.validateTeacherLoad(currentLoad, maxLimit, alreadyInCourse);

            int plannedHours = dao.getPlannedHours(plannedId);
            dao.allocateActivity(dto.getTeacherId(), plannedId, plannedHours);

            connection.commit();
            return "Allocated activity " + dto.getActivityName() + " to " + dto.getTeacherId();

        } catch (Exception e) {
            handleRollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    // deallocate
    public String deallocateTeachingActivity(TeacherAllocationDTO dto) throws SQLException {
        TeachingLoadsDAO dao = new TeachingLoadsDAO(connection);
        connection.setAutoCommit(false);

        try {
            Integer plannedId = dao.getPlannedActivityId(dto.getInstanceId(), dto.getActivityName());
            if (plannedId == null)
                return "Error: Activity not found";

            int rowsDeleted = dao.deallocateActivity(dto.getTeacherId(), plannedId);
            connection.commit();

            if (rowsDeleted > 0) {
                return "Removed Teacher " + dto.getTeacherId() + " from " + dto.getActivityName();
            } else {
                return "Teacher was not assigned to this activity";
            }
        } catch (SQLException e) {
            handleRollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    // task 4
    public DisplayNewActivityDTO addTeachingActivity(CreateActivityDTO dto) throws Exception {
        TeachingLoadsDAO dao = new TeachingLoadsDAO(connection);
        connection.setAutoCommit(false);

        try {
            dao.lockTeacherForUpdate(dto.getTeacherId());

            Integer activityId = dao.getTeachingActivityId(dto.getActivityName());
            if (activityId == null) {
                activityId = dao.createTeachingActivity(dto.getActivityName(), dto.getFactor());
                if (activityId == -1)
                    throw new SQLException("Failed to create activity");
            }

            int plannedId = dao.createPlannedActivity(dto.getInstanceId(), activityId, dto.getPlannedHours());
            if (plannedId == -1)
                throw new SQLException("Failed to create planned activity");

            String[] timeInfo = dao.getCoursePeriod(dto.getInstanceId());
            int currentLoad = dao.countActiveCoursesForTeacher(dto.getTeacherId(), timeInfo[0], timeInfo[1]);
            boolean alreadyInCourse = dao.isTeacherAlreadyInCourse(dto.getTeacherId(), dto.getInstanceId());
            int maxLimit = dao.getMaxCourseLimit();

            businessLogic.validateTeacherLoad(currentLoad, maxLimit, alreadyInCourse);

            
            dao.allocateActivity(dto.getTeacherId(), plannedId, dto.getPlannedHours() );

            DisplayNewActivityDTO report = dao.getNewActivityReport(plannedId);

            connection.commit();
            return report;

        } catch (Exception e) {
            handleRollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    private void handleRollback() {
        try {
            if (connection != null)
                connection.rollback();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
}
