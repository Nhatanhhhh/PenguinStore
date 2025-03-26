/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBContext;
import Models.Product;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class ProductDAO extends DBContext {

    //Method get all product for admin
    public ArrayList<Product> readAll() {
        ArrayList<Product> products = new ArrayList<>();
        String sql = "SELECT p.productID, p.productName, p.description, p.price, \n"
                + "       p.isSale,\n"
                + "       tp.typeName, c.categoryName, \n"
                + "       STRING_AGG(i.imgName, ', ') AS imgName\n"
                + "FROM Product p\n"
                + "JOIN TypeProduct tp ON p.typeID = tp.typeID\n"
                + "JOIN Category c ON tp.categoryID = c.categoryID\n"
                + "LEFT JOIN Image i ON p.productID = i.productID\n"
                + "GROUP BY p.productID, p.productName, p.description, p.price, \n"
                + "         p.isSale, -- Thêm vào GROUP BY\n"
                + "         tp.typeName, c.categoryName, p.dateCreate\n"
                + "ORDER BY p.dateCreate DESC;";
        try ( ResultSet rs = execSelectQuery(sql)) {
            while (rs.next()) {
                String productID = rs.getString("productID");
                String productName = rs.getString("productName");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                String typeName = rs.getString("typeName");
                String categoryName = rs.getString("categoryName");
                String imgName = rs.getString("imgName");
                boolean isSale = rs.getBoolean("isSale");
                Product product = new Product(productID, productName, description, price, typeName, categoryName, imgName, isSale);
                products.add(product);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Error get product", ex);
        }
        return products;
    }

    public ArrayList<Product> getProductCustomer() {
        ArrayList<Product> products = new ArrayList<>();
        String sql = "SELECT p.productID, p.productName, p.description, p.price, tp.typeName, c.categoryName, \n"
                + "       STRING_AGG(i.imgName, ', ') AS imgName\n"
                + "FROM Product p\n"
                + "JOIN TypeProduct tp ON p.typeID = tp.typeID\n"
                + "JOIN Category c ON tp.categoryID = c.categoryID\n"
                + "LEFT JOIN Image i ON p.productID = i.productID\n"
                + "WHERE p.isSale = 1\n"
                + "GROUP BY p.productID, p.productName, p.description, p.price, tp.typeName, c.categoryName, p.dateCreate\n"
                + "ORDER BY p.dateCreate DESC;";
        try ( ResultSet rs = execSelectQuery(sql)) {
            while (rs.next()) {
                String productID = rs.getString("productID");
                String productName = rs.getString("productName");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                String typeName = rs.getString("typeName");
                String categoryName = rs.getString("categoryName");
                String imgName = rs.getString("imgName");
                Product product = new Product(productID, productName, description, price, typeName, categoryName, imgName);
                products.add(product);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Error get product", ex);
        }
        return products;
    }

    public Product getOneProduct(String id) {
        Product product = new Product();
        String sql = "SELECT p.productID, p.productName, p.description, p.price, p.isSale, \n"
                + "       tp.typeName, c.categoryName, \n"
                + "       STRING_AGG(i.imgName, ', ') AS imgName\n"
                + "FROM Product p\n"
                + "JOIN TypeProduct tp ON p.typeID = tp.typeID\n"
                + "JOIN Category c ON tp.categoryID = c.categoryID\n"
                + "LEFT JOIN Image i ON p.productID = i.productID\n"
                + "WHERE p.productID = ?\n"
                + "GROUP BY p.productID, p.productName, p.description, p.price, p.isSale, tp.typeName, c.categoryName;";
        Object param[] = {id};
        try ( ResultSet rs = execSelectQuery(sql, param)) {
            while (rs.next()) {
                String productID = rs.getString("productID");
                String productName = rs.getString("productName");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                String typeName = rs.getString("typeName");
                String categoryName = rs.getString("categoryName");
                String imgName = rs.getString("imgName");
                boolean isSale = rs.getBoolean("isSale");
                product = new Product(productID, productName, description, price, typeName, categoryName, imgName, isSale);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Error get product", ex);
        }
        return product;
    }

    public ArrayList<Product> searchProduct(String keysearch) {
        ArrayList<Product> products = new ArrayList<>();
        String sql = """
                     SELECT p.productID, p.productName, p.description, p.price, 
                            tp.typeName, c.categoryName, 
                            STRING_AGG(i.imgName, ', ') AS imgName 
                     FROM Product p 
                     JOIN TypeProduct tp ON p.typeID = tp.typeID 
                     JOIN Category c ON tp.categoryID = c.categoryID 
                     LEFT JOIN Image i ON p.productID = i.productID 
                     WHERE p.isSale = 1 
                     AND (
                         ? IS NULL OR 
                         LOWER(p.productName) LIKE LOWER(CONCAT('%', ?, '%')) OR 
                         LOWER(tp.typeName) LIKE LOWER(CONCAT('%', ?, '%')) OR 
                         LOWER(c.categoryName) LIKE LOWER(CONCAT('%', ?, '%'))
                     ) 
                     GROUP BY p.productID, p.productName, p.description, p.price, tp.typeName, c.categoryName;""";
        Object param[] = {keysearch, keysearch, keysearch, keysearch};
        try ( ResultSet rs = execSelectQuery(sql, param)) {
            while (rs.next()) {
                String productID = rs.getString("productID");
                String productName = rs.getString("productName");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                String typeName = rs.getString("typeName");
                String categoryName = rs.getString("categoryName");
                String imgName = rs.getString("imgName");
                Product product = new Product(productID, productName, description, price, typeName, categoryName, imgName);
                products.add(product);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Error get product", ex);
        }
        return products;
    }

    public int insertProduct(Product product) throws SQLException {
        String sql = "EXEC InsertProduct \n"
                + "    @productName = ?,\n"
                + "    @description = ?,\n"
                + "    @price = ?,\n"
                + "    @typeID = ?;";
        Object params[] = {product.getProductName(),
            product.getDescription(), product.getPrice(), product.getTypeID()};
        try {
            return execQuery(sql, params);
        } catch (SQLIntegrityConstraintViolationException e) {
            System.out.println("Product exist!");
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }

    }

    public boolean updateProduct(Product proUpdate) {
        String sql = "UPDATE Product SET productName = ?, description = ?, price = ? WHERE productID = ?";
        Object params[] = {proUpdate.getProductName(), proUpdate.getDescription(), proUpdate.getPrice(), proUpdate.getProductID()};
        try {
            execQuery(sql, params);
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public ArrayList<Product> getFilteredProducts(String[] types, String[] prices, String sortCondition) {
        ArrayList<Product> productList = new ArrayList<>();
        List<Object> paramList = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT p.productID, p.productName, p.description, p.price, "
                + "tp.typeName, c.categoryName, "
                + "STRING_AGG(i.imgName, ', ') AS imgName "
                + "FROM Product p "
                + "JOIN TypeProduct tp ON p.typeID = tp.typeID "
                + "JOIN Category c ON tp.categoryID = c.categoryID "
                + "LEFT JOIN Image i ON p.productID = i.productID "
                + "WHERE 1=1 AND p.isSale = 1");
        if (types != null && types.length > 0) {
            query.append(" AND typeName IN (");
            query.append(String.join(", ", Collections.nCopies(types.length, "?")));
            query.append(")");
            Collections.addAll(paramList, (Object[]) types);
        }

        if (prices != null && prices.length > 0) {
            query.append(" AND (");
            List<String> priceConditions = new ArrayList<>();
            for (String price : prices) {
                if (price.contains(">")) {
                    priceConditions.add("price > ?");
                    paramList.add(1000000);
                } else {
                    priceConditions.add("price BETWEEN ? AND ?");
                    String[] range = price.split("-");
                    paramList.add(Integer.parseInt(range[0]));
                    paramList.add(Integer.parseInt(range[1]));
                }
            }
            query.append(String.join(" OR ", priceConditions));
            query.append(")");
        }
        query.append(" GROUP BY p.productID, p.productName, p.description, p.price, tp.typeName, c.categoryName, p.dateCreate");
        if (sortCondition != null) {
            query.append(sortCondition);
        } else {
            query.append(" ORDER BY p.dateCreate DESC");
        }
        Object[] params = paramList.toArray();
        try ( ResultSet rs = execSelectQuery(query.toString(), params)) {
            while (rs.next()) {
                String productID = rs.getString("productID");
                String productName = rs.getString("productName");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                String typeName = rs.getString("typeName");
                String categoryName = rs.getString("categoryName");
                String imgName = rs.getString("imgName");
                Product product = new Product(productID, productName, description, price, typeName, categoryName, imgName);
                productList.add(product);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, "Error get product", ex);
        }
        return productList;
    }

    public boolean updateSaleStatus(String productID, boolean isSale) {
        String sql = "UPDATE Product SET isSale = ? WHERE productID = ?";
        Object params[] = {isSale, productID};
        try {
            execQuery(sql, params);
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean checkProduct(String productName) throws SQLException {
        String query = "SELECT COUNT(*) FROM Product WHERE productName = ?";
        Object params[] = {productName};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            while (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public boolean checkNameUpdate(String productName, String productID) throws SQLException {
        String query = "SELECT COUNT(*) FROM Product WHERE productName = ? AND productID != ?";
        Object params[] = {productName, productID};
        try ( ResultSet rs = execSelectQuery(query, params)) {
            if (rs.next()) {
                return rs.getInt(1) > 0; // Nếu COUNT > 0 nghĩa là đã có sản phẩm khác trùng tên
            }
        }
        return false;
    }

}