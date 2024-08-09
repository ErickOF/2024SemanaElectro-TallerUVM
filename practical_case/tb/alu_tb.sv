//-------------------------------------------------------------------------------------------------
// Company:           IEEE CASS Costa Rica Section Chapter
// Engineer:          Erick Andres Obregon Fonseca
//
// Create Date:       2024-08-04
// Design Name:       Arithmetic Logic Unit (ALU) Testbench
// Module Name:       ALU Practical case - alu_testbench.sv
// Project Name:      ALU Practical case
// Target Devices:    FPGA, ASIC
// Tool Versions:
//                    - Quartus Prime Lite 19.1
//                    - Vivado 2020.1
//                    - ModelSim 10.7
// Description:
//                    This module defines the top-level testbench for the ALU, integrating
//                    all UVM components such as the environment, agents, drivers, monitors, 
//                    and test sequences. It serves as the main entry point for running
//                    the ALU verification process.
//
// Dependencies:
//                    UVM library
// 
// Revision:
//                    1.0 - Initial Release
//                    2024-08-04 - Erick Andres Obregon Fonseca - Designed for educational purposes
//
// Additional Comments:
//                    This testbench module coordinates the setup and execution of the ALU 
//                    verification, ensuring that all components are properly instantiated 
//                    and connected. It orchestrates the overall test process and manages 
//                    the verification flow.
//
// Copyright (c) 2024 IEEE CASS Costa Rica Section Chapter.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted
// provided that the following conditions are met:
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright notice, this list of
//    conditions and the following disclaimer in the documentation and/or other materials provided
//    with the  distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
// FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
// OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//-------------------------------------------------------------------------------------------------
// Include the UVM macros header file, which contains useful UVM macros for coding convenience
`include "uvm_macros.svh"

// Import the UVM package, making all UVM classes, methods, and macros available
import uvm_pkg::*;

// Set the timescale for the simulation, where 1ns is the unit of time, and 1ps is the precision
`timescale 1ns/1ps

module testbench;
  // Local parameter for bit-width used in ALU and I/O
  localparam BITS = 8;

  // Clock signal for the testbench
  logic test_clk;

  // Generate a clock signal with a period of 2 time units (1 time unit high, 1 time unit low)
  always #1 test_clk = ~test_clk;

  // Instantiate the ALU I/O interface with the specified bit-width
  alu_io #(.N(BITS)) alu_if (
    // Connect the clock to the I/O interface
    .clk(test_clk)
  );

  // Instantiate the ALU with the specified bit-width
  alu #(.N(BITS)) dut (
    // Connect operand A from the I/O interface to the ALU
    .op_a(alu_if.op_a),
    // Connect operand B from the I/O interface to the ALU
    .op_b(alu_if.op_b),
    // Connect selection signal from the I/O interface to the ALU
    .sel(alu_if.sel),
    // Connect result output from the ALU to the I/O interface
    .result(alu_if.result)
  );
  
  // Include the SystemVerilog Assertions (SVA) file for the ALU
  `include "alu_assertions.sva"

  // Initial block for testbench initialization and execution
  initial begin
    // Specify the VCD (Value Change Dump) file for waveform output
    $dumpfile("dump.vcd");
    // Enable dumping of all variables to the VCD file
    $dumpvars;

    // Initialize the clock signal
    test_clk <= 1'b0;

    // Configure the UVM testbench to use the `alu_if` as the virtual interface
    uvm_config_db #(virtual alu_io)::set(null, "uvm_test_top", "alu_vio", alu_if);
    // Run the UVM test named "alu_test"
    run_test("alu_test");
  end
endmodule : testbench
