; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=bonaire < %s | FileCheck -check-prefixes=GCN,CIVI %s
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=tonga < %s | FileCheck -check-prefixes=GCN,CIVI %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=fiji < %s | FileCheck -check-prefixes=GCN,CIVI,CIVI-HSA %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 < %s | FileCheck -check-prefixes=GCN,GFX9 %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 < %s | FileCheck -check-prefixes=GCN,GFX10,GFX10PLUS %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1100 -mattr=+real-true16 -amdgpu-enable-vopd=0 < %s | FileCheck -check-prefixes=GCN,GFX10PLUS,GFX11-TRUE16 %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1100 -mattr=-real-true16 -amdgpu-enable-vopd=0 < %s | FileCheck -check-prefixes=GCN,GFX10PLUS,GFX11-FAKE16 %s

; GCN-LABEL: {{^}}store_flat_i32:
; GCN-DAG: s_load_{{dwordx2|b64}} s[[[LO_SREG:[0-9]+]]:[[HI_SREG:[0-9]+]]],
; GCN-DAG: s_load_{{dword|b32}} s[[SDATA:[0-9]+]],
; GCN: s_waitcnt lgkmcnt(0)
; GCN-DAG: v_mov_b32_e32 v[[DATA:[0-9]+]], s[[SDATA]]
; GCN-DAG: v_mov_b32_e32 v[[LO_VREG:[0-9]+]], s[[LO_SREG]]
; GCN-DAG: v_mov_b32_e32 v[[HI_VREG:[0-9]+]], s[[HI_SREG]]
; GCN: flat_store_{{dword|b32}} v[[[LO_VREG]]:[[HI_VREG]]], v[[DATA]]
define amdgpu_kernel void @store_flat_i32(ptr addrspace(1) %gptr, i32 %x) #0 {
  %fptr = addrspacecast ptr addrspace(1) %gptr to ptr
  store volatile i32 %x, ptr %fptr, align 4
  ret void
}

; GCN-LABEL: {{^}}store_flat_i64:
; GCN: flat_store_{{dword|b64}}
define amdgpu_kernel void @store_flat_i64(ptr addrspace(1) %gptr, i64 %x) #0 {
  %fptr = addrspacecast ptr addrspace(1) %gptr to ptr
  store volatile i64 %x, ptr %fptr, align 8
  ret void
}

; GCN-LABEL: {{^}}store_flat_v4i32:
; GCN: flat_store_{{dword|b128}}
define amdgpu_kernel void @store_flat_v4i32(ptr addrspace(1) %gptr, <4 x i32> %x) #0 {
  %fptr = addrspacecast ptr addrspace(1) %gptr to ptr
  store volatile <4 x i32> %x, ptr %fptr, align 16
  ret void
}

; GCN-LABEL: {{^}}store_flat_trunc_i16:
; GCN: flat_store_{{short|b16}}
define amdgpu_kernel void @store_flat_trunc_i16(ptr addrspace(1) %gptr, i32 %x) #0 {
  %fptr = addrspacecast ptr addrspace(1) %gptr to ptr
  %y = trunc i32 %x to i16
  store volatile i16 %y, ptr %fptr, align 2
  ret void
}

; GCN-LABEL: {{^}}store_flat_trunc_i8:
; GCN: flat_store_{{byte|b8}}
define amdgpu_kernel void @store_flat_trunc_i8(ptr addrspace(1) %gptr, i32 %x) #0 {
  %fptr = addrspacecast ptr addrspace(1) %gptr to ptr
  %y = trunc i32 %x to i8
  store volatile i8 %y, ptr %fptr, align 2
  ret void
}



; GCN-LABEL: load_flat_i32:
; GCN: flat_load_{{dword|b32}}
define amdgpu_kernel void @load_flat_i32(ptr addrspace(1) noalias %out, ptr addrspace(1) noalias %gptr) #0 {
  %fptr = addrspacecast ptr addrspace(1) %gptr to ptr
  %fload = load volatile i32, ptr %fptr, align 4
  store i32 %fload, ptr addrspace(1) %out, align 4
  ret void
}

; GCN-LABEL: load_flat_i64:
; GCN: flat_load_{{dword|b64}}
define amdgpu_kernel void @load_flat_i64(ptr addrspace(1) noalias %out, ptr addrspace(1) noalias %gptr) #0 {
  %fptr = addrspacecast ptr addrspace(1) %gptr to ptr
  %fload = load volatile i64, ptr %fptr, align 8
  store i64 %fload, ptr addrspace(1) %out, align 8
  ret void
}

; GCN-LABEL: load_flat_v4i32:
; GCN: flat_load_{{dword|b128}}
define amdgpu_kernel void @load_flat_v4i32(ptr addrspace(1) noalias %out, ptr addrspace(1) noalias %gptr) #0 {
  %fptr = addrspacecast ptr addrspace(1) %gptr to ptr
  %fload = load volatile <4 x i32>, ptr %fptr, align 32
  store <4 x i32> %fload, ptr addrspace(1) %out, align 8
  ret void
}

