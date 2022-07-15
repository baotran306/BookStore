USE [master]
GO
/****** Object:  Database [BookOnlineStore]    Script Date: 7/5/2022 3:35:28 PM ******/
CREATE DATABASE [BookOnlineStore]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BookOnlineStore', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BookOnlineStore.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BookOnlineStore_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BookOnlineStore_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [BookOnlineStore] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BookOnlineStore].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BookOnlineStore] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BookOnlineStore] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BookOnlineStore] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BookOnlineStore] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BookOnlineStore] SET ARITHABORT OFF 
GO
ALTER DATABASE [BookOnlineStore] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BookOnlineStore] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BookOnlineStore] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BookOnlineStore] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BookOnlineStore] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BookOnlineStore] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BookOnlineStore] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BookOnlineStore] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BookOnlineStore] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BookOnlineStore] SET  ENABLE_BROKER 
GO
ALTER DATABASE [BookOnlineStore] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BookOnlineStore] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BookOnlineStore] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BookOnlineStore] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BookOnlineStore] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BookOnlineStore] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BookOnlineStore] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BookOnlineStore] SET RECOVERY FULL 
GO
ALTER DATABASE [BookOnlineStore] SET  MULTI_USER 
GO
ALTER DATABASE [BookOnlineStore] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BookOnlineStore] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BookOnlineStore] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BookOnlineStore] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BookOnlineStore] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BookOnlineStore] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BookOnlineStore', N'ON'
GO
ALTER DATABASE [BookOnlineStore] SET QUERY_STORE = OFF
GO
USE [BookOnlineStore]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[account] [varchar](32) NOT NULL,
	[password] [varchar](32) NULL,
	[role_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Author]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Author](
	[author_id] [varchar](16) NOT NULL,
	[last_name] [varchar](64) NULL,
	[first_name] [varchar](64) NULL,
	[gender] [bit] NULL,
	[date_of_birth] [date] NULL,
	[phone_number] [varchar](16) NULL,
	[address] [varchar](255) NULL,
	[email] [varchar](64) NULL,
PRIMARY KEY CLUSTERED 
(
	[author_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Book]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book](
	[isbn] [varchar](32) NOT NULL,
	[book_name] [varchar](128) NOT NULL,
	[image] [varchar](256) NULL,
	[pages] [int] NULL,
	[price] [money] NULL,
	[release_year] [varchar](4) NULL,
	[quantity_in_stock] [int] NOT NULL,
	[is_new] [bit] NOT NULL,
	[book_type_id] [varchar](16) NULL,
	[publisher_id] [varchar](16) NULL,
 CONSTRAINT [PK__Book__99F9D0A55028FE6A] PRIMARY KEY CLUSTERED 
(
	[isbn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookType]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookType](
	[book_type_id] [varchar](16) NOT NULL,
	[book_type_name] [varchar](64) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[book_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cart]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cart](
	[cart_id] [int] IDENTITY(1,1) NOT NULL,
	[order_cart_time] [datetime] NOT NULL,
	[last_name_receive] [nvarchar](32) NULL,
	[first_name_receive] [nvarchar](32) NOT NULL,
	[address_receive] [nvarchar](255) NOT NULL,
	[phone_number_receive] [varchar](16) NOT NULL,
	[email] [varchar](64) NULL,
	[date_receive] [datetime] NOT NULL,
	[status_id] [int] NULL,
	[customer_id] [varchar](16) NOT NULL,
	[staff_id_confirm] [varchar](16) NULL,
	[staff_id_deliver] [varchar](16) NULL,
 CONSTRAINT [PK_Cart] PRIMARY KEY CLUSTERED 
(
	[cart_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CartDetail]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CartDetail](
	[cart_id] [int] NOT NULL,
	[isbn] [varchar](32) NOT NULL,
	[price] [money] NOT NULL,
	[quantity] [int] NOT NULL,
	[return_note_id] [int] NULL,
 CONSTRAINT [PK__CartDeta__676AB72D757B87CE] PRIMARY KEY CLUSTERED 
(
	[cart_id] ASC,
	[isbn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Compositions]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compositions](
	[author_id] [varchar](16) NOT NULL,
	[isbn] [varchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[author_id] ASC,
	[isbn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[customer_id] [varchar](16) NOT NULL,
	[last_name] [varchar](32) NOT NULL,
	[first_name] [varchar](32) NOT NULL,
	[gender] [bit] NOT NULL,
	[address] [varchar](255) NOT NULL,
	[date_of_birth] [date] NOT NULL,
	[phone_number] [varchar](16) NOT NULL,
	[email] [varchar](128) NOT NULL,
	[tax] [varchar](64) NULL,
	[account] [varchar](32) NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[department_id] [varchar](16) NOT NULL,
	[department_name] [nvarchar](64) NULL,
PRIMARY KEY CLUSTERED 
(
	[department_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ImportNote]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ImportNote](
	[import_note_id] [int] IDENTITY(1,1) NOT NULL,
	[date_import] [date] NOT NULL,
	[staff_id_import] [varchar](16) NOT NULL,
	[order_publisher_id] [varchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[import_note_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[order_publisher_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ImportNoteDetail]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ImportNoteDetail](
	[import_note_id] [int] NOT NULL,
	[isbn] [varchar](32) NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [money] NOT NULL,
 CONSTRAINT [PK_ImportNoteDetail] PRIMARY KEY CLUSTERED 
(
	[import_note_id] ASC,
	[isbn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice](
	[invoice_id] [varchar](32) NOT NULL,
	[invoice_date] [datetime] NOT NULL,
	[total_money] [money] NOT NULL,
	[tax] [varchar](64) NULL,
	[staff_id] [varchar](16) NOT NULL,
	[cart_id] [int] NULL,
 CONSTRAINT [PK__Invoice__F58DFD4942D65998] PRIMARY KEY CLUSTERED 
(
	[invoice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[cart_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderPublisher]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderPublisher](
	[order_publisher_id] [varchar](32) NOT NULL,
	[order_publisher_date] [datetime] NOT NULL,
	[publisher_id] [varchar](16) NOT NULL,
	[staff_order_id] [varchar](16) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[order_publisher_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderPublisherDetail]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderPublisherDetail](
	[order_publisher_id] [varchar](32) NOT NULL,
	[isbn] [varchar](32) NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[order_publisher_id] ASC,
	[isbn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PriceUpdateDetail]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PriceUpdateDetail](
	[staff_id_update] [varchar](16) NOT NULL,
	[isbn] [varchar](32) NOT NULL,
	[update_price] [money] NOT NULL,
	[update_date] [datetime] NOT NULL,
 CONSTRAINT [PK_PriceUpdateDetail] PRIMARY KEY CLUSTERED 
(
	[isbn] ASC,
	[update_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Promotion]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Promotion](
	[promotion_id] [int] NOT NULL,
	[promotion_name] [nvarchar](64) NOT NULL,
	[promotion_start_date] [datetime] NOT NULL,
	[promotion_end_date] [datetime] NOT NULL,
	[promotion_reason] [nvarchar](512) NOT NULL,
	[staff_id_create] [varchar](16) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[promotion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PromotionDetail]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PromotionDetail](
	[promotion_id] [int] NOT NULL,
	[isbn] [varchar](32) NOT NULL,
	[percent_discount] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[promotion_id] ASC,
	[isbn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Publisher]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Publisher](
	[publisher_id] [varchar](16) NOT NULL,
	[publisher_name] [varchar](128) NOT NULL,
	[address] [varchar](256) NOT NULL,
	[phone_number] [varchar](16) NULL,
	[email] [varchar](128) NULL,
PRIMARY KEY CLUSTERED 
(
	[publisher_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReturnNote]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReturnNote](
	[return_note_id] [int] IDENTITY(1,1) NOT NULL,
	[create_date] [datetime] NULL,
	[invoice_id] [varchar](32) NULL,
	[staff_id] [varchar](16) NULL,
PRIMARY KEY CLUSTERED 
(
	[return_note_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[invoice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[role_id] [int] IDENTITY(1,1) NOT NULL,
	[role_name] [nvarchar](64) NULL,
PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Staff]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staff](
	[staff_id] [varchar](16) NOT NULL,
	[last_name] [varchar](32) NOT NULL,
	[first_name] [varchar](32) NOT NULL,
	[gender] [bit] NOT NULL,
	[address] [varchar](255) NOT NULL,
	[date_of_birth] [date] NOT NULL,
	[phone_number] [varchar](16) NOT NULL,
	[email] [varchar](128) NOT NULL,
	[department_id] [varchar](16) NOT NULL,
	[account] [varchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[staff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StatusOrder]    Script Date: 7/5/2022 3:35:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StatusOrder](
	[status_id] [int] IDENTITY(1,1) NOT NULL,
	[status_name] [nvarchar](64) NULL,
PRIMARY KEY CLUSTERED 
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Book] ADD  CONSTRAINT [DF__Book__is_new__29572725]  DEFAULT ((1)) FOR [is_new]
GO
ALTER TABLE [dbo].[Cart] ADD  CONSTRAINT [DF__Cart__order_cart__68487DD7]  DEFAULT (getdate()) FOR [order_cart_time]
GO
ALTER TABLE [dbo].[ImportNote] ADD  DEFAULT (getdate()) FOR [date_import]
GO
ALTER TABLE [dbo].[Invoice] ADD  CONSTRAINT [DF__Invoice__invoice__7C4F7684]  DEFAULT (getdate()) FOR [invoice_date]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [fk_account_role] FOREIGN KEY([role_id])
REFERENCES [dbo].[Roles] ([role_id])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [fk_account_role]
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD  CONSTRAINT [FK_Book_Publisher] FOREIGN KEY([publisher_id])
REFERENCES [dbo].[Publisher] ([publisher_id])
GO
ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [FK_Book_Publisher]
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD  CONSTRAINT [FK_Book_Type] FOREIGN KEY([book_type_id])
REFERENCES [dbo].[BookType] ([book_type_id])
GO
ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [FK_Book_Type]
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD  CONSTRAINT [fk_cart_customer] FOREIGN KEY([customer_id])
REFERENCES [dbo].[Customer] ([customer_id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Cart] CHECK CONSTRAINT [fk_cart_customer]
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD  CONSTRAINT [fk_cart_staff_confirm] FOREIGN KEY([staff_id_confirm])
REFERENCES [dbo].[Staff] ([staff_id])
GO
ALTER TABLE [dbo].[Cart] CHECK CONSTRAINT [fk_cart_staff_confirm]
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD  CONSTRAINT [fk_cart_staff_deliver] FOREIGN KEY([staff_id_deliver])
REFERENCES [dbo].[Staff] ([staff_id])
GO
ALTER TABLE [dbo].[Cart] CHECK CONSTRAINT [fk_cart_staff_deliver]
GO
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD  CONSTRAINT [fk_cart_status] FOREIGN KEY([status_id])
REFERENCES [dbo].[StatusOrder] ([status_id])
GO
ALTER TABLE [dbo].[Cart] CHECK CONSTRAINT [fk_cart_status]
GO
ALTER TABLE [dbo].[CartDetail]  WITH CHECK ADD  CONSTRAINT [fk_cart_detail_cart] FOREIGN KEY([cart_id])
REFERENCES [dbo].[Cart] ([cart_id])
GO
ALTER TABLE [dbo].[CartDetail] CHECK CONSTRAINT [fk_cart_detail_cart]
GO
ALTER TABLE [dbo].[CartDetail]  WITH CHECK ADD  CONSTRAINT [fk_cart_detail_isbn] FOREIGN KEY([isbn])
REFERENCES [dbo].[Book] ([isbn])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CartDetail] CHECK CONSTRAINT [fk_cart_detail_isbn]
GO
ALTER TABLE [dbo].[CartDetail]  WITH CHECK ADD  CONSTRAINT [FK_CartDetail_ReturnNote] FOREIGN KEY([return_note_id])
REFERENCES [dbo].[ReturnNote] ([return_note_id])
GO
ALTER TABLE [dbo].[CartDetail] CHECK CONSTRAINT [FK_CartDetail_ReturnNote]
GO
ALTER TABLE [dbo].[Compositions]  WITH CHECK ADD  CONSTRAINT [FK_Compositions_Book] FOREIGN KEY([isbn])
REFERENCES [dbo].[Book] ([isbn])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Compositions] CHECK CONSTRAINT [FK_Compositions_Book]
GO
ALTER TABLE [dbo].[Compositions]  WITH CHECK ADD  CONSTRAINT [FK_Compositions_Publisher] FOREIGN KEY([author_id])
REFERENCES [dbo].[Author] ([author_id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Compositions] CHECK CONSTRAINT [FK_Compositions_Publisher]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [fk_account_customer] FOREIGN KEY([account])
REFERENCES [dbo].[Account] ([account])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [fk_account_customer]
GO
ALTER TABLE [dbo].[ImportNote]  WITH CHECK ADD  CONSTRAINT [fk_order_publisher_import] FOREIGN KEY([order_publisher_id])
REFERENCES [dbo].[OrderPublisher] ([order_publisher_id])
GO
ALTER TABLE [dbo].[ImportNote] CHECK CONSTRAINT [fk_order_publisher_import]
GO
ALTER TABLE [dbo].[ImportNote]  WITH CHECK ADD  CONSTRAINT [fk_order_publisher_staff] FOREIGN KEY([staff_id_import])
REFERENCES [dbo].[Staff] ([staff_id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ImportNote] CHECK CONSTRAINT [fk_order_publisher_staff]
GO
ALTER TABLE [dbo].[ImportNoteDetail]  WITH CHECK ADD  CONSTRAINT [fk_import_note_book] FOREIGN KEY([isbn])
REFERENCES [dbo].[Book] ([isbn])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ImportNoteDetail] CHECK CONSTRAINT [fk_import_note_book]
GO
ALTER TABLE [dbo].[ImportNoteDetail]  WITH CHECK ADD  CONSTRAINT [fk_import_note_id] FOREIGN KEY([import_note_id])
REFERENCES [dbo].[ImportNote] ([import_note_id])
GO
ALTER TABLE [dbo].[ImportNoteDetail] CHECK CONSTRAINT [fk_import_note_id]
GO
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD  CONSTRAINT [fk_invoice_cart] FOREIGN KEY([cart_id])
REFERENCES [dbo].[Cart] ([cart_id])
GO
ALTER TABLE [dbo].[Invoice] CHECK CONSTRAINT [fk_invoice_cart]
GO
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD  CONSTRAINT [fk_invoice_staff] FOREIGN KEY([staff_id])
REFERENCES [dbo].[Staff] ([staff_id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Invoice] CHECK CONSTRAINT [fk_invoice_staff]
GO
ALTER TABLE [dbo].[OrderPublisher]  WITH CHECK ADD  CONSTRAINT [fk_order_publisher_pub] FOREIGN KEY([publisher_id])
REFERENCES [dbo].[Publisher] ([publisher_id])
GO
ALTER TABLE [dbo].[OrderPublisher] CHECK CONSTRAINT [fk_order_publisher_pub]
GO
ALTER TABLE [dbo].[OrderPublisher]  WITH CHECK ADD  CONSTRAINT [FK_OrderPublisher_Staff] FOREIGN KEY([staff_order_id])
REFERENCES [dbo].[Staff] ([staff_id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[OrderPublisher] CHECK CONSTRAINT [FK_OrderPublisher_Staff]
GO
ALTER TABLE [dbo].[OrderPublisherDetail]  WITH CHECK ADD  CONSTRAINT [fk_order_publisher_detail_book] FOREIGN KEY([isbn])
REFERENCES [dbo].[Book] ([isbn])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[OrderPublisherDetail] CHECK CONSTRAINT [fk_order_publisher_detail_book]
GO
ALTER TABLE [dbo].[OrderPublisherDetail]  WITH CHECK ADD  CONSTRAINT [fk_order_publisher_detail_pub] FOREIGN KEY([order_publisher_id])
REFERENCES [dbo].[OrderPublisher] ([order_publisher_id])
GO
ALTER TABLE [dbo].[OrderPublisherDetail] CHECK CONSTRAINT [fk_order_publisher_detail_pub]
GO
ALTER TABLE [dbo].[PriceUpdateDetail]  WITH CHECK ADD  CONSTRAINT [fk_update_price_isbn] FOREIGN KEY([isbn])
REFERENCES [dbo].[Book] ([isbn])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[PriceUpdateDetail] CHECK CONSTRAINT [fk_update_price_isbn]
GO
ALTER TABLE [dbo].[PriceUpdateDetail]  WITH CHECK ADD  CONSTRAINT [fk_update_price_staff] FOREIGN KEY([staff_id_update])
REFERENCES [dbo].[Staff] ([staff_id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[PriceUpdateDetail] CHECK CONSTRAINT [fk_update_price_staff]
GO
ALTER TABLE [dbo].[Promotion]  WITH CHECK ADD  CONSTRAINT [fk_promotion_staff] FOREIGN KEY([staff_id_create])
REFERENCES [dbo].[Staff] ([staff_id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Promotion] CHECK CONSTRAINT [fk_promotion_staff]
GO
ALTER TABLE [dbo].[PromotionDetail]  WITH CHECK ADD  CONSTRAINT [fk_promotion_detail_book] FOREIGN KEY([isbn])
REFERENCES [dbo].[Book] ([isbn])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[PromotionDetail] CHECK CONSTRAINT [fk_promotion_detail_book]
GO
ALTER TABLE [dbo].[PromotionDetail]  WITH CHECK ADD  CONSTRAINT [fk_promotion_detail_id] FOREIGN KEY([promotion_id])
REFERENCES [dbo].[Promotion] ([promotion_id])
GO
ALTER TABLE [dbo].[PromotionDetail] CHECK CONSTRAINT [fk_promotion_detail_id]
GO
ALTER TABLE [dbo].[ReturnNote]  WITH CHECK ADD  CONSTRAINT [fk_return_note_invoice] FOREIGN KEY([invoice_id])
REFERENCES [dbo].[Invoice] ([invoice_id])
GO
ALTER TABLE [dbo].[ReturnNote] CHECK CONSTRAINT [fk_return_note_invoice]
GO
ALTER TABLE [dbo].[ReturnNote]  WITH CHECK ADD  CONSTRAINT [fk_return_note_staff] FOREIGN KEY([staff_id])
REFERENCES [dbo].[Staff] ([staff_id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ReturnNote] CHECK CONSTRAINT [fk_return_note_staff]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD FOREIGN KEY([department_id])
REFERENCES [dbo].[Department] ([department_id])
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [fk_account_employee] FOREIGN KEY([account])
REFERENCES [dbo].[Account] ([account])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [fk_account_employee]
GO
USE [master]
GO
ALTER DATABASE [BookOnlineStore] SET  READ_WRITE 
GO
