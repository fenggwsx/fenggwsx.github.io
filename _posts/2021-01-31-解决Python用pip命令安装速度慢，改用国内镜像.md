---
layout: post
title: 解决Python用pip命令安装速度慢，改用国内镜像
typora-root-url: ..
category: 软件配置
tags: [Pyhton, 配置, 镜像源]
---

> 本文转载于：[https://blog.csdn.net/shawroad88/article/details/87692142](https://blog.csdn.net/shawroad88/article/details/87692142)，进行了部分修改

Python提供了pip命令，让开发者很容易安装需要的模块。但是，用pip安装时，好多模块默认去外网下载，这样，下载速度就变得非常缓慢，这里我们提供一种解决方案：使用国内镜像下载地址

## 国内的一些站点
- 豆瓣：[http://pypi.douban.com/simple/](http://pypi.douban.com/simple/)
- 清华：[https://pypi.tuna.tsinghua.edu.cn/simple](https://pypi.tuna.tsinghua.edu.cn/simple)
- 阿里云：[http://mirrors.aliyun.com/pypi/simple/](http://mirrors.aliyun.com/pypi/simple/)
- 中国科技大学：[https://pypi.mirrors.ustc.edu.cn/simple/](https://pypi.mirrors.ustc.edu.cn/simple/)
- 华中理工大学：[http://pypi.hustunique.com/](http://pypi.hustunique.com/)
- 山东理工大学：[http://pypi.sdutlinux.org/](http://pypi.sdutlinux.org/)

## 临时使用方法

直接在安装模块的后面加参数：`-i http://pypi.douban.com/simple/`

例如：安装web模块`django`，我们这里指定用豆瓣：

```shell
pip install django -i http://pypi.douban.com/simple/
```

## 永久性使用

### Windows环境

直接在`user`目录中创建一个pip目录，如：`C:\Users\xx\pip`，新建文件`pip.ini`， 内容如下：

```ini
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = mirrors.aliyun.com
```

### Linux环境

修改 `~/.pip/pip.conf`  (没有的话创建一个，那个“.”必须有， 代表的是隐藏文件夹)，内容如下：

```ini
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = mirrors.aliyun.com
```