module ALU #(
 parameter WIDTH = 8
) (
 input [WIDTH-1:0] in1, in2,
 input [3:0] op,
 input invalid_data,
 output logic [2*WIDTH-1:0] out,
 output zero,
 output error
);

wire divx0;

always_comb begin
    	if(error)
      	  	out = 'b1;
	else begin
		case (op)
		4'b0000 : out = { {WIDTH{1'b0}} , in1 } + { {WIDTH{1'b0}} , in2 };
		4'b0001 : out = { {WIDTH{1'b0}} , in1 } - { {WIDTH{1'b0}} , in2 };
		4'b0010 : out = { {WIDTH{1'b0}} , in1 } * { {WIDTH{1'b0}} , in2 };
		4'b0100 : out = { {WIDTH{1'b0}} , in1 } / { {WIDTH{1'b0}} , in2 };
		default : out = 'b0;
		endcase
        end
end

    assign zero = (out == 'b0);
    assign divx0 = (in2 == 0) && op[2];
    assign error = divx0 || invalid_data;


endmodule