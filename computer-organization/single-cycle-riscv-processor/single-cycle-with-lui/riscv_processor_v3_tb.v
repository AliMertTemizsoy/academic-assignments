// Testbench for our third RISC-V processor

module riscv_processor_v3_tb();
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
    reg [31:0] data_mem[0:16383];   
    
    // Processor instantiation
    riscv_processor_v3 dut(
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
            if ((alu_result >> 2) < 16384) begin // Memory boundary check
                $display("DEBUG: Before write: alu_result = %h, alu_result >> 2 = %d", alu_result, (alu_result >> 2));
                data_mem[alu_result >> 2] = write_data; // Word aligned (alu_result >> 2 = address / 4)
                $display("Memory write: address = %d (index %d), data = %h", alu_result, (alu_result >> 2), write_data);
                $display("DEBUG: After write: mem[%d] = %h", (alu_result >> 2), data_mem[alu_result >> 2]);
            end else begin
                $display("WARNING: Memory write attempt out of bounds! Address: %d", alu_result);
            end
        end
    end
    
    // Data memory read (word aligned)
    assign read_data = ((alu_result >> 2) < 16384) ? data_mem[alu_result >> 2] : 32'b0;
    
    // Clock
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        $dumpfile("processor_v3.vcd"); // VCD file for GTKWave
        $dumpvars(0, riscv_processor_v3_tb); // Dump all variables for waveform viewing
    end
    
    // Test program
    initial begin
        // Initialize memories and signals
        clk = 0; // Clock signal
        reset = 1; // Reset signal
        pc_monitor = 0; // Monitor for program counter changes
        
        // Reset sırasında mem_write kontrolü
        $display("Reset state: mem_write = %b", mem_write);
        
        // Initialize instruction memory to NOP
        for (integer i = 0; i < 256; i = i + 1) begin
            instr_mem[i] = 32'h00000013;  // addi x0, x0, 0 (NOP)
        end
        
        // Test programı
        instr_mem[0] = 32'h000AB0B7;  // lui x1, 0xAB
        instr_mem[1] = 32'hFFFCD137;  // lui x2, 0xFFFCD
        instr_mem[2] = 32'h00001237;  // lui x4, 0x1
        instr_mem[3] = 32'h00001197;  // auipc x3, 0x1
        instr_mem[4] = 32'h00100293;  // addi x5, x0, 1
        instr_mem[5] = 32'h00129313;  // slli x6, x5, 1
        instr_mem[6] = 32'h006282B3;  // add x5, x5, x6
        instr_mem[7] = 32'h00008337;  // lui x6, 0x8
        instr_mem[8] = 32'h00628293;  // addi x5, x5, 6
        instr_mem[9] = 32'h00532023;  // sw x5, 0(x6)
        instr_mem[10] = 32'h00032383; // lw x7, 0(x6)
        instr_mem[11] = 32'h00728463; // beq x5, x7, skip
        instr_mem[12] = 32'h00000013; // nop
        instr_mem[13] = 32'h00000097; // auipc x1, 0
        instr_mem[14] = 32'h00000063; // beq x0, x0, end
        
        // Debugging: Display instruction memory contents
        $display("DEBUG: instr_mem[0] = %h", instr_mem[0]);
        $display("DEBUG: instr_mem[1] = %h", instr_mem[1]);
        $display("DEBUG: instr_mem[2] = %h", instr_mem[2]);
        $display("DEBUG: instr_mem[3] = %h", instr_mem[3]);
        
        // Initialize data memory
        for (integer i = 0; i < 16384; i = i + 1) begin
            data_mem[i] = 32'h00000000; 
        end
        
        // Release reset
        #10 reset = 0;
        
        // Run for enough cycles to complete the program
        #500;
        
        // Display register file contents
        display_registers();
        
        // Display key memory locations
        $display("Data Memory Contents:");
        $display("mem[%d] = %h", 32'h8000 >> 2, data_mem[32'h8000 >> 2]);
        
        $finish;
    end
    
    // Register file contents display
    task display_registers;
        begin
            $display("Register File Contents:");
            $display("x1 = %h", dut.dp.rf.registers[1]); 
            $display("x2 = %h", dut.dp.rf.registers[2]);
            $display("x3 = %h", dut.dp.rf.registers[3]);
            $display("x4 = %h", dut.dp.rf.registers[4]);
            $display("x5 = %h", dut.dp.rf.registers[5]);
            $display("x6 = %h", dut.dp.rf.registers[6]);
            $display("x7 = %h", dut.dp.rf.registers[7]);
        end
    endtask
    
    // Monitor program counter changes
    always @(posedge clk) begin
        if (!reset && pc_current != pc_monitor) begin // Check for changes in program counter
            $display("Time: %4d, PC: %h, Index: %d, Instr: %h", $time, pc_current, pc_current[9:2], instr);
            pc_monitor = pc_current; // Update monitor value
        end
    end
    
    // Monitor ALU result and program counter
    always @(posedge clk) begin
        if (!reset) begin // Check for changes in ALU result
            $display("DEBUG: Time: %4d, PC: %h, alu_result: %h, alu_result >> 2: %d", $time, pc_current, alu_result, (alu_result >> 2));
        end
    end
endmodule

// iverilog -o processor_v3_vvp -s riscv_processor_v3_tb alu_decoder_v2.v alu_mips_v2.v and_32bit.v control_unit_v3.v datapath_v3.v fulladder_32bit.v imm_generator_v3.v main_decoder_v3.v or_32bit.v program_counter.v register_file.v riscv_processor_v3.v riscv_processor_v3_tb.v setlessthan_32bit.v signext.v sll_32bit.v subtractor_32bit.v
// vvp processor_v3_vvp
// gtkwave