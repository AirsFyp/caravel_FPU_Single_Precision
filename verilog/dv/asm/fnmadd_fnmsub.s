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
     li x5, 0x445453
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
     fnmadd.s f16, f1, f0, f1
     fnmadd.s f17, f3, f2, f3 
     fnmadd.s f18, f5, f4, f5
     fnmadd.s f19, f7, f6, f7
     fnmadd.s f20, f9, f8, f9
     fnmadd.s f21, f11, f10, f11
     fnmadd.s f22, f13, f12, f13
     fnmadd.s f23, f15, f14, f15
     fnmsub.s f16, f1, f0, f0
     fnmsub.s f17, f3, f2, f2 
     fnmsub.s f18, f5, f4, f4
     fnmsub.s f19, f7, f6, f6
     fnmsub.s f20, f9, f8, f8
     fnmsub.s f21, f11, f10, f11
     fnmsub.s f22, f13, f12, f12
     fnmsub.s f23, f15, f14, f14

     
