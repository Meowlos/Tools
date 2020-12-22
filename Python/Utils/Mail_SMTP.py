# -*- coding:utf-8 -*-

import os
import smtplib
from email.header import Header
from email.mime.application import MIMEApplication
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart


class MailSmtp:
    def __init__(self, from_addr, password, smtp_server, smtp_port):
        self.__from = from_addr
        self.__pass = password
        self.__server = smtp_server
        self.__port = smtp_port

    @staticmethod
    def __parse_attach_file(file_path, content_index):
        if not os.path.isfile(file_path):
            return None
        part = MIMEApplication(open(file_path, "rb").read())
        part.add_header("Content-Disposition", "attachment", filename=os.path.basename(file_path))
        part.add_header("Content-ID", str(content_index))
        return part

    def send_mail(self, subject, send_to, content, attach_file=None, mail_type="plain"):
        if attach_file is None:
            msg = MIMEText(content, mail_type, 'utf-8')
        else:
            msg = MIMEMultipart(content, mail_type, 'utf-8')
            index = 0
            for file in attach_file:
                part = self.__parse_attach_file(file, index)
                if part is not None:
                    msg.attach(part)
                    index += 1

        msg['From'] = Header(self.__from, 'utf-8')
        msg['To'] = Header(send_to, 'utf-8')
        msg['Subject'] = Header(subject, 'utf-8')

        try:
            server = smtplib.SMTP(self.__server, self.__port)
            server.login(self.__from, self.__pass)
            server.sendmail(self.__from, send_to, msg.as_string())
            server.quit()
            print("Success: 邮件发送成功")
        except smtplib.SMTPException:
            print("Error: 邮件发送错误")
