//-------------------------------------------------------------------------------------------------
// Company:           IEEE CASS Costa Rica Section Chapter
// Engineer:          Erick Andres Obregon Fonseca
//
// Create Date:       2024-08-04
// Design Name:       Arithmetic Logic Unit (ALU) UVM Agent
// Module Name:       ALU Practical case - alu_agent.sv
// Project Name:      ALU Practical case
// Target Devices:    FPGA, ASIC
// Tool Versions:
//                    - Quartus Prime Lite 19.1
//                    - Vivado 2020.1
//                    - ModelSim 10.7
// Description:
//                    This UVM agent encapsulates the driver, monitor, and sequencer for the 
//                    ALU, providing a reusable verification component that drives and monitors 
//                    ALU transactions within a testbench.
//
// Dependencies:
//                    UVM library
// 
// Revision:
//                    1.0 - Initial Release
//                    2024-08-04 - Erick Andres Obregon Fonseca - Designed for educational purposes
//
// Additional Comments:
//                    This UVM agent coordinates the activities of the driver, monitor, and 
//                    sequencer, ensuring synchronized stimulus and observation of the ALU's 
//                    behavior, thus enabling comprehensive verification.
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

// Define a class named `alu_agent` that extends `uvm_agent`
// The agent typically encapsulates a driver, monitor, and potentially a sequencer, coordinating
// their activities
class alu_agent extends uvm_agent;
  // Register the `alu_agent` class with the UVM factory, enabling it to be created dynamically
  `uvm_component_utils(alu_agent)

  // Constructor function for the `alu_agent` class
  // Takes a string argument `name` with a default value of "alu_agent" and an optional `component`
  // parent
  function new(string name="alu_agent", uvm_component component=null);
    // Call the constructor of the base class `uvm_agent` to initialize the agent component
    super.new(name, component);
  endfunction : new

  // Sequencer, driver, and monitor components for the ALU agent
  uvm_sequencer #(alu_item) m_alu_sequencer;
  alu_driver m_alu_driver;
  alu_monitor m_alu_monitor;

  // Override the `build_phase()` function to perform any necessary build-time configuration
  virtual function void build_phase(uvm_phase phase);
    // Calls the base class's `build_phase` to ensure proper setup
    super.build_phase(phase);

    // Log information about the build phase
    `uvm_info("AGENT", $sformatf("Running build_phase of %s...", get_name()), UVM_NONE)
    
    // Create and initialize the sequencer, driver, and monitor components
    m_alu_sequencer = uvm_sequencer#(alu_item)::type_id::create("m_alu_sequencer", this);
    m_alu_driver = alu_driver::type_id::create("m_alu_driver", this);
    m_alu_monitor = alu_monitor::type_id::create("m_alu_monitor", this);
    
    // Log information about the completion of the build phase
    `uvm_info("AGENT", $sformatf("build_phase of %s finished", get_name()), UVM_NONE)
  endfunction : build_phase

  // Override the `connect_phase()` function to establish connections between components
  virtual function void connect_phase(uvm_phase phase);
    // Calls the base class's `connect_phase` to ensure proper connection setup
    super.connect_phase(phase);

    // Log information about the connect phase
    `uvm_info("AGENT", $sformatf("Running connect_phase of %s...", get_name()), UVM_NONE)
    
    // Connect the sequencer's sequence item export to the driver's sequence item port
    m_alu_driver.seq_item_port.connect(m_alu_sequencer.seq_item_export);
    
    // Log information about the completion of the connect phase
    `uvm_info("AGENT", $sformatf("connect_phase of %s finished", get_name()), UVM_NONE)
  endfunction : connect_phase
endclass : alu_agent
