# -*- coding:utf-8 -*-

import os
import time


# ----
# 文件操作
# ----

def clear_dir(_dir):
    if not os.path.isdir(_dir):
        return
    for root, dirs, files in os.walk(_dir):
        for file in files:
            fp = os.path.join(root, file)
            if os.path.isfile(fp):
                os.remove(fp)
        if len(dirs) == 0:
            os.rmdir(root)


def del_dir(_dir):
    if not os.path.isdir(_dir):
        return
    clear_dir(_dir)
    time.sleep(0.01)
    os.rmdir(_dir)
# ----
