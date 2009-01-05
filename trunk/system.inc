<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''	文档作用：用于配置一些系统参数
''	创建时间：2005-1-1
''	修改情况：
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'设置电邮服务器
mail_server_style="Jmail"		'邮件服务器用的是那一种服务:([ASPmail]|[CDNOT][Jmail]);
mail_server_host="smtp.126.com"			'邮件SMTP的域名或IP地址;
mail_server_manager="txmaimai@163.com"			'邮件服务器的管理员的电邮地址;
'数据库的设置
db_server_style="ACCESS"		'设置采用何种数据库([ACCESS]|[SQLSERVER])
'服务器设置
server_buffer=true			'设置是否启用Buffer([true]|[false])
server_runtime=999			'设置脚本运行时间
Session.CodePage=65001
Response.Charset="utf-8"
'网站名称
server_name="/"				'如果是作为主网站,设为"/",如果是作为子网(虚拟目录),设为:"/虚拟目录"
'网站的网址
url_path="/"
%>
