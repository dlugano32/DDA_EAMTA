`timescale 10ns/1ps

module tb_control;

// Interface to communicate with the DUT
logic clk,
logic rst,
logic [6:0] cmd_in,    // Linea de comando
logic p_error,         // error de la ALU
logic aluin_reg_en,   // enable de la ALU
logic datain_reg_en,  // enable del cmdin
logic memoryWrite, memoryRead, selmux2,
logic aluout_reg_en,  // enable de los registros de salida
logic invalid_data,    //
logic [1:0] in_select_a,  //MUXA
logic [1:0] in_select_b,  //MUXB
logic [3:0] opcode        //OPCODE ALU

// Device under test instantiation
control U1( .clk(clk), .rst(rst), .cmd_in(cmd_in), .p_error(p_error), .aluin_reg_en(aluin_reg_en), .datain_reg_en(datain_reg_en), .memoryWrite(memoryWrite), .memoryRead(memoryRead), 
.selmux2(selmux2), .aluout_reg_en(aluout_reg_en), .invalid_data(invalid_data), .in_select_a(in_select_a), .in_select_b(in_select_b), .opcode(opcode));

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
$display("clk | rst | aluin_reg_en | datain_reg_en | memoryWrite | memoryRead | selmux2 | alout_reg_en | invalid_data | in_select_a | in_select_b | opcode");
$monitor("%b  | %b  |       %b     |      %b       |     %b      |     %b     |     %b  |      %b      |       %b     |      %b     |      %b     |    %b  ", clk, rst, aluin_reg_en, datain_reg_en, memoryWrite, memoryRead, selmux2, alout_reg_en, invalid_data, in_select_a, in_select_b, opcode);
end


// Define test1 function
task test1();
begin

    // Test case: SUMA
    rst = 1'b0;
    cmd_in = 7'b0000000;
    p_error = 1'b0;
    #50
end
endtask
endmodule