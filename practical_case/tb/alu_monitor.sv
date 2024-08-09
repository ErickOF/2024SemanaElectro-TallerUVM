//-------------------------------------------------------------------------------------------------
// Company:           IEEE CASS Costa Rica Section Chapter
// Engineer:          Erick Andres Obregon Fonseca
//
// Create Date:       2024-08-04
// Design Name:       Arithmetic Logic Unit (ALU) UVM Monitor
// Module Name:       ALU Practical case - alu_monitor.sv
// Project Name:      ALU Practical case
// Target Devices:    FPGA, ASIC
// Tool Versions:
//                    - Quartus Prime Lite 19.1
//                    - Vivado 2020.1
//                    - ModelSim 10.7
// Description:
//                    This UVM monitor is responsible for observing the pin-level signals
//                    of the ALU, capturing both inputs and outputs, and converting them 
//                    into transactions for further analysis.
//
// Dependencies:
//                    UVM library
// 
// Revision:
//                    1.0 - Initial Release
//                    2024-08-04 - Erick Andres Obregon Fonseca - Designed for educational purposes
//
// Additional Comments:
//                    This UVM monitor plays a critical role in ensuring the ALU's functionality 
//                    by passively collecting signal data and providing it to other verification 
//                    components like scoreboards and coverage collectors.
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

// Define a class named `alu_monitor` that extends `uvm_monitor`
// The monitor observes transactions on the ALU interface without driving or modifying them
class alu_monitor extends uvm_monitor;
  // Register the `alu_monitor` class with the UVM factory, enabling it to be created dynamically
  `uvm_component_utils(alu_monitor)

  // Constructor function for the `alu_monitor` class
  // Takes a string argument `name` with a default value of "alu_monitor" and an optional `parent`
  // component
  function new(string name="alu_monitor", uvm_component parent=null);
    // Call the constructor of the base class `uvm_monitor` to initialize the monitor component
    super.new(name, parent);
  endfunction : new

  // Override the `build_phase()` function to perform any necessary build-time configuration
  virtual function void build_phase(uvm_phase phase);
    // Calls the base class's `build_phase` to ensure proper setup
    super.build_phase(phase);
  endfunction : build_phase

  // Define the `run_phase()` task, which contains the main behavior of the monitor
  // The task is virtual, allowing for further customization in derived classes
  virtual task run_phase(uvm_phase phase);
    // Call the base class's `run_phase` to execute any inherited behavior
    super.run_phase(phase);
    // The actual monitoring logic will be implemented here
  endtask : run_phase
endclass : alu_monitor
