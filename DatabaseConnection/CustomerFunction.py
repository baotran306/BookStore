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
            ans.append({'customer_id': r[0], 'last_name': r[1], 'first_name': r[2], 'role_id': r[3], 'role_name': r[4]})
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


# print(customer_order('Nguyễn', 'Văn Long', '110 Chương Dương, Thủ Đức', '0987271333', 'nvl1682@gmail.com',
#                      'CUSTOMER_2', [['978-604-2-27347-3', 64000, 1]]))
