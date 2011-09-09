@rem %1 - 附件名称, 如果带有空格传入的时候需要加引号，这里不能统一加了，否则右键菜单运行也不能支持路径有空格
@rem 发送附件时设置超时时间为600s

set dst_emails=chenguodong@huawei.com
@rem set dst_emails=sinojelly@163.com,mj.xiang@gmail.com,83711220@qq.com

blat -body "参见附件" -to %dst_emails%  -ti 600 -base64 -charset Gb2312 -subject %1 -attach  %1 -server smtp.163.com -f sinojelly@163.com -u sinojelly -pw cedar8786



 