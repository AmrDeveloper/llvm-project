//===-- LibCxx.h -----------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_SOURCE_PLUGINS_LANGUAGE_CPLUSPLUS_GENERIC_H
#define LLDB_SOURCE_PLUGINS_LANGUAGE_CPLUSPLUS_GENERIC_H

#include "lldb/DataFormatters/TypeSummary.h"
#include "lldb/Utility/Stream.h"
#include "lldb/ValueObject/ValueObject.h"

namespace lldb_private {
namespace formatters {

bool GenericOptionalSummaryProvider(ValueObject &valobj, Stream &stream,
                                    const TypeSummaryOptions &options);

/// Return the ValueObjectSP of the underlying pointer member whose type
/// is a desugared 'std::shared_ptr::element_type *'.
lldb::ValueObjectSP GetDesugaredSmartPointerValue(ValueObject &ptr,
                                                  ValueObject &container);

} // namespace formatters
} // namespace lldb_private

#endif // LLDB_SOURCE_PLUGINS_LANGUAGE_CPLUSPLUS_GENERIC_H
