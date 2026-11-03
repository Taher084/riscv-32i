module tb_imm_gen;
  import rv32i_pkg::*;

  // Signals connected to the DUT
  logic [31:0] instr;
  imm_type_e   imm_type;
  logic [31:0] imm_val;

  int tests  = 0;
  int errors = 0;

  imm_gen dut (
    .instr    (instr),
    .imm_type (imm_type),
    .imm_val  (imm_val)
  );

  // Drive one case, wait, compare, and record the result
  task automatic check(
    input string       name,
    input logic [31:0] test_instr,
    input imm_type_e   test_type,
    input logic [31:0] expected
  );
    instr    = test_instr;
    imm_type = test_type;
    #1;
    tests++;

    if (imm_val !== expected) begin
      errors++;
      $display("FAIL %s: instr=%h expected=%h got=%h",
               name, test_instr, expected, imm_val);
    end else begin
      $display("PASS %s", name);
    end
  endtask

  initial begin
    // I-format
    check("I zero",          32'h00000093, IMM_I, 32'h00000000); // addi x1, x0, 0
    check("I small +5",      32'h00500093, IMM_I, 32'h00000005); // addi x1, x0, 5
    check("I mixed +1365",   32'h55500093, IMM_I, 32'h00000555); // addi x1, x0, 1365
    check("I mixed -1366",   32'hAAA00093, IMM_I, 32'hFFFFFAAA); // addi x1, x0, -1366
    check("I max +2047",     32'h7FF00093, IMM_I, 32'h000007FF); // addi x1, x0, 2047
    check("I min -2048",     32'h80000093, IMM_I, 32'hFFFFF800); // addi x1, x0, -2048
    check("I -1",            32'hFFF00093, IMM_I, 32'hFFFFFFFF); // addi x1, x0, -1
    check("I no field leak", 32'h000FFF93, IMM_I, 32'h00000000); // andi x31, x31, 0

    // s type
    check("S zero",          32'h00000093, IMM_S, 32'h00000000); 
    check("S small +5",      32'h00500093, IMM_S, 32'h00000005); 
    check("S mixed +1365",   32'h55500093, IMM_S, 32'h00000555); 
    check("S mixed -1366",   32'hAAA00093, IMM_S, 32'hFFFFFAAA); 
    check("S max +2047",     32'h7FF00093, IMM_S, 32'h000007FF); 
    check("S min -2048",     32'h80000093, IMM_S, 32'hFFFFF800); 
    check("S -1",            32'hFFF00093, IMM_S, 32'hFFFFFFFF); 
    check("S no field leak", 32'h000FFF93, IMM_S, 32'h00000000); 

    
   // B-format
    check("B zero",          32'h00208063, IMM_B, 32'h00000000); // beq x1, x2, 0
    check("B small +12",     32'h00208663, IMM_B, 32'h0000000C); // beq x1, x2, 12
    check("B small -12",     32'hFE208AE3, IMM_B, 32'hFFFFFFF4); // beq x1, x2, -12
    check("B max +4094",     32'h7E208FE3, IMM_B, 32'h00000FFE); // beq x1, x2, 4094
    check("B min -4096",     32'h80208063, IMM_B, 32'hFFFFF000); // beq x1, x2, -4096
    check("B imm[11] +2048", 32'h002080E3, IMM_B, 32'h00000800); // beq x1, x2, 2048
    check("B mixed +2730",   32'h2A2085E3, IMM_B, 32'h00000AAA); // beq x1, x2, 2730
    check("B mixed +1364",   32'h54208A63, IMM_B, 32'h00000554); // beq x1, x2, 1364
    check("B mixed -1366",   32'hAA2085E3, IMM_B, 32'hFFFFFAAA); // beq x1, x2, -1366
    check("B all ones -2",   32'hFE208FE3, IMM_B, 32'hFFFFFFFE); // beq x1, x2, -2
    check("B no field leak", 32'h01FFF063, IMM_B, 32'h00000000); // bgeu x31, x31, 0

        // J-format
    check("J zero",            32'h000000EF, IMM_J, 32'h00000000); // jal x1, 0
    check("J small +16",       32'h010000EF, IMM_J, 32'h00000010); // jal x1, 16
    check("J small -4",        32'hFFDFF0EF, IMM_J, 32'hFFFFFFFC); // jal x1, -4
    check("J max +1048574",    32'h7FFFF0EF, IMM_J, 32'h000FFFFE); // jal x1, 1048574
    check("J min -1048576",    32'h800000EF, IMM_J, 32'hFFF00000); // jal x1, -1048576
    check("J imm[11] +2048",   32'h0010016F, IMM_J, 32'h00000800); // jal x2, 2048
    check("J imm[12] +4096",   32'h000010EF, IMM_J, 32'h00001000); // jal x1, 4096
    check("J mixed +699050",   32'h2ABAA0EF, IMM_J, 32'h000AAAAA); // jal x1, 699050
    check("J mixed +349524",   32'h554550EF, IMM_J, 32'h00055554); // jal x1, 349524
    check("J mixed -349526",   32'hAABAA0EF, IMM_J, 32'hFFFAAAAA); // jal x1, -349526
    check("J all ones -2",     32'hFFFFF0EF, IMM_J, 32'hFFFFFFFE); // jal x1, -2
    check("J no field leak",   32'h00000FEF, IMM_J, 32'h00000000); // jal x31, 0

        // U-format
    check("U zero",          32'h000002B7, IMM_U, 32'h00000000); // lui x5, 0
    check("U pattern",       32'h123452B7, IMM_U, 32'h12345000); // lui x5, 0x12345
    check("U top bit only",  32'h800002B7, IMM_U, 32'h80000000); // lui x5, 0x80000
    check("U all ones",      32'hFFFFF2B7, IMM_U, 32'hFFFFF000); // lui x5, 0xFFFFF
    check("U mixed A",       32'hAAAAA2B7, IMM_U, 32'hAAAAA000); // lui x5, 0xAAAAA
    check("U mixed 5",       32'h555552B7, IMM_U, 32'h55555000); // lui x5, 0x55555
    check("U no field leak", 32'h00000FB7, IMM_U, 32'h00000000); // lui x31, 0

    // Unused imm_type must take the default branch
    check("default type",    32'hFFFFFFFF, imm_type_e'(3'd7), 32'h00000000);
    if (errors == 0) $display("ALL %0d TESTS PASSED", tests);
    else             $display("%0d of %0d TESTS FAILED", errors, tests);
    $finish;
  end
endmodule