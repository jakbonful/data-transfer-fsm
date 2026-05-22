`timescale 1ns/1us
module ram_dp_async_read #(
    parameter width = 8,
    parameter depth = 16,
    parameter depth_bits = $clog2(depth)
) (
    input clk,
    input w_en,
    input [depth_bits-1:0] addr_wr,
    input [depth_bits-1:0] addr_rd,
    input [width-1:0] data_wr,
    output [width-1:0] data_rd,
);

// RAM 8bits * 16word memory locations
reg [width-1:0] ram [0:depth-1];
    
// Synchronous Write
always @(posedge clk ) begin
    if (w_en)
        ram[addr_wr] <= data_wr;
end

// Asynchronous Read
assign data_rd = ram[addr_rd];
endmodule