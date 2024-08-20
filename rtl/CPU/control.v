module control (
 input clk,
 input rst,
 input [6:0] cmd_in,    // Linea de comando
 input p_error,         // error de la ALU
 output logic aluin_reg_en,   // enable de la ALU
 output logic datain_reg_en,  // enable del cmdin
 output logic memoryWrite, memoryRead, selmux2,
 output logic aluout_reg_en,  // enable de los registros de salida
 output logic invalid_data,    //
 output logic [1:0] in_select_a,  //MUXA
 output logic [1:0] in_select_b,  //MUXB
 output logic [3:0] opcode        //OPCODE ALU
);

// type enum logic [2:0] {RST=3'b000, FETCH=3'b001, DECODE=3'b010, EXECUTE_ALU_OP=3'b011, EXEC_MEM_OP=3'b100, NOP=3'b101}
//     state_type;

localparam RST=3'b000, FETCH=3'b001, DECODE=3'b010, EXEC_ALU_OP=3'b011, EXEC_MEM_OP=3'b100, NOP=3'b101;
logic [2:0] state, next;
logic [1:0] alu_op, mem_op;

always @(posedge clk) begin
    if (rst)     
        state <= RST;
    else    
        state <= next;
end

always @(*) begin
    next = FETCH;
    //En principio, todas las salidas en cero
    datain_reg_en   = 1'b0;
    aluin_reg_en    = 1'b0;
    memoryWrite     = 1'b0;
    memoryRead      = 1'b0;
    selmux2         = 1'b0;
    aluout_reg_en   = 1'b0;
    opcode          = 4'b0000;

    unique case (state)
    RST     :  begin
                next = FETCH;
    end
    FETCH   :  begin 
                datain_reg_en = 1'b1;
                next = DECODE;
    end

    DECODE  : begin
            if(~cmd_in[2]) begin
                alu_op = cmd_in[1:0];
                next = EXEC_ALU_OP;
            end
            else if(opcode[1]^opcode[0]) begin
                    mem_op = cmd_in[1:0];
                    next = EXEC_MEM_OP;
		 end
                 else next = NOP;
    end
    
    EXEC_ALU_OP : begin
                next = FETCH;
                aluin_reg_en = 1'b1;
                aluout_reg_en = 1'b1;
                selmux2 = 1'b0;

                case(alu_op)
                2'b00 : opcode = 4'b0000;
                2'b01 : opcode = 4'b0001;
                2'b10 : opcode = 4'b0100;
                2'b11 : opcode = 4'b1000;
                endcase
    end

    EXEC_MEM_OP : begin
                next = FETCH;
                if(mem_op[0]) begin             //LOAD
                        selmux2 = 1'b1;
                        memoryRead = 1'b1;
                        aluout_reg_en = 1'b1;
                end
                else    memoryWrite = 1'b1;     //STORE
    end

    NOP         : state = FETCH;
    default state = FETCH;

    endcase
end

    assign invalid_data = cmd_in[2] && p_error && ( (in_select_a == 2'b11) || (in_select_b == 2'b11) );
    assign in_select_a = cmd_in[6:5];   //Tengo que tocar algo cuando hago LOAD o STORE?
    assign in_select_b = cmd_in[4:3];
endmodule