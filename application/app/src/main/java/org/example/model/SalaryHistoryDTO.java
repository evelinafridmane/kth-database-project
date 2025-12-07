package org.example.model;

public class SalaryHistoryDTO {
    private String salaryHistoryId;
    private String monthlySalaryAmount;
    private String fromDate;
    private String toDate;
    private String employmentId;

    public SalaryHistoryDTO() {
    }

    public SalaryHistoryDTO(String salaryHistoryId, String monthlySalaryAmount, 
                           String fromDate, String toDate, String employmentId) {
        this.salaryHistoryId = salaryHistoryId;
        this.monthlySalaryAmount = monthlySalaryAmount;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.employmentId = employmentId;
    }

    public String getSalaryHistoryId() {
        return salaryHistoryId;
    }

    public String getMonthlySalaryAmount() {
        return monthlySalaryAmount;
    }

    public String getFromDate() {
        return fromDate;
    }

    public String getToDate() {
        return toDate;
    }

    public String getEmploymentId() {
        return employmentId;
    }
}