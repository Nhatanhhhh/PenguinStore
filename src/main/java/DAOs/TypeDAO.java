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
import java.util.List;

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

    public boolean isTypeNameExists(String typeName) {
        String sql = "SELECT COUNT(*) AS count FROM TypeProduct WHERE typeName = ?";
        Object[] params = {typeName};

        try ( ResultSet rs = execSelectQuery(sql, params)) {
            if (rs.next() && rs.getInt("count") > 0) {
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(TypeDAO.class.getName()).log(Level.SEVERE, "Error checking type existence", ex);
        }
        return false;
    }

    public List<Type> getPaginatedList(int offset, int limit) {
        List<Type> typeList = new ArrayList<>();
        String sql = "SELECT t.typeID, t.typeName, c.categoryID, c.categoryName \n"
                + "FROM TypeProduct t \n"
                + "JOIN Category c ON t.categoryID = c.categoryID \n"
                + "ORDER BY t.typeID \n"
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;";  // SQL Server syntax

        try ( PreparedStatement ps = getConn().prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Type type = new Type(
                            rs.getString("typeID"),
                            rs.getString("typeName"),
                            rs.getString("categoryID"),
                            rs.getString("categoryName")
                    );
                    typeList.add(type);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(TypeDAO.class.getName()).log(Level.SEVERE, "Error getting paginated types", ex);
        }
        return typeList;
    }

    public int getTotalTypes() {
        String sql = "SELECT COUNT(*) AS total FROM TypeProduct";

        try ( ResultSet rs = execSelectQuery(sql, new Object[]{})) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException ex) {
            Logger.getLogger(TypeDAO.class.getName()).log(Level.SEVERE, "Error getting total types count", ex);
        }
        return 0;
    }

    public List<Type> searchTypes(String keyword) {
        List<Type> types = new ArrayList<>();
        String sql = "SELECT * FROM Type WHERE typeName LIKE ? OR categoryName LIKE ?";

        try ( Connection conn = DBContext.getConn();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Type type = new Type(rs.getString("typeID"), rs.getString("typeName"), rs.getString("categoryName"));
                types.add(type);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return types;
    }

}
