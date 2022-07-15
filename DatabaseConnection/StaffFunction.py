import DatabaseConnection.ConnectSQL

cursor = DatabaseConnection.ConnectSQL.connect.cursor()


def insert_staff(last_name, first_name, gender_, address, date_of_birth, phone_num, email, account,
                 password, department_id, role_id):
    try:
        sql = """
            SET NOCOUNT ON;
            DECLARE @RC int;
            exec @RC = InsertStaff ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?;
            SELECT @RC AS rc;
        """
        values = (last_name, first_name, gender_, address, date_of_birth, phone_num, email, account,
                  password, department_id, role_id)
        cursor.execute(sql, values)
        cursor.commit()
        return True
    except Exception as ex:
        print(ex)
        return False


def insert_department(department_id, department_name):
    try:
        sql = """
            SET NOCOUNT ON;
            DECLARE @RC int;
            exec @RC = InsertDepartment ?, ?;
            SELECT @RC AS rc;
        """
        values = (department_id, department_name)
        cursor.execute(sql, values)
        cursor.commit()
        return True
    except Exception as ex:
        print(ex)
        return False


def insert_role(role_name):
    try:
        sql = """
            SET NOCOUNT ON;
            DECLARE @RC int;
            exec @RC = InsertRole ?;
            SELECT @RC AS rc;
        """
        values = role_name
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
