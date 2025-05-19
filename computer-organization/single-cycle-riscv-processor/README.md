# Single-Cycle RISC-V Processor

## Overview
This project implements a Single-Cycle RISC-V Processor in Verilog, as part of the Computer Organization course (BLM2022) at Yildiz Technical University. The processor is designed to support the basic RISC-V instruction set, with additional extensions in subsequent implementations.

## Project Structure

The project is divided into three main implementations, each expanding on the previous one:

### 1. Base Single-Cycle Processor
- **Implementation**: Basic RISC-V processor supporting core instructions
- **Supported Instructions**: lw, sw, add, sub, slt, or, and, beq, addi, slti, ori, andi, jal
- **Directory**: `/single-cycle/`

### 2. Processor with SLL Extension
- **Implementation**: Extended processor with shift left logical support
- **Additional Instructions**: sll (shift left logical)
- **Directory**: `/single-cycle-with-sll/`

### 3. Processor with LUI Extension
- **Implementation**: Further extended processor with load upper immediate support
- **Additional Instructions**: lui (load upper immediate)
- **Directory**: `/single-cycle-with-lui/`

## Architecture

The processor follows the standard single-cycle RISC-V architecture as described in "Digital Design and Computer Architecture, RISC-V Edition" by Harris & Harris. It includes:

- **Instruction Fetch Unit**: PC and Instruction Memory
- **Decode Unit**: Register File and Control Unit
- **Execution Unit**: ALU and related components
- **Memory Unit**: Data Memory
- **Writeback Logic**: For storing results back to registers

## Components

Each implementation includes these main components:
- **Control Unit**: Generates control signals based on instruction opcode
- **ALU**: Performs arithmetic and logical operations
- **Register File**: 32 x 32-bit registers
- **Data Memory**: For load/store operations
- **Instruction Memory**: Stores the program
- **Program Counter**: Keeps track of the instruction address
- **Various Multiplexers**: For data path control

## Modifications for Extensions

### SLL Extension
- Added ALU functionality for shift left logical operation
- Modified control signals to support sll instruction
- Extended ALU control logic

### LUI Extension
- Added support for loading immediate values into the upper 20 bits of registers
- Modified data path to support the lui instruction format
- Added new control signals for immediate value handling

## Testing

Each implementation includes comprehensive test benches to verify:
- Correct instruction execution
- Proper control signal generation
- Data path functionality
- Instruction extensions (sll, lui) working correctly

## Tools Used
- **Verilog HDL**: For hardware description
- **GTKWave**: For waveform visualization and analysis
- **Icarus Verilog**: For simulation and testing

## Results

All implementations have been thoroughly tested with various test programs to ensure correct functionality:
- The base processor successfully executes all the required RISC-V instructions
- The sll extension correctly shifts register values left by the specified amount
- The lui extension properly loads immediate values into the upper bits of registers

## Course Information
- **Course**: BLM2022 - Computer Organization
- **Semester**: Spring 2024-2025
- **Assignment**: Homework 2