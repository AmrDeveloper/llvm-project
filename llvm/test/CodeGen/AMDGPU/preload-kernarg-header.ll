; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx942 -asm-verbose=0 < %s | FileCheck -check-prefixes=ASM %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx942 -filetype=obj < %s | llvm-objdump --arch=amdgcn --mcpu=gfx942 --disassemble - | FileCheck -check-prefixes=OBJ %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx942 -amdgpu-kernarg-preload-count=1 -asm-verbose=0 < %s | llvm-mc -triple amdgcn-amd-amdhsa -mcpu=gfx942 -filetype=obj | llvm-objdump --arch=amdgcn --mcpu=gfx942 --disassemble - | FileCheck -check-prefixes=OBJ %s

; OBJ: preload_ptr_kernarg_header
; OBJ-COUNT-60: s_nop 0
define amdgpu_kernel void @preload_ptr_kernarg_header(ptr inreg %arg) {
; ASM-LABEL: preload_ptr_kernarg_header:
; ASM:         s_load_dwordx2 s[8:9], s[4:5], 0x0
; ASM-NEXT:    s_waitcnt lgkmcnt(0)
; ASM-NEXT:    s_branch .LBB0_0
; ASM-NEXT:    .p2align 8
; ASM-NEXT:  .LBB0_0:
; ASM-NEXT:    v_mov_b64_e32 v[0:1], s[8:9]
; ASM-NEXT:    flat_store_dwordx2 v[0:1], v[0:1]
; ASM-NEXT:    s_endpgm
    store ptr %arg, ptr %arg
    ret void
}

; OBJ: preload_i32_kernarg_header
; OBJ-COUNT-58: s_nop 0
define amdgpu_kernel void @preload_i32_kernarg_header(ptr inreg %arg, i32 inreg %arg1) {
; ASM-LABEL: preload_i32_kernarg_header:
; ASM:         s_load_dwordx2 s[8:9], s[4:5], 0x0
; ASM-NEXT:    s_load_dword s10, s[4:5], 0x8
; ASM-NEXT:    s_waitcnt lgkmcnt(0)
; ASM-NEXT:    s_branch .LBB1_0
; ASM-NEXT:    .p2align 8
; ASM-NEXT:  .LBB1_0:
; ASM-NEXT:    v_mov_b64_e32 v[0:1], s[8:9]
; ASM-NEXT:    v_mov_b32_e32 v2, s10
; ASM-NEXT:    flat_store_dword v[0:1], v2
; ASM-NEXT:    s_endpgm
    store i32 %arg1, ptr %arg
    ret void
}

; OBJ: non_kernel_function
; ASM: non_kernel_function
; OBJ-NOT: s_branch
; ASM-NOT: s_branch
define void @non_kernel_function(ptr %arg) {
; ASM-LABEL: non_kernel_function:
; ASM:         s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; ASM-NEXT:    flat_store_dwordx2 v[0:1], v[0:1]
; ASM-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; ASM-NEXT:    s_setpc_b64 s[30:31]
    store ptr %arg, ptr %arg
    ret void
}
