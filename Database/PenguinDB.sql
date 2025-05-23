USE [master]
GO
/****** Object:  Database [PenguinDB]    Script Date: 4/15/2025 11:58:36 PM ******/
CREATE DATABASE [PenguinDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PenguinDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PenguinDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PenguinDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\PenguinDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [PenguinDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PenguinDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PenguinDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PenguinDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PenguinDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PenguinDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PenguinDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [PenguinDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PenguinDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PenguinDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PenguinDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PenguinDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PenguinDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PenguinDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PenguinDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PenguinDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PenguinDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [PenguinDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PenguinDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PenguinDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PenguinDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PenguinDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PenguinDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PenguinDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PenguinDB] SET RECOVERY FULL 
GO
ALTER DATABASE [PenguinDB] SET  MULTI_USER 
GO
ALTER DATABASE [PenguinDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PenguinDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PenguinDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PenguinDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PenguinDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PenguinDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'PenguinDB', N'ON'
GO
ALTER DATABASE [PenguinDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [PenguinDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [PenguinDB]
GO
/****** Object:  Table [dbo].[Cart]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cart](
	[cartID] [uniqueidentifier] NOT NULL,
	[customerID] [uniqueidentifier] NULL,
	[proVariantID] [uniqueidentifier] NULL,
	[quantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[cartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[categoryID] [uniqueidentifier] NOT NULL,
	[categoryName] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[categoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatBotHistory]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatBotHistory](
	[historyID] [uniqueidentifier] NOT NULL,
	[customerID] [uniqueidentifier] NULL,
	[customerName] [nvarchar](255) NULL,
	[question] [nvarchar](max) NOT NULL,
	[answer] [nvarchar](max) NULL,
	[questionDate] [datetime] NULL,
	[isAnswered] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[historyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Color]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Color](
	[colorID] [uniqueidentifier] NOT NULL,
	[colorName] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[colorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[customerID] [uniqueidentifier] NOT NULL,
	[customerName] [nvarchar](255) NULL,
	[password] [nvarchar](max) NULL,
	[fullName] [nvarchar](max) NULL,
	[address] [nvarchar](max) NULL,
	[googleID] [nvarchar](max) NULL,
	[email] [nvarchar](max) NULL,
	[phoneNumber] [nvarchar](max) NULL,
	[accessToken] [nvarchar](max) NULL,
	[state] [nvarchar](50) NULL,
	[zip] [varchar](10) NULL,
	[isVerified] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[customerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[customerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feedback]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feedback](
	[feedbackID] [uniqueidentifier] NOT NULL,
	[customerID] [uniqueidentifier] NULL,
	[productID] [uniqueidentifier] NULL,
	[orderDetailID] [uniqueidentifier] NULL,
	[comment] [nvarchar](max) NULL,
	[rating] [decimal](18, 2) NULL,
	[feedbackCreateAt] [datetime] NULL,
	[isResolved] [bit] NULL,
	[isViewed] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[feedbackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FeedbackReplies]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FeedbackReplies](
	[replyID] [uniqueidentifier] NOT NULL,
	[feedbackID] [uniqueidentifier] NULL,
	[managerID] [uniqueidentifier] NULL,
	[replyComment] [nvarchar](max) NULL,
	[replyCreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[replyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Image]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Image](
	[imgID] [uniqueidentifier] NOT NULL,
	[productID] [uniqueidentifier] NULL,
	[imgName] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[imgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Manager]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Manager](
	[managerID] [uniqueidentifier] NOT NULL,
	[managerName] [nvarchar](255) NULL,
	[password] [nvarchar](max) NULL,
	[fullName] [nvarchar](max) NULL,
	[email] [nvarchar](max) NULL,
	[phoneNumber] [nvarchar](max) NULL,
	[address] [nvarchar](max) NULL,
	[dateOfBirth] [datetime] NULL,
	[role] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[managerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[managerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[orderID] [uniqueidentifier] NOT NULL,
	[statusOID] [uniqueidentifier] NULL,
	[voucherID] [uniqueidentifier] NULL,
	[customerID] [uniqueidentifier] NULL,
	[totalAmount] [decimal](18, 2) NULL,
	[discountAmount] [decimal](18, 2) NULL,
	[finalAmount] [decimal](18, 2) NULL,
	[orderDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[orderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[orderDetailID] [uniqueidentifier] NOT NULL,
	[orderID] [uniqueidentifier] NULL,
	[productVariantID] [uniqueidentifier] NULL,
	[quantity] [int] NULL,
	[unitPrice] [decimal](18, 2) NULL,
	[totalPrice] [decimal](18, 2) NULL,
	[dateOrder] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[orderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[productID] [uniqueidentifier] NOT NULL,
	[typeID] [uniqueidentifier] NULL,
	[productName] [nvarchar](max) NULL,
	[description] [nvarchar](max) NULL,
	[price] [decimal](18, 2) NULL,
	[dateCreate] [datetime] NOT NULL,
	[isSale] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[productID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductVariants]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductVariants](
	[proVariantID] [uniqueidentifier] NOT NULL,
	[productID] [uniqueidentifier] NULL,
	[colorID] [uniqueidentifier] NULL,
	[sizeID] [uniqueidentifier] NULL,
	[status] [bit] NULL,
	[stockQuantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[proVariantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Restock]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restock](
	[restockID] [uniqueidentifier] NOT NULL,
	[proVariantID] [uniqueidentifier] NULL,
	[quantity] [int] NULL,
	[price] [decimal](18, 2) NULL,
	[totalCost] [decimal](18, 2) NULL,
	[restockDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[restockID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Size]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Size](
	[sizeID] [uniqueidentifier] NOT NULL,
	[sizeName] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[sizeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StatusOrder]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StatusOrder](
	[statusOID] [uniqueidentifier] NOT NULL,
	[statusName] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[statusOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TypeProduct]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TypeProduct](
	[typeID] [uniqueidentifier] NOT NULL,
	[categoryID] [uniqueidentifier] NULL,
	[typeName] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[typeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsedVoucher]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsedVoucher](
	[usedVoucherID] [uniqueidentifier] NOT NULL,
	[voucherID] [uniqueidentifier] NULL,
	[customerID] [uniqueidentifier] NULL,
	[usedAt] [datetime] NULL,
	[status] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[usedVoucherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vouchers]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vouchers](
	[voucherID] [uniqueidentifier] NOT NULL,
	[voucherCode] [nvarchar](max) NULL,
	[discountAmount] [decimal](18, 2) NULL,
	[minOrderValue] [decimal](18, 2) NULL,
	[validFrom] [datetime] NULL,
	[validUntil] [datetime] NULL,
	[voucherStatus] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[voucherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cart] ADD  DEFAULT (newid()) FOR [cartID]
GO
ALTER TABLE [dbo].[Category] ADD  DEFAULT (newid()) FOR [categoryID]
GO
ALTER TABLE [dbo].[ChatBotHistory] ADD  DEFAULT (newid()) FOR [historyID]
GO
ALTER TABLE [dbo].[ChatBotHistory] ADD  DEFAULT (getdate()) FOR [questionDate]
GO
ALTER TABLE [dbo].[ChatBotHistory] ADD  DEFAULT ((0)) FOR [isAnswered]
GO
ALTER TABLE [dbo].[Color] ADD  DEFAULT (newid()) FOR [colorID]
GO
ALTER TABLE [dbo].[Customer] ADD  DEFAULT (newid()) FOR [customerID]
GO
ALTER TABLE [dbo].[Feedback] ADD  DEFAULT (newid()) FOR [feedbackID]
GO
ALTER TABLE [dbo].[FeedbackReplies] ADD  DEFAULT (newid()) FOR [replyID]
GO
ALTER TABLE [dbo].[Image] ADD  DEFAULT (newid()) FOR [imgID]
GO
ALTER TABLE [dbo].[Manager] ADD  DEFAULT (newid()) FOR [managerID]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT (newid()) FOR [orderID]
GO
ALTER TABLE [dbo].[OrderDetail] ADD  DEFAULT (newid()) FOR [orderDetailID]
GO
ALTER TABLE [dbo].[Product] ADD  DEFAULT (newid()) FOR [productID]
GO
ALTER TABLE [dbo].[Product] ADD  DEFAULT (getdate()) FOR [dateCreate]
GO
ALTER TABLE [dbo].[Product] ADD  DEFAULT ((0)) FOR [isSale]
GO
ALTER TABLE [dbo].[ProductVariants] ADD  DEFAULT (newid()) FOR [proVariantID]
GO
ALTER TABLE [dbo].[Restock] ADD  DEFAULT (newid()) FOR [restockID]
GO
ALTER TABLE [dbo].[Size] ADD  DEFAULT (newid()) FOR [sizeID]
GO
ALTER TABLE [dbo].[StatusOrder] ADD  DEFAULT (newid()) FOR [statusOID]
GO
ALTER TABLE [dbo].[TypeProduct] ADD  DEFAULT (newid()) FOR [typeID]
GO
ALTER TABLE [dbo].[UsedVoucher] ADD  DEFAULT (newid()) FOR [usedVoucherID]
GO
ALTER TABLE [dbo].[Vouchers] ADD  DEFAULT (newid()) FOR [voucherID]
GO
ALTER TABLE [dbo].[Vouchers] ADD  DEFAULT ((1)) FOR [voucherStatus]
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD FOREIGN KEY([customerID])
REFERENCES [dbo].[Customer] ([customerID])
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD FOREIGN KEY([proVariantID])
REFERENCES [dbo].[ProductVariants] ([proVariantID])
GO
ALTER TABLE [dbo].[ChatBotHistory]  WITH CHECK ADD FOREIGN KEY([customerID])
REFERENCES [dbo].[Customer] ([customerID])
GO
ALTER TABLE [dbo].[Feedback]  WITH CHECK ADD FOREIGN KEY([customerID])
REFERENCES [dbo].[Customer] ([customerID])
GO
ALTER TABLE [dbo].[Feedback]  WITH CHECK ADD FOREIGN KEY([orderDetailID])
REFERENCES [dbo].[OrderDetail] ([orderDetailID])
GO
ALTER TABLE [dbo].[Feedback]  WITH CHECK ADD FOREIGN KEY([productID])
REFERENCES [dbo].[Product] ([productID])
GO
ALTER TABLE [dbo].[FeedbackReplies]  WITH CHECK ADD FOREIGN KEY([feedbackID])
REFERENCES [dbo].[Feedback] ([feedbackID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FeedbackReplies]  WITH CHECK ADD FOREIGN KEY([managerID])
REFERENCES [dbo].[Manager] ([managerID])
GO
ALTER TABLE [dbo].[Image]  WITH CHECK ADD FOREIGN KEY([productID])
REFERENCES [dbo].[Product] ([productID])
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([customerID])
REFERENCES [dbo].[Customer] ([customerID])
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([statusOID])
REFERENCES [dbo].[StatusOrder] ([statusOID])
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD FOREIGN KEY([voucherID])
REFERENCES [dbo].[Vouchers] ([voucherID])
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD FOREIGN KEY([orderID])
REFERENCES [dbo].[Order] ([orderID])
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD FOREIGN KEY([productVariantID])
REFERENCES [dbo].[ProductVariants] ([proVariantID])
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD FOREIGN KEY([typeID])
REFERENCES [dbo].[TypeProduct] ([typeID])
GO
ALTER TABLE [dbo].[ProductVariants]  WITH CHECK ADD FOREIGN KEY([colorID])
REFERENCES [dbo].[Color] ([colorID])
GO
ALTER TABLE [dbo].[ProductVariants]  WITH CHECK ADD FOREIGN KEY([productID])
REFERENCES [dbo].[Product] ([productID])
GO
ALTER TABLE [dbo].[ProductVariants]  WITH CHECK ADD FOREIGN KEY([sizeID])
REFERENCES [dbo].[Size] ([sizeID])
GO
ALTER TABLE [dbo].[Restock]  WITH CHECK ADD FOREIGN KEY([proVariantID])
REFERENCES [dbo].[ProductVariants] ([proVariantID])
GO
ALTER TABLE [dbo].[TypeProduct]  WITH CHECK ADD FOREIGN KEY([categoryID])
REFERENCES [dbo].[Category] ([categoryID])
GO
ALTER TABLE [dbo].[UsedVoucher]  WITH CHECK ADD FOREIGN KEY([customerID])
REFERENCES [dbo].[Customer] ([customerID])
GO
ALTER TABLE [dbo].[UsedVoucher]  WITH CHECK ADD FOREIGN KEY([voucherID])
REFERENCES [dbo].[Vouchers] ([voucherID])
GO
/****** Object:  StoredProcedure [dbo].[InsertProduct]    Script Date: 4/15/2025 11:58:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertProduct]
    @productName NVARCHAR(MAX),
    @description NVARCHAR(MAX),
    @price DECIMAL(10,2),
    @typeID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM Product 
        WHERE productName = @productName 
          AND typeID = @typeID 
          
    )
    BEGIN
        RAISERROR ('Product is exist!', 16, 1);
        RETURN;
    END
    INSERT INTO Product (productName, description, price, typeID, dateCreate)
    VALUES (@productName, @description, @price, @typeID, GETDATE());
END;
GO
USE [master]
GO
ALTER DATABASE [PenguinDB] SET  READ_WRITE 
GO
