import DatabaseConnection.ConnectSQL

cursor = DatabaseConnection.ConnectSQL.connect.cursor()


def insert_book(bus_plate, seat):
    try:
        if seat <= 0:
            print("Books greater than 0")
            return False
        sql = """
            SET NOCOUNT ON;
            DECLARE @RC int;
            exec @RC = InsertBus ?, ?;
            SELECT @RC AS rc;
        """
        values = (bus_plate, seat)
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


def get_list_best_seller_book():
    try:
        cursor.execute("select * from get_list_best_seller_book()")
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
