/// mv.xv a0, v0.0
/// mv.xv a1, v0.1
/// mv.xv a2, v1.0
/// mv.xv a3, v1.1

// v0 is rs1, v1 is rs2
/// nv2cag v2, v0, v1

/// mv.vx v2.0, a0
/// mv.vx v2.1, a1
/// mv.vx v2.2, a2

  .globl main
main:
  li a0, 0x0011223344556677;
  li a1, 0x8899AABBCCDDEEFF;

  li a2, 0x0022446688AACCEE;
  li a3, 0x1133557799BBDDFF;
  # Generated by parser_helper.py
  .word 0b00000000000001010001000000001011
  .word 0b00000000000101011001000000001011
  .word 0b00000000000001100001000010001011
  .word 0b00000000000101101001000010001011
  .word 0b00000100000100000000000100001011
  .word 0b00000000000000010000010100001011
  .word 0b00000000000100010000010110001011
  .word 0b00000000001000010000011000001011
  // YUV: 0x663388aa55ccee77, 0xddddffff00221144, 0x1133995577bb99bb
  li a4, 0x663388aa55ccee77;
  li a5, 0xddddffff00221144;
  li a6, 0x1133995577bb99bb;

  xor a0, a0, a4;
  bnez a0, fail;
  xor a1, a1, a5;
  bnez a1, fail;
  xor a2, a2, a6;
  bnez a2, fail;
  j pass;

fail:
  # Failure post-processing (messages, ecall setup etc.)
  li a0, 0x1;
  jal exit;

pass:
  # Success post-processing (messages, ecall setup etc.)
  li a0, 0x0;
  jal exit;