package org.example.service;

import java.sql.SQLException;
import java.util.List;

import org.example.dao.PersonDAO;
import org.example.model.PersonDTO;

public class PersonService {
    private PersonDAO personDAO;

    public PersonService(PersonDAO personDAO) {
        this.personDAO = personDAO;
    }

    public List<PersonDTO> getAllPersons() throws SQLException {
        return personDAO.getAllPersons();
    }

    public String getFullName(PersonDTO person) {
        return person.getFirstName() + " " + person.getLastName();
    }

    public int getTotalPersonCount() throws SQLException {
        return personDAO.getAllPersons().size();
    }
}