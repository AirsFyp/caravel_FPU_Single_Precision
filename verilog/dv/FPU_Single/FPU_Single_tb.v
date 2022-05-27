// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype wire

//`timescale 1 ns / 1 ps

//`include "uprj_netlists.v"
//`include "caravel_netlists.v"
//`include "spiflash.v"
`include "tb_prog.v"

module FPU_Single_tb();
    reg clock;
    reg RSTB;
    reg CSB;
    reg power1, power2;
    reg power3, power4;
    
    wire gpio;
    wire [37:0] mprj_io;

    wire [31:0] mprj_io_0;
    wire mprj_ready;
    
    assign mprj_io_0 = {mprj_io[4],mprj_io[36:6]};
    assign mprj_ready = mprj_io[37];
    
    assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;
    
    always #12.5 clock <= (clock === 1'b0);
    
    initial begin
        clock = 0;
    end
 
    initial begin
        $dumpfile("FPU_Single.vcd");
        $dumpvars(0, FPU_Single_tb);

        // Repeat cycles of 1000 clock edges as needed to complete testbench
        //repeat (300) begin
        //    repeat (1000) @(posedge clock);
        //end
        //$display("%c[1;31m",27);
        //$display ("Monitor: Timeout, Test Project IO Stimulus (RTL) Failed");
        //$display("%c[0m",27);
        //$finish;
    end

	initial begin
	    wait(mprj_ready == 1'b1)
            // Observe Output pins for Fmove
            /*
            wait(mprj_io_0 == 32'h40B60EBF);
            wait(mprj_io_0 == 32'h4208ED91);
            wait(mprj_io_0 == 32'h380FDD58);
            wait(mprj_io_0 == 32'hBCA75DB8);
            */
            // Observe Output pins for Fsign and I2F
            /*
            wait(mprj_io_0 == 32'h4208ED91);
            wait(mprj_io_0 == 32'h40ADD2F2);
            wait(mprj_io_0 == 32'hC63C087B);
            wait(mprj_io_0 == 32'hC3F7999A);
            wait(mprj_io_0 == 32'h4147EB85);
            wait(mprj_io_0 == 32'hC2095C29);
            wait(mprj_io_0 == 32'hBB195AAF);
            wait(mprj_io_0 == 32'hBCA75DB8);
            wait(mprj_io_0 == 32'h4E816C1D);
            wait(mprj_io_0 == 32'h4E8411DB);
            wait(mprj_io_0 == 32'h4E7ACCCD);
            wait(mprj_io_0 == 32'h4F3CA75E);
            wait(mprj_io_0 == 32'hCE77DA8F);
            wait(mprj_io_0 == 32'h4F43F79A);
            wait(mprj_io_0 == 32'hCE651A10);
            */
            // Observe Output pins for min/max and comparison
            /*
            wait(mprj_io_0 == 32'h00000000);
            wait(mprj_io_0 == 32'h00000001);
            wait(mprj_io_0 == 32'h00000000);
            wait(mprj_io_0 == 32'h00000001);
            wait(mprj_io_0 == 32'h00000000);
            wait(mprj_io_0 == 32'h00000001);
            wait(mprj_io_0 == 32'h00000001);
            wait(mprj_io_0 == 32'h00000001);
            wait(mprj_io_0 == 32'h40B60EBF);
            wait(mprj_io_0 == 32'hC0ADD2F2);
            wait(mprj_io_0 == 32'hC6B97C00);
            wait(mprj_io_0 == 32'hC3F7999A);
            wait(mprj_io_0 == 32'h4147EB85);
            wait(mprj_io_0 == 32'h00445453);
            wait(mprj_io_0 == 32'h3EB33333);
            wait(mprj_io_0 == 32'h380FDD58);
            */
            // Observe Output pins for F2I and fclass
            /*
            wait(mprj_io_0 == 32'h00000022);
            wait(mprj_io_0 == 32'h00000002);
            wait(mprj_io_0 == 32'hFFFFFFFB);
            //wait(mprj_io_0 == 32'h00005CBE);
            wait(mprj_io_0 == 32'h00002F02);
            wait(mprj_io_0 == 32'h0000000E);
            wait(mprj_io_0 == 32'hFFFFFE11);
            wait(mprj_io_0 == 32'h00000040);
            wait(mprj_io_0 == 32'h00000040);
            wait(mprj_io_0 == 32'h00000002);
            wait(mprj_io_0 == 32'h00000040);
            wait(mprj_io_0 == 32'h00000002);
            wait(mprj_io_0 == 32'h00000040);
            wait(mprj_io_0 == 32'h00000002);
            */
            // Observe Output pins for Fmul
            /*
            wait(mprj_io_0 == 32'h4342C190);
            wait(mprj_io_0 == 32'hC128167B);
            wait(mprj_io_0 == 32'hCD883D35);
            wait(mprj_io_0 == 32'hC5D1D74D);
            wait(mprj_io_0 == 32'hC40EAAFC);
            wait(mprj_io_0 == 32'h8292A6E7);
            wait(mprj_io_0 == 32'hBA56B228);
            wait(mprj_io_0 == 32'hB53C1C1E);
           */
            // Observe Output pins for Fadd/fsub
            
            wait(mprj_io_0 == 32'h421FAF69);
            wait(mprj_io_0 == 32'hC05FDF3C);
            wait(mprj_io_0 == 32'hC636EF85);
            wait(mprj_io_0 == 32'hC3F0D1EC);
            wait(mprj_io_0 == 32'hC204B540);
            wait(mprj_io_0 == 32'h444BBD70);
            wait(mprj_io_0 == 32'h3EB2007E);
            wait(mprj_io_0 == 32'hBCA715C9);
            wait(mprj_io_0 == 32'hC1E45772);
            wait(mprj_io_0 == 32'hC0EBB646);
            wait(mprj_io_0 == 32'h470BC01F);
            wait(mprj_io_0 == 32'hC3FE6148);
            wait(mprj_io_0 == 32'h4268AB02);
            wait(mprj_io_0 == 32'hC45CE8F6);
            wait(mprj_io_0 == 32'hBEB465E8);
           
            
            $display("MPRJ-IO state = %h", mprj_io_0[31:0]);  
		
		`ifdef GL
	    	    $display("Monitor: Test 1 Mega-Project IO (GL) Passed");
		`else
		    $display("Monitor: Test 1 Mega-Project IO (RTL) Passed");
		`endif
	    $finish;
	end
	
	// Reset Operation
    initial begin
        RSTB <= 1'b0;
        CSB  <= 1'b1;       // Force CSB high
        #2000;
        RSTB <= 1'b1;       // Release reset
        #170000;
        CSB = 1'b0;         // CSB can be released
    end

	initial begin		// Power-up sequence
		power1 <= 1'b0;
		power2 <= 1'b0;
		power3 <= 1'b0;
		power4 <= 1'b0;
		#100;
		power1 <= 1'b1;
		#100;
		power2 <= 1'b1;
		#100;
		power3 <= 1'b1;
		#100;
		power4 <= 1'b1;
	end
	
	always @(mprj_io_0) begin
		#1 $display("MPRJ-IO state = %h, at time = %0t  ", mprj_io_0[31:0], $time);
	end
	
	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;
	wire r_Rx_Serial;
	assign mprj_io[5] = r_Rx_Serial;
        
        assign VDD3V3 = power1;
	assign VDD1V8 = power2;
	assign VSS = 1'b0;

	caravel uut (
		.vddio	  (VDD3V3),
		.vddio_2  (VDD3V3),
		.vssio	  (VSS),
		.vssio_2  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (VDD3V3),
		.vdda1_2  (VDD3V3),
		.vdda2    (VDD3V3),
		.vssa1	  (VSS),
		.vssa1_2  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (VDD1V8),
		.vccd2	  (VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock    (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("FPU_Single.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);
	
	
	uartprog #(
		.FILENAME("../hex/uart.hex")
	) prog_uut (
		//.clk(clock),
		.mprj_ready (mprj_ready),
		.r_Rx_Serial (r_Rx_Serial)
	);

endmodule
`default_nettype wire