; GCN-LABEL: sextload_flat_i8:
; GCN: flat_load_{{sbyte|i8}}
define amdgpu_kernel void @sextload_flat_i8(ptr addrspace(1) noalias %out, ptr addrspace(1) noalias %gptr) #0 {
  %fptr = addrspacecast ptr addrspace(1) %gptr to ptr
  %fload = load volatile i8, ptr %fptr, align 4
  %ext = sext i8 %fload to i32
  store i32 %ext, ptr addrspace(1) %out, align 4
  ret void
}

; GCN-LABEL: zextload_flat_i8:
; GCN: flat_load_{{ubyte|u8}}
define amdgpu_kernel void @zextload_flat_i8(ptr addrspace(1) noalias %out, ptr addrspace(1) noalias %gptr) #0 {
  %fptr = addrspacecast ptr addrspace(1) %gptr to ptr
  %fload = load volatile i8, ptr %fptr, align 4
  %ext = zext i8 %fload to i32
  store i32 %ext, ptr addrspace(1) %out, align 4
  ret void
}

; GCN-LABEL: sextload_flat_i16:
; GCN: flat_load_{{sshort|i16}}
define amdgpu_kernel void @sextload_flat_i16(ptr addrspace(1) noalias %out, ptr addrspace(1) noalias %gptr) #0 {
  %fptr = addrspacecast ptr addrspace(1) %gptr to ptr
  %fload = load volatile i16, ptr %fptr, align 4
  %ext = sext i16 %fload to i32
  store i32 %ext, ptr addrspace(1) %out, align 4
  ret void
}

; GCN-LABEL: zextload_flat_i16:
; GCN: flat_load_{{ushort|u16}}
define amdgpu_kernel void @zextload_flat_i16(ptr addrspace(1) noalias %out, ptr addrspace(1) noalias %gptr) #0 {
  %fptr = addrspacecast ptr addrspace(1) %gptr to ptr
  %fload = load volatile i16, ptr %fptr, align 4
  %ext = zext i16 %fload to i32
  store i32 %ext, ptr addrspace(1) %out, align 4
  ret void
}

; GCN-LABEL: flat_scratch_unaligned_load:
; GFX9: flat_load_dword
; GFX10PLUS: flat_load_{{dword|b32}}
define amdgpu_kernel void @flat_scratch_unaligned_load() {
  %scratch = alloca i32, addrspace(5)
  %fptr = addrspacecast ptr addrspace(5) %scratch to ptr
  store volatile ptr %fptr, ptr addrspace(3) null
  %ld = load volatile i32, ptr %fptr, align 1
  ret void
}

; GCN-LABEL: flat_scratch_unaligned_store:
; GFX9: flat_store_dword
; GFX10PLUS: flat_store_{{dword|b32}}
define amdgpu_kernel void @flat_scratch_unaligned_store() {
  %scratch = alloca i32, addrspace(5)
  %fptr = addrspacecast ptr addrspace(5) %scratch to ptr
  store volatile ptr %fptr, ptr addrspace(3) null
  store volatile i32 0, ptr %fptr, align 1
  ret void
}

; GCN-LABEL: flat_scratch_multidword_load_kernel:
; CIVI-HSA: flat_load_dword v
; CIVI-HSA: flat_load_dword v
; GFX9:  flat_load_dwordx2
; GFX10PLUS: flat_load_{{dwordx2|b64}}
; FIXME: These tests are broken for os = mesa3d, becasue it doesn't initialize flat_scr
define amdgpu_kernel void @flat_scratch_multidword_load_kernel() {
  %scratch = alloca <2 x i32>, addrspace(5)
  %fptr = addrspacecast ptr addrspace(5) %scratch to ptr
  %ld = load volatile <2 x i32>, ptr %fptr
  ret void
}
;
; GCN-LABEL: flat_scratch_multidword_load_func:
; CIVI-HSA: flat_load_dword v
; CIVI-HSA: flat_load_dword v
; GFX9:  flat_load_dwordx2
; GFX10PLUS: flat_load_{{dwordx2|b64}}
; FIXME: These tests are broken for os = mesa3d, becasue it doesn't initialize flat_scr
define <2 x i32> @flat_scratch_multidword_load_func(ptr %maybe.scratch) {
  %load = load <2 x i32>, ptr %maybe.scratch
  ret <2 x i32> %load
}

; GCN-LABEL: flat_scratch_multidword_store_kernel:
; CIVI-HSA: flat_store_dword v
; CIVI-HSA: flat_store_dword v
; GFX9:  flat_store_dwordx2
; GFX10PLUS: flat_store_{{dwordx2|b64}}
; FIXME: These tests are broken for os = mesa3d, becasue it doesn't initialize flat_scr
define amdgpu_kernel void @flat_scratch_multidword_store_kernel() {
  %scratch = alloca <2 x i32>, addrspace(5)
  %fptr = addrspacecast ptr addrspace(5) %scratch to ptr
  store volatile <2 x i32> zeroinitializer, ptr %fptr
  ret void
}

