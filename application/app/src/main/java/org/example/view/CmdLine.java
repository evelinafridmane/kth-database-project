//reused code from:
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

public class CmdLine {
    private static final String PARAM_DELIMETER = " ";
    private String[] params;
    private Command cmd;
    private final String enteredLine;

    public CmdLine(String enteredLine) {
        this.enteredLine = enteredLine;
        parseCmd(enteredLine);
        extractParams(enteredLine);
    }

    public Command getCmd() {
        return cmd;
    }

    public String getUserInput() {
        return enteredLine;
    }

    public String getParameter(int index) {
        if (params == null) {
            return null;
        }
        if (index >= params.length) {
            return null;
        }
        return params[index];
    }

    private String removeExtraSpaces(String source) {
        if (source == null) {
            return source;
        }
        String oneOrMoreOccurences = "+";
        return source.trim().replaceAll(PARAM_DELIMETER + oneOrMoreOccurences, PARAM_DELIMETER);
    }

    private void parseCmd(String enteredLine) {
        int cmdNameIndex = 0;
        try {
            String trimmed = removeExtraSpaces(enteredLine);
            if (trimmed == null) {
                cmd = Command.ILLEGAL_COMMAND;
                return;
            }
            String[] enteredTokens = trimmed.split(PARAM_DELIMETER);
            cmd = Command.valueOf(enteredTokens[cmdNameIndex].toUpperCase());
        } catch (Exception failedToReadCmd) {
            cmd = Command.ILLEGAL_COMMAND;
        }
    }

    private void extractParams(String enteredLine) {
        if (enteredLine == null) {
            params = null;
            return;
        }
        String paramPartOfCmd = removeExtraSpaces(removeCmd(enteredLine));
        if (paramPartOfCmd == null || paramPartOfCmd.isEmpty()) {
            params = null;
            return;
        }
        params = paramPartOfCmd.split(PARAM_DELIMETER);
    }

    private String removeCmd(String enteredLine) {
        if (cmd == Command.ILLEGAL_COMMAND) {
            return enteredLine;
        }
        int indexAfterCmd = enteredLine.toUpperCase().indexOf(cmd.name()) + cmd.name().length();
        String withoutCmd = enteredLine.substring(indexAfterCmd, enteredLine.length());
        return withoutCmd.trim();
    }
}