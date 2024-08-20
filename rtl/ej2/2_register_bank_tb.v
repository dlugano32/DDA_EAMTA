`timescale 10ns/1ps

module tb_register_bank;

// Interface to communicate with the DUT
logic clk;
logic rst;
logic wr_en;
logic [7:0] in;
logic [7:0] out;

// Device under test instantiation
register_bank #(.WIDTH(8)) U1 (.clk(clk), .rst(rst), .wr_en(wr_en), .in(in), .out(out));

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
$display("clk | rst | wr_en | in | out |");
$monitor("%b  | %b  | %b    | %h | %h  |", clk, rst, wr_en, in, out);
end


// Define test1 function
task test1();
begin

    // Test case 1 : rst
    rst = 1'b1;
    wr_en = 1'b0;
    in = 8'haa;
    #10;

    // Test case 2 : in_data -> out_data
    rst = 1'b0;
    wr_en = 1'b1;
    in = 8'hfa;
    #10;


    // Test case 3 : ~wr_en
    rst = 1'b0;
    wr_en = 1'b0;
    in = 8'h0f;
    #10;

end
endtask
endmodule