// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//

#ifndef _STDAFX_H
#define _STDAFX_H

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#if !defined(__clang__)
#include "targetver.h"
#endif //__clang__

#define POINTER_64 __ptr64

#include "MTime.h"
#include "SafeString.h"

#endif
