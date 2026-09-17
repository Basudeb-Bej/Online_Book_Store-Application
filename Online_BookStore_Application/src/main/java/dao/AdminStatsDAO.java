package dao;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminStatsDAO {

    private final Connection con = DBConnection.getConnection();
    private static final String[] SALES_TABLES = {
            "sales", "order_items", "orders", "transactions", "invoices", "checkout_items", "purchases"
    };
    private static final String[] SALES_COUNT_COLUMNS = {
            "quantity", "item_quantity", "book_quantity", "qty", "count"
    };
    private static final String[] REVENUE_COLUMNS = {
            "total_amount", "grand_total", "total", "amount", "line_total", "item_total", "subtotal", "price"
    };

    public long getTotalUsers() {
        return countRows("users");
    }

    public long getTotalBooks() {
        return countRows("books");
    }

    public long getTotalSales() {
        return sumSalesAcrossExistingTable();
    }

    public double getTotalRevenue() {
        return sumRevenueAcrossExistingTable();
    }

    private long countRows(String tableName) {
        if (con == null || !tableExists(tableName)) {
            return 0L;
        }

        String sql = "SELECT COUNT(*) AS total FROM `" + tableName + "`";

        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getLong("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0L;
    }

    private long sumSalesAcrossExistingTable() {
        for (String tableName : SALES_TABLES) {
            if (!tableExists(tableName)) {
                continue;
            }

            String quantityColumn = findExistingColumn(tableName, SALES_COUNT_COLUMNS);
            if (quantityColumn != null) {
                return sumLongColumn(tableName, quantityColumn);
            }

            // Fallback: if the table has no quantity column, count the rows.
            return countRows(tableName);
        }

        return 0L;
    }

    private double sumRevenueAcrossExistingTable() {
        for (String tableName : SALES_TABLES) {
            if (!tableExists(tableName)) {
                continue;
            }

            String revenueColumn = findExistingColumn(tableName, REVENUE_COLUMNS);
            if (revenueColumn != null) {
                return sumDoubleColumn(tableName, revenueColumn);
            }

            String quantityColumn = findExistingColumn(tableName, SALES_COUNT_COLUMNS);
            String priceColumn = findExistingColumn(tableName, new String[] {"price", "rate", "unit_price", "sale_price"});

            if (quantityColumn != null && priceColumn != null) {
                return sumQuantityTimesPrice(tableName, quantityColumn, priceColumn);
            }
        }

        return 0.0;
    }

    private long sumLongColumn(String tableName, String columnName) {
        if (con == null || !tableExists(tableName)) {
            return 0L;
        }

        String sql = "SELECT COALESCE(SUM(`" + columnName + "`), 0) AS total FROM `" + tableName + "`";

        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getLong("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0L;
    }

    private double sumDoubleColumn(String tableName, String columnName) {
        if (con == null || !tableExists(tableName)) {
            return 0.0;
        }

        String sql = "SELECT COALESCE(SUM(`" + columnName + "`), 0) AS total FROM `" + tableName + "`";

        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    private double sumQuantityTimesPrice(String tableName, String quantityColumn, String priceColumn) {
        if (con == null || !tableExists(tableName)) {
            return 0.0;
        }

        String sql = "SELECT COALESCE(SUM(CAST(`" + quantityColumn + "` AS DECIMAL(18,2)) * CAST(`" + priceColumn + "` AS DECIMAL(18,2))), 0) AS total FROM `" + tableName + "`";

        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    private boolean tableExists(String tableName) {
        if (con == null) {
            return false;
        }

        try {
            DatabaseMetaData metaData = con.getMetaData();

            try (ResultSet rs = metaData.getTables(con.getCatalog(), null, "%", new String[] {"TABLE"})) {
                while (rs.next()) {
                    String existingName = rs.getString("TABLE_NAME");
                    if (existingName != null && existingName.equalsIgnoreCase(tableName)) {
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private String findExistingColumn(String tableName, String[] columnNames) {
        if (con == null || !tableExists(tableName)) {
            return null;
        }

        try {
            DatabaseMetaData metaData = con.getMetaData();

            try (ResultSet rs = metaData.getColumns(con.getCatalog(), null, tableName, "%")) {
                while (rs.next()) {
                    String existingName = rs.getString("COLUMN_NAME");

                    for (String candidate : columnNames) {
                        if (existingName != null && existingName.equalsIgnoreCase(candidate)) {
                            return existingName;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}