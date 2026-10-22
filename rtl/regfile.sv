module regfile
  import rv32i_pkg::*;
  (
  input logic clk,
  input logic rst_n,
  input logic [4:0]rs1_addr,
  input logic [4:0]rs2_addr,
  input logic [4:0]rd_addr,
  input logic [31:0] write_data,
  input logic we,
  output logic [31:0] rs1_data,
  output logic [31:0] rs2_data
  );
  
  //array for all the registers x1 to x31 
  logic [31:0] regs [32];
  
  always_ff @(posedge clk or negedge rst_n) begin
  
  if (!rst_n) begin
    for (int i = 0; i <32; i++) begin
      regs[i] <= 0;
    end
  
  end
  
  else if( we && rd_addr != 5'b0) begin
    regs[rd_addr] <= write_data;
  end
  
  end 
  
  assign rs1_data = (rs1_addr == 5'd0) ? 32'd0 : regs[rs1_addr];
  assign rs2_data = (rs2_addr == 5'd0) ? 32'd0 : regs[rs2_addr]; 
endmodule 
  
  
  
  
  