; GCN-LABEL: flat_scratch_multidword_store_func:
; CIVI-HSA: flat_store_dword v
; CIVI-HSA: flat_store_dword v
; GFX9:  flat_store_dwordx2
; GFX10PLUS: flat_store_{{dwordx2|b64}}
define void @flat_scratch_multidword_store_func(ptr %maybe.scratch) {
  store <2 x i32> zeroinitializer, ptr %maybe.scratch
  ret void
}

; GCN-LABEL: {{^}}store_flat_i8_max_offset:
; CIVI: flat_store_byte v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}{{$}}
; GFX9: flat_store_byte v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}} offset:4095{{$}}
define amdgpu_kernel void @store_flat_i8_max_offset(ptr %fptr, i8 %x) #0 {
  %fptr.offset = getelementptr inbounds i8, ptr %fptr, i64 4095
  store volatile i8 %x, ptr %fptr.offset
  ret void
}

; GCN-LABEL: {{^}}store_flat_i8_max_offset_p1:
; GCN: flat_store_{{byte|b8}} v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}{{( dlc)?}}{{$}}
define amdgpu_kernel void @store_flat_i8_max_offset_p1(ptr %fptr, i8 %x) #0 {
  %fptr.offset = getelementptr inbounds i8, ptr %fptr, i64 4096
  store volatile i8 %x, ptr %fptr.offset
  ret void
}

; GCN-LABEL: {{^}}store_flat_i8_neg_offset:
; CIVI: flat_store_byte v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}{{$}}

; GFX9: v_add_co_u32_e64 v{{[0-9]+}}, vcc, -2, s
; GFX9: v_addc_co_u32_e32 v{{[0-9]+}}, vcc, -1,
; GFX9: flat_store_byte v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}{{$}}
define amdgpu_kernel void @store_flat_i8_neg_offset(ptr %fptr, i8 %x) #0 {
  %fptr.offset = getelementptr inbounds i8, ptr %fptr, i64 -2
  store volatile i8 %x, ptr %fptr.offset
  ret void
}

; GCN-LABEL: {{^}}load_flat_i8_max_offset:
; CIVI: flat_load_ubyte v{{[0-9]+}}, v{{\[[0-9]+:[0-9]+\]}} glc{{$}}
; GFX9: flat_load_ubyte v{{[0-9]+}}, v{{\[[0-9]+:[0-9]+\]}} offset:4095 glc{{$}}
; GFX10: flat_load_ubyte v{{[0-9]+}}, v{{\[[0-9]+:[0-9]+\]}} glc dlc{{$}}
; GFX11-TRUE16: flat_load_d16_u8 v{{[0-9]+}}, v{{\[[0-9]+:[0-9]+\]}} offset:4095 glc dlc{{$}}
; GFX11-FAKE16: flat_load_u8 v{{[0-9]+}}, v{{\[[0-9]+:[0-9]+\]}} offset:4095 glc dlc{{$}}
define amdgpu_kernel void @load_flat_i8_max_offset(ptr %fptr) #0 {
  %fptr.offset = getelementptr inbounds i8, ptr %fptr, i64 4095
  %val = load volatile i8, ptr %fptr.offset
  ret void
}

; GCN-LABEL: {{^}}load_flat_i8_max_offset_p1:
; CIVI: flat_load_ubyte v{{[0-9]+}}, v{{\[[0-9]+:[0-9]+\]}} glc{{$}}
; GFX9: flat_load_ubyte v{{[0-9]+}}, v{{\[[0-9]+:[0-9]+\]}} glc{{$}}
; GFX10: flat_load_ubyte v{{[0-9]+}}, v{{\[[0-9]+:[0-9]+\]}} glc dlc{{$}}
; GFX11-TRUE16: flat_load_d16_u8 v{{[0-9]+}}, v{{\[[0-9]+:[0-9]+\]}} glc dlc{{$}}
; GFX11-FAKE16: flat_load_u8 v{{[0-9]+}}, v{{\[[0-9]+:[0-9]+\]}} glc dlc{{$}}
define amdgpu_kernel void @load_flat_i8_max_offset_p1(ptr %fptr) #0 {
  %fptr.offset = getelementptr inbounds i8, ptr %fptr, i64 4096
  %val = load volatile i8, ptr %fptr.offset
  ret void
}

; GCN-LABEL: {{^}}load_flat_i8_neg_offset:
; CIVI: flat_load_ubyte v{{[0-9]+}}, v{{\[[0-9]+:[0-9]+\]}} glc{{$}}

; GFX9: v_add_co_u32_e64 v{{[0-9]+}}, vcc, -2, s
; GFX9: v_addc_co_u32_e32 v{{[0-9]+}}, vcc, -1,
; GFX9: flat_load_ubyte v{{[0-9]+}}, v{{\[[0-9]+:[0-9]+\]}} glc{{$}}
define amdgpu_kernel void @load_flat_i8_neg_offset(ptr %fptr) #0 {
  %fptr.offset = getelementptr inbounds i8, ptr %fptr, i64 -2
  %val = load volatile i8, ptr %fptr.offset
  ret void
}

attributes #0 = { nounwind }
attributes #1 = { nounwind convergent }
