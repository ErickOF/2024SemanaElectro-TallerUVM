//-------------------------------------------------------------------------------------------------
// Company:           IEEE CASS Costa Rica Section Chapter
// Engineer:          Erick Andres Obregon Fonseca
//
// Create Date:       2024-08-04
// Design Name:       Arithmetic Logic Unit (ALU) UVM Driver
// Module Name:       ALU Practical case - alu_driver.sv
// Project Name:      ALU Practical case
// Target Devices:    FPGA, ASIC
// Tool Versions:
//                    - Quartus Prime Lite 19.1
//                    - Vivado 2020.1
//                    - ModelSim 10.7
// Description:
//                    This UVM driver is responsible for translating UVM sequences into 
//                    pin-level signals to the ALU, driving the inputs based on the sequence 
//                    transactions and capturing the outputs.
//
// Dependencies:
//                    UVM library
// 
// Revision:
//                    1.0 - Initial Release
//                    2024-08-04 - Erick Andres Obregon Fonseca - Designed for educational purposes
//
// Additional Comments:
//                    This UVM driver acts as the bridge between the ALU and the testbench, 
//                    ensuring that the ALU is properly stimulated with the intended input 
//                    sequences during verification.
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

// Define a class named `alu_driver` that extends `uvm_driver` with a parameterized type `alu_item`
// The driver is responsible for driving transactions (alu_item) to the ALU
class alu_driver extends uvm_driver #(alu_item);
  // Register the `alu_driver` class with the UVM factory, enabling it to be created dynamically
  `uvm_component_utils(alu_driver)

  // Constructor function for the `alu_driver` class
  // Takes a string argument `name` with a default value of "driver" and an optional `parent`
  // component
  function new(string name="driver", uvm_component parent=null);
    // Call the constructor of the base class `uvm_driver` to initialize the driver component
    super.new(name, parent);
  endfunction : new

  // Virtual interface for the ALU
  virtual alu_io alu_if;

  // Override the `build_phase()` function to perform any necessary build-time configuration
  virtual function void build_phase(uvm_phase phase);
    // Calls the base class's `build_phase` to ensure proper setup
    super.build_phase(phase);

    // Log information about the build phase
    `uvm_info("DRV", $sformatf("Running build_phase of %s...", get_name()), UVM_NONE)

    // Retrieve the virtual interface from the UVM configuration database
    if (!uvm_config_db #(virtual alu_io)::get(this, "", "alu_vio", alu_if)) begin
      // Report a fatal error if the interface could not be retrieved
      `uvm_fatal("DRV", "Could not get alu_io")
    end

    // Log information about the completion of the build phase
    `uvm_info("DRV", $sformatf("build_phase of %s finished", get_name()), UVM_NONE)
  endfunction : build_phase

  // Define the `run_phase()` task, which contains the main behavior of the driver
  // The task is virtual, allowing for further customization in derived classes
  virtual task run_phase(uvm_phase phase);
    // Call the base class's `run_phase` to execute any inherited behavior
    super.run_phase(phase);

    // Log information about the run phase
    `uvm_info("DRV", $sformatf("Running run_phase of %s...", get_name()), UVM_NONE)

    // Continuous loop to process items from the sequencer
    forever begin
      alu_item m_item;
      // Wait for an item from the sequencer
      `uvm_info("DRV", "Wait for item from sequencer", UVM_NONE)

      // Get the next item from the sequencer
      seq_item_port.get_next_item(m_item);
      // Drive the item onto the interface
      drive_item(m_item);
      // Notify the sequencer that the item is processed
      seq_item_port.item_done();
    end

    // Log information about the completion of the run phase
    `uvm_info("DRV", $sformatf("run_phase of %s finished", get_name()), UVM_NONE)
  endtask : run_phase

  // Task to drive an `alu_item` onto the ALU interface
  virtual task drive_item(alu_item m_item);
    // Wait for a clock edge on the ALU interface's clock
    @(alu_if.cb) begin
      // Drive operand A onto the interface
      alu_if.op_a <= m_item.op_a;
      // Drive operand B onto the interface
      alu_if.op_b <= m_item.op_b;
      // Drive the selection signal onto the interface
      alu_if.sel <= m_item.sel;
    end
  endtask : drive_item
endclass : alu_driver
