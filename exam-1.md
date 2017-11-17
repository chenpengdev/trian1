# 安装VMware
* 下载VMware安装包，双击安装包，然后按图示步骤安装  
![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image002.jpg)  
![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image004.jpg)  
![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image006.jpg)  
![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image008.jpg)  
![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image010.jpg)  
![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image012.jpg)  
* 点击安装，完成安装，在安装完毕后输入秘钥

# 在VMware上配置CentOS系统的虚拟机 
* 安装虚拟机
    1. 选择文件，新建虚拟机，在弹出的窗口选择典型  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image014.jpg)  
	2. 选择如图  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image016.jpg)  
	3. 选择如图  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image018.jpg)  
	4. 直接下一步  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image020.jpg)  
	5. 一直依照默认设置，点击下一步，直到此处，点击完成  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image022.jpg)  
	6. 选择CentOS，点击编辑虚拟机，选择CD/DVD  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image024.jpg)  
	7. 选择使用ISO映像文件，点击浏览，选择你的iso映像文件  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image026.jpg)  
	8. 点击确定，完成虚拟机的创建。  
	9. 开启虚拟机，若显示BISO的虚拟化设置未开启，请自行开启。  
	10. 选择Install CentOS 7  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image028.jpg)  
	11. 选择如图  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image030.jpg)  
	12. 选择如图  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image032.jpg)  
	13. 设置root用户的密码  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image034.jpg)  
	14. 点击Reboot，完成系统安装  
	15. 按默认选择，进入系统，输入用户名和密码  
* 配置虚拟机网络  
	1. 选择编辑，虚拟网络编辑器  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image036.jpg) 
	1. 查看NAT模式的设置  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image038.jpg) 
	1. 记录子网掩码：255.255.255.0，网关172.16.75.2  
	1. 修改/etc/sysconfig/network-scripts/目录下的ifcfg-ens33文件如下：(修改命令：vi /etc/sysconfig/network-scripts/ifcfg-ens33)  
		![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image040.jpg) 
		修改
		BOOTPRORO=static       //将IP获取方式设为静态  
		ONBOOT=yes			  //启用网络服务  
		IPADDR0=172.16.75.97	  //设置虚拟机IP，要与网关在同一网段  
		PREFIXO0=24			  //设置子网掩码  
		GATEWAY0=172.16.75.2   //设置网关  
		DNS1=114. 114. 114. 114  //设置DNS：国内  
		DNS2=8.8.8.8			  //设置DNS：谷歌  
		(此处其实设置BOOTPRORO=dhcp,ONBOOT=yes，即可开启网络，这里设置为静态，是为了之后开启远程控制)  
	1. 执行命令：service network restart，重启网络服务，开启网络  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image042.jpg) 
	1. 执行命令：ping www.baidu.con，测试网络开启是否成功  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image044.jpg) 
	1. 网络配置成功  
* 配置SSH服务  
	1. 查看CentOS7是否安装了openssh-server（命令：yum list installed | grep openssh-server） 
![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image046.jpg)   
	若未安装，使用yum install openssh-server，安装openssh-server  
	1. 编辑/etc/ssh/目录下的sshd服务配置文件sshd_config，将文件中关于监听端口、监听地址前的#号去除，该部分如下：  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image048.jpg)   
	然后开启允许远程登陆，去除PermitRootLogin的#号  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image050.jpg)   
	最后，开启使用用户名密码来作为连接验证，去除PasswordActhentication的#  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image052.jpg)   
	1. 开启sshd服务，输入service sshd start  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image054.jpg)   
	1. 检查sshd服务是否已经开启，输入ps –e | grep sshd   
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image056.jpg)  
	1. 在windows主机中，通过ipconfig查看VMnet8d的连接信息，发下ip地址如下：  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image058.jpg) 
	1. 在CentOS中，输入ifconfig查看网络连接地址，发现IP地址如下：  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image060.jpg) 
	1. 在CentOS中，输入ping 172.16.75.1，测试是否能连通主机  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image062.jpg) 
	1. 在windows中，输入ping 172.16.75.97，测试是否能连通CentOS  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image064.jpg) 
	1. 若不能，修改网络适配器VMnet8的TCP/IPv4的属性，进行一下网络配置，保证主机的  IP  和  CentOS  的  IP  在同一网络区段中，然后在使用ping命令测试
* 安装远程连接工具XShell  
	1. 打开安装包，一直按照默认设置安装即可  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image066.jpg)   
	1. 创建一个新的连接  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image068.jpg)   
	1. 点击连接，输入用户名和密码  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image070.jpg)   
	1. 连接成功  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image071.png)   
	1. 远程连接配置完成  
# Ubuntu安装  
1. 先按创建虚拟机步骤，选择Ubuntu，并将要安装的Ubuntu的iso镜像导入  
2. 运行UBuntu系统，开始安装系统  
3. 选择语言，English  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(1).jpg)    
4. 选择Install Ubuntu Server  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(2).jpg)  
![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(3).jpg)   
5. 选择时区，选择United States即可，可以进入系统后调整   
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(4).jpg)  
6. 配置键盘，默认“No”，然后选英语键盘即可  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(5).jpg)  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(6).jpg)  
然后enter确认  
7. 然后会开始安装。显示网络自动配置失败，进行手动配置即可。  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(7).jpg)  
8. 设置主机名  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(8).jpg)  
9. 设置一个普通账户  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(9).jpg)  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(10).jpg)  
10. 设置普通用户密码  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(11).jpg)   
然后确认密码，若密码过弱，会提示是否使用密码，选择yes  
11. 是否对主目录加密，选择否即可  
12. 确认时区是否正确，选择yes即可  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(12).jpg)  
13. 设置磁盘分区，使用默认即可  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(13).jpg)  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(14).jpg)  
14. 是否将改动写入磁盘，选择yes  
15. 直接下一步  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(15).jpg)  
16. 是否自动更新，默认不更新即可  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(16).jpg)  
用空格选择OpenSSH server，开启SSH服务，然后用enter下一步  
17. 选择yes，下一步  
18. 选择continue，安装完成  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(17).jpg)  
19. 进入系统，查看是否开启SSH服务  
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(18).jpg)  
若未开启，使用sudo apt-get install openssh-server 开启SSH服务   
20. 查看虚拟机IP   
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(19).jpg)  
21. 通过XShell连接，输入用户名和密码   
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(20).jpg)  
连接成功   
