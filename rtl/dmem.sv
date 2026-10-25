module dmem
  import rv32i_pkg::*;
#(
  parameter int DEPTH = 1024
)(
  input  logic        clk,
  input  logic        mem_write,
  input  logic [2:0]  funct3,
  input  logic [31:0] addr,
  input  logic [31:0] wdata,
  output logic [31:0] rdata
);

  localparam int AW = $clog2(DEPTH);

  logic [31:0]   mem [DEPTH];
  logic [AW-1:0] word_idx;
  logic [1:0]    byte_off;

  assign word_idx = addr[AW+1:2];
  assign byte_off = addr[1:0];

  initial begin
    for (int i = 0; i < DEPTH; i++) mem[i] = '0;
  end

  logic [3:0]  be;
  logic [31:0] wdata_lanes;

  always_comb begin
    case (funct3)
      F3_SB: begin
        be          = 4'b0001 << byte_off;
        wdata_lanes = {4{wdata[7:0]}};
      end
      F3_SH: begin
        be          = byte_off[1] ? 4'b1100 : 4'b0011;
        wdata_lanes = {2{wdata[15:0]}};
      end
      default: begin
        be          = 4'b1111;
        wdata_lanes = wdata;
      end
    endcase
  end

  always @(posedge clk) begin
    if (mem_write) begin
      for (int i = 0; i < 4; i++)
        if (be[i]) mem[word_idx][8*i +: 8] <= wdata_lanes[8*i +: 8];
    end
  end

  logic [31:0] word;
  logic [7:0]  rbyte;
  logic [15:0] rhalf;

  assign word  = mem[word_idx];
  assign rbyte = word[8*byte_off +: 8];
  assign rhalf = byte_off[1] ? word[31:16] : word[15:0];

  always_comb begin
    case (funct3)
      F3_LB:   rdata = {{24{rbyte[7]}},  rbyte};
      F3_LH:   rdata = {{16{rhalf[15]}}, rhalf};
      F3_LBU:  rdata = {24'b0, rbyte};
      F3_LHU:  rdata = {16'b0, rhalf};
      default: rdata = word;
    endcase
  end

endmodule