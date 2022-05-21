// SPDX-License-Identifier: Apache-2.0
// Copyright 2019 MERL Corporation or its affiliates.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


// Code to execute
.section .text
.global _start
_start:


     li x5, 0x40B60EBF
     fmv.w.x f0, x5
     li x5, 0x4208ED91
     fmv.w.x f1, x5
     li x5, 0x3FF78D50
     fmv.w.x f2, x5
     li x5, 0xC0ADD2F2
     fmv.w.x f3, x5
     li x5, 0xC6B97C00
     fmv.w.x f4, x5
     li x5, 0x463C087B
     fmv.w.x f5, x5
     li x5, 0x4158F5C3
     fmv.w.x f6, x5
     li x5, 0xC3F7999A
     fmv.w.x f7, x5
     li x5, 0xC236B021
     fmv.w.x f8, x5
     li x5, 0x4147EB85
     fmv.w.x f9, x5
     li x5, 0x44545333
     fmv.w.x f10, x5
     li x5, 0xC2095C29
     fmv.w.x f11, x5
     li x5, 0x3EB33333
     fmv.w.x f12, x5
     li x5, 0xBB195AAF
     fmv.w.x f13, x5
     li x5, 0x380FDD58
     fmv.w.x f14, x5
     li x5, 0xBCA75DB8
     fmv.w.x f15, x5
     fcvt.w.s x1, f1
     fcvt.wu.s x2, f2
     fcvt.w.s x3, f3
     fcvt.wu.s x4, f4
     fcvt.w.s x5, f5
     fcvt.wu.s x6, f6
     fcvt.w.s x7, f7
     fcvt.wu.s x8, f8
     fclass.s x9, f9
     fclass.s x10, f10
     fclass.s x11, f11
     fclass.s x12, f12
     fclass.s x13, f13
     fclass.s x14, f14
     fclass.s x15, f15


     
