package DAOs;

import Models.Type;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import DB.DBContext;

public class TypeDAO extends DBContext {

    // 1. Read all types
    public ArrayList<Type> getAll() {
        ArrayList<Type> types = new ArrayList<>();
        String query = "SELECT t.typeID, t.typeName, c.categoryID, c.categoryName "
                + "FROM Category c JOIN TypeProduct t ON c.categoryID = t.categoryID";

        try ( ResultSet rs = execSelectQuery(query)) {
            while (rs.next()) {
                types.add(new Type(
                        rs.getString("typeID"),
                        rs.getString("typeName"),
                        rs.getString("categoryID"),
                        rs.getString("categoryName")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(TypeDAO.class.getName()).log(Level.SEVERE, "Error when get TypeProduct data", ex);
        }
        return types;
    }

    // 2. Read a type by ID
    public Type getOnlyById(String typeID) {
        Type type = null;
        String sql = "SELECT * FROM TypeProduct WHERE typeID = ?";
        Object param[] = {typeID};

        try ( ResultSet rs = execSelectQuery(sql, param)) {
            if (rs.next()) {
                type = new Type(
                        rs.getString("typeID"),
                        rs.getString("categoryID"),
                        rs.getString("typeName"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(TypeDAO.class.getName()).log(Level.SEVERE, "GetOnlyByID failer", ex);
        }
        return type;
    }

    // 3. Create a new type
    public int create(Type type) {
        String sql = "INSERT INTO TypeProduct (typeName, categoryID) VALUES (?, ?)";

        Object[] params = {
            type.getTypeName(),
            type.getCategoryID()
        };

        try {
            return execQuery(sql, params); 
        } catch (SQLException ex) {
            Logger.getLogger(TypeDAO.class.getName()).log(Level.SEVERE, "Error inserting new type", ex);
            return 0;
        }
    }

    // 4. Update a type
    public int update(Type type) {
        String sql = "UPDATE TypeProduct SET typeName = ?, categoryID = ? WHERE typeID = ?";
        Object[] params = {
            type.getTypeName(),
            type.getCategoryID(),
            type.getTypeID()

        };
        try {
            return execQuery(sql, params);
        } catch (SQLException ex) {
            Logger.getLogger(TypeDAO.class.getName()).log(Level.SEVERE, null, ex);
            return 0;
        }
    }
}
