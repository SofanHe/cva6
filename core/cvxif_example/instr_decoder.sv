// Copyright 2021 Thales DIS design services SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Original Author: Guillaume Chauvon (guillaume.chauvon@thalesgroup.com)

module instr_decoder
  import cvxif_pkg::*;
#(
    parameter int                                 NbInstr                  = 1,
    parameter int                                 EnableCustomVec          = 0,
    parameter cvxif_instr_pkg::copro_issue_resp_t CoproInstr     [NbInstr] = {0}
) (
    input  logic                                  clk_i,
    input  logic                                  req_valid_i,
    input  x_issue_req_t                          x_issue_req_i,
    output x_issue_resp_t                         x_issue_resp_o,
    output cvxif_instr_pkg::custom_vec_op_e       instr_op_o,
    output cvxif_instr_pkg::vlen_t          [2:0] vlen_o
);

  logic [NbInstr-1:0] sel;

  for (genvar i = 0; i < NbInstr; i++) begin : gen_predecoder_selector
    assign sel[i] = ((CoproInstr[i].mask & x_issue_req_i.instr) == CoproInstr[i].instr) & req_valid_i & (EnableCustomVec == 1);
  end

  always_comb begin
    x_issue_resp_o.accept    = '0;
    x_issue_resp_o.writeback = '0;
    x_issue_resp_o.dualwrite = '0;
    x_issue_resp_o.dualread  = '0;
    x_issue_resp_o.loadstore = '0;
    x_issue_resp_o.exc       = '0;
    instr_op_o               = cvxif_instr_pkg::MV_V_X;
    vlen_o                   = '0;
    for (int unsigned i = 0; i < NbInstr; i++) begin
      if (sel[i]) begin
        x_issue_resp_o.accept    = CoproInstr[i].resp.accept;
        x_issue_resp_o.writeback = CoproInstr[i].resp.writeback;
        x_issue_resp_o.dualwrite = CoproInstr[i].resp.dualwrite;
        x_issue_resp_o.dualread  = CoproInstr[i].resp.dualread;
        x_issue_resp_o.loadstore = CoproInstr[i].resp.loadstore;
        x_issue_resp_o.exc       = CoproInstr[i].resp.exc;
        instr_op_o               = CoproInstr[i].op;
        vlen_o[0]                = CoproInstr[i].vlen_in1;
        vlen_o[1]                = CoproInstr[i].vlen_in2;
        vlen_o[2]                = CoproInstr[i].vlen_out;
      end
    end
  end

  assert property (@(posedge clk_i) $onehot0(sel))
  else $warning("This offloaded instruction is valid for multiple coprocessor instructions !");

endmodule
