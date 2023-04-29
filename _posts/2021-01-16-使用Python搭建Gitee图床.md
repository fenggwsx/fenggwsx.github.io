---
layout: post
title: 使用Python搭建Gitee图床
typora-root-url: ..
category: 实用技术
tags: [Python, Gitee, 图床]
---

## 摘要

在写博客的过程中经常要插入图片，许多博客平台提供了图片上传的服务，但是不能保证长期有效，不同平台还不能通用，所以要通过搭建统一的图床来实现。有用服务器作为图床和第三方图床，前者限制多，需要备案，后者不是很可靠，而用代码托管平台做图床，既稳定可靠没有很大限制，而且数据实现同步，即使云端的数据丢失了，本地还有备份，而在中国，为了提升访问速度，我们并不选取GitHub做图床，而是选择了Gitee，本文将使用Python实现对上传的图片自动压缩，自动编码，以及自动推送到远程仓库，但由于Gitee的限制，最后仍需要手动对Gitee Pages进行更新

## 新建仓库

如果没有帐户，先进入Gitee主页注册账户，接着新建仓库，名称为`resource`，路径为`res`（使用res是为了使图片链接看起来更加简洁）

新建完成后需要初始化`Readme.md`文件，同时复制地址（为了使用Gitee Pages服务）:

![](/assets/img/posts/d04e7c71683f2d4e796277da845558be.png)

然后打开服务选项：

![](/assets/img/posts/eebed08005daf88cffdd46a34f18cefd.png)

点击Gitee Pages：

![](/assets/img/posts/9e592f5e85b7b2812b535c9db2dd7d03.png)

点击“启动”启动服务：

![](/assets/img/posts/a2609ca0f769f305aa428b76409138fb.png)

## 克隆仓库

在计算机中找一个位置建一个文件夹，在文件夹中使用`Git Bash`输入命令克隆仓库到本地：

```shell
git clone https://gitee.com/xxx/xxx.git
```

克隆完成后在本地生成了一个名为`res`的文件夹，此时可以删除文件夹中的`Readme.md`文件，在`res`文件夹中新建空文件夹`upload_images`

在与`res`同级的目录下新建空文件夹`temp`用于存放待上传的文件：

![](/assets/img/posts/1de344227970390aaae914d666ffbd24.png)

## 获取TinyPng的"API Key"

进入TinyPng的主页（[https://tinypng.com/](https://tinypng.com/)），在右上角进行注册：

![](/assets/img/posts/d7bc6ac2e957625a27958718a113b81b.png)

输入邮箱地址：

![](/assets/img/posts/cdddcd204a9fadfd187e745273e01284.png)

打开邮箱验证，点击邮件中的"Log in with magic link"，点击刚刚注册的地方，选择"Account page"：

![](/assets/img/posts/b598a8d7594da1afcd8f03dbc3ec621a.png)

注册成功后会出现如下页面，启用并复制"API Key"

![](/assets/img/posts/a76fa520218d9caeba8c7aa623e4d9cb.png)

TinyPng每月支持免费转换500张图片，并且重复的图片多次压缩只算做一次，这对图片插入量一般的人来说已经足够了，如果觉得一个月500张不够，又不想花钱，可以多注册几个号

## 安装需要的Python包

脚本需要用到两个包：`tinify`和`GitPython`

打开cmd命令提示符，输入安装指令：

```
pip install --upgrade tinify
pip install gitpython
```

如果失败可以尝试本地安装

## 编写Python脚本

在与`res`同级的目录下新建`upload.py`：

![](/assets/img/posts/cc6cb8bdb080654f531b4473c5c76291.png)

用python的IDE打开该py文件写入如下代码：

```python
import random
import time
import os
import shutil
from git import Repo
import tinify

repo = Repo('./res') #创建版本库对象
tinify.key = '****************' #在此粘贴刚刚复制的API Key

exts = ['.png','.jpg','.bmp'] #支持的图像格式
compression = ['.png','.jpg'] #支持压缩的图像格式
srcdir = './temp' #源文件夹
dstdir = './res/upload_images' #目标文件夹
url = 'https://xxx.gitee.io/res/upload_images/' #图床路径（末尾必须加“/”），将xxx替换成自己的用户名

def random_hex(length):
    result = hex(random.randint(0,16**length)).replace('0x','').lower()
    if(len(result)<length):
        result = '0'*(length-len(result))+result
    return result

def auto_code(ext):
    while True:
        name = random_hex(8) #随机8位16进制编码
        result = os.path.join(dstdir,name + ext)
        if not os.path.exists(result):
            break #目标路径不存在则可以移动图片
    return result

def main():
    f = open('./output.txt','w') #打开输出文件
    list = os.listdir(srcdir) #列出文件夹下所有的目录与文件
    for i in range(0,len(list)):
        srcpath = os.path.join(srcdir,list[i])
        if not os.path.isfile(srcpath):
            continue #不是文件则跳过
        ext=os.path.splitext(srcpath)[-1].lower() #获取文件扩展名
        if ext not in exts:
            continue #不是支持的图像格式则跳过
        dstpath = auto_code(ext)
        if ext in compression:
            tinify.from_file(srcpath).to_file(srcpath) #压缩文件
            shutil.move(srcpath,dstpath) #移动文件
            print('成功压缩并移动：' + os.path.basename(srcpath))
        else:
            shutil.move(srcpath,dstpath) #移动文件
            print('成功移动：' + os.path.basename(srcpath))
        f.write(os.path.basename(srcpath) + ':![](' + url + os.path.basename(dstpath) + ')\n') #将原始文件名和与之对应的图片网址写入txt文件
    f.close()
    print('输出文件output.txt已生成')
    print(repo.git.add('--all')) #添加全部更改
    print(repo.git.commit('-m upload images')) #提交
    print(repo.remote().push('master')) #推送
    print('已推送至远程仓库，python即将退出')
    time.sleep(1)

if __name__ == '__main__':
    main()
```

## 测试功能

将图片复制到`temp`文件夹，运行`upload.py`，在其运行完毕后打开Gitee Pages服务进行更新，然后打开`output.txt`，复制里面的Markdown语句至Markdown编辑器即可看见图片