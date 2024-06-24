module cache_memory_lru (
    input  clk,
    input  reset,
    input  [31:0] addr,
    input  [31:0] data_in,
    input  we,
    input  re,
    output reg [31:0] data_out,
    output reg hit
);

    parameter CACHE_SIZE = 256;  // Cache size in words
    parameter INDEX_BITS = 8;    // log2(CACHE_SIZE)
    parameter TAG_BITS = 24;     // 32 - INDEX_BITS - OFFSET_BITS
    parameter WAY_SIZE = 4;      // Number of ways for set-associative cache

    reg [31:0] data_array [0:WAY_SIZE-1][0:CACHE_SIZE-1];  // Data array
    reg [TAG_BITS-1:0] tag_array [0:WAY_SIZE-1][0:CACHE_SIZE-1];  // Tag array
    reg valid_array [0:WAY_SIZE-1][0:CACHE_SIZE-1];  // Valid bit array
    reg [1:0] lru_counter [0:CACHE_SIZE-1][0:WAY_SIZE-1];  // LRU counter array

    wire [INDEX_BITS-1:0] index = addr[INDEX_BITS+1:2];
    wire [TAG_BITS-1:0] tag = addr[31:INDEX_BITS+2];
    integer i, j,lru_way ;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < CACHE_SIZE; i = i + 1) begin
                for (j = 0; j < WAY_SIZE; j = j + 1) begin
                    valid_array[j][i] <= 0;
                    lru_counter[i][j] <= j;
                end
            end
            hit <= 0;
            data_out <= 0;
        end else begin
            hit <= 0;
            data_out <= 32'bx;

            // Check for cache hit
            for (i = 0; i < WAY_SIZE; i = i + 1) begin
                if (valid_array[i][index] && tag_array[i][index] == tag) begin
                    hit <= 1;
                    data_out <= data_array[i][index];

                    // Update LRU counter for cache hit
                    for (j = 0; j < WAY_SIZE; j = j + 1) begin
                        if (lru_counter[index][j] < lru_counter[index][i])
                            lru_counter[index][j] <= lru_counter[index][j] + 1;
                    end
                    lru_counter[index][i] <= 0;
                end
            end

            // Cache miss handling
            if (!hit && we) begin
                // Find the LRU way
              // integer lru_way;
                for (i = 0; i < WAY_SIZE; i = i + 1) begin
                    if (lru_counter[index][i] == WAY_SIZE-1)
                        lru_way = i;
                end

                // Write data to LRU way
                data_array[lru_way][index] <= data_in;
                tag_array[lru_way][index] <= tag;
                valid_array[lru_way][index] <= 1;

                // Update LRU counters
                for (i = 0; i < WAY_SIZE; i = i + 1) begin
                    if (lru_counter[index][i] < lru_counter[index][lru_way])
                        lru_counter[index][i] <= lru_counter[index][i] + 1;
                end
                lru_counter[index][lru_way] <= 0;
            end

            // Handle read enable
            if (re && !hit) begin
                data_out <= 32'bx;
            end
        end
    end

endmodule




//data_array: Stores the actual data in the cache.
// tag_array: Stores the tag bits for each cache line.
// valid_array: Indicates if the cache line is valid.
// lru_counter: Stores the LRU counter for each cache line.
// Cache Hit:

// If the requested data is found in the cache (hit), the corresponding lru_counter is updated to reflect that this cache line was recently used.
// Cache Miss and Write:

// If the data is not found in the cache (miss), the LRU way is determined by finding the highest value in the lru_counter.
// The data is then written to this LRU way, the tag and valid bits are updated, and the lru_counter for this way is reset to zero (most recently used). 
//All other counters are incremented accordingly.
// Reset:

// On reset, all valid bits are cleared, and the LRU counters are initialized.