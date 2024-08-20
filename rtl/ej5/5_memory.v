module memory #( parameter WIDTH = 8) (
 input clk, rst, memoryWrite, memoryRead,
 input [2*WIDTH-1:0] memoryWriteData,
 input [WIDTH-1:0] memoryAddress,
 output logic [2*WIDTH-1:0] memoryOutData
);

logic [WIDTH*2-1:0] mem [(2**WIDTH)];
logic [WIDTH*2-1:0] auxRead;

always @(posedge clk) begin
	if(rst)
		mem <= '{default:'b0};
	else begin
		auxRead <= mem[memoryAddress];
		if (memoryWrite)
			mem[memoryAddress] <= memoryWriteData;
	     end		
end

always_comb begin
	if(memoryRead)
		memoryOutData = auxRead;
	else
		memoryOutData = 'b0;
end

endmodule