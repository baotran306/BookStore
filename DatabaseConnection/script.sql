USE [master]
GO
/****** Object:  Database [BookOnlineStore]    Script Date: 9/6/2022 10:32:05 PM ******/
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
/****** Object:  UserDefinedTableType [dbo].[cart_details_type]    Script Date: 9/6/2022 10:32:05 PM ******/
CREATE TYPE [dbo].[cart_details_type] AS TABLE(
	[isbn] [varchar](32) NULL,
	[price] [money] NULL,
	[qty] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[order_details_type]    Script Date: 9/6/2022 10:32:05 PM ******/
CREATE TYPE [dbo].[order_details_type] AS TABLE(
	[isbn] [varchar](32) NULL,
	[price] [money] NULL,
	[qty] [int] NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[generate_full_month]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[generate_full_month](@from_date date, @to_date date)
returns @generate_month table(month_year varchar(10))
as
begin
  DECLARE @month_diff INT;  
  DECLARE @counter  INT;  
  
  SET @counter = 0;  
  SELECT @month_diff = DATEDIFF(mm, @from_date, @to_date);  
  
  WHILE @counter <= @month_diff  
  BEGIN  
      INSERT @generate_month  
      SELECT concat(Month(DATEADD(mm, @counter, @from_date)), '-', year(DATEADD(mm, @counter, @from_date)));
  
    SET @counter = @counter + 1;  
  END 
  --insert into @ans values(1, 2)
return
end
GO
/****** Object:  UserDefinedFunction [dbo].[remove_mark]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[remove_mark] (@text nvarchar(max))
RETURNS nvarchar(max)
AS
BEGIN
	SET @text = LOWER(@text)
	DECLARE @textLen int = LEN(@text)
	IF @textLen > 0
	BEGIN
		DECLARE @index int = 1
		DECLARE @lPos int
		DECLARE @SIGN_CHARS nvarchar(100) = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýđð'
		DECLARE @UNSIGN_CHARS varchar(100) = 'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyydd'

		WHILE @index <= @textLen
		BEGIN
			SET @lPos = CHARINDEX(SUBSTRING(@text,@index,1),@SIGN_CHARS)
			IF @lPos > 0
			BEGIN
				SET @text = STUFF(@text,@index,1,SUBSTRING(@UNSIGN_CHARS,@lPos,1))
			END
			SET @index = @index + 1
		END
	END
	RETURN @text
END
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[customer_id] [varchar](16) NOT NULL,
	[last_name] [nvarchar](50) NOT NULL,
	[first_name] [nvarchar](50) NOT NULL,
	[gender] [bit] NOT NULL,
	[address] [nvarchar](255) NOT NULL,
	[date_of_birth] [date] NOT NULL,
	[phone_number] [varchar](16) NOT NULL,
	[email] [varchar](128) NOT NULL,
	[tax] [varchar](64) NULL,
	[account] [varchar](32) NULL,
 CONSTRAINT [PK__Customer__CD65CB85FE808CAB] PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[get_customer_info_by_account]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_customer_info_by_account](@account varchar(32))
returns table
as
return
	select customer_id, last_name, first_name, gender, address, date_of_birth, phone_number, email, tax, account
	from Customer
	where account = @account;
GO
/****** Object:  Table [dbo].[Staff]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Staff](
	[staff_id] [varchar](16) NOT NULL,
	[last_name] [nvarchar](50) NOT NULL,
	[first_name] [nvarchar](50) NOT NULL,
	[gender] [bit] NOT NULL,
	[address] [nvarchar](255) NOT NULL,
	[date_of_birth] [date] NOT NULL,
	[phone_number] [varchar](16) NOT NULL,
	[email] [varchar](128) NOT NULL,
	[department_id] [varchar](16) NOT NULL,
	[account] [varchar](32) NOT NULL,
 CONSTRAINT [PK__Staff__1963DD9CD83025FB] PRIMARY KEY CLUSTERED 
(
	[staff_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[get_staff_info_by_account]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_staff_info_by_account](@account varchar(32))
returns table
as
return
	select staff_id, last_name, first_name, gender, address, date_of_birth, phone_number, email, account
	from Staff
	where account = @account;
GO
/****** Object:  Table [dbo].[ExchangeRate]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExchangeRate](
	[exchange_id] [varchar](8) NOT NULL,
	[exchange_date_apply] [datetime] NOT NULL,
	[exchange_value] [money] NULL,
	[staff_id_update] [varchar](16) NULL,
PRIMARY KEY CLUSTERED 
(
	[exchange_id] ASC,
	[exchange_date_apply] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[get_newest_exchange]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_newest_exchange](@exchange_id varchar(8))
returns table
as
return
	select top(1) ExchangeRate.*, Staff.last_name, Staff.first_name
	from ExchangeRate
	left join Staff
	on ExchangeRate.staff_id_update = Staff.staff_id
	where exchange_id = @exchange_id
	order by exchange_date_apply desc;
GO
/****** Object:  Table [dbo].[Book]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book](
	[isbn] [varchar](32) NOT NULL,
	[book_name] [nvarchar](128) NOT NULL,
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
/****** Object:  Table [dbo].[CartDetail]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CartDetail](
	[cart_id] [int] NOT NULL,
	[isbn] [varchar](32) NOT NULL,
	[price] [money] NOT NULL,
	[quantity] [int] NOT NULL,
	[return_quantity] [nchar](10) NULL,
	[return_note_id] [int] NULL,
 CONSTRAINT [PK__CartDeta__676AB72D757B87CE] PRIMARY KEY CLUSTERED 
(
	[cart_id] ASC,
	[isbn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cart]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cart](
	[cart_id] [int] IDENTITY(1,1) NOT NULL,
	[order_cart_time] [datetime] NOT NULL,
	[last_update_time] [datetime] NOT NULL,
	[last_name_receive] [nvarchar](32) NOT NULL,
	[first_name_receive] [nvarchar](32) NOT NULL,
	[address_receive] [nvarchar](255) NOT NULL,
	[phone_number_receive] [varchar](16) NOT NULL,
	[email] [varchar](64) NULL,
	[date_receive] [datetime] NULL,
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
/****** Object:  Table [dbo].[StatusOrder]    Script Date: 9/6/2022 10:32:05 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[get_list_cart_detail_by_customer]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_cart_detail_by_customer](@customer_id varchar(16))
returns table
as
return
	select CartDetail.cart_id, CartDetail.isbn, Book.book_name, Book.image,
	CartDetail.quantity, CartDetail.price, Cart.order_cart_time, StatusOrder.status_id, StatusOrder.status_name,
	Cart.last_name_receive, Cart.first_name_receive, Cart.address_receive, Cart.phone_number_receive, Cart.email
	from Cart
	left join StatusOrder on Cart.status_id = StatusOrder.status_id
	left join CartDetail on Cart.cart_id = CartDetail.cart_id
	left join Book on Book.isbn = CartDetail.isbn
	where Cart.customer_id = @customer_id
	;
GO
/****** Object:  UserDefinedFunction [dbo].[statistic_sales_by_month]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[statistic_sales_by_month](@from_date date, @to_date date)
returns table
as
return
	select full_month.month_year, COALESCE(temp.total_revenue, 0) as total_revenue
	from
	(
		select month_year
		from dbo.generate_full_month(@from_date, @to_date)
	) full_month
	left join
	(
		select CONCAT(MONTH(Cart.order_cart_time),'-', YEAR(Cart.order_cart_time)) as month_year,
			sum(CartDetail.price * CartDetail.quantity) as total_revenue
		from 
		(
			select cart_id, order_cart_time
			from Cart
			where cast(Cart.order_cart_time as date) >= @from_date and cast(Cart.order_cart_time as date) <= @to_date
			and Cart.status_id != 4
		) Cart
		inner join CartDetail on Cart.cart_id = CartDetail.cart_id
		
		group by CONCAT(MONTH(Cart.order_cart_time),'-', YEAR(Cart.order_cart_time))
	) temp
	on temp.month_year = full_month.month_year
	;
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_customer_order_detail]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_customer_order_detail]()
returns table
as
return
	select CartDetail.cart_id, CartDetail.isbn, Book.book_name, Book.image,
	CartDetail.quantity, CartDetail.price, Customer.customer_id, Customer.last_name, Customer.first_name,
	Cart.order_cart_time, StatusOrder.status_id, StatusOrder.status_name,
	Cart.last_name_receive, Cart.first_name_receive, Cart.address_receive, Cart.phone_number_receive, Cart.email,
	Staff.staff_id, Staff.last_name as staff_last_name, Staff.first_name as staff_first_name
	from Cart
	left join StatusOrder on Cart.status_id = StatusOrder.status_id
	left join CartDetail on Cart.cart_id = CartDetail.cart_id
	left join Book on Book.isbn = CartDetail.isbn
	left join Customer on Customer.customer_id = Cart.customer_id
	left join Staff on Staff.staff_id = Cart.staff_id_deliver
	;
GO
/****** Object:  Table [dbo].[Account]    Script Date: 9/6/2022 10:32:05 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[get_list_count_delivery_staff]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_count_delivery_staff]()
returns table
as
return
	select Staff.staff_id, Staff.first_name, Staff.last_name, count(Cart.cart_id) as number_delivery
	from Staff
	left join Cart on Cart.staff_id_deliver = Staff.staff_id
	left join Account on Staff.account = Account.account
	where Account.role_id = 3 -- Shipper
	group by Staff.staff_id, Staff.first_name, Staff.last_name;
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_customer_order_detail_by_status]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_customer_order_detail_by_status](@status_id int)
returns table
as
return
	select CartDetail.cart_id, CartDetail.isbn, Book.book_name, Book.image,
	CartDetail.quantity, CartDetail.price, Customer.customer_id, Customer.last_name, Customer.first_name,
	Cart.order_cart_time, StatusOrder.status_id, StatusOrder.status_name,
	Cart.last_name_receive, Cart.first_name_receive, Cart.address_receive, Cart.phone_number_receive, Cart.email,
	Staff.staff_id, Staff.last_name as staff_last_name, Staff.first_name as staff_first_name
	from Cart
	left join StatusOrder on Cart.status_id = StatusOrder.status_id
	left join CartDetail on Cart.cart_id = CartDetail.cart_id
	left join Book on Book.isbn = CartDetail.isbn
	left join Customer on Customer.customer_id = Cart.customer_id
	left join Staff on Staff.staff_id = Cart.staff_id_deliver
	where Cart.status_id = @status_id	;
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_customer_cart_by_status]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_customer_cart_by_status](@status_id int)
returns table
as
return
	select Cart.cart_id, Customer.customer_id, Customer.account, Customer.last_name, Customer.first_name,
	Cart.order_cart_time, StatusOrder.status_id, StatusOrder.status_name,
	Cart.last_name_receive, Cart.first_name_receive, Cart.address_receive, Cart.phone_number_receive, Cart.email,
	Staff.staff_id, Staff.last_name as staff_last_name, Staff.first_name as staff_first_name
	from Cart
	left join StatusOrder on Cart.status_id = StatusOrder.status_id
	left join Customer on Customer.customer_id = Cart.customer_id
	left join Staff on Staff.staff_id = Cart.staff_id_deliver
	where Cart.status_id = @status_id	;
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_customer_cart_detail_by_cart_id]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_customer_cart_detail_by_cart_id](@cart_id int)
returns table
as
return
	select Cart.cart_id, CartDetail.isbn, Book.book_name, Book.image,
	CartDetail.quantity, CartDetail.price,
	Cart.order_cart_time, StatusOrder.status_id, StatusOrder.status_name,
	Cart.last_name_receive, Cart.first_name_receive, Cart.address_receive, Cart.phone_number_receive, Cart.email
	from Cart
	left join StatusOrder on Cart.status_id = StatusOrder.status_id
	left join CartDetail on CartDetail.cart_id = Cart.cart_id
	left join Book on Book.isbn = CartDetail.isbn
	where Cart.cart_id = @cart_id;
GO
/****** Object:  Table [dbo].[Publisher]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Publisher](
	[publisher_id] [varchar](16) NOT NULL,
	[publisher_name] [nvarchar](128) NOT NULL,
	[address] [nvarchar](256) NOT NULL,
	[phone_number] [varchar](16) NULL,
	[email] [varchar](128) NULL,
 CONSTRAINT [PK__Publishe__3263F29D81C8F99F] PRIMARY KEY CLUSTERED 
(
	[publisher_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_publisher]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_publisher]()
returns table
as
return
	select * from Publisher;
GO
/****** Object:  Table [dbo].[BookType]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookType](
	[book_type_id] [varchar](16) NOT NULL,
	[book_type_name] [nvarchar](64) NOT NULL,
 CONSTRAINT [PK__BookType__6489BE8BD0D03C33] PRIMARY KEY CLUSTERED 
(
	[book_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Promotion]    Script Date: 9/6/2022 10:32:05 PM ******/
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
/****** Object:  Table [dbo].[PromotionDetail]    Script Date: 9/6/2022 10:32:05 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[get_list_book_by_name_and_is_new]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_book_by_name_and_is_new](@bookname nvarchar(256), @is_new bit)
returns table
as
return
	select Book.*, BookType.book_type_name, Publisher.publisher_name, PromotionDetail.percent_discount
	from (
		select Promotion.promotion_id 
		from Promotion
		where GETDATE() >= Promotion.promotion_start_date and GETDATE() <= Promotion.promotion_end_date
	) Promotion
	left join PromotionDetail on Promotion.promotion_id = PromotionDetail.promotion_id
	right join Book on PromotionDetail.isbn = Book.isbn
	left join BookType on Book.book_type_id = BookType.book_type_id
	left join Publisher on Book.publisher_id = Publisher.publisher_id
	where (dbo.remove_mark(book_name) like '%'+dbo.remove_mark(@bookname)+'%' or book_name like '%'+@bookname+'%')
	and is_new = @is_new;
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_cart_detail_by_staff_delivery]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_cart_detail_by_staff_delivery](@staff_id varchar(16))
returns table
as
return
	select CartDetail.cart_id, CartDetail.isbn, Book.book_name, Book.image,
	CartDetail.quantity, CartDetail.price, Cart.order_cart_time, StatusOrder.status_id, StatusOrder.status_name,
	Cart.last_name_receive, Cart.first_name_receive, Cart.address_receive, Cart.phone_number_receive, Cart.email
	from Cart
	left join StatusOrder on Cart.status_id = StatusOrder.status_id
	left join CartDetail on Cart.cart_id = CartDetail.cart_id
	left join Book on Book.isbn = CartDetail.isbn
	where Cart.staff_id_deliver = @staff_id
	;
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_book_type_by_id]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_book_type_by_id](@book_type_id varchar(16))
returns table
as
return
	select *
	from BookType
	where BookType.book_type_id = @book_type_id;
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_book_type_by_name]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_book_type_by_name](@bookname nvarchar(256))
returns table
as
return
	select *
	from BookType
	where dbo.remove_mark(book_type_name) like '%'+dbo.remove_mark(@bookname)+'%' or book_type_name like '%'+@bookname+'%';
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_new_book]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_new_book]()
returns table
as
return
	select Book.*, BookType.book_type_name, Publisher.publisher_name, PromotionDetail.percent_discount
	from (
		select Promotion.promotion_id 
		from Promotion
		where GETDATE() >= Promotion.promotion_start_date and GETDATE() <= Promotion.promotion_end_date
	) Promotion
	join PromotionDetail on Promotion.promotion_id = PromotionDetail.promotion_id
	right join Book on Book.isbn = PromotionDetail.isbn
	join BookType on Book.book_type_id = BookType.book_type_id
	join Publisher on Book.publisher_id = Publisher.publisher_id
	where is_new = 1;
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_book_type]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[get_list_book_type]()
returns table
as
return
	select *
	from BookType;
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_book]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_book]()
returns table
as
return
	select Book.*, BookType.book_type_name, Publisher.publisher_name, PromotionDetail.percent_discount
	from (
		select Promotion.promotion_id 
		from Promotion
		where GETDATE() >= Promotion.promotion_start_date and GETDATE() <= Promotion.promotion_end_date
	) Promotion 
	join PromotionDetail on Promotion.promotion_id = PromotionDetail.promotion_id
	right join Book on PromotionDetail.isbn = Book.isbn
	left join BookType on Book.book_type_id = BookType.book_type_id
	left join Publisher on Book.publisher_id = Publisher.publisher_id
	;
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_best_seller_book]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_best_seller_book](@top int, @month int)
returns table
as
return
	select Book.*, BookType.book_type_name, Publisher.publisher_name, PromotionDetail.percent_discount
	from (
		select Promotion.promotion_id 
		from Promotion
		where GETDATE() >= Promotion.promotion_start_date and GETDATE() <= Promotion.promotion_end_date
	) Promotion
	join PromotionDetail on Promotion.promotion_id = PromotionDetail.promotion_id
	right join 
	(
		select top(@top) B1.isbn, sum(C1.quantity) as quantity
		from Book B1
		join CartDetail C1 on B1.isbn = c1.isbn
		join (select cart_id 
				from Cart 
				where DATEDIFF(month, getdate(), Cart.order_cart_time) <= @month and Cart.status_id = 3
			  ) C on C.cart_id = C1.cart_id
		group by B1.isbn
		order by sum(C1.quantity) desc
	) best_seller on best_seller.isbn = PromotionDetail.isbn
	join Book on best_seller.isbn = Book.isbn
	left join BookType on Book.book_type_id = BookType.book_type_id
	left join Publisher on Book.publisher_id = Publisher.publisher_id
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_book_by_name]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_book_by_name](@bookname nvarchar(256))
returns table
as
return
	select Book.*, BookType.book_type_name, Publisher.publisher_name, PromotionDetail.percent_discount
	from (
		select Promotion.promotion_id 
		from Promotion
		where GETDATE() >= Promotion.promotion_start_date and GETDATE() <= Promotion.promotion_end_date
	) Promotion
	left join PromotionDetail on Promotion.promotion_id = PromotionDetail.promotion_id
	right join Book on PromotionDetail.isbn = Book.isbn
	left join BookType on Book.book_type_id = BookType.book_type_id
	left join Publisher on Book.publisher_id = Publisher.publisher_id
	where dbo.remove_mark(book_name) like '%'+dbo.remove_mark(@bookname)+'%' or book_name like '%'+@bookname+'%';
GO
/****** Object:  Table [dbo].[Department]    Script Date: 9/6/2022 10:32:05 PM ******/
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
/****** Object:  Table [dbo].[Roles]    Script Date: 9/6/2022 10:32:05 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[get_list_staff]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_staff]()
returns table
as
return
	select Staff.*, Department.department_name, Roles.*
	from Staff
	left join Department on Staff.department_id = Department.department_id
	left join Account on Account.account = Staff.account
	left join Roles on Account.role_id = Roles.role_id;
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_customer]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_customer]()
returns table
as
return
	select Customer.*
	from Customer;
GO
/****** Object:  UserDefinedFunction [dbo].[customer_login]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[customer_login](@account varchar(32), @password varchar(32))
returns table
as
return
	select Customer.customer_id, Customer.last_name, Customer.first_name,
	Customer.address, Customer.phone_number, Customer.email,
	Account.role_id, Roles.role_name
	from Account 
	left join Customer on Account.account = Customer.account
	left join Roles on Account.role_id = Roles.role_id
	where Account.account = @account and Account.password = @password and Account.role_id = 4;
GO
/****** Object:  UserDefinedFunction [dbo].[staff_login]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[staff_login](@account varchar(32), @password varchar(32))
returns table
as
return
	select Staff.staff_id, Staff.last_name, Staff.first_name, Account.role_id, Roles.role_name
	from Account 
	left join Staff on Account.account = Staff.account
	left join Roles on Account.role_id = Roles.role_id
	where Account.account = @account and Account.password = @password and Account.role_id != 4;
GO
/****** Object:  UserDefinedFunction [dbo].[get_list_book_by_id]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[get_list_book_by_id](@isbn nvarchar(32))
returns table
as
return
	select Book.*, BookType.book_type_name, Publisher.publisher_name, PromotionDetail.percent_discount
	from (
		select Promotion.promotion_id 
		from Promotion
		where GETDATE() >= Promotion.promotion_start_date and GETDATE() <= Promotion.promotion_end_date
	) Promotion
	left join PromotionDetail on Promotion.promotion_id = PromotionDetail.promotion_id
	right join Book on PromotionDetail.isbn = Book.isbn
	left join BookType on Book.book_type_id = BookType.book_type_id
	left join Publisher on Book.publisher_id = Publisher.publisher_id
	where Book.isbn = @isbn;
GO
/****** Object:  Table [dbo].[Author]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Author](
	[author_id] [varchar](16) NOT NULL,
	[last_name] [nvarchar](64) NULL,
	[first_name] [nvarchar](64) NULL,
	[gender] [bit] NULL,
	[date_of_birth] [date] NULL,
	[phone_number] [varchar](16) NULL,
	[address] [nvarchar](255) NULL,
	[email] [varchar](64) NULL,
 CONSTRAINT [PK__Author__86516BCFEF098801] PRIMARY KEY CLUSTERED 
(
	[author_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Compositions]    Script Date: 9/6/2022 10:32:05 PM ******/
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
/****** Object:  Table [dbo].[ImportNote]    Script Date: 9/6/2022 10:32:05 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ImportNoteDetail]    Script Date: 9/6/2022 10:32:05 PM ******/
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
/****** Object:  Table [dbo].[Invoice]    Script Date: 9/6/2022 10:32:05 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderPublisher]    Script Date: 9/6/2022 10:32:05 PM ******/
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
/****** Object:  Table [dbo].[OrderPublisherDetail]    Script Date: 9/6/2022 10:32:05 PM ******/
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
/****** Object:  Table [dbo].[PriceUpdateDetail]    Script Date: 9/6/2022 10:32:05 PM ******/
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
/****** Object:  Table [dbo].[ReturnNote]    Script Date: 9/6/2022 10:32:05 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Account] ([account], [password], [role_id]) VALUES (N'anhcute0102', N'882f0174a02077e9f13551fa7a6ecf0e', 3)
INSERT [dbo].[Account] ([account], [password], [role_id]) VALUES (N'anhngoc43', N'882f0174a02077e9f13551fa7a6ecf0e', 3)
INSERT [dbo].[Account] ([account], [password], [role_id]) VALUES (N'cisco', N'123456', 1)
INSERT [dbo].[Account] ([account], [password], [role_id]) VALUES (N'hoai3011', N'882f0174a02077e9f13551fa7a6ecf0e', 3)
INSERT [dbo].[Account] ([account], [password], [role_id]) VALUES (N'nvl1682', N'882f0174a02077e9f13551fa7a6ecf0e', 4)
INSERT [dbo].[Account] ([account], [password], [role_id]) VALUES (N'phuonghoai12', N'882f0174a02077e9f13551fa7a6ecf0e', 4)
INSERT [dbo].[Account] ([account], [password], [role_id]) VALUES (N'thangdracu', N'123456', 4)
INSERT [dbo].[Account] ([account], [password], [role_id]) VALUES (N'thanhhienm4', N'882f0174a02077e9f13551fa7a6ecf0e', 2)
GO
INSERT [dbo].[Author] ([author_id], [last_name], [first_name], [gender], [date_of_birth], [phone_number], [address], [email]) VALUES (N'ANT_EXUPERY', N'Antoine ', N'de Saint Exupéry', 1, CAST(N'1954-07-10' AS Date), N'0928391123', N'Russia', N'exupery0710@gmail.com')
INSERT [dbo].[Author] ([author_id], [last_name], [first_name], [gender], [date_of_birth], [phone_number], [address], [email]) VALUES (N'GE_AKUTAMI', N'GEGE', N'AKUTAMI', 1, CAST(N'1992-02-26' AS Date), N'0918291829', N'Iwate', N'gege_akutami@studio.com')
INSERT [dbo].[Author] ([author_id], [last_name], [first_name], [gender], [date_of_birth], [phone_number], [address], [email]) VALUES (N'HEC_MALOT', N'Hector', N'Malot', 0, CAST(N'1956-05-05' AS Date), N'0928391829', N'United Kingdom', N'hec_malot05@gmail.com')
INSERT [dbo].[Author] ([author_id], [last_name], [first_name], [gender], [date_of_birth], [phone_number], [address], [email]) VALUES (N'MAI_LEO', N'Mai', N'Leo', 0, CAST(N'1979-01-17' AS Date), N'0911198737', N'22 Hoàng Văn Thụ, Phú Nhuận, Hồ Chí Minh', N'leo373@book.com')
INSERT [dbo].[Author] ([author_id], [last_name], [first_name], [gender], [date_of_birth], [phone_number], [address], [email]) VALUES (N'MOM_RUBY', N'M?', N'Ruby', 0, CAST(N'1977-02-18' AS Date), N'0911198736', N'39 Cộng Hòa, Tân Bình, Hồ Chí Minh', N'meruby@book.com')
INSERT [dbo].[Author] ([author_id], [last_name], [first_name], [gender], [date_of_birth], [phone_number], [address], [email]) VALUES (N'NG_HANG', N'Nguyễn', N'Thu Hằng', 0, CAST(N'1989-02-03' AS Date), N'0918291223', N'Quảng Ning', N'th_hang03@gmail.com')
INSERT [dbo].[Author] ([author_id], [last_name], [first_name], [gender], [date_of_birth], [phone_number], [address], [email]) VALUES (N'NG_TU', N'Nguyễn', N'Đình Tú', 1, CAST(N'1977-03-06' AS Date), N'0911223123', N'99 Tô Vĩnh Diện, Thủ Đức, TPHCM', N'tu_nguyen1_a@gmail.com')
INSERT [dbo].[Author] ([author_id], [last_name], [first_name], [gender], [date_of_birth], [phone_number], [address], [email]) VALUES (N'NG_TUAN', N'Nguyễn', N'Phú Tuấn', 1, CAST(N'1955-05-25' AS Date), N'0918291111', N'34 Trần Hưng Đạo, Quận 1, TPHCM', N'phutuan34@gmail.com')
INSERT [dbo].[Author] ([author_id], [last_name], [first_name], [gender], [date_of_birth], [phone_number], [address], [email]) VALUES (N'PEN_FAN', N'PENG', N'FAN', 1, CAST(N'1990-02-02' AS Date), N'0901987223', N'Singapore', N'pengfan1990@book.com')
INSERT [dbo].[Author] ([author_id], [last_name], [first_name], [gender], [date_of_birth], [phone_number], [address], [email]) VALUES (N'QU_DUNG', N'Quang', N'Dũng', 1, CAST(N'1959-02-23' AS Date), N'0918291211', N'Hà Nam', N'dungquang03@gmail.com')
INSERT [dbo].[Author] ([author_id], [last_name], [first_name], [gender], [date_of_birth], [phone_number], [address], [email]) VALUES (N'THU_DUNG', N'Thùy', N'Dung', 0, CAST(N'1977-09-09' AS Date), N'0911198776', N'12 Nguyễn Văn Linh, Q7, Hồ Chí Minh', N'thuydung09@book.com')
INSERT [dbo].[Author] ([author_id], [last_name], [first_name], [gender], [date_of_birth], [phone_number], [address], [email]) VALUES (N'TR_TAN', N'Trần', N'Nhựt Tân', 1, CAST(N'1972-01-05' AS Date), N'0911000111', N'115 Nguyễn Du, Quảng Nam', N'nhattan05@gmail.com')
INSERT [dbo].[Author] ([author_id], [last_name], [first_name], [gender], [date_of_birth], [phone_number], [address], [email]) VALUES (N'VG_NHAM', N'Vương', N'Thanh Nhậm', 1, CAST(N'1103-03-06' AS Date), N'', N'Nhà Thanh', N'')
GO
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-2-23830-4', N'CÂY GẠO CÕNG MẶT TRỜI', N'gao_cong_mat_troi.jpg', 108, 27000.0000, N'2018', 103, 0, N'VHVN', N'KIMDONG')
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-2-23931-4', N'KÍNH SỢ VÀ RUN RẨY', N'kinh-so-va-run-ray.jpg', 308, 135000.0000, N'1996', 5, 1, N'TL_TL_TG', N'HONGDUC')
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-2-26123-5', N'Tâm lý học', N'tam-ly-hoc.jpg', 65, 49000.0000, N'2021', 0, 1, N'TL_TL_TG', N'HONGDUC')
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-2-26314-6', N'Không gia đình', N'khong-gia-dinh.jpg', 464, 150000.0000, N'2018', 34, 1, N'VHNN', N'KIMDONG')
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-2-26812-7', N'CHÚ THUẬT HỒI CHIẾN - TẬP 1 - BẢN THƯỜNG', N'chu-thuat-1.jpg', 200, 30000.0000, N'2021', 86, 0, N'MGCM', N'KIMDONG')
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-2-26930-8', N'BÁCH KHOA THƯ KĨ NĂNG SỐNG - DÀNH CHO BẠN TRAI - TUYỆT CHIÊU HỌC TẬP', N'tuyet-chieu-hoc-tap.jpg', 176, 75000.0000, N'2020', 63, 0, N'TN', N'KIMDONG')
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-2-27192-9', N'ĐẤT NƯỚC GẤM HOA - ATLAS VIỆT NAM', N'1662050193714dat-nuoc-gam-hoa.jpg', 172, 315000.0000, N'2022', 10, 1, N'VHXHLS', N'KIMDONG')
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-2-27204-9', N'ĐOÀN BINH TÂY TIẾN', N'doan-binh-tay-tien.jpg', 124, 45000.0000, N'2003', 93, 0, N'VHVN', N'KIMDONG')
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-2-27206-3', N'Hoàng tử bé', N'hoang-tu-be.jpg', 144, 160000.0000, N'2008', 0, 1, N'VHNN', N'KIMDONG')
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-2-27304-6', N'ONE PIECE - TẬP 100', N'1661268705996one_piece_tap_100.jpg', 212, 120000.0000, N'2022', 97, 1, N'MGCM', N'KIMDONG')
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-2-27347-3', N'HỎI ĐÁP VỀ THẾ GIỚI - ĐỘNG VẬT KÌ THÚ', N'dong-vat-ki-thu.jpg', 64, 64000.0000, N'2020', 49, 0, N'TN', N'KIMDONG')
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-2-27367-1', N'NHỮNG ĐỨA TRẺ HẠNH PHÚC - LÀ CHÍNH MÌNH - BẠN NHỎ DÂN TỘC KINH', N'1662473422289la-chinh-minh.jpg', 20, 25000.0000, N'2021', 5, 1, N'TN', N'KIMDONG')
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-3-14223-5', N'Chuyện của lính', N'chuyen-cua-linh.jpg', 156, 60000.0000, N'2003', 93, 0, N'VHVN', N'THANHNIEN')
INSERT [dbo].[Book] ([isbn], [book_name], [image], [pages], [price], [release_year], [quantity_in_stock], [is_new], [book_type_id], [publisher_id]) VALUES (N'978-604-5-26812-9', N'Y LÂM CẢI THÁC', N'y-lam-cai-thac.jpg', 234, 80000.0000, N'2000', 92, 1, N'YH_SK', N'LAODONG')
GO
INSERT [dbo].[BookType] ([book_type_id], [book_type_name]) VALUES (N'CTPL', N'Chính trị - Pháp luật')
INSERT [dbo].[BookType] ([book_type_id], [book_type_name]) VALUES (N'GT', N'Giáo trình')
INSERT [dbo].[BookType] ([book_type_id], [book_type_name]) VALUES (N'KHCNKT', N'Khoa học công nghệ - Kinh tế')
INSERT [dbo].[BookType] ([book_type_id], [book_type_name]) VALUES (N'MGCM', N'Manga - Comic')
INSERT [dbo].[BookType] ([book_type_id], [book_type_name]) VALUES (N'VHDL', N'Sách Văn hóa - Du lịch')
INSERT [dbo].[BookType] ([book_type_id], [book_type_name]) VALUES (N'YH_SK', N'Sách Y học - Sức khỏe')
INSERT [dbo].[BookType] ([book_type_id], [book_type_name]) VALUES (N'TL_TL_TG', N'Tâm lý - Tâm linh - Tôn giáo')
INSERT [dbo].[BookType] ([book_type_id], [book_type_name]) VALUES (N'TN', N'Thiếu nhi')
INSERT [dbo].[BookType] ([book_type_id], [book_type_name]) VALUES (N'T_TT', N'Truyện - Tiểu thuyết')
INSERT [dbo].[BookType] ([book_type_id], [book_type_name]) VALUES (N'VHNT', N'Văn học nghệ thuật')
INSERT [dbo].[BookType] ([book_type_id], [book_type_name]) VALUES (N'VHNN', N'Văn học nước ngoài')
INSERT [dbo].[BookType] ([book_type_id], [book_type_name]) VALUES (N'VHVN', N'Văn học Việt Nam')
INSERT [dbo].[BookType] ([book_type_id], [book_type_name]) VALUES (N'VHXHLS', N'Văn học xã hội - Lịch sử')
GO
SET IDENTITY_INSERT [dbo].[Cart] ON 

INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (1, CAST(N'2022-07-13T23:14:31.757' AS DateTime), CAST(N'2022-07-16T22:13:16.040' AS DateTime), N'Nguyễn', N'Quốc Thắng', N'120 Lê Văn Việt, Thủ Đức, Hồ Chí Minh', N'0949618231', N'dracuthang@gmail.com', CAST(N'2022-07-13T23:21:36.993' AS DateTime), 3, N'CUSTOMER_1', N'Staff_1', N'STAFF_3')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (2, CAST(N'2022-07-20T16:11:36.740' AS DateTime), CAST(N'2022-07-20T16:11:36.740' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', CAST(N'2022-07-20T16:17:23.327' AS DateTime), 3, N'CUSTOMER_2', N'Staff_1', N'STAFF_3')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (4, CAST(N'2022-07-20T16:15:21.687' AS DateTime), CAST(N'2022-07-20T16:15:21.687' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', CAST(N'2022-07-20T16:17:23.327' AS DateTime), 3, N'CUSTOMER_2', N'Staff_1', N'STAFF_3')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (5, CAST(N'2022-07-20T16:19:03.010' AS DateTime), CAST(N'2022-07-20T16:19:03.010' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (7, CAST(N'2022-07-21T21:35:23.513' AS DateTime), CAST(N'2022-07-21T21:35:23.513' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (9, CAST(N'2022-07-23T14:30:54.867' AS DateTime), CAST(N'2022-07-23T14:30:54.867' AS DateTime), N'Nguyễn', N'Quoc Thang', N'110 Chương Dương, HCM', N'0987271334', N'nvl1682@gmail.com1', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (10, CAST(N'2022-07-23T14:32:07.617' AS DateTime), CAST(N'2022-07-23T14:32:07.617' AS DateTime), N'Nguyễn', N'Quoc Thang', N'110 Chương Dương, HCM', N'0987271334', N'nvl1682@gmail.com1', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (12, CAST(N'2022-07-23T14:33:26.310' AS DateTime), CAST(N'2022-07-23T14:33:26.310' AS DateTime), N'Nguyễn', N'Quoc Thang', N'110 Chương Dương, HCM', N'0987271334', N'nvl1682@gmail.com1', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (13, CAST(N'2022-07-23T14:42:42.130' AS DateTime), CAST(N'2022-07-23T14:42:42.130' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (14, CAST(N'2022-07-23T14:46:44.713' AS DateTime), CAST(N'2022-07-23T14:46:44.713' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (15, CAST(N'2022-07-23T14:49:32.793' AS DateTime), CAST(N'2022-07-23T14:49:32.793' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (17, CAST(N'2022-07-23T14:59:56.310' AS DateTime), CAST(N'2022-07-23T14:59:56.310' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (18, CAST(N'2022-07-23T15:00:40.520' AS DateTime), CAST(N'2022-07-23T15:00:40.520' AS DateTime), N'Nguyễn', N'Quốc Thắng', N'110 Lê Văn Việt, Thủ Đức', N'0987271111', N'thnag111@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (19, CAST(N'2022-07-23T16:59:50.830' AS DateTime), CAST(N'2022-07-23T16:59:50.830' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (23, CAST(N'2022-07-23T21:10:56.123' AS DateTime), CAST(N'2022-07-23T21:10:56.123' AS DateTime), N'Nguyễn', N'Văn Long', N'118 Chương Dương, Thủ Đức', N'0987271212', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (25, CAST(N'2022-07-23T21:25:38.117' AS DateTime), CAST(N'2022-07-23T21:25:38.117' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (26, CAST(N'2022-07-23T21:27:29.927' AS DateTime), CAST(N'2022-07-23T21:27:29.927' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (27, CAST(N'2022-07-23T21:33:04.743' AS DateTime), CAST(N'2022-07-23T21:33:04.743' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (28, CAST(N'2022-07-23T21:34:23.407' AS DateTime), CAST(N'2022-07-23T21:34:23.407' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (29, CAST(N'2022-07-23T21:41:27.003' AS DateTime), CAST(N'2022-07-23T21:41:27.003' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (30, CAST(N'2022-07-23T21:43:01.440' AS DateTime), CAST(N'2022-07-23T21:43:01.440' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (31, CAST(N'2022-07-23T21:50:03.650' AS DateTime), CAST(N'2022-08-06T16:22:46.387' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 2, N'CUSTOMER_2', N'STAFF_1', N'STAFF_4')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (32, CAST(N'2022-07-23T21:51:46.683' AS DateTime), CAST(N'2022-07-31T09:20:26.820' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 2, N'CUSTOMER_2', N'STAFF_1', N'STAFF_5')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (33, CAST(N'2022-07-23T23:03:55.560' AS DateTime), CAST(N'2022-08-23T21:04:07.630' AS DateTime), N'Trần', N'Quốc Bảo', N'100 Tô Vĩnh Diện, Linh Chiểu, Thủ Đức', N'0948672123', N'tranquocb306@gmail.com', CAST(N'2022-08-23T21:04:07.630' AS DateTime), 3, N'CUSTOMER_2', N'STAFF_1', N'STAFF_3')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (34, CAST(N'2022-07-23T23:23:47.040' AS DateTime), CAST(N'2022-07-30T22:48:23.920' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 2, N'CUSTOMER_2', N'STAFF_1', N'STAFF_4')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (35, CAST(N'2022-07-24T08:12:47.377' AS DateTime), CAST(N'2022-07-30T22:33:36.423' AS DateTime), N'Nguyễn', N'Trung', N'11 Nguyễn Đình Chiểu, Quận 1', N'0987271444', N'htrung11@gmail.com', NULL, 2, N'CUSTOMER_2', N'STAFF_1', N'STAFF_4')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (36, CAST(N'2022-06-29T00:00:00.000' AS DateTime), CAST(N'2022-07-31T08:37:12.877' AS DateTime), N'Văn', N'Thị Hoài Phương', N'141 Lê Duẩn, Quận 5, TPHCM', N'0912876999', N'phuonghoai12@gmail.com', NULL, 3, N'CUSTOMER_3', N'STAFF_1', N'STAFF_3')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (37, CAST(N'2022-05-31T00:00:00.000' AS DateTime), CAST(N'2022-08-23T20:55:36.843' AS DateTime), N'Văn', N'Thị Hoài Phương', N'141 Lê Duẩn, Quận 5, TPHCM', N'0912876999', N'phuonghoai12@gmail.com', CAST(N'2022-08-23T20:55:36.843' AS DateTime), 3, N'CUSTOMER_3', N'STAFF_1', N'STAFF_3')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (38, CAST(N'2022-08-07T09:40:48.343' AS DateTime), CAST(N'2022-08-07T09:41:15.210' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 2, N'CUSTOMER_2', N'STAFF_1', N'STAFF_4')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (39, CAST(N'2022-08-07T10:17:53.947' AS DateTime), CAST(N'2022-08-07T10:18:11.483' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 2, N'CUSTOMER_2', N'STAFF_1', N'STAFF_5')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (40, CAST(N'2022-08-17T22:47:17.287' AS DateTime), CAST(N'2022-08-17T22:47:17.287' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (41, CAST(N'2022-08-20T16:48:40.633' AS DateTime), CAST(N'2022-08-20T16:48:40.633' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 1, N'CUSTOMER_2', NULL, NULL)
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (46, CAST(N'2022-08-20T17:26:21.460' AS DateTime), CAST(N'2022-09-06T21:59:16.487' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 2, N'CUSTOMER_2', N'STAFF_2', N'STAFF_4')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (47, CAST(N'2022-08-20T17:27:38.350' AS DateTime), CAST(N'2022-09-06T22:20:54.037' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', CAST(N'2022-09-06T22:20:54.037' AS DateTime), 3, N'CUSTOMER_2', N'STAFF_1', N'STAFF_5')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (48, CAST(N'2022-09-01T17:28:06.720' AS DateTime), CAST(N'2022-08-27T16:34:57.220' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', NULL, 2, N'CUSTOMER_2', N'STAFF_1', N'STAFF_3')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (49, CAST(N'2022-09-01T23:27:16.790' AS DateTime), CAST(N'2022-09-01T23:33:08.943' AS DateTime), N'Nguyễn', N'Văn Long', N'110 Chương Dương, Thủ Đức', N'0987271333', N'nvl1682@gmail.com', CAST(N'2022-09-01T23:33:08.943' AS DateTime), 3, N'CUSTOMER_2', N'STAFF_1', N'STAFF_5')
INSERT [dbo].[Cart] ([cart_id], [order_cart_time], [last_update_time], [last_name_receive], [first_name_receive], [address_receive], [phone_number_receive], [email], [date_receive], [status_id], [customer_id], [staff_id_confirm], [staff_id_deliver]) VALUES (50, CAST(N'2022-09-06T22:17:31.530' AS DateTime), CAST(N'2022-09-06T22:19:19.757' AS DateTime), N'Nguyễn', N'Thị Bình Minh', N'VNG Campus', N'0987271999', N'', NULL, 2, N'CUSTOMER_2', N'STAFF_2', N'STAFF_5')
SET IDENTITY_INSERT [dbo].[Cart] OFF
GO
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (1, N'978-604-2-23830-4', 24300.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (1, N'978-604-2-26123-5', 49000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (1, N'978-604-2-26812-7', 30000.0000, 5, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (1, N'978-604-2-27204-9', 40500.0000, 3, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (1, N'978-604-3-14223-5', 54000.0000, 4, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (1, N'978-604-5-26812-9', 30000.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (2, N'978-604-2-26812-7', 30000.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (2, N'978-604-2-27206-3', 128000.0000, 3, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (4, N'978-604-2-23830-4', 27000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (4, N'978-604-2-27204-9', 45000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (5, N'978-604-2-27347-3', 64000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (7, N'978-604-2-26314-6', 124000.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (7, N'978-604-2-27206-3', 160000.0000, 8, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (9, N'978-604-2-27206-3', 128000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (9, N'978-604-2-27347-3', 64000.0000, 5, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (10, N'978-604-2-27206-3', 128000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (10, N'978-604-2-27347-3', 64000.0000, 5, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (12, N'978-604-2-27206-3', 128000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (12, N'978-604-2-27347-3', 64000.0000, 5, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (13, N'978-604-2-26123-5', 49000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (13, N'978-604-3-14223-5', 54000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (14, N'978-604-3-14223-5', 54000.0000, 8, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (15, N'978-604-2-23830-4', 24300.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (15, N'978-604-2-27204-9', 40500.0000, 4, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (15, N'978-604-5-26812-9', 80000.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (17, N'978-604-2-26812-7', 30000.0000, 5, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (17, N'978-604-2-27206-3', 128000.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (17, N'978-604-5-26812-9', 80000.0000, 3, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (18, N'978-604-2-27204-9', 40500.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (18, N'978-604-2-27347-3', 64000.0000, 3, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (19, N'978-604-2-26812-7', 30000.0000, 3, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (23, N'978-604-2-27347-3', 64000.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (23, N'978-604-5-26812-9', 80000.0000, 5, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (25, N'978-604-2-26930-8', 75000.0000, 3, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (25, N'978-604-2-27206-3', 128000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (26, N'978-604-2-26930-8', 75000.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (27, N'978-604-3-14223-5', 54000.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (28, N'978-604-2-27347-3', 64000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (29, N'978-604-2-27347-3', 64000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (30, N'978-604-2-26930-8', 75000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (30, N'978-604-2-27347-3', 64000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (31, N'978-604-2-26123-5', 49000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (31, N'978-604-2-26314-6', 120000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (32, N'978-604-2-26812-7', 30000.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (32, N'978-604-2-27204-9', 40500.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (33, N'978-604-2-26123-5', 49000.0000, 7, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (33, N'978-604-2-27206-3', 128000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (33, N'978-604-3-14223-5', 54000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (34, N'978-604-2-26314-6', 120000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (35, N'978-604-2-26812-7', 30000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (35, N'978-604-2-26930-8', 75000.0000, 3, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (35, N'978-604-2-27204-9', 40500.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (36, N'978-604-5-26812-9', 80000.0000, 3, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (37, N'978-604-2-27206-3', 160000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (37, N'978-604-5-26812-9', 80000.0000, 3, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (38, N'978-604-2-26314-6', 120000.0000, 12, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (39, N'978-604-2-26930-8', 75000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (40, N'978-604-2-26314-6', 120000.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (40, N'978-604-2-26812-7', 30000.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (40, N'978-604-2-26930-8', 75000.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (41, N'978-604-2-26314-6', 120000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (46, N'978-604-2-27204-9', 40500.0000, 5, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (47, N'978-604-2-26812-7', 30000.0000, 5, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (48, N'978-604-5-26812-9', 80000.0000, 3, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (49, N'978-604-2-26314-6', 120000.0000, 2, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (49, N'978-604-2-26812-7', 30000.0000, 1, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (49, N'978-604-2-27304-6', 120000.0000, 3, NULL, NULL)
INSERT [dbo].[CartDetail] ([cart_id], [isbn], [price], [quantity], [return_quantity], [return_note_id]) VALUES (50, N'978-604-2-27347-3', 64000.0000, 3, NULL, NULL)
GO
INSERT [dbo].[Compositions] ([author_id], [isbn]) VALUES (N'ANT_EXUPERY', N'978-604-2-27206-3')
INSERT [dbo].[Compositions] ([author_id], [isbn]) VALUES (N'GE_AKUTAMI', N'978-604-2-26812-7')
INSERT [dbo].[Compositions] ([author_id], [isbn]) VALUES (N'HEC_MALOT', N'978-604-2-26314-6')
INSERT [dbo].[Compositions] ([author_id], [isbn]) VALUES (N'MAI_LEO', N'978-604-2-27347-3')
INSERT [dbo].[Compositions] ([author_id], [isbn]) VALUES (N'MOM_RUBY', N'978-604-2-27347-3')
INSERT [dbo].[Compositions] ([author_id], [isbn]) VALUES (N'NG_HANG', N'978-604-2-23830-4')
INSERT [dbo].[Compositions] ([author_id], [isbn]) VALUES (N'NG_TUAN', N'978-604-3-14223-5')
INSERT [dbo].[Compositions] ([author_id], [isbn]) VALUES (N'PEN_FAN', N'978-604-2-26930-8')
INSERT [dbo].[Compositions] ([author_id], [isbn]) VALUES (N'QU_DUNG', N'978-604-2-27204-9')
INSERT [dbo].[Compositions] ([author_id], [isbn]) VALUES (N'THU_DUNG', N'978-604-2-27347-3')
INSERT [dbo].[Compositions] ([author_id], [isbn]) VALUES (N'TR_TAN', N'978-604-2-26123-5')
INSERT [dbo].[Compositions] ([author_id], [isbn]) VALUES (N'VG_NHAM', N'978-604-5-26812-9')
GO
INSERT [dbo].[Customer] ([customer_id], [last_name], [first_name], [gender], [address], [date_of_birth], [phone_number], [email], [tax], [account]) VALUES (N'CUSTOMER_1', N'Nguyễn', N'Quốc Thắng', 1, N'120 Lê Văn Việt, Thủ Đức, Hồ Chí Minh', CAST(N'2000-05-25' AS Date), N'0949618231', N'dracuthang@gmail.com', N'12344442123123', N'thangdracu')
INSERT [dbo].[Customer] ([customer_id], [last_name], [first_name], [gender], [address], [date_of_birth], [phone_number], [email], [tax], [account]) VALUES (N'CUSTOMER_2', N'Nguyễn', N'Văn Long', 1, N'110 Chương Dương, Thủ Đức', CAST(N'2000-08-16' AS Date), N'0987271333', N'nvl1682@gmail.com', N'ahduh123678123', N'nvl1682')
INSERT [dbo].[Customer] ([customer_id], [last_name], [first_name], [gender], [address], [date_of_birth], [phone_number], [email], [tax], [account]) VALUES (N'CUSTOMER_3', N'Văn', N'Thị Hoài Phương', 0, N'141 Lê Duẩn, Quận 5, TPHCM', CAST(N'2000-12-12' AS Date), N'0912876999', N'phuonghoai12@gmail.com', N'au90912joif2193a', N'phuonghoai12')
GO
INSERT [dbo].[Department] ([department_id], [department_name]) VALUES (N'dept_account', N'Phòng kế toán')
INSERT [dbo].[Department] ([department_id], [department_name]) VALUES (N'dept_manager', N'Phòng quản lý')
INSERT [dbo].[Department] ([department_id], [department_name]) VALUES (N'dept_shipper', N'Phòng vận chuyển')
GO
INSERT [dbo].[ExchangeRate] ([exchange_id], [exchange_date_apply], [exchange_value], [staff_id_update]) VALUES (N'USD', CAST(N'2022-08-28T15:09:37.493' AS DateTime), 22500.0000, N'STAFF_1')
INSERT [dbo].[ExchangeRate] ([exchange_id], [exchange_date_apply], [exchange_value], [staff_id_update]) VALUES (N'USD', CAST(N'2022-08-28T15:09:43.920' AS DateTime), 23000.0000, N'STAFF_1')
GO
INSERT [dbo].[Promotion] ([promotion_id], [promotion_name], [promotion_start_date], [promotion_end_date], [promotion_reason], [staff_id_create]) VALUES (1, N'Hè bổ ích, tiếp thu nhiều giảm nhiều', CAST(N'2022-07-12T00:00:00.000' AS DateTime), CAST(N'2022-08-15T00:00:00.000' AS DateTime), N'Giảm 10% đối với các sách thuộc thể loại văn học khi ghé mua từ ngày 12/07/2022 đến 15/05/2022', N'STAFF_1')
INSERT [dbo].[Promotion] ([promotion_id], [promotion_name], [promotion_start_date], [promotion_end_date], [promotion_reason], [staff_id_create]) VALUES (2, N'Trung Thu', CAST(N'2022-09-01T00:00:00.000' AS DateTime), CAST(N'2022-09-15T00:00:00.000' AS DateTime), N'Nhân ngày Quốc Khánh', N'STAFF_1')
GO
INSERT [dbo].[PromotionDetail] ([promotion_id], [isbn], [percent_discount]) VALUES (1, N'978-604-2-23830-4', 10)
INSERT [dbo].[PromotionDetail] ([promotion_id], [isbn], [percent_discount]) VALUES (1, N'978-604-2-26314-6', 20)
INSERT [dbo].[PromotionDetail] ([promotion_id], [isbn], [percent_discount]) VALUES (1, N'978-604-2-27204-9', 10)
INSERT [dbo].[PromotionDetail] ([promotion_id], [isbn], [percent_discount]) VALUES (1, N'978-604-2-27206-3', 20)
INSERT [dbo].[PromotionDetail] ([promotion_id], [isbn], [percent_discount]) VALUES (1, N'978-604-3-14223-5', 10)
INSERT [dbo].[PromotionDetail] ([promotion_id], [isbn], [percent_discount]) VALUES (2, N'978-604-2-27206-3', 50)
INSERT [dbo].[PromotionDetail] ([promotion_id], [isbn], [percent_discount]) VALUES (2, N'978-604-2-27304-6', 30)
GO
INSERT [dbo].[Publisher] ([publisher_id], [publisher_name], [address], [phone_number], [email]) VALUES (N'HONGDUC', N'Nhà xuất bản Hồng Đức', N'5', N'0919873829', N'nxbhongduc@gmail.com')
INSERT [dbo].[Publisher] ([publisher_id], [publisher_name], [address], [phone_number], [email]) VALUES (N'KIMDONG', N'Kim Đồng', N'1', N'0929182391', N'nxbkimdong@gmail.com')
INSERT [dbo].[Publisher] ([publisher_id], [publisher_name], [address], [phone_number], [email]) VALUES (N'LAODONG', N'Nhà xuất bản Lao động', N'3', N'0911664532', N'nxblaodong@gmail.com')
INSERT [dbo].[Publisher] ([publisher_id], [publisher_name], [address], [phone_number], [email]) VALUES (N'SUTHAT', N'Nhà xuất bản Sự thật', N'5', N'0900918293', N'nxbsuthat@gmail.com')
INSERT [dbo].[Publisher] ([publisher_id], [publisher_name], [address], [phone_number], [email]) VALUES (N'THANHNIEN', N'Nhà xuất bản Thanh Niên', N'1', N'0923153412', N'nxbthanhnien@gmail.com')
GO
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([role_id], [role_name]) VALUES (1, N'Admin')
INSERT [dbo].[Roles] ([role_id], [role_name]) VALUES (2, N'Nhân viên')
INSERT [dbo].[Roles] ([role_id], [role_name]) VALUES (3, N'Giao hàng')
INSERT [dbo].[Roles] ([role_id], [role_name]) VALUES (4, N'Khách hàng')
SET IDENTITY_INSERT [dbo].[Roles] OFF
GO
INSERT [dbo].[Staff] ([staff_id], [last_name], [first_name], [gender], [address], [date_of_birth], [phone_number], [email], [department_id], [account]) VALUES (N'STAFF_1', N'Trần', N'Quốc Bảo', 1, N'Tô Vĩnh Diện, Thủ Đức, Hồ Chí Minh', CAST(N'2000-06-30' AS Date), N'0949618234', N'tranquocb306@gmail.com', N'dept_manager', N'cisco')
INSERT [dbo].[Staff] ([staff_id], [last_name], [first_name], [gender], [address], [date_of_birth], [phone_number], [email], [department_id], [account]) VALUES (N'STAFF_2', N'Nguyễn', N'Thanh Hiền', 1, N'Đình Phong Phú, Quận 9', CAST(N'2000-01-07' AS Date), N'0987271283', N'thanhhienm4@gmail.com', N'dept_account', N'thanhhienm4')
INSERT [dbo].[Staff] ([staff_id], [last_name], [first_name], [gender], [address], [date_of_birth], [phone_number], [email], [department_id], [account]) VALUES (N'STAFF_3', N'Lê', N'Nhật Anh', 1, N'Đại học Bách Khóa TPHCM', CAST(N'2000-01-02' AS Date), N'0989876123', N'anhcute0102@gmail.com', N'dept_shipper', N'anhcute0102')
INSERT [dbo].[Staff] ([staff_id], [last_name], [first_name], [gender], [address], [date_of_birth], [phone_number], [email], [department_id], [account]) VALUES (N'STAFF_4', N'Trương', N'Thị Ngọc Ánh', 0, N'Sơn Trà, Đà Nẵng', CAST(N'2000-09-02' AS Date), N'0989876143', N'anhngoc43@gmail.com', N'dept_shipper', N'anhngoc43')
INSERT [dbo].[Staff] ([staff_id], [last_name], [first_name], [gender], [address], [date_of_birth], [phone_number], [email], [department_id], [account]) VALUES (N'STAFF_5', N'Văn', N'Thị Hoài', 0, N'129 Nguyễn Đình Chiểu, Quận 1, TPHCM', CAST(N'2000-11-30' AS Date), N'0989876179', N'hoai3011@gmail.com', N'dept_shipper', N'hoai3011')
GO
SET IDENTITY_INSERT [dbo].[StatusOrder] ON 

INSERT [dbo].[StatusOrder] ([status_id], [status_name]) VALUES (1, N'Chờ xác nhận')
INSERT [dbo].[StatusOrder] ([status_id], [status_name]) VALUES (2, N'Đang giao hàng')
INSERT [dbo].[StatusOrder] ([status_id], [status_name]) VALUES (3, N'Đã giao hàng')
INSERT [dbo].[StatusOrder] ([status_id], [status_name]) VALUES (4, N'Đã hủy')
SET IDENTITY_INSERT [dbo].[StatusOrder] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Author__AB6E61642ED0B365]    Script Date: 9/6/2022 10:32:05 PM ******/
ALTER TABLE [dbo].[Author] ADD  CONSTRAINT [UQ__Author__AB6E61642ED0B365] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Book__AFEBF551FCEF8211]    Script Date: 9/6/2022 10:32:05 PM ******/
ALTER TABLE [dbo].[Book] ADD UNIQUE NONCLUSTERED 
(
	[book_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__BookType__DE2384CCCC6569E7]    Script Date: 9/6/2022 10:32:05 PM ******/
ALTER TABLE [dbo].[BookType] ADD UNIQUE NONCLUSTERED 
(
	[book_type_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Customer__AB6E6164DB26D916]    Script Date: 9/6/2022 10:32:05 PM ******/
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [UQ__Customer__AB6E6164DB26D916] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Customer__EA162E11195302AF]    Script Date: 9/6/2022 10:32:05 PM ******/
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [UQ__Customer__EA162E11195302AF] UNIQUE NONCLUSTERED 
(
	[account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__ImportNo__2E0434EC944B992D]    Script Date: 9/6/2022 10:32:05 PM ******/
ALTER TABLE [dbo].[ImportNote] ADD UNIQUE NONCLUSTERED 
(
	[order_publisher_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Invoice__2EF52A26D5D178EB]    Script Date: 9/6/2022 10:32:05 PM ******/
ALTER TABLE [dbo].[Invoice] ADD UNIQUE NONCLUSTERED 
(
	[cart_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__ReturnNo__F58DFD48D80230C9]    Script Date: 9/6/2022 10:32:05 PM ******/
ALTER TABLE [dbo].[ReturnNote] ADD UNIQUE NONCLUSTERED 
(
	[invoice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Staff__AB6E616461EB2B13]    Script Date: 9/6/2022 10:32:05 PM ******/
ALTER TABLE [dbo].[Staff] ADD  CONSTRAINT [UQ__Staff__AB6E616461EB2B13] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Staff__EA162E1128C534C7]    Script Date: 9/6/2022 10:32:05 PM ******/
ALTER TABLE [dbo].[Staff] ADD  CONSTRAINT [UQ__Staff__EA162E1128C534C7] UNIQUE NONCLUSTERED 
(
	[account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Book] ADD  CONSTRAINT [DF__Book__is_new__29572725]  DEFAULT ((1)) FOR [is_new]
GO
ALTER TABLE [dbo].[Cart] ADD  CONSTRAINT [DF__Cart__order_cart__68487DD7]  DEFAULT (getdate()) FOR [order_cart_time]
GO
ALTER TABLE [dbo].[Cart] ADD  CONSTRAINT [DF_Cart_last_update_time]  DEFAULT (getdate()) FOR [last_update_time]
GO
ALTER TABLE [dbo].[ExchangeRate] ADD  DEFAULT (getdate()) FOR [exchange_date_apply]
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
ON UPDATE CASCADE
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
ALTER TABLE [dbo].[ExchangeRate]  WITH CHECK ADD  CONSTRAINT [fk_exchange_staff] FOREIGN KEY([staff_id_update])
REFERENCES [dbo].[Staff] ([staff_id])
GO
ALTER TABLE [dbo].[ExchangeRate] CHECK CONSTRAINT [fk_exchange_staff]
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
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK__Staff__departmen__74AE54BC] FOREIGN KEY([department_id])
REFERENCES [dbo].[Department] ([department_id])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK__Staff__departmen__74AE54BC]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [fk_account_employee] FOREIGN KEY([account])
REFERENCES [dbo].[Account] ([account])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [fk_account_employee]
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD  CONSTRAINT [CK_Book_Quantity] CHECK  (([quantity_in_stock]>=(0)))
GO
ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [CK_Book_Quantity]
GO
ALTER TABLE [dbo].[CartDetail]  WITH CHECK ADD  CONSTRAINT [CK_CartDetail_Price] CHECK  (([price]>(0)))
GO
ALTER TABLE [dbo].[CartDetail] CHECK CONSTRAINT [CK_CartDetail_Price]
GO
ALTER TABLE [dbo].[CartDetail]  WITH CHECK ADD  CONSTRAINT [CK_CartDetail_Quantity] CHECK  (([quantity]>(0)))
GO
ALTER TABLE [dbo].[CartDetail] CHECK CONSTRAINT [CK_CartDetail_Quantity]
GO
ALTER TABLE [dbo].[ImportNoteDetail]  WITH CHECK ADD  CONSTRAINT [CK_ImportNoteDetail_Price] CHECK  (([price]>(0)))
GO
ALTER TABLE [dbo].[ImportNoteDetail] CHECK CONSTRAINT [CK_ImportNoteDetail_Price]
GO
ALTER TABLE [dbo].[ImportNoteDetail]  WITH CHECK ADD  CONSTRAINT [CK_ImportNoteDetail_Quantity] CHECK  (([quantity]>(0)))
GO
ALTER TABLE [dbo].[ImportNoteDetail] CHECK CONSTRAINT [CK_ImportNoteDetail_Quantity]
GO
ALTER TABLE [dbo].[OrderPublisherDetail]  WITH CHECK ADD  CONSTRAINT [CK_OrderPublisherDetail_Price] CHECK  (([price]>(0)))
GO
ALTER TABLE [dbo].[OrderPublisherDetail] CHECK CONSTRAINT [CK_OrderPublisherDetail_Price]
GO
ALTER TABLE [dbo].[OrderPublisherDetail]  WITH CHECK ADD  CONSTRAINT [CK_OrderPublisherDetail_Quantity] CHECK  (([quantity]>(0)))
GO
ALTER TABLE [dbo].[OrderPublisherDetail] CHECK CONSTRAINT [CK_OrderPublisherDetail_Quantity]
GO
ALTER TABLE [dbo].[PriceUpdateDetail]  WITH CHECK ADD  CONSTRAINT [CK_PriceUpdateDetail_Price] CHECK  (([update_price]>(0)))
GO
ALTER TABLE [dbo].[PriceUpdateDetail] CHECK CONSTRAINT [CK_PriceUpdateDetail_Price]
GO
ALTER TABLE [dbo].[PromotionDetail]  WITH CHECK ADD  CONSTRAINT [CK_PromotionDetail_Discount] CHECK  (([percent_discount]>(0)))
GO
ALTER TABLE [dbo].[PromotionDetail] CHECK CONSTRAINT [CK_PromotionDetail_Discount]
GO
/****** Object:  StoredProcedure [dbo].[InsertAuthor]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[InsertAuthor] @author_id varchar(16), @last_name nvarchar(64), @first_name nvarchar(64),
@gender bit, @date_of_birth date, @phone_number varchar(16), @address nvarchar(255), @email varchar(64)
AS
    insert into Author(author_id, last_name, first_name, gender, date_of_birth, phone_number, address, email)
	values (@author_id, @last_name, @first_name, @gender, @date_of_birth, @phone_number, @address, @email)
GO
/****** Object:  StoredProcedure [dbo].[InsertBook]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[InsertBook] @isbn varchar(32), @book_name nvarchar(128), @image varchar(256),
@pages int, @price money, @release_year varchar(4), @quantity_in_stock int, @book_type_id varchar(16),
@publisher_id varchar(16)
AS
    insert into Book(isbn, book_name, image, pages, price, release_year, quantity_in_stock, is_new, book_type_id, publisher_id)
	values (@isbn, @book_name, @image, @pages, @price, @release_year, @quantity_in_stock, 1, @book_type_id, @publisher_id)
GO
/****** Object:  StoredProcedure [dbo].[InsertBookType]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[InsertBookType] @book_type_id varchar(16), @book_type_name nvarchar(64)
AS
    insert into BookType(book_type_id, book_type_name)
	values (@book_type_id, @book_type_name)
GO
/****** Object:  StoredProcedure [dbo].[InsertCart]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertCart] (@l_name nvarchar(32), @f_name nvarchar(32), @addres nvarchar(255),
@phonenum varchar(16), @mail varchar(128), @customer_id varchar(16), @details cart_details_type readonly)
AS 
BEGIN
		BEGIN TRAN
              BEGIN TRY
				declare @cart_id int;
				Insert into Cart(last_name_receive, first_name_receive, address_receive, phone_number_receive, email, customer_id, status_id)
				values (@l_name, @f_name, @addres, @phonenum, @mail, @customer_id, 1);

				SET @cart_id = SCOPE_IDENTITY();

				Update Book set quantity_in_stock = quantity_in_stock - dt.qty
				From @details dt
				where Book.isbn = dt.isbn;

				Insert into CartDetail(cart_id, isbn, price, quantity)
				select @cart_id, isbn, price, qty
				from @details;
				
				COMMIT TRANSACTION
				END TRY
       BEGIN CATCH
              -- if error, roll back any chanegs done by any of the sql statements
              ROLLBACK TRANSACTION
			  DECLARE @ErrorMessage VARCHAR(2000)
			  SELECT @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
			  RAISERROR(@ErrorMessage, 16, 1)
       END CATCH
		
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertCartDetail]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertCartDetail] (@cart_id int, @isbn varchar(32), @price money, @quatity int)
AS 
BEGIN
	
		Insert into CartDetail(cart_id, isbn, price, quantity, return_quantity)
		values (@cart_id, @isbn, @price, @quatity, null)
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertCompositions]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[InsertCompositions] @author_id varchar(16), @isbn varchar(32)
AS
    insert into Compositions(author_id, isbn)
	values (@author_id, @isbn)
GO
/****** Object:  StoredProcedure [dbo].[InsertCustomer]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertCustomer] (@l_name nvarchar(32), @f_name nvarchar(32), @gen bit, @addres nvarchar(255),@dob date,
@phonenum varchar(16), @mail varchar(128), @tax varchar(64), @account varchar(16), @pass varchar(32))
AS 
BEGIN
	BEGIN TRAN
              BEGIN TRY
				DECLARE @last_index int = 1;

				 IF EXISTS(SELECT * FROM Customer)
				 BEGIN
					SELECT @last_index = convert(INT, substring(customer_id, CHARINDEX('_', customer_id) + 1, len(customer_id))) 
					from Customer
					order by convert(INT, substring(customer_id, CHARINDEX('_', customer_id) + 1, len(customer_id)))
					SET @last_index = @last_index + 1
				 END
	 
				 DECLARE @new_id varchar(16) = concat('CUSTOMER', '_', convert(varchar(7), @last_index))
				 print(@new_id)
				
				Insert into Account(account, password, role_id) values (@account, @pass, 4);

				Insert into Customer(customer_id, last_name, first_name, gender, address, date_of_birth, phone_number, email, tax, account)
				values (@new_id, @l_name, @f_name, @gen, @addres, @dob, @phonenum, @mail, @tax, @account);
				
				COMMIT TRANSACTION
				END TRY
       BEGIN CATCH
              -- if error, roll back any chanegs done by any of the sql statements
              ROLLBACK TRANSACTION
			  DECLARE @ErrorMessage VARCHAR(2000)
			  SELECT @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
			  RAISERROR(@ErrorMessage, 16, 1)
       END CATCH
	 
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertDepartment]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[InsertDepartment] @dept_id varchar(16), @dept_name nvarchar(64)
AS
    insert into Department(department_id, department_name)
	values (@dept_id, @dept_name)
GO
/****** Object:  StoredProcedure [dbo].[InsertExchangeRate]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[InsertExchangeRate] @exchange_id varchar(8), @exchange_value money, @staff_id varchar(16)
AS
    insert into ExchangeRate(exchange_id, exchange_value, staff_id_update)
	values (@exchange_id, @exchange_value, @staff_id)
GO
/****** Object:  StoredProcedure [dbo].[InsertPublisher]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[InsertPublisher] @publisher_id varchar(16), @publisher_name nvarchar(128), @address nvarchar,
@phone_number varchar(16), @email varchar(128)
AS
    insert into Publisher(publisher_id, publisher_name, address, phone_number, email)
	values (@publisher_id, @publisher_name, @address, @phone_number, @email)
GO
/****** Object:  StoredProcedure [dbo].[InsertRole]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[InsertRole] @role_name nvarchar(64)
AS
    insert into Roles(role_name)
	values (@role_name)
GO
/****** Object:  StoredProcedure [dbo].[InsertStaff]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertStaff] (@l_name nvarchar(32), @f_name nvarchar(32), @gen bit, @addres nvarchar(255),@dob date,
@phonenum varchar(16), @mail varchar(128), @account varchar(16), @pass varchar(32), @depart_id varchar(16), @role int)
AS 
BEGIN
	BEGIN TRAN
              BEGIN TRY
				DECLARE @last_index int = 1;

				 IF EXISTS(SELECT * FROM Staff)
				 BEGIN
					SELECT @last_index = convert(INT, substring(staff_id, CHARINDEX('_', staff_id) + 1, len(staff_id))) 
					from Staff
					order by convert(INT, substring(staff_id, CHARINDEX('_', staff_id) + 1, len(staff_id)))
					SET @last_index = @last_index + 1
				 END
	 
				 DECLARE @new_id varchar(16) = concat('STAFF', '_', convert(varchar(7), @last_index))
				 print(@new_id)
				
				Insert into Account(account, password, role_id) values (@account, @pass, @role);

				Insert into Staff(staff_id, last_name, first_name, gender, address, date_of_birth, phone_number, email, account, department_id)
				values (@new_id, @l_name, @f_name, @gen, @addres, @dob, @phonenum, @mail, @account, @depart_id);
				
				COMMIT TRANSACTION
				END TRY
       BEGIN CATCH
              -- if error, roll back any chanegs done by any of the sql statements
              ROLLBACK TRANSACTION
			  DECLARE @ErrorMessage VARCHAR(2000)
			  SELECT @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
			  RAISERROR(@ErrorMessage, 16, 1)
       END CATCH
	 
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateAuthor]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateAuthor] @author_id varchar(16), @last_name nvarchar(64), @first_name nvarchar(64),
@gender bit, @date_of_birth date, @phone_number varchar(16), @address nvarchar(255), @email varchar(64)
AS
    update Author set last_name = @last_name, first_name = @first_name, gender = @gender,
		date_of_birth = @date_of_birth, phone_number = @phone_number, address = @address, email = @email
	where author_id = @author_id
GO
/****** Object:  StoredProcedure [dbo].[UpdateBook]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[UpdateBook] @isbn varchar(32), @book_name nvarchar(128), @image varchar(256),
@pages int, @price money, @release_year varchar(4), @quantity_in_stock int, @is_new bit, @book_type_id varchar(16),
@publisher_id varchar(16)
AS
    update Book set book_name = @book_name, image = @image, pages = @pages, price = @price,
	release_year = @release_year, quantity_in_stock = @quantity_in_stock, book_type_id = @book_type_id,
	is_new = @is_new where isbn = @isbn
GO
/****** Object:  StoredProcedure [dbo].[UpdateBookType]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateBookType] @book_type_id varchar(16), @book_type_name nvarchar(64)
AS
    update BookType set book_type_name = @book_type_name
	where book_type_id = @book_type_id
GO
/****** Object:  StoredProcedure [dbo].[UpdateCartCustomer]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateCartCustomer] (@cart_id int, @l_name nvarchar(32), @f_name nvarchar(32), @addres nvarchar(255),
@phonenum varchar(16), @mail varchar(128))
AS 
BEGIN
	
		update Cart set last_update_time = getdate(), last_name_receive = @l_name, first_name_receive = @f_name,
		address_receive = @addres, phone_number_receive = @phonenum, email = @mail
		where cart_id = @cart_id;
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateCartStaff]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateCartStaff] (@cart_id int, @status int, @staff_id_confirm varchar(16), @staff_id_deliver varchar(16))
AS 
BEGIN
	
		update Cart set last_update_time = getdate(), status_id = @status, 
		staff_id_confirm = @staff_id_confirm, staff_id_deliver = @staff_id_deliver
		where cart_id = @cart_id;
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateCompositions]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateCompositions] @author_id varchar(16), @isbn varchar(32)
AS
    update Compositions set author_id = @author_id
	where isbn = @isbn;
GO
/****** Object:  StoredProcedure [dbo].[UpdateDeliverySuccess]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDeliverySuccess] (@cart_id int)
AS 
BEGIN
	
		update Cart set last_update_time = getdate(), status_id = 3, date_receive = GETDATE()
		where cart_id = @cart_id;
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateDepartment]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateDepartment] @dept_id varchar(16), @dept_name nvarchar(64)
AS
    update Department set department_name = @dept_name
	where department_id = @dept_id;
GO
/****** Object:  StoredProcedure [dbo].[UpdateInfoCustomer]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateInfoCustomer] (@customer_id varchar(16), @l_name nvarchar(32), @f_name nvarchar(32), @gen bit, @addres nvarchar(255),@dob date,
@phonenum varchar(16), @mail varchar(128), @tax varchar(64))
AS 
BEGIN
	 update Customer set last_name = @l_name, first_name = @f_name, gender = @gen, address = @addres, date_of_birth = @dob,
	 phone_number = @phonenum, email = @mail, tax = @tax
	 where customer_id = @customer_id;
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdatePassword]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdatePassword] (@account varchar(16), @pass varchar(32))
AS 
BEGIN
	 update Account set password = @pass
	 where account = @account;
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdatePublisher]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdatePublisher] @publisher_id varchar(16), @publisher_name nvarchar(128), @address nvarchar,
@phone_number varchar(16), @email varchar(128)
AS
    update Publisher set publisher_name = @publisher_name, address = @address, phone_number = @phone_number,
	email = @email where publisher_id = @publisher_id;
GO
/****** Object:  StoredProcedure [dbo].[UpdateStaffInfo]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateStaffInfo] (@staff_id varchar(16), @l_name nvarchar(32), @f_name nvarchar(32), @gen bit, @addres nvarchar(255),@dob date,
@phonenum varchar(16), @mail varchar(128))
AS 
BEGIN
	 update Staff set last_name = @l_name, first_name = @f_name, gender = @gen,
	 address = @addres, date_of_birth = @dob, phone_number = @phonenum, email = @mail
	 where staff_id = @staff_id;
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdateStaffLevel]    Script Date: 9/6/2022 10:32:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateStaffLevel] (@staff_id varchar(16), @depart_id varchar(16), @role int)
AS 
BEGIN
BEGIN TRAN
              BEGIN TRY
				update Staff set department_id = @depart_id
				 where staff_id = @staff_id;

				update Account set role_id = @role
				from Staff where 
				Staff.account = Account.account and Staff.staff_id = @staff_id;
				
				COMMIT TRANSACTION
				END TRY
       BEGIN CATCH
              -- if error, roll back any chanegs done by any of the sql statements
              ROLLBACK TRANSACTION
			  DECLARE @ErrorMessage VARCHAR(2000)
			  SELECT @ErrorMessage = 'Error: ' + ERROR_MESSAGE()
			  RAISERROR(@ErrorMessage, 16, 1)
       END CATCH
	 
END;
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Book', @level2type=N'CONSTRAINT',@level2name=N'CK_Book_Quantity'
GO
USE [master]
GO
ALTER DATABASE [BookOnlineStore] SET  READ_WRITE 
GO
