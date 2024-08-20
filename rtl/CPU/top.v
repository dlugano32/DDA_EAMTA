module top #(    parameter WIDTH= 8    ) (
input clk,
input rst,    
input [6:0] cmdin,    
input [WIDTH-1:0] din_1,   
input [WIDTH-1:0] din_2,   
input [WIDTH-1:0] din_3,   
output [WIDTH-1:0] dout_low,   
output [WIDTH-1:0] dout_high,   
output zero,   
output error );

logic [WIDTH*2-1:0] alu_out, regout_in, mem_out, dout;
logic [WIDTH-1:0] rega_in, regb_in, op_a, op_b;
logic [3:0] opcode;
logic [6:0] cmd_out;
logic [1:0] select_a, select_b;
logic wr_en_regin, wr_en_regout, wr_en_cmd, invalid_data, selmux_out, reg_zero_in, reg_error_in, memoryRead, memoryWrite;

control U1( .clk(clk), .rst(rst), .cmd_in(cmd_out), .p_error(error), .aluin_reg_en(wr_en_regin), .datain_reg_en(wr_en_cmd), .memoryWrite(memoryWrite), .memoryRead(memoryRead), 
.selmux2(selmux_out), .aluout_reg_en(wr_en_regout), .invalid_data(invalid_data), .in_select_a(select_a), .in_select_b(select_b), .opcode(opcode));

mux4 #(.WIDTH(WIDTH)) MUXA   (.din1(din_1), .din2(din_2), .din3(din_3), .din4(dout_high), .select(select_a), .dout(rega_in));
mux4 #(.WIDTH(WIDTH)) MUXB   (.din1(din_1), .din2(din_2), .din3(din_3), .din4(dout_low),  .select(select_b), .dout(regb_in));

register_bank #(.WIDTH(7))       CMD    ( .clk(clk), .rst(rst), .wr_en(wr_en_cmd),    .in(cmdin),   .out(cmd_out));
register_bank #(.WIDTH(WIDTH))   REGA   ( .clk(clk), .rst(rst), .wr_en(wr_en_regin),  .in(rega_in), .out(op_a));
register_bank #(.WIDTH(WIDTH))   REGB   ( .clk(clk), .rst(rst), .wr_en(wr_en_regin),  .in(regb_in), .out(op_b));
register_bank #(.WIDTH(2))       REG_ZE ( .clk(clk), .rst(rst), .wr_en(wr_en_regout), .in({reg_zero_in, reg_error_in}), .out({zero, error}));
register_bank #(.WIDTH(2*WIDTH)) REG_OUT( .clk(clk), .rst(rst), .wr_en(wr_en_regout), .in(regout_in), .out(dout));

memory #(.WIDTH(WIDTH)) MEM1 ( .clk(clk), .rst(rst), .memoryWrite(memoryWrite), .memoryRead(memoryRead), .memoryWriteData(dout), .memoryAddress(din_1), .memoryOutData(mem_out));

ALU #(.WIDTH(WIDTH)) U2( .in1(op_a), .in2(op_b), .op(opcode), .invalid_data(invalid_data), .out(alu_out), .zero(reg_zero_in), .error(reg_error_in));

assign regout_in = (selmux_out) ? mem_out : alu_out;
assign dout_high = dout[WIDTH*2-1:WIDTH];
assign dout_low  = dout[WIDTH-1:0];

endmodule
