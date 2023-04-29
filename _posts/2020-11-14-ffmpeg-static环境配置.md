---
layout: post
title: ffmpeg-static环境配置
typora-root-url: ..
category: 软件配置
tags: [ffmpeg, 配置]
---

## 准备工作

下载ffmpeg，最新版下载地址：[https://github.com/BtbN/FFmpeg-Builds/releases](https://github.com/BtbN/FFmpeg-Builds/releases)

找到`ffmpeg`的文件夹，打开其中的`bin`文件夹，复制`bin`文件夹的路径
![](/assets/img/posts/8ddcce5fb4a83aa2fb30f0c5647d2ebb.png)

## 设置环境变量

右键“此电脑”，点击“属性(R)”，然后点击“高级系统设置”
![](/assets/img/posts/af736977a1139ea81cc6ef49b90d419e.png)
在选项卡中选择“高级”，点击“环境变量”按钮
![](/assets/img/posts/3d54a92ba9080f11b840c77e00ba5701.png)
在“系统变量(S)”中，双击`Path`进行编辑
![](/assets/img/posts/c715bcac4ce29e34bb50236afd4ba457.png)
点击“新建”
![](/assets/img/posts/381f982f680dca268481cccfa538040e.png)
将刚才复制的路径粘贴
![](/assets/img/posts/4894662820d0b61ceb0771cd28dc6415.png)
然后一路点击“确定”关闭之前所有的对话框

## 测试检查

使用`Win+R`组合键调出“运行”对话框，输入“cmd”后回车调出`cmd命令行`
![](/assets/img/posts/b02870788ab032a6ae8ab9bafb646c46.png)
输入`ffmpeg -version`检查是否配置成功
![](/assets/img/posts/21f9c2880adb8a180d01641193689542.png)
如果出现类似以下的版本信息则表明配置成功了
![](/assets/img/posts/61f33a37952d99b29ab193f42808c3d8.png)


## 关于ffmpeg

> FFmpeg是一套可以用来记录、转换数字音频、视频，并能将其转化为流的开源计算机程序。采用LGPL或GPL许可证。它提供了录制、转换以及流化音视频的完整解决方案。它包含了非常先进的音频/视频编解码库libavcodec，为了保证高可移植性和编解码质量，libavcodec里很多code都是从头开发的。

> FFmpeg在Linux平台下开发，但它同样也可以在其它操作系统环境中编译运行，包括Windows、Mac OS X等。这个项目最早由Fabrice Bellard发起，2004年至2015年间由Michael Niedermayer主要负责维护。许多FFmpeg的开发人员都来自MPlayer项目，而且当前FFmpeg也是放在MPlayer项目组的服务器上。项目的名称来自MPEG视频编码标准，前面的"FF"代表"Fast Forward"。FFmpeg编码库可以使用GPU加速

资料来自百度百科，也是为了这篇随笔更完整一点。

## 总结

这篇随笔主要介绍了ffmpeg环境配置的方法，其实网上搜索能找到很多类似的随笔，我这里只是为了方便而记录下来，当然截图也更加详细，不会让人不太好理解