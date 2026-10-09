package rv32i_pkg;

  // ---------------- sizes ----------------
  localparam int          XLEN     = 32;
  localparam logic [31:0] RESET_PC = 32'h0000_0000;

  // opcodes: bits [6:0] 
  localparam logic [6:0] OP_OP     = 7'b0110011; // R-type
  localparam logic [6:0] OP_OP_IMM = 7'b0010011; // ADDI, SLTI, ...
  localparam logic [6:0] OP_LOAD   = 7'b0000011; // LB, LH, LW, LBU, LHU
  localparam logic [6:0] OP_STORE  = 7'b0100011; // SB, SH, SW
  localparam logic [6:0] OP_BRANCH = 7'b1100011; // BEQ ... BGEU
  localparam logic [6:0] OP_JAL    = 7'b1101111; //jump and link
  localparam logic [6:0] OP_JALR   = 7'b1100111; //jump and link  reg
  localparam logic [6:0] OP_LUI    = 7'b0110111; // Load upper imm
  localparam logic [6:0] OP_AUIPC  = 7'b0010111; //Add Upper Imm TO  pc 

  // funct3 for ALU ops
  localparam logic [2:0] F3_ADD_SUB = 3'b000;      // ADD, SUB, ADDI
  localparam logic [2:0] F3_SLL     = 3'b001;      //shift left logic 
  localparam logic [2:0] F3_SLT     = 3'b010;      // set less than
  localparam logic [2:0] F3_SLTU    = 3'b011;      //set less than (U)
  localparam logic [2:0] F3_XOR     = 3'b100;
  localparam logic [2:0] F3_SRL_SRA = 3'b101;
  localparam logic [2:0] F3_OR      = 3'b110;
  localparam logic [2:0] F3_AND     = 3'b111;

  // funct3 for branches 
  localparam logic [2:0] F3_BEQ  = 3'b000;
  localparam logic [2:0] F3_BNE  = 3'b001;
  localparam logic [2:0] F3_BLT  = 3'b100;
  localparam logic [2:0] F3_BGE  = 3'b101;
  localparam logic [2:0] F3_BLTU = 3'b110;
  localparam logic [2:0] F3_BGEU = 3'b111;

  // funct3 for loads 
  localparam logic [2:0] F3_LB  = 3'b000;
  localparam logic [2:0] F3_LH  = 3'b001;
  localparam logic [2:0] F3_LW  = 3'b010;
  localparam logic [2:0] F3_LBU = 3'b100;
  localparam logic [2:0] F3_LHU = 3'b101;

  // funct3 for stores
  localparam logic [2:0] F3_SB = 3'b000;
  localparam logic [2:0] F3_SH = 3'b001;
  localparam logic [2:0] F3_SW = 3'b010;

  // funct7
  localparam logic [6:0] F7_BASE = 7'b0000000;     // ADD, SRL, SRLI...
  localparam logic [6:0] F7_ALT  = 7'b0100000;     // SUB, SRA, SRAI

  typedef enum logic [3:0] {
    ALU_ADD, ALU_SUB, ALU_SLL, ALU_SLT, ALU_SLTU,
    ALU_XOR, ALU_SRL, ALU_SRA, ALU_OR, ALU_AND,
    ALU_PASS_B                                     // for LUI: result = immediate
  } alu_opr_e;

  // decoder -> immediate generator
  typedef enum logic [2:0] { IMM_I, IMM_S, IMM_B, IMM_U, IMM_J } imm_type_e;

  // execute -> fetch
  typedef enum logic [1:0] { PC_PLUS4, PC_BRANCH, PC_JAL, PC_JALR } pc_sel_e;

  // decoder -> write-back
  typedef enum logic [1:0] { WB_ALU, WB_MEM, WB_PC4 } wb_sel_e;
  
  // decoder -> ALU input muxes
  typedef enum logic { OPA_RS1, OPA_PC  } op_a_sel_e;
  typedef enum logic { OPB_RS2, OPB_IMM } op_b_sel_e;

endpackage