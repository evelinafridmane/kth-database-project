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

package main.view;

/**
 * Defines all commands that can be performed by a user of the chat application.
 */

public enum Command {
    CALCULATE_COST,      // Task 1: Calculate teaching cost
    INCREASE_STUDENTS,   // Task 2: Increase registered students
    ALLOCATE_TEACHER,    // Task 3: Allocate teacher
    DEALLOCATE_TEACHER,  // Task 3: Deallocate teacher
    ADD_EXERCISE_ACTIVITY, // Task 4: Add exercise activity
    SHOW_ALLOCATIONS,    // Additional: Show current allocations
    HELP,
    QUIT,
    ILLEGAL_COMMAND
}