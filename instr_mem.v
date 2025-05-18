module instr_mem (
	input wire [3:0] addr,  //指令位址
	output reg [7:0] instr  //指令資料
);

// ROM內容宣告
always @ (*) begin
  case (addr)
		4'd0: instr = 8'b00010011;  //示例: LOAD A,3
		4'd1: instr = 8'b00100101;  //示例: LOAD B,5
		4'd2: instr = 8'b01000000;  //示例: ADD A, B
		4'd3: instr = 8'b01000000;  //示例: STORE

		4'd4: instr = 8'b00010010;  //示例: LOAD A,2
		4'd5: instr = 8'b00100101;  //示例: LOAD B,5
		4'd6: instr = 8'b01100000;  //示例: ADD A, B
		4'd7: instr = 8'b10000000;  //示例: STORE

		4'd8: instr = 8'b00010100;  //示例: LOAD A,4
		4'd9: instr = 8'b00100001;  //示例: LOAD B,1
		4'd10: instr = 8'b01110000;  //示例: ADD A, B
		4'd11: instr = 8'b10000000;  //示例: STORE


		default: instr = 8'b00000000;  //預設Nop
  endcase
end
endmodule