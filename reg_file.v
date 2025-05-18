module reg_file(
	input wire clk,  //系統時脈
	input wire rst_n,  //非同步Reset(低有效)
	input wire we_a,   // Write Enable for Reg A
	input wire we_b,   // Write Enable for Reg B
	input wire [7:0] data_in,  //寫入資料
	output reg [7:0] data_a,   // Reg A內容
	output reg [7:0] data_b    // Reg B內容
	
);

//寄存器寫入邏輯
always @ (posedge clk or negedge rst_n) begin
  if (!rst_n) begin
     data_a <= 8'd0;
     data_b <= 8'd0;
  end else begin
      if (we_a)
	 data_a <= data_in;
      if (we_b)
	 data_b <= data_in;
  end
end
endmodule