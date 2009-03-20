@rem %1 - 附件名称, 如果带有空格传入的时候需要加引号，这里不能统一加了，否则右键菜单运行也不能支持路径有空格
@rem 发送附件时设置超时时间为600s

blat -body "参见附件" -to chenguodong@huawei.com -ti 600 -base64 -charset Gb2312 -subject %1 -attach  %1 -server smtp.163.com -f sinojelly@163.com -u sinojelly -pw cedar8786



 