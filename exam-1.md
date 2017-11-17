# 安装VMware
* 下载VMware安装包，双击安装包，按默认配置安装即可
* 安装完毕后输入秘钥

# 在VMware上配置CentOS系统的虚拟机 
* 安装虚拟机
    - 选择文件，新建虚拟机，在弹出的窗口选择典型  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image014.jpg)  
    - 选择如图  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image016.jpg)  
    - 选择如图  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image018.jpg)  
    - 直接下一步  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image020.jpg)  
     - 一直依照默认设置，点击下一步，直到此处，点击完成  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image022.jpg)  
    - 选择CentOS，点击编辑虚拟机，选择CD/DVD  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image024.jpg)  
    - 选择使用ISO映像文件，点击浏览，选择你的iso映像文件  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image026.jpg)  
     - 点击确定，完成虚拟机的创建。  
     - 开启虚拟机，若显示BISO的虚拟化设置未开启，请自行开启。  
     - 选择Install CentOS 7  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image028.jpg)  
     - 选择如图  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image030.jpg)  
     - 选择如图  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image032.jpg)  
     - 设置root用户的密码  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image034.jpg)  
     - 点击Reboot，完成系统安装  
     - 按默认选择，进入系统，输入用户名和密码  
* 配置虚拟机网络  
  ```
  # 修改centos虚拟机的网络配置文件，设置静态ip，ip获取方式等等
  $ vi /etc/sysconfig/network-scripts/ifcfg-ens33
  # 修改后的ifcfg-ens33
    TYPE=Ethernet
    PROXY_METHOD=none
    BROWSER_ONLY=no
    BOOTPROTO=static
    DEFROUTE=yes
    IPV4_FAILURE_FATAL=no
    IPV6INIT=yes
    IPV6_AUTOCONF=yes
    IPV6_DEFROUTE=yes
    IPV6_FAILURE_FATAL=no
    IPV6_ADDR_GEN_MODE=stable-privacy
    NAME=ens33
    UUID=63a37e5d-1639-452c-94c7-bee57e3e4c1d
    DEVICE=ens33
    ONBOOT=yes

    IPADDR0=172.16.75.97
    PREFIXO0=24
    GATEWAY0=172.16.75.2
    DNS1=114.114.114.114
    DNS2=8.8.8.8

  # 重启网络服务
  $ systemctl restart network
  
  # 查看静态IP设置是否成功
  $ ip addr
  1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host 
           valid_lft forever preferred_lft forever
  2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast   state UP qlen 1000
        link/ether 00:0c:29:65:d7:de brd ff:ff:ff:ff:ff:ff
          inet 172.16.75.97/16 brd 172.16.255.255 scope global ens33
           valid_lft forever preferred_lft forever
        inet6 fe80::5eb7:bd88:c864:5c19/64 scope link 
           valid_lft forever preferred_lft forever
  
  # 测试网络是否连通
  $ ping www.baidu.com
  PING www.a.shifen.com (180.97.33.108) 56(84) bytes of data.
  64 bytes from 180.97.33.108 (180.97.33.108): icmp_seq=1 ttl=128 time=33.8 ms
  64 bytes from 180.97.33.108 (180.97.33.108): icmp_seq=2 ttl=128 time=34.0 ms
  64 bytes from 180.97.33.108 (180.97.33.108): icmp_seq=3 ttl=128 time=33.3 ms
  ^C   
  --- www.a.shifen.com ping statistics ---
  3 packets transmitted, 3 received, 0% packet loss, time 2004ms
  rtt min/avg/max/mdev = 33.360/33.731/34.012/0.312 ms

  # 网络配置成功
  ``` 
* 配置SSH服务  
   ```
   # 查看CentOS7是否安装了openssh-server
   $ yum list installed | grep openssh-server
   openssh-server.x86_64                7.4p1-11.el7                   @anaconda 
   # 若未安装，可以使用yum install openssh-server，安装openssh-server
   
   # 编辑/etc/ssh/目录下的sshd服务配置文件sshd_config，将文件中关于监听端口、监听地址前的#号去除
   $ vi /etc/ssh/sshd_config
   #  需去除#部分
   #   #Port 22
   #   #ListenAddress 0.0.0.0
   #   #ListenAddress ::
   #
   #   #PermitRootLogin yes
   #
   #   #PasswordAuthentication yes

   # 开启ssh服务，并将ssh服务设置为开机启动
   $ systemctl start sshd
   $ systemctl enable sshd

   # 检查sshd服务是否已经开启
   $ ps –e | grep sshd 
   1024 ?        00:00:00 sshd
   4789 ?        00:00:00 sshd

  # ssh配置成功
  ```

* 安装远程连接工具XShell  
	- 打开安装包，一直按照默认设置安装即可  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image066.jpg)   
	- 创建一个新的连接  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image068.jpg)   
        注：主机地址填写为centos的ip地址
	- 点击连接，输入用户名和密码  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image070.jpg)   
	- 连接成功  
	![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/image071.png)   
	- 远程连接配置完成  
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
   ```
  $ ps -e | grep ssh
   818 ?        00:00:00 sshd
  1216 ?        00:00:00 sshd
  1323 ?        00:00:00 sshd
  # 若未开启，使用sudo apt-get install openssh-server 开启SSH服务 
   ```
20. 查看虚拟机IP   
 ```
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:e5:bd:47 brd ff:ff:ff:ff:ff:ff
    inet 172.16.75.129/24 brd 172.16.75.255 scope global dynamic ens33
       valid_lft 1281sec preferred_lft 1281sec
    inet6 fe80::20c:29ff:fee5:bd47/64 scope link 
       valid_lft forever preferred_lft forever
 ```
21. 通过XShell连接，输入用户名和密码   
 ![图片加载失败](https://raw.githubusercontent.com/shenyuanyu/shenyuanyu/master/picture/Ubuntu%20(20).jpg)  
连接成功   
