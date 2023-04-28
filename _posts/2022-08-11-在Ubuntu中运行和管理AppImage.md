---
layout: post
title: 在Ubuntu中运行和管理AppImage
typora-root-url: ..
category: 系统管理
tags: [Ubuntu, Linux, AppImage]
---

## 什么是AppImage

`AppImage `是一种把应用打包成单一文件的格式，允许在各种不同的Linux系统上运行，无需进一步修改

本文主要讲如何在Ubuntu中运行和管理它

## 如何运行AppImage

要运行`AppImage`，为其添加可执行权限即可

假如当前目录下有一个名为`app.appimage`的文件，运行下面命令赋予其可执行权限：

```bash
chmod +x app.appimage
```

然后运行该`AppImage`：

```bash
sudo ./app.appimage
```

## 如何管理AppImage

`AppImage`可以在任何位置运行，但是这样运行起来非常不方便，我们希望可以有程序来统一管理这些`AppImage`，并且为它们添加到开始菜单中以方便启动，`AppImageLauncher`就是这样一个程序

### 安装AppImageLauncher

从Github中获取`AppImageLauncher`的最新发布版：[https://github.com/TheAssassin/AppImageLauncher/releases](https://github.com/TheAssassin/AppImageLauncher/releases)

根据自己的系统架构，下载对应的`deb`安装包，下载后进行安装：

```bash
sudo dpkg -i  appimagelauncher*.deb
```

### 添加AppImage

安装完成后，再运行任何未安装的`AppImage`程序文件，都会询问是单次运行`Run once`或是集成并运行`Intergrate and run`，选择后者就会将AppImage移至统一的文件夹下（默认为`~/Applications/`，可以在`AppImageLauncher`的设置中修改），并且为其添加到开始菜单中，这样以后运行就会方便许多

### 移除AppImage

如果通过`AppImageLauncher`管理的某个`AppImage`不想要了，可直接对开始菜单中该程序的图标右键，选择从系统中移除`Remove from system`即可