import DatabaseConnection.ConnectSQL

cursor = DatabaseConnection.ConnectSQL.connect.cursor()


def insert_author(author_id, l_name, f_name, gender, date_of_birth, phone_number, address, email):
    try:
        sql = """
            SET NOCOUNT ON;
            DECLARE @RC int;
            exec @RC = InsertAuthor ?, ?, ?, ?, ?, ?, ?, ?;
            SELECT @RC AS rc;
        """
        values = (author_id, l_name, f_name, gender, date_of_birth, phone_number, address, email)
        cursor.execute(sql, values)
        cursor.commit()
        return True
    except Exception as ex:
        print(ex)
        return False


def insert_book(isbn, book_name, image, pages, price, release_year, quantity, book_type_id, publisher_id):
    try:
        if pages <= 0 or quantity <= 0 or price <= 0:
            print("Pages, Price, Quantity greater than 0")
            return False
        sql = """
            SET NOCOUNT ON;
            DECLARE @RC int;
            exec @RC = InsertBook ?, ?, ?, ?, ?, ?, ?, ?, ?;
            SELECT @RC AS rc;
        """
        values = (isbn, book_name, image, pages, price, release_year, quantity, book_type_id, publisher_id)
        cursor.execute(sql, values)
        cursor.commit()
        return True
    except Exception as ex:
        print(ex)
        return False


def get_list_book():
    try:
        cursor.execute("select * from get_list_book()")
        ans = []
        for r in cursor:
            ans.append({'isbn': r[0], 'book_name': r[1], 'image': r[2], 'pages': r[3], 'price': float(r[4]),
                        'release_year': r[5], 'quantity_in_stock': r[6], 'is_new': r[7], 'book_type_name': r[10],
                        'publisher_name': r[11], 'percent_discount': r[12]})
        cursor.commit()
        print(1)
        return ans
    except Exception as ex:
        print(ex)
        return []


def get_list_new_book():
    try:
        cursor.execute("select * from get_list_new_book()")
        ans = []
        for r in cursor:
            ans.append({'isbn': r[0], 'book_name': r[1], 'image': r[2], 'pages': r[3], 'price': float(r[4]),
                        'release_year': r[5], 'quantity_in_stock': r[6], 'is_new': r[7], 'book_type_name': r[10],
                        'publisher_name': r[11], 'percent_discount': r[12]})
        cursor.commit()
        print(2)
        return ans
    except Exception as ex:
        print(ex)
        return []


def get_list_best_seller_book(top=4, months=3):
    try:
        cursor.execute("select * from get_list_best_seller_book(?, ?)", top, months)
        ans = []
        for r in cursor:
            ans.append({'isbn': r[0], 'book_name': r[1], 'image': r[2], 'pages': r[3], 'price': float(r[4]),
                        'release_year': r[5], 'quantity_in_stock': r[6], 'is_new': r[7], 'book_type_name': r[10],
                        'publisher_name': r[11], 'percent_discount': r[12]})
        cursor.commit()
        return ans
    except Exception as ex:
        print(ex)
        return []


def get_list_book_by_name(name):
    try:
        cursor.execute("select * from get_list_book_by_name(?)", name)
        ans = []
        for r in cursor:
            ans.append({'isbn': r[0], 'book_name': r[1], 'image': r[2], 'pages': r[3], 'price': float(r[4]),
                        'release_year': r[5], 'quantity_in_stock': r[6], 'is_new': r[7], 'book_type_name': r[10],
                        'publisher_name': r[11], 'percent_discount': r[12]})
        cursor.commit()
        return ans
    except Exception as ex:
        print(ex)
        return []


def get_list_book_by_id(book_id):
    try:
        cursor.execute("select * from get_list_book_by_id(?)", book_id)
        ans = []
        for r in cursor:
            ans.append({'isbn': r[0], 'book_name': r[1], 'image': r[2], 'pages': r[3], 'price': float(r[4]),
                        'release_year': r[5], 'quantity_in_stock': r[6], 'is_new': r[7], 'book_type_name': r[10],
                        'publisher_name': r[11], 'percent_discount': r[12]})
        cursor.commit()
        return ans
    except Exception as ex:
        print(ex)
        return []
