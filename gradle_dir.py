# -*- coding: utf-8 -*-
import getopt
import hashlib
import sys


def base_n(num, b):
    return ((num == 0) and "0") or (base_n(num // b, b).lstrip("0") + "0123456789abcdefghijklmnopqrstuvwxyz"[num % b])


def print_gradle_dir(url):
    output_url = "url is >> " + url
    print("\033[1;33m" + output_url + "\033[0m")
    md5_val = hashlib.md5(url.encode('utf8')).hexdigest()
    ten_val = int(md5_val, 16)
    val_36 = base_n(ten_val, 36)
    print("\033[1;31m" + val_36 + "\033[0m")


def main(argv):
    """
    主函数，读取脚本的参数，并且通过计算，输出目录名称
    源文件在：/Users/xuxingchen/IdeaProjects/MyScript
    :param argv: 输入的参数
    """
    try:
        """
            options, args = getopt.getopt(args, shortopts, longopts=[])
            
            参数args：一般是sys.argv[1:]。过滤掉sys.argv[0]，它是执行脚本的名字，不算做命令行参数。
            参数shortopts：短格式分析串。例如："hp:i:"，h后面没有冒号，表示后面不带参数；p和i后面带有冒号，表示后面带参数。
            参数longopts：长格式分析串列表。例如：["help", "ip=", "port="]，help后面没有等号，表示后面不带参数；ip和port后面带冒号，表示后面带参数。
            
            返回值options是以元组为元素的列表，每个元组的形式为：(选项串, 附加参数)，如：('-i', '192.168.0.1')
            返回值args是个列表，其中的元素是那些不含'-'或'--'的参数。
        """
        opts, args = getopt.getopt(argv, "-h-u:", ["help", "url="])
    except getopt.GetoptError as e:
        print('Please use as python gradle_dir.py -url http://www.baidu.com')
        print e
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-h", "--help"):
            print('Please use as python gradle_dir.py -url http://www.baidu.com')
        elif opt in ("-u", "--url"):
            print_gradle_dir(arg)
        else:
            print('Please use as python gradle_dir.py -url http://www.baidu.com')


if __name__ == '__main__':
    if len(sys.argv) <= 1:
        print "Please input -url"
    else:
        main(sys.argv[1:])
