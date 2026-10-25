module imem #(
  parameter int    DEPTH    = 1024,             
  parameter string HEX_FILE = "sw/test.hex"     
)(
  input  logic [31:0] addr,                     
  output logic [31:0] instr                     
);

  localparam int AW = $clog2(DEPTH);            // index bits

  logic [31:0] mem [DEPTH];

  initial begin
    for (int i = 0; i < DEPTH; i++) mem[i] = 32'h0000_0013;  // NOPs
    $readmemh(HEX_FILE, mem);                               
  end


  assign instr = mem[addr[AW+1:2]];

endmodule