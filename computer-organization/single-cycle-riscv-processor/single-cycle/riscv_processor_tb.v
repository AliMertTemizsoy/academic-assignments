// Testbench for our first RISC-V processor
// This testbench simulates the RISC-V processor and verifies its functionality

module riscv_processor_tb();
    reg clk, reset; // Clock and reset signals
    wire [31:0] pc_current; // Current program counter value (address of the current instruction)
    wire [31:0] instr; // Instruction input (from memory)
    wire mem_write; // Memory write enable signal
    wire [31:0] alu_result, write_data; // ALU result and data to be written to memory or register
    wire [31:0] read_data; // Data read from memory
    
    // Monitor for program counter changes
    integer pc_monitor;
    
    // Instruction memory 
    reg [31:0] instr_mem[0:255];  
    
    // Data memory 
    reg [31:0] data_mem[0:255]; 
    
    // Processor instantiation
    riscv_processor dut(
        .clk(clk), // Clock signal
        .reset(reset), // Reset signal
        .pc_current(pc_current), // Current program counter value 
        .instr(instr), // Instruction input
        .mem_write(mem_write), // Memory write enable signal
        .alu_result(alu_result), // ALU result output
        .write_data(write_data), // Data to be written to memory or register
        .read_data(read_data) // Data read from memory
    );
    
    // Instruction memory read
    assign instr = instr_mem[pc_current[9:2]]; // Word aligned (PC[9:2] = address / 4)
    
    // Data memory write (word aligned)
    always @(posedge clk) begin  
        if (mem_write && !reset) begin // Memory write enabled and not in reset state
            data_mem[alu_result[9:2]] = write_data; // Word aligned (alu_result[9:2] = address / 4)
            $display("Memory write: address = %d (index %d), data = %h", alu_result, alu_result[9:2], write_data);
        end
    end
    
    // Data memory read (word aligned)
    assign read_data = data_mem[alu_result[9:2]]; 
    
    // Clock 
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        $dumpfile("processor.vcd"); // VCD file for GTKWave
        $dumpvars(0, riscv_processor_tb);  // Dump all variables for waveform viewing
    end
    
    // Test program
    initial begin
        // Initialize memories and signals
        clk = 0; // Clock signal
        reset = 1; // Reset signal
        pc_monitor = 0; // Monitor for program counter changes
        
        // Reset state
        $display("Reset state: mem_write = %b", mem_write);
        
        // Initialize instruction memory
        for (integer i = 0; i < 256; i = i + 1) begin
            instr_mem[i] = 32'h00000013;  // NOP (No Operation) instruction
        end
        
        // Initialize data memory
        for (integer i = 0; i < 256; i = i + 1) begin
            data_mem[i] = 32'h00000000; // Initialize data memory to zero
        end
        
        // Instruction memory initialization
        
        // 1. R-type - Arithmetic and logical operations
        instr_mem[0] = 32'h00500093;  // addi x1, x0, 5    # x1 = 5
        instr_mem[1] = 32'h00A00113;  // addi x2, x0, 10   # x2 = 10
        instr_mem[2] = 32'h002081B3;  // add x3, x1, x2    # x3 = x1 + x2 = 15
        instr_mem[3] = 32'h40208233;  // sub x4, x1, x2    # x4 = x1 - x2 = -5
        instr_mem[4] = 32'h0020F2B3;  // and x5, x1, x2    # x5 = x1 & x2 = 0
        instr_mem[5] = 32'h0020E333;  // or x6, x1, x2     # x6 = x1 | x2 = 15
        instr_mem[6] = 32'h0020A3B3;  // slt x7, x1, x2    # x7 = (x1 < x2) ? 1 : 0 = 1
        
        // 2. S-type - Memory store operations
        instr_mem[7] = 32'h0030a823;  // sw x3, 16(x1)  # mem[x1+16] = x3 = 15
        instr_mem[8] = 32'h00300593;  // addi x11, x0, 3   # x11 = 3
        instr_mem[9] = 32'h00b12623;  // sw x11, 12(x2) # mem[x2+12] = x11 = 3
        
        // 3. I-type - Immediate operations
        instr_mem[10] = 32'h00c12503; // lw x10, 12(x2) # x10 = mem[x2+12] = 3
        instr_mem[11] = 32'h008000EF; // jal x1, 8
        instr_mem[12] = 32'h0030A293; // slti x5, x1, 3
        instr_mem[13] = 32'h0030E313; // ori x6, x1, 3
        
        // 4. B-type - Branch operations
        instr_mem[14] = 32'h0030F393; // andi x7, x1, 3
        instr_mem[15] = 32'h00100793; // addi x15, x0, 1   # x15 = 1 
        instr_mem[16] = 32'h00310463; // beq x2, x3, skip  # if(x2 == x3) skip
        instr_mem[17] = 32'h00200813; // addi x16, x0, 2   # x16 = 2
        
        // 5. J-type - Jump operations
        instr_mem[18] = 32'h010000EF; // jal x1, jump_target (PC+16)
        instr_mem[19] = 32'h00300893; // addi x17, x0, 3    
        instr_mem[20] = 32'h00400893; // addi x17, x0, 4    
        instr_mem[21] = 32'h00500893; // addi x17, x0, 5    
        instr_mem[22] = 32'h00600893; // addi x17, x0, 6    
        
        // End of program
        instr_mem[23] = 32'h00000013; // nop       
        instr_mem[24] = 32'h00000063; // beq x0, x0, finish  // Infinite loop
        
        // Test data memory
        data_mem[0] = 32'hABCDEF01; 
        
        // Release reset
        #10 reset = 0;
        
        // Run for enough cycles to complete the program
        #1000;
        
        // Display register file contents
        display_registers();
        
        // Display data memory contents
        $display("Data Memory Contents:");
        $display("mem[8] = %h", data_mem[2]);  // mem[8] = mem[2] (8/4 = 2)
        $display("mem[14] = %h", data_mem[3]); // mem[14] = mem[3] (14/4 = 3)
                
        $finish;
    end
    
    // Register file contents display
    task display_registers;
        begin
            $display("Register File Contents:");
            $display("x1 = %h", dut.dp.rf.registers[1]);   // ra
            $display("x2 = %h", dut.dp.rf.registers[2]);   // sp
            $display("x3 = %h", dut.dp.rf.registers[3]);   // gp
            $display("x4 = %h", dut.dp.rf.registers[4]);   // tp
            $display("x5 = %h", dut.dp.rf.registers[5]);   // t0
            $display("x6 = %h", dut.dp.rf.registers[6]);   // t1
            $display("x7 = %h", dut.dp.rf.registers[7]);   // t2
            $display("x10 = %h", dut.dp.rf.registers[10]); // a0
            $display("x11 = %h", dut.dp.rf.registers[11]); // a1
            $display("x12 = %h", dut.dp.rf.registers[12]); // a2
            $display("x13 = %h", dut.dp.rf.registers[13]); // a3
            $display("x14 = %h", dut.dp.rf.registers[14]); // a4
            $display("x15 = %h", dut.dp.rf.registers[15]); // a5
            $display("x16 = %h", dut.dp.rf.registers[16]); // a6
            $display("x17 = %h", dut.dp.rf.registers[17]); // a7
        end
    endtask
    
    // PC watch (synchronous)
    always @(posedge clk) begin
        if (!reset && pc_current != pc_monitor) begin
            $display("Time: %4d, PC: %h, Instr: %h", $time, pc_current, instr);
            pc_monitor = pc_current;
        end
    end
    
    // mem_write watch (combinational)
    always @(posedge clk) begin  
        if (mem_write && instr[6:0] != 7'b0100011 && !reset) begin  // Check if mem_write is active and not a store instruction
            $display("Unexpected mem_write active at Time: %4d, PC: %h, Instr: %h", $time, pc_current, instr);
        end
    end
endmodule

// iverilog -o processor_vvp -s riscv_processor_tb alu_decoder.v alu_mips.v and_32bit.v control_unit.v datapath.v fulladder_32bit.v imm_generator.v main_decoder.v or_32bit.v program_counter.v register_file.v riscv_processor.v riscv_processor_tb.v setlessthan_32bit.v signext.v sll_32bit.v subtractor_32bit.v
// vvp processor_vvp

// gtkwave 