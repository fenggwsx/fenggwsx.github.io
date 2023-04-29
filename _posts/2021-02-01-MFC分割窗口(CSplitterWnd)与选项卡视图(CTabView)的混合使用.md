---
layout: post
title: MFC分割窗口(CSplitterWnd)与选项卡视图(CTabView)的混合使用
typora-root-url: ..
category: 编程
tags: [C++, MFC]
---

本文提供了在主框架和选项卡视图中建立分割窗口，在分割窗口中建立选项卡视图并实现视图切换，这样分割窗口和选项卡视图就能循环嵌套使用了，本Demo项目的源码在Github上可供下载：[https://github.com/fenggwsx/SplitterWndTabViewCombined-Demo](https://github.com/fenggwsx/SplitterWndTabViewCombined-Demo)

## 新建解决方案

为了方便演示，我在创建MFC项目时，选择的应用程序类型为**单文档**，项目样式为**MFC standard**：

![](/assets/img/posts/e615ff6e40d1d5edf270f6ba4991b3fa.png)

创建完成后，首先在头文件`framework.h`中包含头文件`afxcview.h`，因为等下用到的`CTreeView`在这个头文件里，接着在`pch.h`中包含Demo项目下的头文件`MainFrm.h`，然后编译运行，界面如图所示：

![](/assets/img/posts/931fdfd93d3fc6db7b31d66f6f25c229.png)

## 在主框架中创建分割窗口

先添加两个类，分别为`CIndexTreeView`(继承自`CTreeView`)和`CView1`(继承自`CView`)，`CIndexTreeView`用来做索引的，为后续视图切换做准备，`CView1`是用来看显示效果的，为了让它能够易于辨识，我们需要在该类中写入一些绘图代码

先来写一下`CIndexTreeView`中的代码，第一步是要让该类具有动态创建的功能，所以在头文件中添加如下代码 ：

```cpp
protected:
	CIndexTreeView() noexcept;
	DECLARE_DYNCREATE(CIndexTreeView)
```

在源文件`CIndexTreeView.cpp`中添加如下代码：

```cpp
IMPLEMENT_DYNCREATE(CIndexTreeView, CTreeView)
```

第二步，打开类向导，响应`WM_CREATE`和`TVN_SELCHANGED`消息，重写虚函数`PreCreateWindow`

第三步，在`OnCreate`函数中写入如下代码：

```cpp
int CIndexTreeView::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CTreeView::OnCreate(lpCreateStruct) == -1)
		return -1;

	TVINSERTSTRUCT tvInsert;
	HTREEITEM hRootItem;

	tvInsert.hInsertAfter = NULL;

	tvInsert.hParent = TVI_ROOT;
	tvInsert.item.mask = LVFIF_TEXT;
	tvInsert.item.pszText = _T("Root");
	hRootItem = GetTreeCtrl().InsertItem(&tvInsert);

	GetTreeCtrl().InsertItem(_T("Node1"), hRootItem);
	GetTreeCtrl().InsertItem(_T("Node2"), hRootItem);

	GetTreeCtrl().Expand(hRootItem, TVE_EXPAND);

	return 0;
}
```

这样，我们已经将`CIndexTreeView`的节点都建立好了

第四步，在`PreCreateWindow`函数中写入如下代码：

```cpp
BOOL CIndexTreeView::PreCreateWindow(CREATESTRUCT& cs)
{
	cs.style |= TVS_SHOWSELALWAYS | TVS_HASLINES | TVS_LINESATROOT | TVS_HASBUTTONS;
	return CTreeView::PreCreateWindow(cs);
}
```

这些代码是为了修改`CIndexTreeView`的一些样式，所以这一步不是必须的

接着写`CView1`中的代码，第一步同样是要让它有动态创建的功能，代码与`CIndexTreeView`中的类似，只需要将其中的名称改为相应的`CView1`中的名称

第二步是要重写纯虚函数`OnDraw`，因为是纯虚函数，所以必须重写，在函数中写入如下代码：

```cpp
void CView1::OnDraw(CDC* pDC)
{
	CRect rect;
	GetClientRect(&rect);
	pDC->DrawText(CString(GetThisClass()->m_lpszClassName), &rect, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}
```

这些绘图命令会在视图的中央绘制出视图类的类名称

然后写``CMainFrame``中的代码，第一步是在`CMainFrame`类的头文件`MainFrm.h`中声明成员变量：

```cpp
protected:
	CSplitterWnd m_wndSplitterWnd;
```

第二步，重写虚函数`OnCreateClient`，代码如下,，包含相应头文件(`CIndexTreeView`和`CView1`)：

```cpp
BOOL CMainFrame::OnCreateClient(LPCREATESTRUCT lpcs, CCreateContext* pContext)
{
	m_wndSplitterWnd.CreateStatic(this, 1, 2);
	m_wndSplitterWnd.CreateView(0, 0, RUNTIME_CLASS(CIndexTreeView), CSize(200, 0), pContext);
	m_wndSplitterWnd.CreateView(0, 1, RUNTIME_CLASS(CView1), CSize(0, 0), pContext);

	return TRUE;
}
```

编译运行，可以看到如下界面，界面被分成了左右两块区域，左边是`CIndexTreeView`，右边是`CView1`：

![](/assets/img/posts/992996deda4c8cd35f67d722b90e628e.png)

## 创建选项卡视图

首先我们要新建视图`CView2`，与`CView1`相同，可以将`CView1`中的代码复制过来，更改类名即可

接下来我们要创建选项卡视图，添加类`CMyTabView`继承自`CTabView`(因为只有一个选项卡视图，所以不用下标)

第一步，同样是要让`CMyTabView`支持动态创建，这里不再赘述

第二步，响应`WM_CREATE`消息，在`OnCreate`函数中写入如下代码，包含相应头文件(`View2.h`)：

```cpp
int CMyTabView::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CTabView::OnCreate(lpCreateStruct) == -1)
		return -1;

	GetTabControl().SetLocation(CMFCTabCtrl::LOCATION_TOP);
	GetTabControl().ModifyTabStyle(CMFCTabCtrl::STYLE_FLAT);

	AddView(RUNTIME_CLASS(CView2), CString(RUNTIME_CLASS(CView2)->m_lpszClassName));

	return 0;
}
```

## 实现分割窗口的视图切换

首先在`CMainFrame`中添加函数`Switch`：

```cpp
public:
	void Switch(int nIndex);
```

接着在`Switch`函数中写入如下代码：

```cpp
void CMainFrame::Switch(int nIndex)
{
	switch (nIndex)
	{
	case 0:
		m_wndSplitterWnd.DeleteView(0, 1);
		m_wndSplitterWnd.CreateView(0, 1, RUNTIME_CLASS(CView1), CSize(0, 0), NULL);
		break;
	case 1:
		m_wndSplitterWnd.DeleteView(0, 1);
		m_wndSplitterWnd.CreateView(0, 1, RUNTIME_CLASS(CMyTabView), CSize(0, 0), NULL);
		break;
	}
	m_wndSplitterWnd.RecalcLayout();
}
```

然后在`CIndexTreeView`的`OnTvnSelchanged`函数中写入代码：

```cpp
void CIndexTreeView::OnTvnSelchanged(NMHDR* pNMHDR, LRESULT* pResult)
{
	LPNMTREEVIEW pNMTreeView = reinterpret_cast<LPNMTREEVIEW>(pNMHDR);
	HTREEITEM hRootItem = GetTreeCtrl().GetRootItem();
	HTREEITEM hCurItem = pNMTreeView->itemNew.hItem;
	if (hCurItem != hRootItem)
	{
		int nIndex = 0;
		HTREEITEM hItem = GetTreeCtrl().GetChildItem(hRootItem);
		while (hItem)
		{
			if (hItem == hCurItem)
				break;
			hItem = GetTreeCtrl().GetNextSiblingItem(hItem);
			nIndex++;
		}
		CMainFrame* pFrame = DYNAMIC_DOWNCAST(CMainFrame, AfxGetMainWnd());
		if (pFrame != NULL)
		{
			pFrame->Switch(nIndex);
			pFrame->SetActiveView(this);
		}
		
	}
	*pResult = 0;
}
```

最后编译运行，点击左边目录树上的`Node2`节点，可以看到如下界面：

![](/assets/img/posts/e8279d8398567f6fb0c0d7f832a6b645.png)

## 改进视图切换的方式

可以看到，在`CMainFrame`的`Switch`函数中，我们是通过删除分割窗格中原有的视图然后重新建立(推倒重建)的方法来实现视图的切换，但是当视图中要显示大量数据时，使用这种方法可能会导致卡顿的问题，所以我们可以使用另一种策略，通过显示和隐藏达到视图切换的目的，当然原来这种推倒重建的方法在数据量少的情况下是没有问题的

首先我们会发现，`CSplitterWnd`中没有绑定视图的操作，我们只能通过调用它的`CreateView`来创建视图，然而在调用时，我们只能通过`RUNTIME_CLASS(class_name)`告诉它要创建的视图类型，它会去新建一个视图，对于我们已有的视图，是无法直接绑定上去的

其次，`CSplitterWnd`的每一个窗格中只支持一个视图，如果将两个视图建在同一个窗格中程序就会报错

于是我通过分析`CSplitterWnd`中`GetPane`函数的源码明白了`CSplitterWnd`运作机理，找到了解决方案，以下是`GetPane`函数的源码：

```cpp
CWnd* CSplitterWnd::GetPane(int row, int col) const
{
	ASSERT_VALID(this);

	CWnd* pView = GetDlgItem(IdFromRowCol(row, col));
	ASSERT(pView != NULL);  // panes can be a CWnd, but are usually CViews
	return pView;
}
```

可以看到，`GetPane`函数仅仅是通过`GetDlgItem`来获取窗口指针的，所以窗口的ID号决定了窗口所在的位置，而同一个ID号有多个窗口会导致`GetDlgItem`返回`NULL`，进而引发程序报错

再来看看`CSplitterWnd`中`IdFromRowCol`的源码：

```cpp
int CSplitterWnd::IdFromRowCol(int row, int col) const
{
	ASSERT_VALID(this);
	ASSERT(row >= 0);
	ASSERT(row < m_nRows);
	ASSERT(col >= 0);
	ASSERT(col < m_nCols);

	return AFX_IDW_PANE_FIRST + row * 16 + col;
}
```

```cpp
#define AFX_IDW_PANE_FIRST              0xE900  // first pane (256 max)
#define AFX_IDW_PANE_LAST               0xE9ff
```

可以看到，`CSplitterWnd`中窗口的ID号，是从0xE900到0xE9ff，共256个，这也是`CSplitterWnd`的窗口分割最多支持16行16列的原因，了解了`CSplitterWnd`的工作方式，我们就可以通过改变视图的ID号和`ShowWindow`函数来实现显示和隐藏了

首先我们要找一个0xE900到0xE9ff之外的ID号，这里直接选择0xFFFF

声明两个视图类的指针作为`CMainFrame`的成员变量(这样我们就可以对视图进行管理了)：

```cpp
protected:
	CView1* m_pView1;
	CMyTabView* m_pMyTabView;
```

修改`CMainFrame`中的`OnCreateClient`函数：

```cpp
BOOL CMainFrame::OnCreateClient(LPCREATESTRUCT lpcs, CCreateContext* pContext)
{
	m_wndSplitterWnd.CreateStatic(this, 1, 2);
	m_wndSplitterWnd.CreateView(0, 0, RUNTIME_CLASS(CIndexTreeView), CSize(200, 0), pContext);

	m_pView1 = DYNAMIC_DOWNCAST(CView1, RUNTIME_CLASS(CView1)->CreateObject());
	m_pMyTabView = DYNAMIC_DOWNCAST(CMyTabView, RUNTIME_CLASS(CMyTabView)->CreateObject());

	m_pView1->Create(NULL, NULL, WS_CHILD,
		CRect(0, 0, 0, 0), &m_wndSplitterWnd, 0xFFFF, pContext);
	m_pMyTabView->Create(NULL, NULL, WS_CHILD,
		CRect(0, 0, 0, 0), &m_wndSplitterWnd, 0xFFFF, pContext);

	Switch(0);

	return TRUE;
}
```

注意`Switch(0);`语句不能漏掉，不然没有一个视图的ID是`m_wndSplitterWnd.IdFromRowCol(0,1)`会导致分割窗口找不到ID号所对应的窗口而出错

修改`Switch`函数：

```cpp
void CMainFrame::Switch(int nIndex)
{
	switch (nIndex)
	{
	case 0:
		::SetWindowLong(m_pView1->m_hWnd, GWL_ID, m_wndSplitterWnd.IdFromRowCol(0,1));
		m_pView1->ShowWindow(SW_SHOW);
		::SetWindowLong(m_pMyTabView->m_hWnd, GWL_ID, 0xFFFF);
		m_pMyTabView->ShowWindow(SW_HIDE);
		break;
	case 1:
		::SetWindowLong(m_pView1->m_hWnd, GWL_ID, 0xFFFF);
		m_pView1->ShowWindow(SW_HIDE);
		::SetWindowLong(m_pMyTabView->m_hWnd, GWL_ID, m_wndSplitterWnd.IdFromRowCol(0, 1));
		m_pMyTabView->ShowWindow(SW_SHOW);
		break;
	}
	m_wndSplitterWnd.RecalcLayout();
}
```

重新编译运行，可以看到实现了同样的切换效果

## 在选项卡视图中创建分割窗口

首先我们要新建视图`CView3`，这个视图中代码的结构也可以从`CView1`中复制过来，但是要删除`OnDraw`中的代码(不要删除函数的声明与定义，因为`OnDraw`是纯虚函数)

接着修改`CMyTabView`的`OnCreate`函数：

```cpp
int CMyTabView::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CTabView::OnCreate(lpCreateStruct) == -1)
		return -1;

	GetTabControl().SetLocation(CMFCTabCtrl::LOCATION_TOP);
	GetTabControl().ModifyTabStyle(CMFCTabCtrl::STYLE_FLAT);

	CCreateContext context;
	context.m_pCurrentDoc = GetDocument();
	context.m_pCurrentFrame = NULL;
	context.m_pLastView = NULL;
	context.m_pNewDocTemplate = NULL;
	context.m_pNewViewClass = NULL;

	AddView(RUNTIME_CLASS(CView2), CString(RUNTIME_CLASS(CView2)->m_lpszClassName), -1, &context);
	AddView(RUNTIME_CLASS(CView3), CString(RUNTIME_CLASS(CView3)->m_lpszClassName), -1, &context);

	return 0;
}
```

这里注意到，我新建了一个`CCreateContext`并在`AddView`的第四个参数中使用，这是通过分析`AddView`源码得来的，以下是部分`AddView`源码：

```cpp
CView* pView = DYNAMIC_DOWNCAST(CView, pViewClass->CreateObject());
ASSERT_VALID(pView);

if (!pView->Create(NULL, _T(""), WS_CHILD | WS_VISIBLE, CRect(0, 0, 0, 0), &m_wndTabs, (UINT) -1, pContext))
{
    TRACE1("CTabView:Failed to create view '%s'\n", pViewClass->m_lpszClassName);
    return -1;
}

CDocument* pDoc = GetDocument();
if (pDoc != NULL)
{
    ASSERT_VALID(pDoc);

    BOOL bFound = FALSE;
    for (POSITION pos = pDoc->GetFirstViewPosition(); !bFound && pos != NULL;)
    {
        if (pDoc->GetNextView(pos) == pView)
        {
            bFound = TRUE;
        }
    }

    if (!bFound)
    {
        pDoc->AddView(pView);
    }
}
```

可以看到，`AddView`函数先使用了`CreateObject`创建对象，然后用`Create`函数创建了视图，最后去`CDocument`里面寻找类是否绑定了文档，如果没有则进行绑定，这个过程的确符合构建的一般顺序，然而我们在调用`Create`函数的时候却触发了`WM_CREATE`消息，导致被创建的视图在调用`Create`函数后先要响应`WM_CREATE`消息，然后进行文档绑定，但是在被创建的类`CView3`中，在响应`WM_CREATE`消息时需要创建分割窗口，还要创建分割窗口中的视图，然而在这一创建过程中，`CView3`的`GetDocument`函数将返回`NULL`，导致文档类指针无法继续向子窗口传递，所以我使用了`CCreateContext`结构体，在调用`Create`函数时直接将文档指针传入，从而使`CView3`在创建子窗口时能继续传递文档指针

然后为`CView3`响应`WM_CREATE`消息，在`OnCreate`函数中写入如下代码：

```cpp
int CView3::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CView::OnCreate(lpCreateStruct) == -1)
		return -1;

	CCreateContext context;
	context.m_pCurrentDoc = GetDocument();
	context.m_pCurrentFrame = NULL;
	context.m_pLastView = NULL;
	context.m_pNewDocTemplate = NULL;
	context.m_pNewViewClass = NULL;

	m_wndSplitterWnd.CreateStatic(this, 2, 1);
	m_wndSplitterWnd.CreateView(0, 0, RUNTIME_CLASS(CView1), CSize(0, 0), &context);
	m_wndSplitterWnd.CreateView(1, 0, RUNTIME_CLASS(CView2), CSize(0, 0), &context);

	return 0;
}
```

保险起见，仍然使用`CCreateContext`传递文档指针，这里再次使用了`CView1`和`CView2`，其实应该使用另外视图的，为了减少大量的重复代码，重复使用了这两个视图

然后为`CView3`响应`WM_SIZE`消息，在`OnSize`函数中写入如下代码：

```cpp
void CView3::OnSize(UINT nType, int cx, int cy)
{
	CView::OnSize(nType, cx, cy);

	CRect rect;
	GetClientRect(&rect);

	if (m_wndSplitterWnd.GetSafeHwnd() != NULL)
	{
		m_wndSplitterWnd.MoveWindow(&rect);
		m_wndSplitterWnd.SetRowInfo(0, cy / 2, 0);
		m_wndSplitterWnd.RecalcLayout();
	}
}
```

这样实现了两个子视图平分分割窗口的功能

最后编译运行，点击左边目录树上的`Node2`节点，在点击选项卡上的`CView3`选项，可以看到如下界面：

![](/assets/img/posts/41ad48930bca4ce19219086f13d9d907.png)

## 总结

本文给出了分割窗口(CSplitterWnd)与选项卡视图(CTabView)相互建立的方法，同时给出了两种视图切换的方式，这样一来，我们可以不停地建立选项卡，分割视图，再建立选项卡，循环往复(只要你愿意这么做)
