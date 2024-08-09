//-------------------------------------------------------------------------------------------------
// Company:           IEEE CASS Costa Rica Section Chapter
// Engineer:          Erick Andres Obregon Fonseca
//
// Create Date:       2024-08-04
// Design Name:       Arithmetic Logic Unit (ALU) UVM Item
// Module Name:       ALU Practical case - alu_item.sv
// Project Name:      ALU Practical case
// Target Devices:    FPGA, ASIC
// Tool Versions:
//                    - Quartus Prime Lite 19.1
//                    - Vivado 2020.1
//                    - ModelSim 10.7
// Description:
//                    This UVM item class defines the transaction-level interface for an ALU,
//                    including the input operands, control signals for operation selection, 
//                    and expected output results for verification purposes.
//
// Dependencies:
//                    UVM library
// 
// Revision:
//                    1.0 - Initial Release
//                    2024-08-04 - Erick Andres Obregon Fonseca - Designed for educational purposes
//
// Additional Comments:
//                    This UVM item facilitates the creation of transactions for stimulating
//                    and verifying the ALU, ensuring consistency and reusability in testbench 
//                    environments.
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

// Define a class named `alu_item` that extends the `uvm_sequence_item` base class
// This class represents a transaction object that can be used in UVM sequences
class alu_item extends uvm_sequence_item;
  // Register the `alu_item` class with the UVM factory, enabling it to be created dynamically
  `uvm_object_utils(alu_item);

  // Constructor function for the `alu_item` class
  // The function takes an optional string argument `name` with a default value of "alu_item"
  function new(string name = "alu_item");
    // Call the constructor of the base class `uvm_sequence_item` to initialize the object
    super.new(name);
  endfunction : new

  // Randomize operands and selection signal
  // Randomize operand A, 8-bit signed integer
  rand logic signed [7:0] op_a;
  // Randomize operand B, 8-bit signed integer
  rand logic signed [7:0] op_b;
  // Randomize selection signal, 2-bit value
  rand logic [1:0] sel;
  // Result of the ALU operation
  logic signed [7:0] result;

  // Virtual function to get the operation corresponding to the selection signal
  virtual function string get_op();
    string operation;
    
    // Determine the operation based on the selection signal
    case (sel)
      // Addition
      2'b00: operation = "+";
      // Subtraction
      2'b01: operation = "-";
      // Bitwise AND
      2'b10: operation = "&";
      // Bitwise OR
      2'b11: operation = "|";
      // Default case if no valid selection
      default: operation = "none";
    endcase

    // Return the operation as a string
    return operation;
  endfunction : get_op
  
  // Virtual function to convert the sequence item to a string representation
  virtual function string to_str();
    // Format and return a string describing the operands, operation, and result
    return $sformatf("op_a=%d %s op_b=%d, result=%d", op_a, get_op(), op_b, result);
  endfunction : to_str
endclass : alu_item
