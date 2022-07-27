import DatabaseConnection.ConnectSQL
import Helper.SupportFunction

helper = Helper.SupportFunction
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
                  helper.hash_password(password), department_id, role_id)
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


def insert_exchange_rate(exchange_rate, staff_id):
    try:
        sql = """
            SET NOCOUNT ON;
            DECLARE @RC int;
            exec @RC = InsertExchangeRate ?, ?;
            SELECT @RC AS rc;
        """
        values = (exchange_rate, staff_id)
        cursor.execute(sql, values)
        cursor.commit()
        return True
    except Exception as ex:
        print(ex)
        return False


def get_newest_exchange():
    try:
        cursor.execute("select * from get_newest_exchange()")
        ans = []
        for r in cursor:
            ans.append({'exchange_id': r[0], 'exchange_date_update': r[1], 'exchange_value': r[2],
                        'staff_id_update': r[3], 'first_name': r[4], 'last_name': r[5]})
        cursor.commit()
        return ans
    except Exception as ex:
        print(ex)
        return []


def statistic_sales_by_month(from_date, to_date):
    try:
        cursor.execute("select * from statistic_sales_by_month(?, ?)", from_date, to_date)
        ans = []
        for r in cursor:
            ans.append({'from_date': r[0], 'to_date': r[1]})
        cursor.commit()
        return ans
    except Exception as ex:
        print(ex)
        return []


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


def update_password_staff(account, password):
    try:
        sql = """
            SET NOCOUNT ON;
            DECLARE @RC int;
            exec @RC = UpdatePassword ?, ?;
            SELECT @RC AS rc;
        """
        values = (account, password)
        cursor.execute(sql, values)
        cursor.commit()
        return True
    except Exception as ex:
        print(ex)
        return False


def update_delivery_success(cart_id):
    try:
        sql = """
            SET NOCOUNT ON;
            DECLARE @RC int;
            exec @RC = UpdateDeliverySuccess ?;
            SELECT @RC AS rc;
        """
        values = cart_id
        cursor.execute(sql, values)
        cursor.commit()
        return True
    except Exception as ex:
        print(ex)
        return False


def staff_update_cart(cart_id, status, staff_id_confirm, staff_id_delivery):
    try:
        sql = """
            SET NOCOUNT ON;
            DECLARE @RC int;
            exec @RC = UpdateCartStaff ?, ?, ?, ?;
            SELECT @RC AS rc;
        """
        values = (cart_id, status, staff_id_confirm, staff_id_delivery)
        cursor.execute(sql, values)
        cursor.commit()
        return True
    except Exception as ex:
        print(ex)
        return False


def staff_login(account, password):
    try:
        cursor.execute("select * from staff_login(?, ?)", account, helper.hash_password(password))
        ans = []
        for r in cursor:
            ans.append({'customer_id': r[0], 'last_name': r[1], 'first_name': r[2], 'role_id': r[3], 'role_name': r[4]})
        cursor.commit()
        return ans
    except Exception as ex:
        print(ex)
        return []


def get_staff_info_by_account(account):
    try:
        cursor.execute("select * from get_staff_info_by_account(?)", account)
        ans = []
        for r in cursor:
            ans.append({'customer_id': r[0], 'last_name': r[1], 'first_name': r[2], 'gender': r[3], 'address': r[4],
                        'date_of_birth': r[5], 'phone_number': r[6], 'email': r[7], 'account': r[8]})
        cursor.commit()
        return ans
    except Exception as ex:
        print(ex)
        return []


def get_list_count_delivery_staff():
    try:
        cursor.execute("select * from get_list_count_delivery_staff() order by number_delivery asc")
        ans = []
        for r in cursor:
            ans.append({'customer_id': r[0], 'last_name': r[1], 'first_name': r[2], 'number_delivery': r[3]})
        cursor.commit()
        return ans
    except Exception as ex:
        print(ex)
        return []


def get_list_customer_order_detail():
    try:
        cursor.execute("select * from get_list_customer_order_detail() order by cart_id desc")
        ls_info = []
        ls_item = []
        for r in cursor:
            ls_info.append({'cart_id': r[0], 'customer_id': r[6], 'last_name_customer': r[7],
                            'first_name_customer': r[8], 'order_cart_time': r[9], 'status_id': r[10],
                            'status_name': r[11], 'last_name_receiver': r[12], 'first_name_receiver': r[13],
                            'address_receiver': r[14], 'phone_number_receiver': r[15], 'email_receiver': r[16]})
            ls_item.append({'cart_id': r[0], 'isbn': r[1], 'book_name': r[2], 'image': r[3], 'quantity': r[4],
                            'price': r[5]})
        cursor.commit()
        res = []
        set_info = []
        for value in ls_info:
            if value['cart_id'] not in [tmp['cart_id'] for tmp in set_info]:
                set_info.append(value)
        for info in set_info:
            tmp_list = list(filter(lambda customer_items: customer_items['cart_id'] == info['cart_id'], ls_item))
            res.append({'receiver_info': info, 'list_item': tmp_list})
        # print(res)
        return res
    except Exception as ex:
        print(ex)
        return []
