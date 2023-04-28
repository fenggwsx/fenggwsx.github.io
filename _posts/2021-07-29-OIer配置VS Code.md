---
layout: post
title: OIer配置VS Code
typora-root-url: ..
category: 软件配置
tags: [OI, VS Code, 配置]
---

## 系统环境

本文通过虚拟机实现整个流程的模拟，使用的是Windows10x64纯净系统

## 安装VS Code

官网链接：[https://code.visualstudio.com/](https://code.visualstudio.com/)，安装过程很简单，一直下一步就可以了，至于以下这一步可以根据个人喜好来设置

![](/assets/img/posts/8f2d7fe92b4094deef5fdbfe3676348d.png)

VS Code首次启动主界面如下

![](/assets/img/posts/5fd6d4217265b286803b3e9e177403c5.png)

可以看到右下角提示安装中文包，如果希望使用中文界面，则安装即可

安装完成会自动重启VS Code，可以看到界面已经是中文了

![](/assets/img/posts/699df56ff16ee4a12829433ba8a7df52.png)

## 安装MinGW64

官网链接：[https://sourceforge.net/projects/mingw-w64/files/](https://sourceforge.net/projects/mingw-w64/files/)

滚动到网页如下位置

![](/assets/img/posts/1a6d5f3d026f5667743aced71a2f771b.png)

这里不推荐使用在线安装器，安装的时候下载速度非常慢，建议下载离线包自己配置

具体地：
- `x86_64-posix`适用于64位操作系统，`i686`适用于32位操作系统
- `sjlj`兼容32位和64位，稳定性较高，`seh`仅支持64位，`dwarf`仅支持32位，后两者性能较高
- `win32`用于开发窗口应用程序，这里用不到

这里使用了`x86_64-posix-sjlj`，下载完7z压缩包后进行解压，将`mingw64`文件夹放置在C盘的一个位置

![](/assets/img/posts/dc946f89df34437a5c2e4282f9462c20.png)

打开里面的`bin`文件夹，复制路径

![](/assets/img/posts/3fd5e08112200b6136130b41e8655a40.png)

打开系统环境变量，将之前复制的路径粘贴到`PATH`中，然后一路确定即可

![](/assets/img/posts/aea657af5c3d3a3a369aad8223bb9712.png)

至此，推荐重启一遍电脑，确保配置的环境变量生效

## 建立工作目录

建立一个自己的工作目录

![](/assets/img/posts/6a10b10783b9a59fb424e63e383912bf.png)

打开VS Code，在“文件-将文件夹添加至工作区”中选择之前创建的工作目录，然后点击“是，我信任此作者”

![](/assets/img/posts/4802ca6bdeb85c2bf2f698136574c8bb.png)

## 安装C/C++扩展

打开VS Code，点击左边的扩展选项，搜索“C/C++”，然后进行安装

![](/assets/img/posts/b73c6c6155aeea0f13570ee72ed8b70a.png)

## 配置工作目录

在工作目录中新建空文件`temp.cpp`，然后直接按`F5`运行，会提示选择环境，选择“C++ (GDB/LLDB)”

![](/assets/img/posts/afa8f7644a49253d049a9345fbc159e1.png)

然后选择“g++.exe”

![](/assets/img/posts/4422b2ab7658caab88792a39b8d12ad3.png)

接着，VS Code会创建两个`json`文件

![](/assets/img/posts/e696d962f2d1409d515dbcad16186edf.png)

打开`tasks.json`，在`args`中添加`-DLOCAL`，并将`cwd`改为`workspaceFolder`

```json
{
    "tasks": [
        {
            "type": "cppbuild",
            "label": "C/C++: g++.exe 生成活动文件",
            "command": "C:\\mingw64\\bin\\g++.exe",
            "args": [
                "-g",
                "${file}",
                "-o",
                "${fileDirname}\\${fileBasenameNoExtension}.exe",
                "-DLOCAL"
            ],
            "options": {
                "cwd": "${workspaceFolder}"
            },
            "problemMatcher": [
                "$gcc"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "detail": "调试器生成的任务。"
        }
    ],
    "version": "2.0.0"
}
```

按下快捷键`Ctrl`+`Shift`+`P`，输入“C/C++”，选择“C/C++: 编辑配置(JSON)”

在`json`文件中，将`LOCAL`添加至`defines`，并且把`cppStandard`设置为相应的比赛所要求的版本

以下仅供参考

```json
{
    "configurations": [
        {
            "name": "Win32",
            "includePath": [
                "${workspaceFolder}/**"
            ],
            "defines": [
                "_DEBUG",
                "UNICODE",
                "_UNICODE",
                "LOCAL"
            ],
            "windowsSdkVersion": "10.0.18362.0",
            "compilerPath": "C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.28.29333/bin/Hostx64/x64/cl.exe",
            "cStandard": "c11",
            "cppStandard": "c++11",
            "intelliSenseMode": "windows-msvc-x64"
        }
    ],
    "version": 4
}
```

## 添加模板

在工作目录中添加文件`template.cpp`，在其中填入模板

```cpp
#include <iostream>
#include <cstdio>
#include <ctime>
using namespace std;

int main()
{
    clock_t c1 = clock();
#ifdef LOCAL
    freopen("data.in","r",stdin);
    freopen("data.out","w",stdout);
#endif

    // Code Here

end:
    cerr << "Time Used:" << clock() - c1 << "ms" << endl;
    return 0;
}
```

## 添加批处理

考虑到每次复制模板也很麻烦，于是在工作目录中添加一个批处理文件`init.bat`，写入如下指令

```cmd
@echo off
copy main.cpp last.cpp
copy template.cpp main.cpp
```

这两句指令会将原来的代码文件做个备份，然后将模板覆盖上去

又考虑到有时在一道题还没AC的时候要做另一道题的情况，就在工作目录中再添加一个`bk.bat`（`bk`是`backup`的缩写），写入如下指令

```cmd
@echo off
if not exist backup md backup
copy main.cpp "backup/%1.cpp"
```

使用此批处理时需要加上一个参数，也就是文件名称，不需要加后缀`cpp`

## 运行代码

在工作目录中添加文件`data.in`，`data.out`和`main.cpp`，将两个输入输出文件拖到右边，随便写一段代码作为测试，此处以A+B为例

将下方的终端换成`cmd`，因为`powershell`调用`bat`不太方便，点开`+`右边的下箭头,点击“配置终端设置”

![](/assets/img/posts/a1ec0f77b6c9bb699874c7497e058809.png)

将默认终端设为`cmd`

![](/assets/img/posts/b0ebf73f0e9d901f35f5ad75cd129164.png)

设置完成后回到`main.cpp`，按下快捷键`Ctrl`+`Shift`+`B`生成`exe`，生成完毕后在`cmd`终端中输入`main`即可看到`data.out`给出了结果

![](/assets/img/posts/f99ffb224381e62f79c81476517db026.png)

## 调试代码

若要调试代码，下好断点后使用快捷键`F5`会启动调试，调试启动会比较慢

## 将来的流程

当要写一道新题目时，如果之前的那道还未解决，那么在终端中输入`bk unsolved`，`unsolved.cpp`会被放在`backup`文件夹中

接着输入`init`，`main.cpp`就会被初始化为模板了

## 参考资料

- [https://www.bilibili.com/video/BV1aK4y137oa](https://www.bilibili.com/video/BV1aK4y137oa)