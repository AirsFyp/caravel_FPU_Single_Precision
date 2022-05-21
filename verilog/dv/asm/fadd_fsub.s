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
     fadd.s f16, f1, f0
     fadd.s f17, f3, f2
     fadd.s f18, f5, f4
     fadd.s f19, f7, f6
     fadd.s f20, f9, f8
     fadd.s f21, f11, f10
     fadd.s f22, f13, f12
     fadd.s f23, f15, f14
     fsub.s f24, f0, f1
     fsub.s f25, f1, f0
     fsub.s f26, f3, f2
     fsub.s f27, f5, f4
     fsub.s f28, f7, f6
     fsub.s f29, f9, f8
     fsub.s f30, f11, f10
     fsub.s f31, f13, f12


     
