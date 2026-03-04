`timescale 1ns / 1ps

module histogram_mem(
    input clk,
    input [13:0] addr,    
    input we,             
    output reg [31:0] count_out
);

    // Attribute to move 16k bins from LUTs to dedicated BRAM tiles
    (* ram_style = "block" *) 
    reg [31:0] ram [16383:0]; 

    integer i;

    initial begin
        for (i = 0; i < 16384; i = i + 1) begin
            ram[i] = 32'h00000000;
        end
    end

    always @(posedge clk) begin
        if (we) begin
            ram[addr] <= ram[addr] + 1;
        end
        count_out <= ram[addr];
    end
    
endmodule
