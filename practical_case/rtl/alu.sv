//-------------------------------------------------------------------------------------------------
// Company:           IEEE CASS Costa Rica Section Chapter
// Engineer:          Erick Andres Obregon Fonseca
//
// Create Date:       2024-08-04
// Design Name:       Arithmetic Logic Unit (ALU)
// Module Name:       ALU Practical case - alu.sv
// Project Name:      ALU Practical case
// Target Devices:    FPGA, ASIC
// Tool Versions:
//                    - Quartus Prime Lite 19.1
//                    - Vivado 2020.1
//                    - ModelSim 10.7
// Description:
//                    This module implements a parameterizable ALU which performs various
//                    arithmetic and logic operations such as addition, subtraction, bitwise AND,
//                    and OR operations. The ALU takes two operands and a control signal as inputs
//                    and produces a result along with status flags.
// 
// Dependencies:
//                    None
// 
// Revision:
//                    1.0 - Initial Release
//                    2024-08-04 - Erick Andres Obregon Fonseca - Designed for educational purposes
// 
// Additional Comments:
//                    This ALU is designed for educational purposes and can be extended to include
//                    more operations as required.
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
// CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
// USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//-------------------------------------------------------------------------------------------------
module alu
#(
  // Number of bits
  parameter N = 32
)
(
  // Operands
  input  logic [N-1:0] op_a,
  input  logic [N-1:0] op_b,
  // ALU operation
  input  logic [1:0]   sel,
  // ALU result
  output logic [N-1:0] result
);
  always_comb begin
    case (sel)
      // ADD
      2'b00: result <= {op_a + op_b}[N-1:0];
      // SUB
      2'b01: result <= {op_a + op_b}[N-1:0];
      // AND
      2'b10: result <= {op_a + op_b}[N-1:0];
      // OR
      2'b11: result <= {op_a + op_b}[N-1:0];
      // Default
      default: result <= 'b0;
    endcase
  end
endmodule: alu
