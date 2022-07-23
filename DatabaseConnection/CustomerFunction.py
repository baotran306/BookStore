import DatabaseConnection.ConnectSQL
import Helper.SupportFunction

helper = Helper.SupportFunction
cursor = DatabaseConnection.ConnectSQL.connect.cursor()


def insert_customer(last_name, first_name, gender_, address, date_of_birth, phone_num, email, tax, account,
                    password):
    try:
        sql = """
            SET NOCOUNT ON;
            DECLARE @RC int;
            exec @RC = InsertCustomer ?, ?, ?, ?, ?, ?, ?, ?, ?, ?;
            SELECT @RC AS rc;
        """
        values = (last_name, first_name, gender_, address, date_of_birth, phone_num, email, tax, account,
                  helper.hash_password(password))
        cursor.execute(sql, values)
        cursor.commit()
        return True
    except Exception as ex:
        print(ex)
        return False


def update_password_customer(account, password):
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


def customer_login(account, password):
    try:
        cursor.execute("select * from customer_login(?, ?)", account, helper.hash_password(password))
        ans = []
        for r in cursor:
            ans.append({'customer_id': r[0], 'last_name': r[1], 'first_name': r[2], 'address': r[3],
                        'phone_number': r[4], 'email': r[5], 'role_id': r[6], 'role_name': r[7]})
        cursor.commit()
        return ans
    except Exception as ex:
        print(ex)
        return []


def customer_order(l_name, f_name, address, phone_num, email, customer_id, list_item_details):
    try:
        sql = """
            SET NOCOUNT ON;
            DECLARE @RC int;
            exec @RC = InsertCart ?, ?, ?, ?, ?, ?, ?;
            SELECT @RC AS rc;
        """
        values = (l_name, f_name, address, phone_num, email, customer_id, list_item_details)
        cursor.execute(sql, values)
        cursor.commit()
        return True
    except Exception as ex:
        print(ex)
        return False


def get_customer_info_by_account(account):
    try:
        cursor.execute("select * from get_customer_info_by_account(?)", account)
        ans = []
        for r in cursor:
            ans.append({'customer_id': r[0], 'last_name': r[1], 'first_name': r[2], 'gender': r[3], 'address': r[4],
                        'date_of_birth': r[5], 'phone_number': r[6], 'email': r[7], 'tax': r[8], 'account': r[9]})
        cursor.commit()
        return ans
    except Exception as ex:
        print(ex)
        return []


# print(customer_order('Nguyễn', 'Văn Long', '110 Chương Dương, Thủ Đức', '0987271333', 'nvl1682@gmail.com',
#                      'CUSTOMER_2', [['978-604-2-27206-3', 160000, 8], ['978-604-2-26314-6', 124000, 2]]))
# print(customer_order('Nguyễn', 'Quoc Thang', '110 Chương Dương, HCM', '0987271334', 'nvl1682@gmail.com1',
#                      'CUSTOMER_2', [['978-604-2-27206-3', 128000, 1], ['978-604-2-27347-3', 64000, 5]]))
