import re
import hashlib
import smtplib
import ssl
import random


def convert_tag(text):
    text = text.lower().strip()
    text = re.sub("\s\s+" , " ", text)
    vietsub = 'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệếìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵýđð'
    engsub = 'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyydd'
    ans = ''
    for i in text:
        if i in vietsub:
            ans += engsub[vietsub.index(i)]
        else:
            ans += i
    return '-'.join(ans.split(' '))


def hash_password(password):
    my_key = 'secret_key'
    db_password = password + my_key
    new_pass = hashlib.md5(db_password.encode())
    return new_pass.hexdigest()


def check_regex_password(your_pass):
    if " " in your_pass:
        print("----False Regex Password(Type 1)----")
        return False
    punctuation = "!\"#$%&'()*+,-/:;<=>?[\\]^`{|}~"
    for pun in punctuation:
        if pun in your_pass:
            print("----False Regex Password(Type 2)----")
            return False
    regex_type = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,20}$"
    if re.search(regex_type, your_pass):
        return True
    print("----False Regex Password----")
    return False


def message_active_account(verify_number):

    message = """\
Subject: Xác thực email đăng kí tài khoản từ BaoThangShop.

This message is sent from Python
Mã xác thực của bạn là: {}
Vui lòng nhập đúng mã xác thực để kích hoạt tài khoản.
.""".format(verify_number).encode("utf-8")
    return message


def message_reset_password(verify_number):
    message = """\
Subject: Xác thực quên mật khẩu từ BaoThangShop.

Mã xác thực của bạn là: {}
Vui lòng nhập đúng mã xác thực cập nhật mật khẩu mới.
.""".format(verify_number).encode("utf-8")
    return message


def send_mail(receiver_mail_account, type_message):
    """

    :param receiver_mail_account: email receiver
    :param type_message: type == 0: send verify number for new account, else for reset password
    :return:
    """
    try:
        port = 587  # For start TSL
        smtp_server = "smtp.gmail.com"
        send_mail_account = "confirmemail.bao"
        send_mail_password = "kjazmubyfndcefmb"

        verify_number = random.randint(100000, 999999)
        print(verify_number)

        if type_message == 1:
            message = message_active_account(verify_number)
        else:
            message = message_reset_password(verify_number)

        context = ssl.create_default_context()
        with smtplib.SMTP(smtp_server, port) as server:
            server.starttls(context=context)
            server.login(send_mail_account, send_mail_password)
            server.sendmail(send_mail_account, receiver_mail_account, message)
        return verify_number
    except Exception as ex:
        print("Send mail fail")
        print(ex)
        return 0


print(convert_tag('Gạo cổng mặt trời   123'))
