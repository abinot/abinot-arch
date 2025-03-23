#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QLabel

class PersianMessageApp(QMainWindow):
    def __init__(self):
        super().__init__()
        
        # تنظیمات پنجره
        self.setWindowTitle("Abinot")
        self.setGeometry(300, 300, 600, 200)
        
        # ایجاد لیبل با متن مورد نظر
        self.label = QLabel(self)
        self.label.setText(
            "Hello World! We need to push an update."
        )
        
        # تنظیم استایل و فونت
        self.label.setStyleSheet("""
            QLabel {
                font-size: 18px;
                color: #ffffff;
                background-color: #2c3e50;
                padding: 20px;
                border-radius: 10px;
            }
        """)
        self.label.setFont(self.get_persian_font())
        self.label.adjustSize()
        self.label.move(50, 50)

    def get_persian_font(self):
        # انتخاب فونت مناسب برای نمایش فارسی
        font = self.label.font()
        font.setFamily("Arial")  # یا از فونت‌های فارسی مثل "XB Niloofar" استفاده کنید
        font.setPointSize(14)
        return font

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = PersianMessageApp()
    window.show()
    sys.exit(app.exec_())
