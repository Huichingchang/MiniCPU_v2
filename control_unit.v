module control_unit (
	input wire clk,
	input wire rst_n,
	input wire [7:0] instr,  //從指令記憶體拿到的指令
	output reg we_a,        //寫入Reg A使能
	output reg we_b,        //寫入Reg B使能
	output reg [1:0] alu_op,      // 2-bit ALU操作碼
	output reg do_alu,      //是否執行ALU
	output reg do_store,    //是否執行STORE
	output reg [3:0] next_pc  //下一個指令位址
);

//狀態定義
localparam IDLE = 2'd0;
localparam FETCH = 2'd1;
localparam DECODE = 2'd2;
localparam EXECUTE = 2'd3;

reg [1:0] state, next_state;

//主狀態機
always @(posedge clk or negedge rst_n) begin
  if (!rst_n)
    state <= IDLE;
  else
    state <= next_state;
end

//次態轉移邏輯
always @ (*) begin
  case (state)
    IDLE: next_state = FETCH;
    FETCH: next_state = DECODE;
    DECODE: next_state = EXECUTE;
    EXECUTE: next_state = FETCH;
    default: next_state = IDLE;
  endcase
end

//控制信號邏輯
always @ (posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    we_a <= 0;
    we_b <= 0;
    alu_op <= 2'b00;
    do_alu <= 0;
    do_store <= 0;
    next_pc <= 4'd0;
  end else begin
    case  (state)
     FETCH: begin
      next_pc <= next_pc + 1;
      we_a <= 0;
      we_b <= 0;
      alu_op <= 2'b00;
      do_alu <= 0;
      do_store <= 0;
     end
     DECODE: begin
	//預設先清0
	we_a <= 0;
	we_b <= 0;
	alu_op <= 2'b00;
	do_alu <= 0;
	do_store <= 0;

	//根據instr[7:4]解碼
		case (instr[7:4])
	 4'b0001: we_a <= 1;  // LOAD A
         4'b0010: we_b <= 1;  // LOAD B
         4'b0100: begin  // DD
           alu_op <= 2'b00;
           do_alu <= 1;
         end
         4'b0101: begin  // SUB
	   alu_op <= 2'b01;
           do_alu <= 1;
         end
         4'b0110: begin  // AND
	   alu_op <= 2'b10;
           do_alu <= 1;
         end
         4'b0111: begin  // OR
	   alu_op <= 2'b11;
           do_alu <= 1;
         end
         4'b1000: do_store <= 1;  // STORE
	 default:;                //不處理
       endcase
     end
     EXECUTE: begin
       //清除控制訊號
       we_a <= 0;
       we_b <= 0;
       do_alu <= 0;
       do_store <= 0;
     end
     endcase
  end
end
endmodule
