from flask import Flask, jsonify, request, send_file
from flask_cors import CORS
import paypalrestsdk
import DatabaseConnection.BookFunction
import DatabaseConnection.StaffFunction
import DatabaseConnection.CustomerFunction

book_function = DatabaseConnection.BookFunction
staff_function = DatabaseConnection.StaffFunction
customer_function = DatabaseConnection.CustomerFunction


paypalrestsdk.configure({
  "mode": "sandbox",  # sandbox or live
  "client_id": "AbHXLZ77N0PJo1CAspFIU157G1n8KFF7V-ZlIEgKCAM_IcMnL1zMjLXHtIBVp8Rpinyth5URxONj-LHx",
  "client_secret": "EH6mu9MBgKogt2yOVrfvyCRGT13oeKtYGln-5GI00lhGw879ZkDp0zw-pyVjxCQcDYxU_KzIAQJ_3Sim"})


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
        return jsonify([]), 500


@app.route("/book/get-list-book-by-id/<string:book_id>", methods=['GET'])
def get_list_book_by_id(book_id):
    try:
        list_book = book_function.get_list_book_by_id(book_id)
        return jsonify(list_book)
    except Exception as ex:
        print(ex)
        return jsonify([]), 500


@app.route("/customer/get-customer-info-by-account/<string:account>", methods=['GET'])
def get_customer_info_by_account(account):
    try:
        customer_info = customer_function.get_customer_info_by_account(account)
        return jsonify(customer_info)
    except Exception as ex:
        print(ex)
        return jsonify([]), 500


@app.route("/staff/get-staff-info-by-account/<string:account>", methods=['GET'])
def get_staff_info_by_account(account):
    try:
        staff_info = staff_function.get_staff_info_by_account(account)
        return jsonify(staff_info)
    except Exception as ex:
        print(ex)
        return jsonify([]), 500


@app.route("/admin/insert-department", methods=['POST'])
def insert_department():
    try:
        department_id = request.json['departmentId']
        department_name = request.json['departmentName']
        if staff_function.insert_department(department_id, department_name):
            return jsonify({'result': True, 'message': 'Thêm phòng ban thành công'})
        return jsonify({'result': False, 'message': 'Thêm phòng ban thất bại'}), 502
    except Exception as ex:
        print(ex)
        return jsonify({'result': False, 'message': 'Có lỗi xảy ra'}), 500


@app.route("/admin/insert-role", methods=['POST'])
def insert_role():
    try:
        role_name = request.json['roleName']
        if staff_function.insert_role(role_name):
            return jsonify({'result': True, 'message': 'Thêm quyền thành công'})
        return jsonify({'result': False, 'message': 'Thêm quyền thất bại'}), 502
    except Exception as ex:
        print(ex)
        return jsonify({'result': False, 'message': 'Có lỗi xảy ra'}), 500


@app.route("/admin/insert-staff", methods=['POST'])
def insert_staff():
    try:
        l_name = request.json['lName']
        f_name = request.json['fName']
        gender = request.json['gender']
        address = request.json['address']
        date_of_birth = request.json['dateOfBirth']
        phone_num = request.json['phoneNumber']
        email = request.json['email']
        account = request.json['account']
        password = request.json['password']
        department_id = request.json['departmentId']
        role_id = request.json['roleId']
        if staff_function.insert_staff(l_name, f_name, gender, address, date_of_birth, phone_num, email, account,
                                       password, department_id, role_id):
            return jsonify({'result': True, 'message': 'Thêm nhân viên thành công'})
        return jsonify({'result': False, 'message': 'Thêm nhân viên thất bại'}), 502
    except Exception as ex:
        print(ex)
        return jsonify({'result': False, 'message': 'Có lỗi xảy ra'}), 500


@app.route("/staff/login", methods=['POST'])
def staff_login():
    try:
        account = request.json['account']
        password = request.json['password']
        staff_info = staff_function.staff_login(account, password)
        if len(staff_info) != 0:
            return jsonify({'result': True, 'message': 'Đăng nhập thành công', 'info': staff_info})
        return jsonify({'result': True, 'message': 'Sai tên đăng nhập hoặc mật khẩu', 'info': []}), 502
    except Exception as ex:
        print(ex)
        return jsonify({'result': True, 'message': 'Có lỗi xảy ra', 'info': []}), 500


