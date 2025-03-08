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

/**
 *
 * @author Huynh Cong Nghiem - CE181351
 */
public class ProductDAO extends DBContext {

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

    public boolean updateProduct(String productID, String productName, String description, int price) {
        String sql = "UPDATE Product SET productName = ?, description = ?, price = ? WHERE productID = ?";
        Object params[] = {productName, description, price, productID};
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
                + "WHERE 1=1");
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
        System.out.println(query);
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
        } catch (Exception e) {
        }
        return productList;
    }
}
