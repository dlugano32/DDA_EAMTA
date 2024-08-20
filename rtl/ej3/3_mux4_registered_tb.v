`timescale 10ns/1ps

module tb_mux4_registered;

// Interface to communicate with the DUT
 logic clk;
 logic rst;
 logic [1:0] sel;
 logic [7:0] in1, in2, in3, in4;
 logic [7:0] out;

// Device under test instantiation
mux4_registered #(8) U1(.clk(clk), .rst(rst), .sel(sel), .in1(in1), .in2(in2), .in3(in3), .in4(in4), .out(out));

initial begin
// Test program
test1();
$finish;
end

initial
begin
 clk = 0;
 forever #5 clk = ~clk;
end

initial begin
// Monitor the simulation
$display("clk | rst | sel| out|");
$monitor("%b  | %b  | %b  | %h  |", clk, rst, sel, out);
end

task test1();
begin

    in1 = 8'hf5;
    in2 = 8'h15;
    in3 = 8'h3b;
    in4 = 8'h73;

    // Test case rst
    rst = 1'b1;
    sel = 2'b00;
    #10;

    // Test case 00
    rst = 1'b0;
    sel = 2'b00;
    #10;

    // Test case 01
    rst = 1'b0;
    sel = 2'b01;
    #10;

    // Test case 10
    rst = 1'b0;
    sel = 2'b10;
    #10; 
    
    // Test case 11
    rst = 1'b0;
    sel = 2'b11;
    #10;

end
endtask

endmodule