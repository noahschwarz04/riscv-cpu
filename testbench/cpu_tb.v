`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2025 04:38:49 AM
// Design Name: 
// Module Name: cpu_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_tb;

    reg clk;
    reg rst;
    
    
    cpu uut (
     .clk(clk),
     .rst(rst)
     );

    always #5 clk = ~clk;
    
    initial begin
    
         clk = 0;
         rst = 1;
    
         #10
    
         rst = 0;
    
         #900
      
        $stop;
    
    end
    
endmodule
