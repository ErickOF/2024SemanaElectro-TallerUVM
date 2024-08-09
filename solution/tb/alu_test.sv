//-------------------------------------------------------------------------------------------------
// Company:           IEEE CASS Costa Rica Section Chapter
// Engineer:          Erick Andres Obregon Fonseca
//
// Create Date:       2024-08-04
// Design Name:       Arithmetic Logic Unit (ALU) UVM Test
// Module Name:       ALU Practical case - alu_test.sv
// Project Name:      ALU Practical case
// Target Devices:    FPGA, ASIC
// Tool Versions:
//                    - Quartus Prime Lite 19.1
//                    - Vivado 2020.1
//                    - ModelSim 10.7
// Description:
//                    This UVM test defines the test scenarios and sequences to be executed
//                    for verifying the functionality of the ALU. It sets up the environment, 
//                    starts the sequences, and monitors the results to ensure that the ALU 
//                    performs as expected.
//
// Dependencies:
//                    UVM library
// 
// Revision:
//                    1.0 - Initial Release
//                    2024-08-04 - Erick Andres Obregon Fonseca - Designed for educational purposes
//
// Additional Comments:
//                    This UVM test serves as the entry point for running the ALU verification,
//                    orchestrating the execution of sequences and managing test results. It 
//                    ensures that the ALU is thoroughly tested according to the defined scenarios.
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

// Define a class named `alu_test` that extends `uvm_test`
// The `alu_test` class represents a UVM test, which is used to configure and run test scenarios
class alu_test extends uvm_test;
  // Register the `alu_test` class with the UVM factory, enabling it to be created dynamically
  `uvm_component_utils(alu_test)

  // Constructor function for the `alu_test` class
  // Takes a string argument `name` with a default value of "alu_test" and an optional `parent`
  // component
  function new(string name="alu_test", uvm_component parent=null);
    // Call the constructor of the base class `uvm_test` to initialize the test component
    super.new(name, parent);
  endfunction : new

  // ALU environment instance used in the test
  alu_env m_alu_env;
  // ALU sequence instance to be run during the test
  alu_seq m_alu_seq;
  // Virtual interface for the ALU, used for connecting to the DUT
  virtual alu_io alu_if;

  // Override the `build_phase()` function to perform any necessary build-time configuration
  virtual function void build_phase(uvm_phase phase);
    // Calls the base class's `build_phase` to ensure proper setup of the test
    super.build_phase(phase);

    // Log information about the build phase
    `uvm_info("TEST", $sformatf("Running build_phase of %s...", get_name()), UVM_NONE)

    // Create and initialize the ALU environment component
    m_alu_env = alu_env::type_id::create("m_alu_env", this);

    // Retrieve the virtual interface from the UVM config database
    if (!uvm_config_db #(virtual alu_io)::get(this, "", "alu_vio", alu_if)) begin
      `uvm_fatal("TEST", "Could not get alu_vio")
    end

    // Set the virtual interface in the ALU agent's components
    uvm_config_db #(virtual alu_io)::set(this, "m_alu_env.m_alu_agent.*", "alu_vio", alu_if);

    // Create and randomize the ALU sequence
    m_alu_seq = alu_seq::type_id::create("m_alu_seq");
    m_alu_seq.randomize();

    // Log information about the completion of the build phase
    `uvm_info("TEST", $sformatf("build_phase of %s finished", get_name()), UVM_NONE)
  endfunction : build_phase

  // Define the `run_phase()` task, which contains the main behavior of the test
  // The task is virtual, allowing for further customization in derived classes
  virtual task run_phase(uvm_phase phase);
    // Calls the base class's `run_phase` to execute any inherited behavior
    super.run_phase(phase);

    // Log information about the run phase
    `uvm_info("TEST", $sformatf("Running run_phase of %s...", get_name()), UVM_NONE)

    // Raise an objection to keep the run phase active
    phase.raise_objection(this);

    // Start the ALU sequence on the ALU sequencer
    m_alu_seq.start(m_alu_env.m_alu_agent.m_alu_sequencer);

    // Wait for some time to allow the sequence to run
    #10;

    // Drop the objection, indicating that the run phase can complete
    phase.drop_objection(this);

    // Log information about the completion of the run phase
    `uvm_info("TEST", $sformatf("run_phase of %s finished", get_name()), UVM_NONE)
  endtask : run_phase
endclass : alu_test
