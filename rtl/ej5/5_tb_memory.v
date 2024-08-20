`timescale 10ns/1ps

module tb_memory;

// Interface to communicate with the DUT
logic clk, rst, memoryWrite, memoryRead;
logic [15:0] memoryWriteData;
logic [7:0] memoryAddress;
logic [15:0] memoryOutData;

// Interface to communicate with the DUT
memory #(8) U1(
.clk(clk), .rst(rst), .memoryWrite(memoryWrite), .memoryRead(memoryRead), 
.memoryWriteData(memoryWriteData), .memoryAddress(memoryAddress), .memoryOutData(memoryOutData)
);

initial begin
 //Test Program
 test1();
 $finish;
end

initial begin
 clk = 0;
 forever #5 clk = ~clk;
end

initial begin
//Monitor the simulation
$display("clk | rst | memoryWrite | memoryRead | memoryWriteData | memoryAddress | memoryOutData ");
$monitor("%b   | %b   |     %b       |     %b      |     %h        |     %h        |     %h ", 
clk, rst, memoryWrite, memoryRead, memoryWriteData, memoryAddress, memoryOutData);
end

task test1();
begin

	//Test case : rst
	rst = 1'b1;
	memoryWrite = 1'b0;
	memoryRead = 1'b0;
	memoryWriteData = 'b0;
	memoryAddress = 'b0;
	#10;

	//Test case : write
	rst = 1'b0;
	memoryWrite = 1'b1;
	memoryRead = 1'b0;
	memoryWriteData = 16'habcd;
	memoryAddress = 8'd10;
	#10

	//Test case : read
	rst = 1'b0;
	memoryWrite = 1'b0;
	memoryRead = 1'b1;
	memoryWriteData = 16'hffff;
	memoryAddress = 8'd10;
	#10;
	
	//Test case : read & write
	rst = 1'b0;
	memoryWrite = 1'b1;
	memoryRead = 1'b1;
	memoryWriteData = 16'hffff;
	memoryAddress = 8'd10;
	#10;

	//Test case : read previos write
	rst = 1'b0;
	memoryWrite = 1'b0;
	memoryRead = 1'b1;
	memoryWriteData = 16'h0000;
	memoryAddress = 8'd10;
	#10;
	


end
endtask

endmodule