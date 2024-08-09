//-------------------------------------------------------------------------------------------------
// Company:           IEEE CASS Costa Rica Section Chapter
// Engineer:          Erick Andres Obregon Fonseca
//
// Create Date:       2024-08-04
// Design Name:       Arithmetic Logic Unit (ALU) UVM Sequence
// Module Name:       ALU Practical case - alu_sequence.sv
// Project Name:      ALU Practical case
// Target Devices:    FPGA, ASIC
// Tool Versions:
//                    - Quartus Prime Lite 19.1
//                    - Vivado 2020.1
//                    - ModelSim 10.7
// Description:
//                    This UVM sequence defines the set of operations and stimulus for driving
//                    transactions to the ALU under test, including different operand values 
//                    and operation types.
//
// Dependencies:
//                    UVM library
// 
// Revision:
//                    1.0 - Initial Release
//                    2024-08-04 - Erick Andres Obregon Fonseca - Designed for educational purposes
//
// Additional Comments:
//                    This UVM sequence is used to generate a series of transactions to 
//                    thoroughly exercise the ALU's functionality, ensuring comprehensive 
//                    verification coverage.
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

// Define a class named `alu_seq` that extends the `uvm_sequence` base class
// This class represents a sequence of transactions for the ALU (Arithmetic Logic Unit)
class alu_seq extends uvm_sequence;
  // Register the `alu_seq` class with the UVM factory, enabling it to be created dynamically
  `uvm_object_utils(alu_seq)

  // Constructor function for the `alu_seq` class
  // The function takes an optional string argument `name` with a default value of "alu_seq"
  function new(string name="alu_seq");
    // Call the constructor of the base class `uvm_sequence` to initialize the sequence object
    super.new(name);
  endfunction : new

  // Randomize the number of iterations for sending transactions
  rand int iterations;

  // Constraint to define the valid range for the number of iterations
  // The constraint is soft, meaning it is not strictly enforced
  constraint c_num { soft iterations inside {[1:100]}; }

  // Define the `body()` task, which contains the main behavior of the sequence
  // The body task will be implemented in derived classes or instances to define specific ALU
  // operations
  virtual task body();
    // Log information about the sequence start
    `uvm_info("SEQ", $sformatf("Running body of %s...", get_name()), UVM_NONE)
    // Log information about the number of transactions to be sent
    `uvm_info(
      "SEQ",
      $sformatf("Sending %d transactions from %s...", iterations, get_name()),
      UVM_NONE
    )

    // Loop to send the specified number of transactions
    for (int i = 0; i < iterations; i++) begin
      // Create a new `alu_item` instance with a unique name
      alu_item m_alu_item = alu_item::type_id::create($sformatf("m_alu_item_%0d", i));
      // Start the item, marking the beginning of the transaction
      start_item(m_alu_item);
      // Randomize the item fields
      m_alu_item.randomize();
      // Finish the item, marking the end of the transaction
      finish_item(m_alu_item);
    end

    // Log information about the sequence completion
    `uvm_info("SEQ", $sformatf("body of %s finished", get_name()), UVM_NONE)
  endtask : body
endclass : alu_seq
