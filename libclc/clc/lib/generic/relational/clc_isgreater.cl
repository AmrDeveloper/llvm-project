//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include <clc/internal/clc.h>
#include <clc/relational/relational.h>

#define _CLC_RELATIONAL_OP(X, Y) (X) > (Y)

_CLC_DEFINE_SIMPLE_RELATIONAL_BINARY(int, int, __clc_isgreater, float, float)

#ifdef cl_khr_fp64

#pragma OPENCL EXTENSION cl_khr_fp64 : enable

// The scalar version of __clc_isgreater(double, double) returns an int, but the
// vector versions return long.
_CLC_DEFINE_SIMPLE_RELATIONAL_BINARY(int, long, __clc_isgreater, double, double)

#endif

#ifdef cl_khr_fp16

#pragma OPENCL EXTENSION cl_khr_fp16 : enable

// The scalar version of __clc_isgreater(half, half) returns an int, but the
// vector versions return short.
_CLC_DEFINE_SIMPLE_RELATIONAL_BINARY(int, short, __clc_isgreater, half, half)

#endif

#undef _CLC_RELATIONAL_OP
