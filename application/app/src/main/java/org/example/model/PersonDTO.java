package org.example.model;

public class PersonDTO {
    private String personId;
    private String personalNumber;
    private String firstName;
    private String lastName;

    public PersonDTO() {
    }

    public PersonDTO(String personId, String personalNumber, String firstName, String lastName) {
        this.personId = personId;
        this.personalNumber = personalNumber;
        this.firstName = firstName;
        this.lastName = lastName;
    }

    public String getPersonId() {
        return personId;
    }

    public String getPersonalNumber() {
        return personalNumber;
    }

    public String getFirstName() {
        return firstName;
    }
    public String getLastName() {
        return lastName;
    }
}