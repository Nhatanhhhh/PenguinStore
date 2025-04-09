package Controller;

import DAOs.OrderStatisticDAO;
import DAOs.RevenueDAO;
import DAOs.StatisticProductDAO;
import DAOs.OrderStatusStatisticDAO;
import DAOs.ProductDAO;
import Models.OrderStatistic;
import Models.OrderStatusStatistic;
import Models.Product;
import Models.RevenueStatistic;
import Models.StatisticProduct;
import Models.TopOrderCustomer;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.BorderStyle;

import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.PageSize;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.itextpdf.text.FontFactory;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtils;
import org.jfree.chart.JFreeChart;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.CategoryPlot;
import java.awt.Color;

/**
 *
 * @author Do Van Luan - CE180457
 */
@WebServlet(name = "StatisticController", urlPatterns = {"/Statistic"})
public class StatisticController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(StatisticController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderStatisticDAO dao = new OrderStatisticDAO();
        RevenueDAO revenueDAO = new RevenueDAO();
        OrderStatusStatisticDAO orderStatusStatisticDAO = new OrderStatusStatisticDAO();
        StatisticProductDAO productDAO = new StatisticProductDAO();
        ProductDAO pronameDAO = new ProductDAO();

        String action = request.getParameter("action");
        String timeUnit = request.getParameter("timeUnit");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        if ("exportExcel".equals(action)) {
            exportExcel(request, response, timeUnit, startDate, endDate);
            return; // Stop further processing after sending the Excel file
        } else if ("exportPDF".equals(action)) {
            exportPDF(request, response, timeUnit, startDate, endDate);
            return; // Stop further processing after sending the PDF file
        }

        if (action == null || action.isEmpty()) {
            action = "orderStatistic"; // Default action
        }

        if (timeUnit == null || (!timeUnit.equals("day") && !timeUnit.equals("week") && !timeUnit.equals("month") && !timeUnit.equals("year") && !timeUnit.equals("custom"))) {
            timeUnit = "day"; // Default to daily statistics
        }

        switch (action) {
            case "orderStatistic":
                List<OrderStatistic> statistics;
                if ("month".equals(timeUnit)) {
                    statistics = dao.getOrderStatisticsByMonth();
                } else if ("year".equals(timeUnit)) {
                    statistics = dao.getOrderStatisticsByYear();
                } else {
                    statistics = dao.getOrderStatisticsByDay();
                }
                request.setAttribute("statistics", statistics);
                request.setAttribute("timeUnit", timeUnit);
                request.getRequestDispatcher("/View/ViewOStatistic.jsp").forward(request, response);
                break;

            case "revenueStatistic":
                List<RevenueStatistic> revenueList;
                switch (timeUnit) {
                    case "day":
                        revenueList = revenueDAO.getRevenueByDay();
                        break;
                    case "month":
                        revenueList = revenueDAO.getRevenueByMonth();
                        break;
                    case "year":
                        revenueList = revenueDAO.getRevenueByYear();
                        break;
                    case "week":
                        revenueList = revenueDAO.getRevenueLastWeek();
                        break;
                    case "custom":
                        // Validate dates
                        if (startDate == null || startDate.isEmpty()) {
                            startDate = "2025-01-01"; // Ngày mặc định
                        }
                        if (endDate == null || endDate.isEmpty()) {
                            endDate = LocalDate.now().toString(); // Lấy ngày hiện tại
                        }
                        try {
                            LocalDate start = LocalDate.parse(startDate);
                            LocalDate end = LocalDate.parse(endDate);
                            if (start.isAfter(end)) {
                                request.setAttribute("error", "Start date cannot be after end date.");
                                revenueList = new ArrayList<>();
                            } else {
                                revenueList = revenueDAO.getRevenueByCustomRange(startDate, endDate);
                            }
                        } catch (Exception e) {
                            request.setAttribute("error", "Invalid date format. Please use YYYY-MM-DD.");
                            revenueList = new ArrayList<>();
                        }
                        break;
                    default:
                        revenueList = revenueDAO.getRevenueLastWeek();
                        break;
                }

                request.setAttribute("startDate", startDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("revenuelist", revenueList);
                request.setAttribute("timeUnit", timeUnit);
                request.getRequestDispatcher("/View/RevenueStatistic.jsp").forward(request, response);
                break;

            case "orderStatusStatistic":

                List<OrderStatusStatistic> orderstatusList = switch (timeUnit) {
                    case "month" ->
                        orderStatusStatisticDAO.getLastMonth();
                    case "year" ->
                        orderStatusStatisticDAO.getLastYearToNow();
                    default ->
                        orderStatusStatisticDAO.getByDay();
                };

                orderstatusList.forEach(System.out::println); // Debug log

                List<TopOrderCustomer> topCustomers = orderStatusStatisticDAO.getTopCustomersByOrderType();

                request.setAttribute("topCustomersCompleted", extractEmails(topCustomers, "Delivery successful"));
                request.setAttribute("topCustomersFailed", extractEmails(topCustomers, "Delivery failed"));
                request.setAttribute("topCustomersCanceled", extractEmails(topCustomers, "Cancel order"));

                request.setAttribute("statistics", orderstatusList);
                request.setAttribute("timeUnit", timeUnit);
                request.setAttribute("topCustomers", topCustomers);

                request.getRequestDispatcher("/View/ViewOrderStatusStatistic.jsp").forward(request, response);
                break;

//            case "DashBoardForAdmin":
//                
//                switch (timeUnit) {
//                    case "month":
//                        revenuelist = revenueDAO.getRevenueByMonth();
//                        break;
//                    case "year":
//                        revenuelist = revenueDAO.getRevenueByYear();
//                        break;
//                    default:
//                        revenuelist = revenueDAO.getRevenueByDay();
//                        break;
//                }
//                double totalRevenue = revenuelist.stream().mapToDouble(RevenueStatistic::getRevenue).sum();
//                request.setAttribute("revenuelist", revenuelist);
//                request.setAttribute("timeUnit", timeUnit);
//                request.setAttribute("totalRevenue", totalRevenue);
//                request.getRequestDispatcher("/View/DashBoardForAdmin.jsp").forward(request, response);
//                break;    
            case "productStatistic":
                List<StatisticProduct> productStatistics = productDAO.getAll();
                List<StatisticProduct> bestSellingProducts = productDAO.getBestSellingProducts();
                ArrayList<Product> productList = pronameDAO.readAll();
                request.setAttribute("productList", productList);
                request.setAttribute("productStatistics", productStatistics);
                request.setAttribute("bestSellingProducts", bestSellingProducts);

                request.getRequestDispatcher("/View/ProductStatistic.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/Statistic?action=orderStatistic&timeUnit=day");
                break;
        }
    }

    private List<String> extractEmails(List<TopOrderCustomer> customers, String status) {
        return customers.stream()
                .filter(c -> c.getStatusName().equals(status))
                .map(TopOrderCustomer::getEmail)
                .toList();
    }

    private void exportExcel(HttpServletRequest request, HttpServletResponse response, String timeUnit, String startDate, String endDate) throws IOException {
        try {
            // 1. Reset response trước khi ghi
            response.reset();

            RevenueDAO revenueDAO = new RevenueDAO();
            List<RevenueStatistic> revenueList;

            // Fetch data based on timeUnit
            switch (timeUnit) {
                case "day":
                    revenueList = revenueDAO.getRevenueByDay();
                    break;
                case "month":
                    revenueList = revenueDAO.getRevenueByMonth();
                    break;
                case "year":
                    revenueList = revenueDAO.getRevenueByYear();
                    break;
                case "week":
                    revenueList = revenueDAO.getRevenueLastWeek();
                    break;
                case "custom":
                    // Validate dates
                    if (startDate == null || startDate.isEmpty()) {
                        startDate = "2025-01-01"; // Ngày mặc định
                    }
                    if (endDate == null || endDate.isEmpty()) {
                        endDate = LocalDate.now().toString(); // Lấy ngày hiện tại
                    }
                    try {
                        LocalDate start = LocalDate.parse(startDate);
                        LocalDate end = LocalDate.parse(endDate);
                        if (start.isAfter(end)) {
                            throw new IllegalArgumentException("Start date cannot be after end date.");
                        }
                        revenueList = revenueDAO.getRevenueByCustomRange(startDate, endDate);
                    } catch (Exception e) {
                        throw new IllegalArgumentException("Invalid date format or range: " + e.getMessage());
                    }
                    break;
                default:
                    throw new IllegalArgumentException("Invalid time unit: " + timeUnit);
            }

            double totalRevenue = revenueList.stream().mapToDouble(RevenueStatistic::getRevenue).sum();

            try ( Workbook workbook = new XSSFWorkbook()) {
                Sheet sheet = workbook.createSheet("Revenue");

                // 2. Tạo style
                CellStyle headerStyle = workbook.createCellStyle();
                org.apache.poi.ss.usermodel.Font headerFont = workbook.createFont();
                headerFont.setBold(true);
                headerStyle.setFont(headerFont);
                headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
                headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
                headerStyle.setBorderBottom(BorderStyle.THIN);
                headerStyle.setBorderTop(BorderStyle.THIN);
                headerStyle.setBorderLeft(BorderStyle.THIN);
                headerStyle.setBorderRight(BorderStyle.THIN);

                CellStyle dataStyle = workbook.createCellStyle();
                dataStyle.setBorderBottom(BorderStyle.THIN);
                dataStyle.setBorderTop(BorderStyle.THIN);
                dataStyle.setBorderLeft(BorderStyle.THIN);
                dataStyle.setBorderRight(BorderStyle.THIN);

                CellStyle totalStyle = workbook.createCellStyle();
                org.apache.poi.ss.usermodel.Font totalFont = workbook.createFont();
                totalFont.setBold(true);
                totalStyle.setFont(totalFont);
                totalStyle.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
                totalStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                CellStyle currencyStyle = workbook.createCellStyle();
                DataFormat format = workbook.createDataFormat();
                currencyStyle.setDataFormat(format.getFormat("#,##0.00\" ₫\""));
                currencyStyle.setBorderBottom(BorderStyle.THIN);
                currencyStyle.setBorderTop(BorderStyle.THIN);
                currencyStyle.setBorderLeft(BorderStyle.THIN);
                currencyStyle.setBorderRight(BorderStyle.THIN);

                // 3. Tạo header và dữ liệu
                Row headerRow = sheet.createRow(0);
                headerRow.createCell(0).setCellValue("Time Period");
                headerRow.createCell(1).setCellValue("Revenue (VND)");
                headerRow.forEach(cell -> cell.setCellStyle(headerStyle));

                int rowNum = 1;
                for (RevenueStatistic stat : revenueList) {
                    Row row = sheet.createRow(rowNum++);
                    row.createCell(0).setCellValue(stat.getTimePeriod());

                    // 4. Xử lý giá trị null (nếu có)
                    if (stat.getRevenue() != 0) {
                        row.createCell(1).setCellValue(stat.getRevenue());
                    } else {
                        row.createCell(1).setCellValue(0);
                    }

                    row.getCell(0).setCellStyle(dataStyle);
                    row.getCell(1).setCellStyle(currencyStyle);
                }

                // 5. Dòng tổng
                Row totalRow = sheet.createRow(rowNum);
                totalRow.createCell(0).setCellValue("Total Revenue");
                totalRow.createCell(1).setCellValue(totalRevenue);
                totalRow.getCell(0).setCellStyle(totalStyle);
                totalRow.getCell(1).setCellStyle(currencyStyle);

                // 6. Auto-size columns
                for (int i = 0; i < 2; i++) {
                    sheet.autoSizeColumn(i);
                }

                // 7. Thiết lập response
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition",
                        "attachment; filename=Revenue_Statistic_" + timeUnit + "_" + LocalDate.now() + ".xlsx");
                response.setCharacterEncoding("UTF-8");

                // 8. Ghi file và flush buffer
                try ( OutputStream out = response.getOutputStream()) {
                    workbook.write(out);
                    out.flush();
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error exporting Excel", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error generating Excel report: " + e.getMessage());
        }
    }

    private void exportPDF(HttpServletRequest request, HttpServletResponse response, String timeUnit, String startDate, String endDate) throws IOException {
        try {
            RevenueDAO revenueDAO = new RevenueDAO();
            List<RevenueStatistic> revenueList;

            // Fetch data based on timeUnit
            switch (timeUnit) {
                case "day":
                    revenueList = revenueDAO.getRevenueByDay();
                    break;
                case "month":
                    revenueList = revenueDAO.getRevenueByMonth();
                    break;
                case "year":
                    revenueList = revenueDAO.getRevenueByYear();
                    break;
                case "week":
                    revenueList = revenueDAO.getRevenueLastWeek();
                    break;
                case "custom":
                    // Validate dates
                    if (startDate == null || startDate.isEmpty()) {
                        startDate = "2025-01-01"; // Ngày mặc định
                    }
                    if (endDate == null || endDate.isEmpty()) {
                        endDate = LocalDate.now().toString(); // Lấy ngày hiện tại
                    }
                    try {
                        LocalDate start = LocalDate.parse(startDate);
                        LocalDate end = LocalDate.parse(endDate);
                        if (start.isAfter(end)) {
                            throw new IllegalArgumentException("Start date cannot be after end date.");
                        }
                        revenueList = revenueDAO.getRevenueByCustomRange(startDate, endDate);
                    } catch (Exception e) {
                        throw new IllegalArgumentException("Invalid date format or range: " + e.getMessage());
                    }
                    break;
                default:
                    throw new IllegalArgumentException("Invalid time unit: " + timeUnit);
            }

            double totalRevenue = revenueList.stream().mapToDouble(RevenueStatistic::getRevenue).sum();

            // 1. Tạo PDF
            Document document = new Document(PageSize.A4.rotate());
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PdfWriter.getInstance(document, baos);
            document.open();

            // 2. Tiêu đề
            com.itextpdf.text.Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLACK);
            Paragraph title = new Paragraph("REVENUE STATISTIC REPORT", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20f);
            document.add(title);

            // 3. Thông tin
            com.itextpdf.text.Font infoFont = FontFactory.getFont(FontFactory.HELVETICA, 10);
            Paragraph info = new Paragraph();
            info.add(new Chunk("Time Unit: " + getTimeUnitDisplay(timeUnit).toUpperCase(),
                    FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
            info.add(Chunk.NEWLINE);
            info.add(new Chunk("Exported On: " + LocalDate.now(),
                    FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
            info.setSpacingAfter(15f);
            document.add(info);

            // 4. Tạo biểu đồ từ dữ liệu và chuyển thành hình ảnh
            byte[] chartImage = generateChartImage(revenueList);
            Image pdfChartImage = Image.getInstance(chartImage);
            pdfChartImage.scaleToFit(500, 300);
            pdfChartImage.setAlignment(Element.ALIGN_CENTER);
            document.add(pdfChartImage);
            document.add(Chunk.NEWLINE);

            // 5. Bảng dữ liệu
            PdfPTable table = createRevenueTable(revenueList, totalRevenue);
            document.add(table);

            // 6. Footer
            Paragraph footer = new Paragraph("Generated by Penguin Fashion Admin System",
                    FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 8));
            footer.setAlignment(Element.ALIGN_RIGHT);
            document.add(footer);

            document.close();

            // 7. Thiết lập response
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition",
                    "attachment; filename=Revenue_Statistic_" + timeUnit + "_" + LocalDate.now() + ".pdf");
            response.setContentLength(baos.size());
            baos.writeTo(response.getOutputStream());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error exporting PDF", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error generating PDF report: " + e.getMessage());
        }
    }

    // Hàm tạo biểu đồ và chuyển thành hình ảnh
    private byte[] generateChartImage(List<RevenueStatistic> revenueList) throws IOException {
        // 1. Tạo dữ liệu cho biểu đồ
        String[] labels = revenueList.stream()
                .map(RevenueStatistic::getTimePeriod)
                .toArray(String[]::new);

        double[] data = revenueList.stream()
                .mapToDouble(RevenueStatistic::getRevenue)
                .toArray();

        // 2. Tạo biểu đồ sử dụng JFreeChart
        JFreeChart chart = ChartFactory.createBarChart(
                "Revenue by Day", // Tiêu đề
                "Date", // Trục X
                "Amount (VND)", // Trục Y
                createDataset(labels, data), // Dữ liệu
                PlotOrientation.VERTICAL,
                true, true, false);

        // 3. Tùy chỉnh style
        chart.setBackgroundPaint(Color.WHITE);
        CategoryPlot plot = chart.getCategoryPlot();
        plot.setBackgroundPaint(Color.WHITE);
        plot.setRangeGridlinePaint(Color.LIGHT_GRAY);

        // 4. Chuyển biểu đồ thành hình ảnh
        ByteArrayOutputStream chartOutputStream = new ByteArrayOutputStream();
        ChartUtils.writeChartAsPNG(chartOutputStream, chart, 600, 400);
        return chartOutputStream.toByteArray();
    }

    // Hàm tạo dataset cho biểu đồ
    private CategoryDataset createDataset(String[] labels, double[] data) {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        for (int i = 0; i < labels.length; i++) {
            dataset.addValue(data[i], "Revenue", labels[i]);
        }
        return dataset;
    }

    // Hàm tạo bảng dữ liệu
    private PdfPTable createRevenueTable(List<RevenueStatistic> revenueList, double totalRevenue) {
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(20f);

        // Header
        com.itextpdf.text.Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.WHITE);
        PdfPCell headerCell1 = new PdfPCell(new Phrase("TIME PERIOD", headerFont));
        PdfPCell headerCell2 = new PdfPCell(new Phrase("REVENUE (VND)", headerFont));

        headerCell1.setBackgroundColor(new BaseColor(70, 130, 180)); // SteelBlue
        headerCell1.setHorizontalAlignment(Element.ALIGN_CENTER);
        headerCell1.setPadding(5);

        headerCell2.setBackgroundColor(new BaseColor(70, 130, 180));
        headerCell2.setHorizontalAlignment(Element.ALIGN_CENTER);
        headerCell2.setPadding(5);

        table.addCell(headerCell1);
        table.addCell(headerCell2);

        // Dữ liệu
        com.itextpdf.text.Font dataFont = FontFactory.getFont(FontFactory.HELVETICA, 10);
        NumberFormat formatter = NumberFormat.getNumberInstance(Locale.US);

        for (RevenueStatistic stat : revenueList) {
            PdfPCell timeCell = new PdfPCell(new Phrase(stat.getTimePeriod(), dataFont));
            timeCell.setPadding(5);
            timeCell.setBorderWidthBottom(0.5f);

            PdfPCell revenueCell = new PdfPCell(
                    new Phrase(formatter.format(stat.getRevenue()) + " ₫", dataFont));
            revenueCell.setPadding(5);
            revenueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            revenueCell.setBorderWidthBottom(0.5f);

            table.addCell(timeCell);
            table.addCell(revenueCell);
        }

        // Tổng
        PdfPCell totalLabelCell = new PdfPCell(new Phrase("TOTAL REVENUE",
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
        totalLabelCell.setBackgroundColor(new BaseColor(255, 255, 150)); // Light yellow
        totalLabelCell.setPadding(5);
        totalLabelCell.setBorderWidthTop(1f);

        PdfPCell totalValueCell = new PdfPCell(new Phrase(formatter.format(totalRevenue) + " ₫",
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
        totalValueCell.setBackgroundColor(new BaseColor(255, 255, 150));
        totalValueCell.setPadding(5);
        totalValueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        totalValueCell.setBorderWidthTop(1f);

        table.addCell(totalLabelCell);
        table.addCell(totalValueCell);

        return table;
    }

    private String getTimeUnitDisplay(String timeUnit) {
        switch (timeUnit) {
            case "day":
                return "Day";
            case "week":
                return "Week";
            case "month":
                return "Month";
            case "year":
                return "Year";
            case "custom":
                return "Custom Range";
            default:
                return timeUnit;
        }
    }
}
