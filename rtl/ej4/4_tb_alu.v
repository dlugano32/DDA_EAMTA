`timescale 10ns/1ps

module tb_ALU;

// Interface to communicate with the DUT

logic [7:0] in1, in2;
logic [3:0] op;
logic invalid_data;
logic [15:0] out;
logic zero;
logic error;

// Device under test instantiation
ALU #(8) U1(.in1(in1), .in2(in2), .op(op), .invalid_data(invalid_data), .out(out), .zero(zero), .error(error));

initial
//Test program
begin
test1();
$finish;
end

initial begin
// Monitor the simulation
$display("in1 | in2 | op | out| invalid_data | zero | error");
$monitor("%h  | %h  | %b | %h | %b | %b | %b ", in1, in2, op, out, invalid_data, zero, error);
end

task test1();
begin
	// Test case: suma
	in1 = 8'haa;
	in2 = 8'h01;
	op = 4'h0;
	invalid_data = 0;
	#10;

	// Test case: resta
	in1 = 8'h0a;
	in2 = 8'h02;
	op = 4'h1;
	invalid_data = 0;
	#10;

	// Test case: mul
	in1 = 8'h04;
	in2 = 8'h02;
	op = 4'h2;
	invalid_data = 0;
	#10;

	// Test case: div
	in1 = 8'h04;
	in2 = 8'h02;
	op = 4'h4;
	invalid_data = 0;
	#10;

	// Test case: divx0
	in1 = 8'h08;
	in2 = 8'h00;
	op = 4'h4;
	invalid_data = 0;
	#10;

	// Test case: divx0 y invalid data
	in1 = 8'h08;
	in2 = 8'h00;
	op = 4'h4;
	invalid_data = 1;
	#10;

	// Test case: zerov1
	in1 = 8'h08;
	in2 = 8'h08;
	op = 4'h01;
	invalid_data = 0;
	#10;

	// Test case: zerov2 y overflow
	in1 = 8'hff;
	in2 = 8'hff;
	op = 4'h00;
	invalid_data = 0;
	#10;

end
endtask

endmodule