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
