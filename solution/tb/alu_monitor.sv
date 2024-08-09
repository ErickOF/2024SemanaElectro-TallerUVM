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

  // Analysis port for sending monitored transactions to the analysis component
  uvm_analysis_port #(alu_item) mon_analysis_port;

  // Virtual interface for the ALU
  virtual alu_io alu_if;

  // Override the `build_phase()` function to perform any necessary build-time configuration
  virtual function void build_phase(uvm_phase phase);
    // Calls the base class's `build_phase` to ensure proper setup
    super.build_phase(phase);

    // Log information about the build phase
    `uvm_info("MON", $sformatf("Running build_phase of %s...", get_name()), UVM_NONE)

    // Retrieve the virtual interface from the UVM configuration database
    if (!uvm_config_db #(virtual alu_io)::get(this, "", "alu_vio", alu_if)) begin
      // Report a fatal error if the interface could not be retrieved
      `uvm_fatal("MON", "Could not get alu_vio")
    end

    // Create and initialize the analysis port
    mon_analysis_port = new("mon_analysis_port", this);

    // Log information about the completion of the build phase
    `uvm_info("MON", $sformatf("build_phase of %s finished", get_name()), UVM_NONE)
  endfunction : build_phase

  // Define the `run_phase()` task, which contains the main behavior of the monitor
  // The task is virtual, allowing for further customization in derived classes
  virtual task run_phase(uvm_phase phase);
    // Call the base class's `run_phase` to execute any inherited behavior
    super.run_phase(phase);

    // Log information about the run phase
    `uvm_info("MON", $sformatf("Running run_phase of %s...", get_name()), UVM_NONE)

    // Continuous loop to monitor the ALU interface and capture transactions
    forever begin
      // Wait for a clock edge on the ALU interface's clock
      @ (alu_if.cb) begin
        // Create a new `alu_item` instance
        alu_item m_alu_item = alu_item::type_id::create("alu_item");

        // Capture the current values from the ALU interface
        m_alu_item.op_a = alu_if.op_a;
        m_alu_item.op_b = alu_if.op_b;
        m_alu_item.sel = alu_if.sel;
        m_alu_item.result = alu_if.result;

        // Log information about the monitored item
        `uvm_info(
          "MON",
          $sformatf("Saw item %s: %s", m_alu_item.get_name(), m_alu_item.to_str()),
          UVM_NONE
        )

        // Send the monitored item to the analysis port
        mon_analysis_port.write(m_alu_item);
      end
    end

    // Log information about the completion of the run phase
    `uvm_info("MON", $sformatf("run_phase of %s finished", get_name()), UVM_NONE)
  endtask
endclass : alu_monitor
