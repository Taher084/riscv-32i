module reg_file
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
  output logic [31:0] rs2_data,
  );
  
  
  
  
  