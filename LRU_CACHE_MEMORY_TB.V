`include "LRU_CACHE_MEMORY.v"
module tb_cache_memory_lru;

    // Parameters
    parameter CACHE_SIZE = 256;
    parameter INDEX_BITS = 8;
    parameter TAG_BITS = 24;
    parameter WAY_SIZE = 4;

    // Inputs
    reg clk;
    reg reset;
    reg [31:0] addr;
    reg [31:0] data_in;
    reg we;
    reg re;

    // Outputs
    wire [31:0] data_out;
    wire hit;

    // Instantiate the Unit Under Test (UUT)
    cache_memory_lru uut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .data_in(data_in),
        .we(we),
        .re(re),
        .data_out(data_out),
        .hit(hit)
    );

   
    // Clock generation
    initial begin
     $dumpfile("tb_cache_memory_lru.vcd");
    $dumpvars(0,tb_cache_memory_lru);
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock

end
    // Test sequence
    initial begin
        // Initialize Inputs
        reset = 1;
        addr = 0;
        data_in = 0;
        we = 0;
        re = 0;

        // Wait for global reset
        #20;
        reset = 0;

        // Write some data to the cache
        write_to_cache(32'h0000_0000, 32'hAAAA_AAAA);
        write_to_cache(32'h0000_0004, 32'hBBBB_BBBB);
        write_to_cache(32'h0000_0008, 32'hCCCC_CCCC);
        write_to_cache(32'h0000_000C, 32'hDDDD_DDDD);

        // Read the data back from the cache
        read_from_cache(32'h0000_0000);
        read_from_cache(32'h0000_0004);
        read_from_cache(32'h0000_0008);
        read_from_cache(32'h0000_000C);

        // Write more data to cause cache replacement
        write_to_cache(32'h0000_0010, 32'hEEEE_EEEE);
        write_to_cache(32'h0000_0014, 32'hFFFF_FFFF);

        // Read the new data back
        read_from_cache(32'h0000_0010);
        read_from_cache(32'h0000_0014);

        // Read the old data to check LRU replacement
        read_from_cache(32'h0000_0000);
        read_from_cache(32'h0000_0004);

        $finish;
    end

    // Task to write to the cache
    task write_to_cache;
        input [31:0] write_addr;
        input [31:0] write_data;
        begin
            addr = write_addr;
            data_in = write_data;
            we = 1;
            re = 0;
            #10;
            we = 0;
            addr = 0;
            data_in = 0;
            #10;
        end
    endtask

    // Task to read from the cache
    task read_from_cache;
        input [31:0] read_addr;
        begin
            addr = read_addr;
            we = 0;
            re = 1;
            #10;
            re = 0;
            addr = 0;
            #10;
        end
    endtask

endmodule
