# LRU-Cache-Memory
An LRU (Least Recently Used) cache memory in Verilog is designed to store and manage frequently accessed data by implementing a replacement policy that evicts the least recently used entries, ensuring efficient utilization of cache space and improved access times.


# 32-bit LRU Cache Memory Using Verilog

## Overview
This repository contains the implementation of a 32-bit Least Recently Used (LRU) cache memory in Verilog. The LRU cache is designed to store and manage frequently accessed data, ensuring efficient utilization of cache space by evicting the least recently used entries when the cache is full.

## Functionality
The LRU cache memory performs the following operations:
1. **Read**: Retrieves data from the cache if it exists, otherwise fetches from main memory.
2. **Write**: Writes data to the cache and updates the LRU status of the entries.
3. **Update**: Updates the LRU status of the entries to reflect recent usage.
4. **Eviction**: Removes the least recently used entry when the cache is full and a new entry needs to be added.

## Advantages
- **Efficiency**: Provides fast access to frequently used data, reducing the average time to access data.
- **Optimal Space Utilization**: Manages cache space effectively by keeping the most recently used data in the cache.
- **Performance Improvement**: Reduces the need for accessing slower main memory, thereby improving overall system performance.

## Required Data
The following data is required for the proper functioning of the 32-bit LRU Cache Memory:
1. **Address Width**: The number of bits in the address, typically 32 bits for a 32-bit cache.
2. **Data Width**: The width of the data entries, typically 32 bits.
3. **Cache Size**: The number of cache lines or entries.
4. **Main Memory**: The larger, slower memory where data is fetched from if not present in the cache.
## Pin Diagram
Below is a simple pin diagram for the 32-bit LRU Cache Memory module:

![ryJVm](https://github.com/GauravDhak/LRU-Cache-Memory/assets/113551816/15d4d0d3-88cb-4366-b44c-ef4536ab223e)

![Screenshot 2024-06-24 085304](https://github.com/GauravDhak/LRU-Cache-Memory/assets/113551816/898ed4c9-0e1d-46e2-a650-60b9f89fc7b3)

    reg clk;
    reg rst;
    reg read;
    reg write;
    reg [31:0] addr;
    reg [31:0] data_in;
    wire [31:0] data_out;
    wire hit;
    
## Simulation
To simulate the 32-bit LRU Cache Memory, follow these steps:

1. **Testbench**: Create a Verilog testbench file (e.g., `LRU_Cache_MEMORY_tb.v`) to simulate the cache behavior.
2. **Initialize Signals**: Initialize the clock, reset, and other control signals.
3. **Stimulus**: Apply read and write operations to the cache and observe the outputs.
4. **Run Simulation**: Use a Verilog simulator (e.g Icarus Verilog) to run the simulation and verify the functionality.

![Screenshot 2024-06-24 075752](https://github.com/GauravDhak/LRU-Cache-Memory/assets/113551816/1afc7380-11c2-4171-9802-b60b2fa31789)


![Screenshot 2024-06-24 075858](https://github.com/GauravDhak/LRU-Cache-Memory/assets/113551816/5a8e6bda-f2fe-448f-9fc2-a968555b9f4c)

## Usage
To use the 32-bit LRU Cache Memory:
1. Clone this repository to your local machine.
2. Synthesize the Verilog modules using your preferred Verilog simulator or FPGA toolchain.
3. Integrate the `LRU_Cache` module into your system, connecting it with your CPU and main memory.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
