@rem %1 - ��������, ������пո����ʱ����Ҫ�����ţ����ﲻ��ͳһ���ˣ������Ҽ��˵�����Ҳ����֧��·���пո�
@rem ���͸���ʱ���ó�ʱʱ��Ϊ600s

set dst_emails=chenguodong@huawei.com
@rem set dst_emails=sinojelly@163.com,mj.xiang@gmail.com,83711220@qq.com

blat -body "�μ�����" -to %dst_emails%  -ti 600 -base64 -charset Gb2312 -subject %1 -attach  %1 -server smtp.163.com -f sinojelly@163.com -u sinojelly -pw cedar8786



 