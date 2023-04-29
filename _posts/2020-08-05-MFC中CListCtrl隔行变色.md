---
layout: post
title: MFC中CListCtrl隔行变色
typora-root-url: ..
category: 编程
tags: [C++, MFC]
---

## 响应NM_CUSTOMDRAW消息

```cpp
void CMyView::OnNMCustomdraw(NMHDR* pNMHDR, LRESULT* pResult)
{
	NMLVCUSTOMDRAW* pLVCD = reinterpret_cast<NMLVCUSTOMDRAW*>(pNMHDR);
	*pResult = 0;
	if (CDDS_PREPAINT == pLVCD->nmcd.dwDrawStage)
	{
		*pResult = CDRF_NOTIFYITEMDRAW;
	}
	else if (CDDS_ITEMPREPAINT == pLVCD->nmcd.dwDrawStage)
	{
		if (pLVCD->nmcd.dwItemSpec % 2 == 0)
			pLVCD->clrTextBk = RGB(255, 255, 255);
		else if (pLVCD->nmcd.dwItemSpec % 2 == 1)
			pLVCD->clrTextBk = RGB(240, 240, 240);
		*pResult = CDRF_DODEFAULT;
	}
}
```
## 引用文章链接
原文链接：[https://www.cnblogs.com/Guo-xin/p/11723460.html](https://www.cnblogs.com/Guo-xin/p/11723460.html)