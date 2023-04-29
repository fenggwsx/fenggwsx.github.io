---
layout: post
title: MFC中CListCtrl的样式 
typora-root-url: ..
category: 编程
tags: [C++, MFC]
---

## CListCtrl的样式

| 名称 | 值 | 描述 |
| ---- | ---- | ---- |
| LVS_ICON | 0x0000 | 指定为图标视图,为每个item显示大图标 |
| LVS_REPORT | 0x0001 | 指定报表视图,显示item详细资料 |
| LVS_SMALLICON | 0x0002 | 指定为小图标视图,为每个item显示小图标 |
| LVS_LIST | 0x0003 | 指定为列表视图,显示一列带有小图标的item |
| LVS_TYPEMASK | 0x0003 | 可以使用`LVS_TYPEMASK`风格从视图列表类别中获得当前列表的类别 |
| LVS_SINGLESEL | 0x0004 | 允许每次只能选择一个项。缺省时，同时能选择多项 |
| LVS_SHOWSELALWAYS | 0x0008 | 总是显示选择框，即使任何控件都没有焦点 |
| LVS_SORTASCENDING | 0x0010 | 使项按照项文本的升序方式排列 |
| LVS_SORTDESCENDING | 0x0020 | 使项按照项文本的降序方式排列 |
| LVS_SHAREIMAGELISTS | 0x0040 | 指定控件没有归属于它的图象列表的所有权（也就是说，当控件被销毁后，图象列表不会被销毁）。该风格能够是同一个图象列表用于多个列表视图控件中 |
| LVS_NOLABELWRAP | 0x0080 | 在图标视图的单行中显示项文本，缺省时，在图标视图中项文本有可能被遮住 |
| LVS_AUTOARRANGE | 0x0100 | 在图标或小图标视图中指定图标自动保持对齐 |
| LVS_EDITLABELS | 0x0200 | 允许项文本能够适本地进行编辑。父窗口必须运行了`LVN_ENDLABLEDIT`通知消息 |
| LVS_OWNERDATA | 0x1000 | 指定一个虚拟的ListView, 由用户自己管理Item数据 |
| LVS_NOSCROLL | 0x2000 | 不允许滚动，所有项都必须在客户可视的区域内 |
| LVS_TYPESTYLEMASK | 0xfc00 | 可以使用`LVS_TYPESTYLEMASK`风格获得对齐方式（`LVS_ALIGNTOP`、`LVS_ALIGNLEFT`）和头显示和行为（`LVS_NOCOLUMNHEADER`、`LVS_NOSORTHEADER`）的的风格 |
| LVS_ALIGNTOP | 0x0000 | 在图标和小图标视图中指定项在控件的顶端对齐 |
| LVS_ALIGNLEFT | 0x0800 | 在图标和小图标视图中指定项左对齐 |
| LVS_ALIGNMASK | 0x0c00 | 可以使用`LVS_ALIGNMASK`风格获得视图列表当前靠齐方式 |
| LVS_OWNERDRAWFIXED | 0x0400 | 在报表视图中允许所有者窗口为项着色。列表视图控件发送一条`WM_DRAWITWM`消息来为每一项着色；但它不为每一子项发送独立的消息。`DRAWITEMSTRUCT`结构中的`itemDate`成员则包含了指定列表视图项的项数据 |
| LVS_NOCOLUMNHEADER | 0x4000 | 指定在报表视图中不显示列标题。缺省时，在报表视图中列有标题 |
| LVS_NOSORTHEADER | 0x8000 | 指定列标题不象按钮那样工作。这种风格是有用的，例如，当在报表视图中单击列标题，将不会带来例如排序那样的动作 |

## CListCtrl的扩展样式

