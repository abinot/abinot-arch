#!/usr/bin/env python3
import sys
from PyQt5.QtWidgets import (QApplication, QWidget, QLabel, 
                            QPushButton, QVBoxLayout)

class AdvancedMessage(QWidget):
    def __init__(self):
        super().__init__()
        
        # تنظیمات پنجره
        self.setWindowTitle("Abinot Pro")
        self.setFixedSize(400, 200)
        
        # ایجاد ویجت‌ها
        self.label = QLabel("hello world! we have to update something. (this app have a fucking bug)")
        self.label.setStyleSheet("font-size: 20px; color: #e74c3c;")
        
        self.btn_close = QPushButton("X")
        self.btn_close.setStyleSheet("background: #3498db; color: white; padding: 10px;")
        self.btn_close.clicked.connect(self.close)
        
        # لایه‌بندی
        layout = QVBoxLayout()
        layout.addWidget(self.label)
        layout.addWidget(self.btn_close)
        
        self.setLayout(layout)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = AdvancedMessage()
    window.show()
    sys.exit(app.exec_())
