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

/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class ProductDAO extends DBContext {

    private Connection conn;

    public ArrayList<Product> readAll() {
        ArrayList<Product> products = new ArrayList<>();
        String sql = "SELECT p.productID, p.productName, p.description, p.price, tp.typeName, c.categoryName, \n"
                + "    STRING_AGG(i.imgName, ', ') AS imgName\n"
                + "FROM Product p\n"
                + "JOIN TypeProduct tp ON p.typeID = tp.typeID\n"
                + "JOIN Category c ON tp.categoryID = c.categoryID\n"
                + "LEFT JOIN Image i ON p.productID = i.productID\n"
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
        } catch (Exception e) {
        }
        return products;
    }

    public Product getOneProduct(String id) {
        Product product = new Product();
        String sql = "SELECT p.productID, p.productName, p.description, p.price, tp.typeName, c.categoryName, \n"
                + "    STRING_AGG(i.imgName, ', ') AS imgName\n"
                + "FROM Product p\n"
                + "JOIN TypeProduct tp ON p.typeID = tp.typeID\n"
                + "JOIN Category c ON tp.categoryID = c.categoryID\n"
                + "LEFT JOIN Image i ON p.productID = i.productID\n"
                + "WHERE p.productID = ?\n"
                + "GROUP BY p.productID, p.productName, p.description, p.price, tp.typeName, c.categoryName";
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
                product = new Product(productID, productName, description, price, typeName, categoryName, imgName);
            }
        } catch (Exception e) {
        }
        return product;
    }

    public ArrayList<Product> searchProduct(String keysearch) {
        ArrayList<Product> products = new ArrayList<>();
        String sql = "SELECT p.productID, p.productName, p.description, p.price, "
                + "tp.typeName, c.categoryName, "
                + "STRING_AGG(i.imgName, ', ') AS imgName "
                + "FROM Product p "
                + "JOIN TypeProduct tp ON p.typeID = tp.typeID "
                + "JOIN Category c ON tp.categoryID = c.categoryID "
                + "LEFT JOIN Image i ON p.productID = i.productID "
                + "WHERE (? IS NULL OR p.productName LIKE ? "
                + "OR tp.typeName LIKE ? OR c.categoryName LIKE ?) "
                + "GROUP BY p.productID, p.productName, p.description, p.price, tp.typeName, c.categoryName";
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
        } catch (Exception e) {
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

}