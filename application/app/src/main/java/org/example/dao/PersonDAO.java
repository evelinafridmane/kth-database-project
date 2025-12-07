package org.example.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.example.model.PersonDTO;

public class PersonDAO {
    private Connection connection;

    public PersonDAO(Connection connection) {
        this.connection = connection;
    }

    public List<PersonDTO> getAllPersons() throws SQLException {
        List<PersonDTO> persons = new ArrayList<>();
        String sql = "SELECT * FROM person";
        
        try (Statement statement = connection.createStatement();
             ResultSet result = statement.executeQuery(sql)) {
            
            while (result.next()) {
                PersonDTO person = new PersonDTO(
                    result.getString("person_id"),
                    result.getString("personal_number"),
                    result.getString("first_name"),
                    result.getString("last_name")
                );
                persons.add(person);
            }
        }
        
        return persons;
    }

    public PersonDTO getPersonById(String personId) throws SQLException {
        String sql = "SELECT * FROM person WHERE person_id = ?";
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, Integer.parseInt(personId));
            
            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    return new PersonDTO(
                        result.getString("person_id"),
                        result.getString("personal_number"),
                        result.getString("first_name"),
                        result.getString("last_name")
                    );
                }
            }
        }
        
        return null;
    }
}