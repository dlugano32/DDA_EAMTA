`timescale 10ns/1ps

module tb_mux4;

// Interface to communicate with the DUT
logic [7:0] tb_din1, tb_din2, tb_din3, tb_din4;
logic [1:0] tb_select;
logic [7:0] tb_dout;

// Device under test instantiation
mux4 #(.WIDTH(8)) U1 (.din1(tb_din1), .din2(tb_din2), .din3(tb_din3), .din4(tb_din4), .select(tb_select), .dout(tb_dout));

initial begin 
// Test program
test1();
$finish;
end

initial
begin // Monitor the simulation
 $display ("sel | dout");
 $monitor (" %h | %h ", tb_select, tb_dout);
end

// Define test1 function
task test1();
begin
    tb_din1 = 8'h03;
    tb_din2 = 8'hac;
    tb_din3 = 8'h15;
    tb_din4 = 8'h10;

    tb_select = 2'b00;
    #5 tb_select = 2'b01;
    #5 tb_select = 2'b10;
    #5 tb_select = 2'b11;
    #5;
end
endtask
endmodule
