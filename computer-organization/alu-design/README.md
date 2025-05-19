# ALU Design Project

## Overview
This project implements a 32-bit Arithmetic Logic Unit (ALU) using Verilog as part of the Computer Organization course (BLM2022) at Yildiz Technical University. The ALU can perform basic arithmetic and logical operations as specified by control signals.

## Features

The ALU supports the following operations based on the 3-bit ALUControl signal:
- `000`: Addition (A + B)
- `001`: Subtraction (A - B)
- `010`: Logical AND (A & B)
- `011`: Logical XOR (A ^ B)
- `101`: Set Less Than (A < B ? 1 : 0)

## Project Structure

The project is organized into two main sections:

### 1. ALU Implementation
- **Basic Components**: Each component of the ALU (Adder, Mux, ZeroExtender, etc.) is implemented as a separate module
- **ALU Top Module**: Combines all the components to create the complete ALU
- **Testbench**: Verifies the functionality and correctness of the ALU design

### 2. Datapath with Register File
- **Register File**: A 32-bit, 4-register (R0, R1, R2, R3) file that connects to the ALU
- **Datapath**: Connects the ALU and Register File to perform various operations
- **Testbench**: Tests the datapath with a series of operations

## Implementation Details

### ALU Design
The ALU is implemented using modular design principles, with separate modules for each component:
- **Adder Module**: Performs addition/subtraction
- **Logic Unit**: Performs AND and XOR operations
- **Comparator**: Implements the SLT functionality
- **Multiplexer**: Selects the appropriate output based on the ALUControl signal

### Datapath Operations
The datapath is tested with the following operations:
1. R0 ← R1 + R2
2. R1 ← R2 AND R3
3. R3 ← R2 XOR R0
4. R2 ← R1 - R3

Additional control sequence tests:
1. R1 ← 0 (without using reset)
2. R0 ← -1
3. R2 ← R1 – 1
4. R3 ← R0 + 1

## Tools Used
- **Verilog HDL**: For hardware description
- **GTKWave**: For waveform visualization and analysis
- **Icarus Verilog**: For simulation and testing

## File Structure
- `alu.v`: The top-level ALU module
- `adder.v`: Module for arithmetic operations
- `mux.v`: Multiplexer implementation
- `zeroextender.v`: Zero extension implementation
- `alu_tb.v`: Testbench for the ALU
- `regfile.v`: 4-register file implementation
- `datapath.v`: ALU + Register File connection
- `datapath_tb.v`: Testbench for datapath operations

## Results
The ALU and datapath have been successfully implemented and tested. The GTKWave results show that all operations work as expected, with the ALU correctly performing the specified arithmetic and logical operations, and the datapath correctly executing the test instructions.

## Course Information
- **Course**: BLM2022 - Computer Organization
- **Semester**: Spring 2024-2025
- **Assignment**: Homework 1