| 名称 | 值 | 描述 |
| ---- | ---- | ---- |
| LVS_EX_AUTOAUTOARRANGE | 0x01000000 | Windows Vista and later. Automatically arrange icons if no icon positions have been set (Similar to `LVS_AUTOARRANGE`). |
| LVS_EX_AUTOCHECKSELECT | 0x08000000 | Windows Vista and later. Automatically select check boxes on single click. |
| LVS_EX_AUTOSIZECOLUMNS | 0x10000000 | Windows Vista and later. Automatically size listview columns. |
| LVS_EX_BORDERSELECT | 0x00008000 | Version 4.71 and later. Changes border color when an item is selected, instead of highlighting the item. |
| LVS_EX_CHECKBOXES | 0x00000004 | Version 4.70. Enables check boxes for items in a list-view control. When set to this style, the control creates and sets a state image list with two images using `DrawFrameControl`. State image 1 is the unchecked box, and state image 2 is the checked box. Setting the state image to zero removes the check box.<br>Version 6.00 and later Check boxes are visible and functional with all list view modes except the tile view mode introduced in `ComCtl32.dll` version 6. Clicking a checkbox in tile view mode only selects the item; the state does not change.<br>You can obtain the state of the check box for a given item with `ListView_GetCheckState`. To set the check state, use `ListView_SetCheckState`. If this style is set, the list-view control automatically toggles the check state when the user clicks the check box or presses the space bar. |
| LVS_EX_COLUMNOVERFLOW | 0x80000000 | Indicates that an overflow button should be displayed in icon/tile view if there is not enough client width to display the complete set of header items. The list-view control sends the LVN_COLUMNOVERFLOWCLICK notification when the overflow button is clicked. This flag is only valid when `LVS_EX_HEADERINALLVIEWS` is also specified. |
| LVS_EX_COLUMNSNAPPOINTS | 0x40000000 | Windows Vista and later. Snap to minimum column width when the user resizes a column. |
| LVS_EX_DOUBLEBUFFER | 0x00010000 | Version 6.00 and later. Paints via double-buffering, which reduces flicker. This extended style also enables alpha-blended marquee selection on systems where it is supported. |
| LVS_EX_FLATSB | 0x00000100 | Enables flat scroll bars in the list view. If you need more control over the appearance of the list view's scroll bars, you should manipulate the list view's scroll bars directly using the Flat Scroll Bar APIs. If the system metrics change, you are responsible for adjusting the scroll bar metrics with `FlatSB_SetScrollProp`. See Flat Scroll Bars for further details. |
| LVS_EX_FULLROWSELECT | 0x00000020 | When an item is selected, the item and all its subitems are highlighted. This style is available only in conjunction with the `LVS_REPORT` style. |
| LVS_EX_GRIDLINES | 0x00000001 | Displays gridlines around items and subitems. This style is available only in conjunction with the `LVS_REPORT` style. |
| LVS_EX_HEADERDRAGDROP | 0x00000010 | Enables drag-and-drop reordering of columns in a list-view control. This style is only available to list-view controls that use the `LVS_REPORT` style. |
| LVS_EX_HEADERINALLVIEWS | 0x02000000 | Windows Vista and later. Show column headers in all view modes. |
| LVS_EX_HIDELABELS | 0x00020000 | Version 6.00 and later. Hides the labels in icon and small icon view. |
| LVS_EX_INFOTIP | 0x00000400 | When a list-view control uses the `LVS_EX_INFOTIP` style, the `LVN_GETINFOTIP` notification code is sent to the parent window before displaying an item's tooltip. |
| LVS_EX_JUSTIFYCOLUMNS | 0x00200000 | Windows Vista and later. Icons are lined up in columns that use up the whole view. |
| LVS_EX_LABELTIP | 0x00004000 | If a partially hidden label in any list view mode lacks tooltip text, the list-view control will unfold the label. If this style is not set, the list-view control will unfold partly hidden labels only for the large icon mode. |
| LVS_EX_MULTIWORKAREAS | 0x00002000 | If the list-view control has the `LVS_AUTOARRANGE` style, the control will not autoarrange its icons until one or more work areas are defined. To be effective, this style must be set before any work areas are defined and any items have been added to the control.
| LVS_EX_ONECLICKACTIVATE | 0x00000040 | The list-view control sends an `LVN_ITEMACTIVATE` notification code to the parent window when the user clicks an item. This style also enables hot tracking in the list-view control. Hot tracking means that when the cursor moves over an item, it is highlighted but not selected. See the Extended List-View Styles Remarks section for a discussion of item activation. |
| LVS_EX_REGIONAL | 0x00000200 | 	Version 4.71 through Version 5.80 only. Not supported on Windows Vista and later. Sets the list view window region to include only the item icons and text using `SetWindowRgn`. Any area that is not part of an item is excluded from the window region. This style is only available to list-view controls that use the `LVS_ICON` style.
| LVS_EX_SIMPLESELECT | 0x00100000 | Version 6.00 and later. In icon view, moves the state image of the control to the top right of the large icon rendering. In views other than icon view there is no change. When the user changes the state by using the space bar, all selected items cycle over, not the item with the focus. |
| LVS_EX_SINGLEROW | 0x00040000 | Version 6.00 and later. Not used. |
| LVS_EX_SNAPTOGRID | 0x00080000 | Version 6.00 and later. In icon view, icons automatically snap into a grid. |
| LVS_EX_SUBITEMIMAGES | 0x00000002 | Allows images to be displayed for subitems. This style is available only in conjunction with the `LVS_REPORT` style. |
| LVS_EX_TRACKSELECT | 0x00000008 | Enables hot-track selection in a list-view control. Hot track selection means that an item is automatically selected when the cursor remains over the item for a certain period of time. The delay can be changed from the default system setting with a `LVM_SETHOVERTIME` message. This style applies to all styles of list-view control. You can check whether hot-track selection is enabled by calling `SystemParametersInfo`. |
| LVS_EX_TRANSPARENTBKGND | 0x00400000 | Windows Vista and later. Background is painted by the parent via `WM_PRINTCLIENT`. |
| LVS_EX_TRANSPARENTSHADOWTEXT | 0x00800000 | Windows Vista and later. Enable shadow text on transparent backgrounds only. |
| LVS_EX_TWOCLICKACTIVATE | 0x00000080 | The list-view control sends an `LVN_ITEMACTIVATE` notification code to the parent window when the user double-clicks an item. This style also enables hot tracking in the list-view control. Hot tracking means that when the cursor moves over an item, it is highlighted but not selected. See the Extended List-View Styles Remarks section for a discussion of item activation. |
| LVS_EX_UNDERLINECOLD | 0x00001000 | Causes those non-hot items that may be activated to be displayed with underlined text. This style requires that `LVS_EX_TWOCLICKACTIVATE` be set also. See the Extended List-View Styles Remarks section for a discussion of item activation. |
| LVS_EX_UNDERLINEHOT | 0x00000800 | Causes those hot items that may be activated to be displayed with underlined text. This style requires that `LVS_EX_ONECLICKACTIVATE` or `LVS_EX_TWOCLICKACTIVATE` also be set. See the Extended List-View Styles Remarks section for a discussion of item activation. |

## 引用文章链接

原文链接：[https://blog.csdn.net/qq1134993111/article/details/11312749](https://blog.csdn.net/qq1134993111/article/details/11312749)