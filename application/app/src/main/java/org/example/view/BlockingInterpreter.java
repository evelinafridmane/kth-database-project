//reused and changed code from:
/*
 * The MIT License
 *
 * Copyright 2017 Leif Lindbäck <leifl@kth.se>.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


package org.example.view;

import java.util.Scanner;
import org.example.controller.Controller;
import org.example.model.CourseCostDTO;
import org.example.model.CreateActivityDTO;
import org.example.model.DisplayNewActivityDTO;
import org.example.model.TeacherAllocationDTO;

public class BlockingInterpreter {
    private static final String PROMPT = "> ";
    private final Scanner console = new Scanner(System.in);
    private Controller ctrl;
    private boolean keepReceivingCmds = false;

    public BlockingInterpreter(Controller ctrl) {
        this.ctrl = ctrl;
    }

    public void stop() {
        keepReceivingCmds = false;
    }

    public void handleCmds() {
        keepReceivingCmds = true;
        System.out.println("University System Started.");
        System.out.println("Type 'HELP' for instructions.");

        while (keepReceivingCmds) {
            try {
                CmdLine cmdLine = new CmdLine(readNextLine());
                switch (cmdLine.getCmd()) {
                    case HELP:
                        System.out.println("Available commands:");
                        System.out.println("  CALCULATE_COST <instance_id>");
                        System.out.println("  INCREASE_STUDENTS <instance_id>");
                        System.out.println("  ALLOCATE_TEACHER <teacher_id> <instance_id> <activity>");
                        System.out.println("  DEALLOCATE_TEACHER <teacher_id> <instance_id> <activity>");
                        System.out.println("  ADD_EXERCISE_ACTIVITY <teacher_id> <instance_id> <hours>");
                        System.out.println("  QUIT");
                        break;

                    case QUIT:
                        keepReceivingCmds = false;
                        break;

                    // task 1
                    case CALCULATE_COST:
                        String costId = cmdLine.getParameter(0);
                        if (costId == null) {
                            System.out.println("Missing instance ID.");
                        } else {
                            CourseCostDTO result = ctrl.computeTeachingCost(costId);
                            if (result != null)
                                printCostTable(result);
                            else
                                System.out.println("No data found.");
                        }
                        break;

                    // increase student number
                    case INCREASE_STUDENTS:
                        String modId = cmdLine.getParameter(0);
                        if (modId == null) {
                            System.out.println("Missing instance ID.");
                        } else {
                            CourseCostDTO updated = ctrl.modifyStudentCount(modId);
                            System.out.println("Students increased by 100. New Costs: ");
                            if (updated != null)
                                printCostTable(updated);
                        }
                        break;

                    // allocate teacher
                    case ALLOCATE_TEACHER:
                        String tId = cmdLine.getParameter(0);
                        String cId = cmdLine.getParameter(1);
                        String act = cmdLine.getParameter(2);

                        if (tId == null || cId == null || act == null) {
                            System.out.println("Type: <teacherid> <instanceid> <activityid>");
                        } else {
                            TeacherAllocationDTO dto = new TeacherAllocationDTO(tId, cId, act);
                            String resp = ctrl.allocateTeachingActivity(dto);
                            System.out.println(resp);
                        }
                        break;

                // deallocate 
                    case DEALLOCATE_TEACHER:
                        String dtId = cmdLine.getParameter(0);
                        String dcId = cmdLine.getParameter(1);
                        String dAct = cmdLine.getParameter(2);

                        if (dtId == null || dcId == null || dAct == null) {
                            System.out.println("Type: <teacherid> <instanceid> <activityid>");
                        } else {
                            TeacherAllocationDTO dto = new TeacherAllocationDTO(dtId, dcId, dAct);
                            String resp = ctrl.deallocateTeachingActivity(dto);
                            System.out.println(resp);
                        }
                        break;

              // add exercise activity
                    case ADD_EXERCISE_ACTIVITY:
                        String eTid = cmdLine.getParameter(0);
                        String eCid = cmdLine.getParameter(1);
                        String eHours = cmdLine.getParameter(2);

                        if (eTid == null || eCid == null || eHours == null) {
                            System.out.println("Type: <teacherid> <instanceid> <hours>");
                        } else {
                            CreateActivityDTO dto = new CreateActivityDTO(
                                    "Exercise", 1.5, eCid, Integer.parseInt(eHours), eTid);
                            DisplayNewActivityDTO report = ctrl.addTeachingActivity(dto);
                            printActivityReport(report);
                        }
                        break;

                    default:
                        System.out.println("Unknown command."); 
                } 
            } catch (Exception e) {
                System.out.println("Ooops: " + e.getMessage());
            }
        } 
    }

    private String readNextLine() {
        System.out.print(PROMPT);
        return console.nextLine();
    }

    private void printCostTable(CourseCostDTO dto) {
        System.out.println("-------------------------------------------------------------------------------------");
        System.out.printf("| %-12s | %-15s | %-6s | %-20s | %-20s |%n",
                "Course Code", " Course Instance", "Period", "Planned cost (KSEK)", "Actual cost (KSEK)");
        System.out.println("-------------------------------------------------------------------------------------");
        System.out.printf("| %-12s | %-15s | %-6s | %-20.2f | %-20.2f |%n",
                dto.getCourseCode(), dto.getInstanceId(), dto.getStudyPeriod(), dto.getPlannedCost(),
                dto.getActualCost());
        System.out.println("-------------------------------------------------------------------------------------");
    }

    private void printActivityReport(DisplayNewActivityDTO dto) {
        System.out.println("New Activity Created & Allocated");
        System.out.println("Activity: " + dto.getActivityName());
        System.out.println("Course:   " + dto.getCourseName() + " (" + dto.getCourseCode() + ")");
        System.out.println("Teacher:  " + dto.getTeacherName());
    }
}