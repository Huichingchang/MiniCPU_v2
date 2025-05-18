module alu(
	input wire [7:0] op_a,  // Operand A
	input wire [7:0] op_b,  // Operand B
	input wire [1:0] alu_op,	 //  2-bit ALU操作碼
        output reg [7:0] result  // Operation result
);

// ALU運算邏輯
always @(*) begin
  case (alu_op)
    2'b00: result = op_a + op_b;  // ADD
    2'b01: result = op_a - op_b;  // SUB
    2'b10: result = op_a & op_b;  // AND
    2'b11: result = op_a | op_b;  // OR
    default: result = 8'd0;      //預設(安全設計)
  endcase
end
endmodule