@app.route("/customer/register", methods=['POST'])
def insert_customer():
    try:
        l_name = request.json['lName']
        f_name = request.json['fName']
        gender = request.json['gender']
        address = request.json['address']
        date_of_birth = request.json['dateOfBirth']
        phone_num = request.json['phoneNumber']
        email = request.json['email']
        tax = request.json['tax']
        account = request.json['account']
        password = request.json['password']
        if customer_function.insert_customer(l_name, f_name, gender, address, date_of_birth, phone_num, email, tax,
                                             account, password):
            return jsonify({'result': True, 'message': 'Đăng kí tài khoản khách hàng thành công'})
        return jsonify({'result': False, 'message': 'Đăng kí tài khoản khách hàng thất bại'}), 502
    except Exception as ex:
        print(ex)
        return jsonify({'result': False, 'message': 'Có lỗi xảy ra'}), 500


@app.route("/customer/login", methods=['POST'])
def customer_login():
    try:
        account = request.json['account']
        password = request.json['password']
        customer_info = customer_function.customer_login(account, password)
        if len(customer_info) != 0:
            return jsonify({'result': True, 'message': 'Đăng nhập thành công', 'info': customer_info}), 200
        return jsonify({'result': True, 'message': 'Sai tên đăng nhập hoặc mật khẩu', 'info': []}), 403
    except Exception as ex:
        print(ex)
        return jsonify({'result': False, 'message': 'Có lỗi xảy ra', 'info': []}), 500


@app.route("/customer/order", methods=['POST'])
def insert_order_customer():
    try:
        l_name = request.json['last_name']
        f_name = request.json['first_name']
        address = request.json['address']
        phone_num = request.json['phone_number']
        email = request.json['email']
        customer_id = request.json['customer_id']
        list_item_details = request.json['list_book']
        print(list_item_details)
        if len(list_item_details) == 0:
            return jsonify({'result': False, 'message': 'Không thể thêm hàng rỗng'}), 500
        if customer_function.customer_order(l_name, f_name, address, phone_num, email, customer_id, list_item_details):
            return jsonify({'result': True, 'message': 'Đặt hàng thành công'})
        return jsonify({'result': False, 'message': 'Đặt hàng thất bại'}), 502
    except Exception as ex:
        print(ex)
        return jsonify({'result': False, 'message': 'Có lỗi xảy ra'}), 500


@app.route("/book/insert-book", methods=['POST'])
def insert_book():
    try:
        isbn = request.json['isbn']
        book_name = request.json['bookName']
        image = request.json['image']
        pages = request.json['pages']
        price = request.json['price']
        release_year = request.json['releaseYear']
        quantity = request.json['quantity']
        book_type_id = request.json['bookTypeId']
        publisher_id = request.json['publisherId']
        if book_function.insert_book(isbn, book_name, image, pages, price, release_year, quantity,
                                     book_type_id, publisher_id):
            return jsonify({'result': True, 'message': 'Thêm sách thành công'})
        return jsonify({'result': False, 'message': 'Thêm sách thất bại'}), 502
    except Exception as ex:
        print(ex)
        return jsonify({'result': False, 'message': 'Có lỗi xảy ra'}), 500


@app.route("/book/insert-author", methods=['POST'])
def insert_author():
    try:
        author_id = request.json['authorId']
        l_name = request.json['lName']
        f_name = request.json['fName']
        gender = request.json['gender']
        date_of_birth = request.json['dateOfBirth']
        phone_number = request.json['phoneNumber']
        address = request.json['address']
        email = request.json['email']
        if book_function.insert_author(author_id, l_name, f_name, gender, date_of_birth, phone_number, address, email):
            return jsonify({'result': True, 'message': 'Thêm sách thành công'})
        return jsonify({'result': False, 'message': 'Thêm sách thất bại'}), 502
    except Exception as ex:
        print(ex)
        return jsonify({'result': False, 'message': 'Có lỗi xảy ra'}), 500


@app.route("/payment", methods=['POST'])
def payment():
    payment1 = paypalrestsdk.Payment({
        "intent": "sale",
        "payer": {
            "payment_method": "paypal"},
        "redirect_urls": {
            "return_url": "http://localhost:3000/payment/execute",
            "cancel_url": "http://localhost:3000/"},
        "transactions": [{
            "item_list": {
                "items": [{
                    "name": "testitem",
                    "sku": "12345",
                    "price": "500.00",
                    "currency": "USD",
                    "quantity": 1}]},
            "amount": {
                "total": "500.00",
                "currency": "USD"},
            "description": "This is the payment transaction description."}]})
    if payment1.create():
        print('payment success')
    else:
        print('payment fail')
    return jsonify({'paymentID': payment.id})


@app.route("/get-image/<string:id_image>", methods=['GET'])
def get_image(id_image):
    return send_file("D:\\CODE\\PTITHCM_BookStore\\back_end\\Image\\{}".format(id_image), mimetype='image/gif')


if __name__ == "__main__":
    app.run(debug=True, port=5000)
