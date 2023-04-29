---
layout: post
title: MFC中对Excel进行访问操作(OLE方式) 
typora-root-url: ..
category: 编程
tags: [MFC, Excel, OLE]
---

## 前言

我的配置：
- 操作系统：Windows 10 专业版
- Excel：Microsoft Excel 2013
- IDE：Visual Studio 2019

## 正文

### Visual Studio的版本为2015或更低

选择菜单中项目中的类向导

![](/assets/img/posts/c7db784470e3097025f36fe6d1eddb18.png)

在添加类中选择添加类型库中的MFC类

![](/assets/img/posts/4e619751565d7dec93d094ada2f7a753.png)

在可用的类型库中选择Excel，如果没有Excel相关的类型库选项，则选择文件，输入`EXCEL.EXE`所在的位置即可，一般`EXCEL.EXE`在（其中OfficeXXX中的XXX随Excel版本的不同而不同）：

```text
C:\Program Files\Microsoft Office\OfficeXXX\EXCEL.EXE
```

![](/assets/img/posts/66950634559a3dd79ec5d19b22bc85d1.png)

添加6个接口：`_Application`,`_Workbook`,`Worksheet`,`Range`,`Workbooks`,`Worksheets`，分别对应6个类`CApplication`,`CWorkbook`,`CWorksheet`,`CRange`,`CWorkbooks`,`CWorksheets`，如果还需要其他接口，可自行添加

![](/assets/img/posts/0b48be890c5f3188a19bcbb225de02b3.png)

点击`完成`，此时项目中会多出这六个类的头文件，打开这六个文件，将除`CApplication`类所在文件的其他五个文件的如下`#import`语句删除，只保留`CApplication`类所在文件的那个：

```cpp
#import "C:\\Program Files\\Microsoft Office\\OfficeXXX\\EXCEL.EXE" no_namespace
```

并且在`CRange`类中的`VARIANT DialogBox()`函数的定义改为`VARIANT _DialogBox()`
在需要访问Excel的源文件中包含这6个类，以下是示例代码：

```cpp
// 声明变量
CApplication app;
CWorkbook book;
CWorkbooks books;
CWorksheet sheet;
CWorksheets sheets;
CRange range;
LPDISPATCH lpDisp;

COleVariant covOptional((long)DISP_E_PARAMNOTFOUND, VT_ERROR);
if (!app.CreateDispatch(_T("Excel.Application"), NULL))
{
	return -1;
}
app.put_Visible(FALSE);
books = app.get_Workbooks();
lpDisp = books.Open(_T("C:\\Users\\fengy\\Desktop\\Test.xls"), covOptional
	, covOptional, covOptional, covOptional, covOptional, covOptional, covOptional
	, covOptional, covOptional, covOptional
	, covOptional, covOptional, covOptional
	, covOptional); // 文档路径可自行更改
book.AttachDispatch(lpDisp);
sheets = book.get_Worksheets();
sheet = sheets.get_Item(COleVariant((short)1)); // 取得第一张工作表
range = sheet.get_UsedRange();

// 获取数据，抄MSDN的Sample的（通过接收1个二维数组的方式一次性读取所有数据，减少对Excel的访问次数，从而提升性能，具体可参考MSDN）
COleSafeArray sa(range.get_Value2());

//Determine upper bounds for both dimensions
long lNumRows;
long lNumCols;
sa.GetUBound(1, &lNumRows);
sa.GetUBound(2, &lNumCols);

//Display the elements in the SAFEARRAY.
long index[2] = { 0 };
COleVariant val;

//Determine lower bounds for both dimensions
long lowRow, lowCol;
sa.GetLBound(1, &lowRow);
sa.GetLBound(2, &lowCol);

// 测试代码
index[0] = lowRow; // 取第一行
index[1] = lowCol; // 取第一列
sa.GetElement(index, val); // 获取数据的函数
val.ChangeType(VT_BSTR); // 转换类型
AfxMessageBox(CString(val.bstrVal)); // 输出
```

### Visual Studio 2017或Visual Studio 2019

我使用的就是Visual Studio 2019，这个版本中的类向导无法添加类型库中的MFC类（不知是否是微软将此功能隐藏了或是删去了），我搜索了许多文章，最后我采用的方法是下载了Visual Studio 2015，新建了一个MFC项目，进行了上面的操作，将6个头文件添加到了Visual Studio 2019项目的目录下，在本文结尾，我将这6个头文件的内容贴在此（不知道Excel的其他版本能否使用）：[MFC中对Excel进行访问操作相关文件.rar](https://files.cnblogs.com/files/fenggwsx/MFC%E4%B8%AD%E5%AF%B9Excel%E8%BF%9B%E8%A1%8C%E8%AE%BF%E9%97%AE%E6%93%8D%E4%BD%9C%E7%9B%B8%E5%85%B3%E6%96%87%E4%BB%B6.rar)