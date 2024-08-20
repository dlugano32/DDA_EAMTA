module mux4_registered #(parameter WIDTH= 8) (
 input clk,
 input rst,
 input [1:0] sel,
 input [WIDTH-1:0] in1, in2, in3, in4,
 output [WIDTH-1:0] out
);

wire [WIDTH-1 : 0] q_reg;

mux4 #(.WIDTH(WIDTH)) M1 (.din1(in1), .din2(in2), .din3(in3), .din4(in4), .select(sel), .dout(q_reg));
register_bank #(.WIDTH(WIDTH)) U1 (.clk(clk), .rst(rst), .wr_en(1'b1), .in(q_reg), .out(out));

endmodule