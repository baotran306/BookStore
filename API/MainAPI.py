from flask import Flask, jsonify, request
from flask_cors import CORS, cross_origin
import DatabaseConnection.BookFunction
import DatabaseConnection.StaffFunction
import DatabaseConnection.CustomerFunction
book_function = DatabaseConnection.BookFunction
staff_function = DatabaseConnection.StaffFunction
customer_function = DatabaseConnection.CustomerFunction


app = Flask(__name__)
# CORS(app, resources={r"/*": {"origins": "*"}})
CORS(app, resources={r"/*": {"origins": "*"}}, headers="Content-Type")


@app.route("/book/get-list-book", methods=['GET'])
def get_list_book():
    list_book = book_function.get_list_book()
    print(list_book)
    return jsonify(list_book)


@app.route("/book/get-list-new-book", methods=['GET'])
def get_list_new_book():
    list_book = book_function.get_list_new_book()
    print(list_book)
    return jsonify(list_book)


@app.route("/book/get-list-best-seller-book", methods=['GET'])
def get_list_best_seller_book():
    list_book = book_function.get_list_best_seller_book()
    print(list_book)
    return jsonify(list_book)


@app.route("/book/get-list-book-by-name", methods=['POST'])
def get_list_book_by_name():
    try:
        book_name = request.json['bookName']
        list_book = book_function.get_list_book_by_name(book_name)
        return jsonify(list_book)
    except Exception as ex:
        print(ex)
        return jsonify([])


@app.route("/admin/insert-department", methods=['POST'])
def insert_department():
    try:
        department_id = request.json['departmentId']
        department_name = request.json['departmentName']
        if staff_function.insert_department(department_id, department_name):
            return jsonify({'result': True})
        return jsonify({'result': False})
    except Exception as ex:
        print(ex)
        return jsonify({'result': False})


@app.route("/admin/insert-role", methods=['POST'])
def insert_role():
    try:
        role_name = request.json['roleName']
        if staff_function.insert_role(role_name):
            return jsonify({'result': True})
        return jsonify({'result': False})
    except Exception as ex:
        print(ex)
        return jsonify({'result': False})


@app.route("/admin/insert-staff", methods=['POST'])
def insert_staff():
    try:
        l_name = request.json['lName']
        f_name = request.json['fName']
        gender = request.json['gender']
        address = request.json['address']
        date_of_birth = request.json['dateOfBirth']
        phone_num = request.json['phoneNum']
        email = request.json['email']
        account = request.json['account']
        password = request.json['password']
        department_id = request.json['departmentId']
        role_id = request.json['roleId']
        if staff_function.insert_staff(l_name, f_name, gender, address, date_of_birth, phone_num, email, account,
                                       password, department_id, role_id):
            return jsonify({'result': True})
        return jsonify({'result': False})
    except Exception as ex:
        print(ex)
        return jsonify({'result': False})


@app.route("/customer/register", methods=['POST'])
def insert_customer():
    try:
        l_name = request.json['lName']
        f_name = request.json['fName']
        gender = request.json['gender']
        address = request.json['address']
        date_of_birth = request.json['dateOfBirth']
        phone_num = request.json['phoneNum']
        email = request.json['email']
        tax = request.json['tax']
        account = request.json['account']
        password = request.json['password']
        if customer_function.insert_customer(l_name, f_name, gender, address, date_of_birth, phone_num, email, tax,
                                             account, password):
            return jsonify({'result': True})
        return jsonify({'result': False})
    except Exception as ex:
        print(ex)
        return jsonify({'result': False})


if __name__ == "__main__":
    app.run(debug=True, port=5000)
