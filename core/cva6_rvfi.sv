// Copyright 2024 Thales DIS France SAS
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
// You may obtain a copy of the License at https://solderpad.org/licenses/
//
// Original Author: Yannick Casamatta - Thales
// Date: 09/01/2024


module cva6_rvfi
  import ariane_pkg::*;
#(
    parameter config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty,
    parameter type rvfi_instr_t = logic,
    parameter type rvfi_csr_t = logic,
    parameter type rvfi_probes_instr_t = logic,
    parameter type rvfi_probes_csr_t = logic,
    parameter type rvfi_probes_t = logic

) (

    input logic clk_i,
    input logic rst_ni,

    input rvfi_probes_t rvfi_probes_i,
    output rvfi_instr_t [CVA6Cfg.NrCommitPorts-1:0] rvfi_instr_o,
    output rvfi_csr_t rvfi_csr_o


);

  localparam logic [CVA6Cfg.XLEN-1:0] IsaCode = 
    (CVA6Cfg.XLEN'(CVA6Cfg.RVA) << 0)   // A - Atomic Instructions extension
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVB) << 1)  // C - Bitmanip extension
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVC) << 2)  // C - Compressed extension
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVD) << 3)  // D - Double precision floating-point extension
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVF) << 5)  // F - Single precision floating-point extension
  | (CVA6Cfg.XLEN'(1) << 8)  // I - RV32I/64I/128I base ISA
  | (CVA6Cfg.XLEN'(1) << 12)  // M - Integer Multiply/Divide extension
  | (CVA6Cfg.XLEN'(0) << 13)  // N - User level interrupts supported
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVS) << 18)  // S - Supervisor mode implemented
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVU) << 20)  // U - User mode implemented
  | (CVA6Cfg.XLEN'(CVA6Cfg.RVV) << 21)  // V - Vector extension
  | (CVA6Cfg.XLEN'(CVA6Cfg.NSX) << 23)  // X - Non-standard extensions present
  | ((CVA6Cfg.XLEN == 64 ? 2 : 1) << CVA6Cfg.XLEN - 2);  // MXL

  localparam logic [CVA6Cfg.XLEN-1:0] hart_id_i = '0;

  localparam logic [63:0] SMODE_STATUS_READ_MASK = ariane_pkg::smode_status_read_mask(CVA6Cfg);

  logic flush;
  logic issue_instr_ack;
  logic fetch_entry_valid;
  logic [31:0] instruction;
  logic is_compressed;

  logic [CVA6Cfg.TRANS_ID_BITS-1:0] issue_pointer;
  logic [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.TRANS_ID_BITS-1:0] commit_pointer;

  logic flush_unissued_instr;
  logic decoded_instr_valid;
  logic decoded_instr_ack;

  logic [CVA6Cfg.XLEN-1:0] rs1_forwarding;
  logic [CVA6Cfg.XLEN-1:0] rs2_forwarding;

  logic [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.VLEN-1:0] commit_instr_pc;
  fu_op [CVA6Cfg.NrCommitPorts-1:0] commit_instr_op;
  logic [CVA6Cfg.NrCommitPorts-1:0][REG_ADDR_SIZE-1:0] commit_instr_rs1;
  logic [CVA6Cfg.NrCommitPorts-1:0][REG_ADDR_SIZE-1:0] commit_instr_rs2;
  logic [CVA6Cfg.NrCommitPorts-1:0][REG_ADDR_SIZE-1:0] commit_instr_rd;
  logic [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.XLEN-1:0] commit_instr_result;
  logic [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.VLEN-1:0] commit_instr_valid;

  logic [CVA6Cfg.XLEN-1:0] ex_commit_cause;
  logic ex_commit_valid;

  riscv::priv_lvl_t priv_lvl;

  logic [CVA6Cfg.VLEN-1:0] lsu_ctrl_vaddr;
  fu_t lsu_ctrl_fu;
  logic [(CVA6Cfg.XLEN/8)-1:0] lsu_ctrl_be;
  logic [CVA6Cfg.TRANS_ID_BITS-1:0] lsu_ctrl_trans_id;

  logic [((CVA6Cfg.CvxifEn || CVA6Cfg.RVV) ? 5 : 4)-1:0][CVA6Cfg.XLEN-1:0] wbdata;
  logic [CVA6Cfg.NrCommitPorts-1:0] commit_ack;
  logic [CVA6Cfg.PLEN-1:0] mem_paddr;
  logic debug_mode;
  logic [CVA6Cfg.NrCommitPorts-1:0][CVA6Cfg.XLEN-1:0] wdata;

  logic [CVA6Cfg.VLEN-1:0] lsu_addr;
  logic [(CVA6Cfg.XLEN/8)-1:0] lsu_rmask;
  logic [(CVA6Cfg.XLEN/8)-1:0] lsu_wmask;
  logic [CVA6Cfg.TRANS_ID_BITS-1:0] lsu_addr_trans_id;

  riscv::pmpcfg_t [15:0] pmpcfg_q, pmpcfg_d;

  rvfi_probes_csr_t   csr;
  rvfi_probes_instr_t instr;

  always_comb begin
    csr   = '0;
    instr = '0;

    if ($bits(rvfi_probes_i.instr) == $bits(instr)) begin
      instr = rvfi_probes_i.instr;
    end

    if ($bits(rvfi_probes_i.csr) == $bits(csr)) begin
      csr = rvfi_probes_i.csr;
    end

  end


  assign flush = instr.flush;
  assign issue_instr_ack = instr.issue_instr_ack;
  assign fetch_entry_valid = instr.fetch_entry_valid;
  assign instruction = instr.instruction;
  assign is_compressed = instr.is_compressed;

  assign issue_pointer = instr.issue_pointer;
  assign commit_pointer = instr.commit_pointer;

  assign flush_unissued_instr = instr.flush_unissued_instr;
  assign decoded_instr_valid = instr.decoded_instr_valid;
  assign decoded_instr_ack = instr.decoded_instr_ack;

  assign rs1_forwarding = instr.rs1_forwarding;
  assign rs2_forwarding = instr.rs2_forwarding;

  assign commit_instr_pc = instr.commit_instr_pc;
  assign commit_instr_op = instr.commit_instr_op;
  assign commit_instr_rs1 = instr.commit_instr_rs1;
  assign commit_instr_rs2 = instr.commit_instr_rs2;
  assign commit_instr_rd = instr.commit_instr_rd;
  assign commit_instr_result = instr.commit_instr_result;
  assign commit_instr_valid = instr.commit_instr_valid;

  assign ex_commit_cause = instr.ex_commit_cause;
  assign ex_commit_valid = instr.ex_commit_valid;

  assign priv_lvl = instr.priv_lvl;

  assign wbdata = instr.wbdata;
  assign commit_ack = instr.commit_ack;
  assign mem_paddr = instr.mem_paddr;
  assign debug_mode = instr.debug_mode;
  assign wdata = instr.wdata;

  assign lsu_addr = instr.lsu_ctrl_vaddr;
  assign lsu_rmask = instr.lsu_ctrl_fu == LOAD ? instr.lsu_ctrl_be : '0;
  assign lsu_wmask = instr.lsu_ctrl_fu == STORE ? instr.lsu_ctrl_be : '0;
  assign lsu_addr_trans_id = instr.lsu_ctrl_trans_id;


  //ID STAGE

  typedef struct packed {
    logic        valid;
    logic [31:0] instr;
  } issue_struct_t;
  issue_struct_t issue_n, issue_q;

  always_comb begin
    issue_n = issue_q;

    if (issue_instr_ack) issue_n.valid = 1'b0;

    if ((!issue_q.valid || issue_instr_ack) && fetch_entry_valid) begin
      issue_n.valid = 1'b1;
      issue_n.instr = (is_compressed) ? {{16{1'b0}}, instruction[15:0]} : instruction;
    end

    if (flush) issue_n.valid = 1'b0;
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      issue_q <= '0;
    end else begin
      issue_q <= issue_n;
    end
  end

  //ISSUE STAGE

  // this is the FIFO struct of the issue queue
  typedef struct packed {
    logic [CVA6Cfg.XLEN-1:0] rs1_rdata;
    logic [CVA6Cfg.XLEN-1:0] rs2_rdata;
    logic [CVA6Cfg.VLEN-1:0] lsu_addr;
    logic [(CVA6Cfg.XLEN/8)-1:0] lsu_rmask;
    logic [(CVA6Cfg.XLEN/8)-1:0] lsu_wmask;
    logic [CVA6Cfg.XLEN-1:0] lsu_wdata;
    logic [31:0] instr;
  } sb_mem_t;
  sb_mem_t [CVA6Cfg.NR_SB_ENTRIES-1:0] mem_q, mem_n;

  always_comb begin : issue_fifo
    mem_n = mem_q;

    if (decoded_instr_valid && decoded_instr_ack && !flush_unissued_instr) begin
      mem_n[issue_pointer] = '{
          rs1_rdata: rs1_forwarding,
          rs2_rdata: rs2_forwarding,
          lsu_addr: '0,
          lsu_rmask: '0,
          lsu_wmask: '0,
          lsu_wdata: '0,
          instr: issue_q.instr
      };
    end

    if (lsu_rmask != 0) begin
      mem_n[lsu_addr_trans_id].lsu_addr  = lsu_addr;
      mem_n[lsu_addr_trans_id].lsu_rmask = lsu_rmask;
    end else if (lsu_wmask != 0) begin
      mem_n[lsu_addr_trans_id].lsu_addr  = lsu_addr;
      mem_n[lsu_addr_trans_id].lsu_wmask = lsu_wmask;
      mem_n[lsu_addr_trans_id].lsu_wdata = wbdata[1];
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : regs
    if (!rst_ni) begin
      mem_q <= '{default: sb_mem_t'(0)};
    end else begin
      mem_q <= mem_n;
    end
  end

  //----------------------------------------------------------------------------------------------------------
  // PACK
  //----------------------------------------------------------------------------------------------------------

  always_comb begin
    for (int i = 0; i < CVA6Cfg.NrCommitPorts; i++) begin
      logic exception;
      exception = commit_instr_valid[i][0] && ex_commit_valid;
      rvfi_instr_o[i].valid    = (commit_ack[i] && !ex_commit_valid) ||
        (exception && (ex_commit_cause == riscv::ENV_CALL_MMODE ||
                  ex_commit_cause == riscv::ENV_CALL_SMODE ||
                  ex_commit_cause == riscv::ENV_CALL_UMODE));
      rvfi_instr_o[i].insn = mem_q[commit_pointer[i]].instr;
      // when trap, the instruction is not executed
      rvfi_instr_o[i].trap = exception;
      rvfi_instr_o[i].cause = ex_commit_cause;
      rvfi_instr_o[i].mode = (CVA6Cfg.DebugEn && debug_mode) ? 2'b10 : priv_lvl;
      rvfi_instr_o[i].ixl = CVA6Cfg.XLEN == 64 ? 2 : 1;
      rvfi_instr_o[i].rs1_addr = commit_instr_rs1[i][4:0];
      rvfi_instr_o[i].rs2_addr = commit_instr_rs2[i][4:0];
      rvfi_instr_o[i].rd_addr = commit_instr_rd[i][4:0];
      rvfi_instr_o[i].rd_wdata = (CVA6Cfg.FpPresent && is_rd_fpr(commit_instr_op[i])) ?
          commit_instr_result[i] : wdata[i];
      rvfi_instr_o[i].pc_rdata = commit_instr_pc[i];
      rvfi_instr_o[i].mem_addr = mem_q[commit_pointer[i]].lsu_addr;
      // So far, only write paddr is reported. TODO: read paddr
      rvfi_instr_o[i].mem_paddr = mem_paddr;
      rvfi_instr_o[i].mem_wmask = mem_q[commit_pointer[i]].lsu_wmask;
      rvfi_instr_o[i].mem_wdata = mem_q[commit_pointer[i]].lsu_wdata;
      rvfi_instr_o[i].mem_rmask = mem_q[commit_pointer[i]].lsu_rmask;
      rvfi_instr_o[i].mem_rdata = commit_instr_result[i];
      rvfi_instr_o[i].rs1_rdata = mem_q[commit_pointer[i]].rs1_rdata;
      rvfi_instr_o[i].rs2_rdata = mem_q[commit_pointer[i]].rs2_rdata;
    end
  end


  //----------------------------------------------------------------------------------------------------------
  // CSR
  //----------------------------------------------------------------------------------------------------------


  always_comb begin

    rvfi_csr_o.fflags = CVA6Cfg.FpPresent ?
    '{
        rdata: {{CVA6Cfg.XLEN - 5{1'b0}}, csr.fcsr_q.fflags},
        wdata: {{CVA6Cfg.XLEN - 5{1'b0}}, csr.fcsr_q.fflags},
        rmask: '1,
        wmask: '1
    }
    : '0;
    rvfi_csr_o.frm = CVA6Cfg.FpPresent ?
    '{
        rdata: {{CVA6Cfg.XLEN - 3{1'b0}}, csr.fcsr_q.frm},
        wdata: {{CVA6Cfg.XLEN - 3{1'b0}}, csr.fcsr_q.frm},
        rmask: '1,
        wmask: '1
    }
    : '0;
    rvfi_csr_o.fcsr = CVA6Cfg.FpPresent ?
    '{
        rdata: {{CVA6Cfg.XLEN - 8{1'b0}}, csr.fcsr_q.frm, csr.fcsr_q.fflags},
        wdata: {{CVA6Cfg.XLEN - 8{1'b0}}, csr.fcsr_q.frm, csr.fcsr_q.fflags},
        rmask: '1,
        wmask: '1
    }
    : '0;
    rvfi_csr_o.ftran = CVA6Cfg.FpPresent ?
    '{
        rdata: {{CVA6Cfg.XLEN - 7{1'b0}}, csr.fcsr_q.fprec},
        wdata: {{CVA6Cfg.XLEN - 7{1'b0}}, csr.fcsr_q.fprec},
        rmask: '1,
        wmask: '1
    }
    : '0;
    rvfi_csr_o.dcsr = CVA6Cfg.DebugEn ?
    '{
        rdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.dcsr_q},
        wdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.dcsr_q},
        rmask: '1,
        wmask: '1
    }
    : '0;
    rvfi_csr_o.dpc = CVA6Cfg.DebugEn ?
    '{rdata: csr.dpc_q, wdata: csr.dpc_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.dscratch0 = CVA6Cfg.DebugEn ?
    '{rdata: csr.dscratch0_q, wdata: csr.dscratch0_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.dscratch1 = CVA6Cfg.DebugEn ?
    '{rdata: csr.dscratch1_q, wdata: csr.dscratch1_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.sstatus = CVA6Cfg.RVS ?
    '{
        rdata: csr.mstatus_extended & SMODE_STATUS_READ_MASK[CVA6Cfg.XLEN-1:0],
        wdata: csr.mstatus_extended & SMODE_STATUS_READ_MASK[CVA6Cfg.XLEN-1:0],
        rmask: '1,
        wmask: '1
    }
    : '0;
    rvfi_csr_o.sie = CVA6Cfg.RVS ?
    '{rdata: csr.mie_q & csr.mideleg_q, wdata: csr.mie_q & csr.mideleg_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.sip = CVA6Cfg.RVS ?
    '{rdata: csr.mip_q & csr.mideleg_q, wdata: csr.mip_q & csr.mideleg_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.stvec = CVA6Cfg.RVS ?
    '{rdata: csr.stvec_q, wdata: csr.stvec_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.scounteren = CVA6Cfg.RVS ?
    '{rdata: csr.scounteren_q, wdata: csr.scounteren_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.sscratch = CVA6Cfg.RVS ?
    '{rdata: csr.sscratch_q, wdata: csr.sscratch_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.sepc = CVA6Cfg.RVS ?
    '{rdata: csr.sepc_q, wdata: csr.sepc_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.scause = CVA6Cfg.RVS ?
    '{rdata: csr.scause_q, wdata: csr.scause_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.stval = CVA6Cfg.RVS ?
    '{rdata: csr.stval_q, wdata: csr.stval_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.satp = CVA6Cfg.RVS ?
    '{rdata: csr.satp_q, wdata: csr.satp_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.mstatus = '{
        rdata: csr.mstatus_extended,
        wdata: csr.mstatus_extended,
        rmask: '1,
        wmask: '1
    };
    rvfi_csr_o.mstatush = CVA6Cfg.XLEN == 32 ?
    '{rdata: '0, wdata: '0, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.misa = '{rdata: IsaCode, wdata: IsaCode, rmask: '1, wmask: '1};
    rvfi_csr_o.medeleg = CVA6Cfg.RVS ?
    '{rdata: csr.medeleg_q, wdata: csr.medeleg_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.mideleg = CVA6Cfg.RVS ?
    '{rdata: csr.mideleg_q, wdata: csr.mideleg_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.mie = '{rdata: csr.mie_q, wdata: csr.mie_q, rmask: '1, wmask: '1};
    rvfi_csr_o.mtvec = '{rdata: csr.mtvec_q, wdata: csr.mtvec_q, rmask: '1, wmask: '1};
    rvfi_csr_o.mcounteren = '{
        rdata: csr.mcounteren_q,
        wdata: csr.mcounteren_q,
        rmask: '1,
        wmask: '1
    };
    rvfi_csr_o.mscratch = '{rdata: csr.mscratch_q, wdata: csr.mscratch_q, rmask: '1, wmask: '1};
    rvfi_csr_o.mepc = '{rdata: csr.mepc_q, wdata: csr.mepc_q, rmask: '1, wmask: '1};
    rvfi_csr_o.mcause = '{rdata: csr.mcause_q, wdata: csr.mcause_q, rmask: '1, wmask: '1};
    rvfi_csr_o.mtval = '{rdata: csr.mtval_q, wdata: csr.mtval_q, rmask: '1, wmask: '1};
    rvfi_csr_o.mip = '{rdata: csr.mip_q, wdata: csr.mip_q, rmask: '1, wmask: '1};
    rvfi_csr_o.menvcfg = '{
        rdata: {{CVA6Cfg.XLEN - 1{1'b0}}, csr.fiom_q},
        wdata: {{CVA6Cfg.XLEN - 1{1'b0}}, csr.fiom_q},
        rmask: '1,
        wmask: '1
    };
    rvfi_csr_o.menvcfgh = CVA6Cfg.XLEN == 32 ?
    '{rdata: '0, wdata: '0, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.mvendorid = '{
        rdata: {{CVA6Cfg.XLEN - 32{1'b0}}, OPENHWGROUP_MVENDORID},
        wdata: {{CVA6Cfg.XLEN - 32{1'b0}}, OPENHWGROUP_MVENDORID},
        rmask: '1,
        wmask: '1
    };
    rvfi_csr_o.marchid = '{
        rdata: {{CVA6Cfg.XLEN - 32{1'b0}}, ARIANE_MARCHID},
        wdata: {{CVA6Cfg.XLEN - 32{1'b0}}, ARIANE_MARCHID},
        rmask: '1,
        wmask: '1
    };

    rvfi_csr_o.mhartid = '{rdata: hart_id_i, wdata: hart_id_i, rmask: '1, wmask: '1};
    rvfi_csr_o.mcountinhibit = '{
        rdata: {{(CVA6Cfg.XLEN - (MHPMCounterNum + 3)) {1'b0}}, csr.mcountinhibit_q},
        wdata: {{(CVA6Cfg.XLEN - (MHPMCounterNum + 3)) {1'b0}}, csr.mcountinhibit_q},
        rmask: '1,
        wmask: '1
    };
    rvfi_csr_o.mcycle = '{
        rdata: csr.cycle_q[CVA6Cfg.XLEN-1:0],
        wdata: csr.cycle_q[CVA6Cfg.XLEN-1:0],
        rmask: '1,
        wmask: '1
    };
    rvfi_csr_o.mcycleh = CVA6Cfg.XLEN == 32 ?
    '{
        rdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.cycle_q[63:32]},
        wdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.cycle_q[63:32]},
        rmask: '1,
        wmask: '1
    }
    : '0;
    rvfi_csr_o.minstret = '{
        rdata: csr.instret_q[CVA6Cfg.XLEN-1:0],
        wdata: csr.instret_q[CVA6Cfg.XLEN-1:0],
        rmask: '1,
        wmask: '1
    };
    rvfi_csr_o.minstreth = CVA6Cfg.XLEN == 32 ?
    '{
        rdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.instret_q[63:32]},
        wdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.instret_q[63:32]},
        rmask: '1,
        wmask: '1
    }
    : '0;
    rvfi_csr_o.cycle = '{
        rdata: csr.cycle_q[CVA6Cfg.XLEN-1:0],
        wdata: csr.cycle_q[CVA6Cfg.XLEN-1:0],
        rmask: '1,
        wmask: '1
    };
    rvfi_csr_o.cycleh = CVA6Cfg.XLEN == 32 ?
    '{
        rdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.cycle_q[63:32]},
        wdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.cycle_q[63:32]},
        rmask: '1,
        wmask: '1
    }
    : '0;
    rvfi_csr_o.instret = '{
        rdata: csr.instret_q[CVA6Cfg.XLEN-1:0],
        wdata: csr.instret_q[CVA6Cfg.XLEN-1:0],
        rmask: '1,
        wmask: '1
    };
    rvfi_csr_o.instreth = CVA6Cfg.XLEN == 32 ?
    '{
        rdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.instret_q[63:32]},
        wdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.instret_q[63:32]},
        rmask: '1,
        wmask: '1
    }
    : '0;
    rvfi_csr_o.dcache = '{rdata: csr.dcache_q, wdata: csr.dcache_q, rmask: '1, wmask: '1};
    rvfi_csr_o.icache = '{rdata: csr.icache_q, wdata: csr.icache_q, rmask: '1, wmask: '1};
    rvfi_csr_o.acc_cons = CVA6Cfg.EnableAccelerator ?
    '{rdata: csr.acc_cons_q, wdata: csr.acc_cons_q, rmask: '1, wmask: '1}
    : '0;
    rvfi_csr_o.pmpcfg0 = '{
        rdata: csr.pmpcfg_q[CVA6Cfg.XLEN/8-1:0],
        wdata: csr.pmpcfg_q[CVA6Cfg.XLEN/8-1:0],
        rmask: '1,
        wmask: '1
    };
    rvfi_csr_o.pmpcfg1 = CVA6Cfg.XLEN == 32 ?
    '{
        rdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.pmpcfg_q[7:4]},
        wdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.pmpcfg_q[7:4]},
        rmask: '1,
        wmask: '1
    }
    : '0;
    rvfi_csr_o.pmpcfg2 = '{
        rdata: csr.pmpcfg_q[8+:CVA6Cfg.XLEN/8],
        wdata: csr.pmpcfg_q[8+:CVA6Cfg.XLEN/8],
        rmask: '1,
        wmask: '1
    };
    rvfi_csr_o.pmpcfg3 = CVA6Cfg.XLEN == 32 ?
    '{
        rdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.pmpcfg_q[15:12]},
        wdata: {{CVA6Cfg.XLEN - 32{1'b0}}, csr.pmpcfg_q[15:12]},
        rmask: '1,
        wmask: '1
    }
    : '0;

    for (int i = 0; i < 16; i++) begin
      rvfi_csr_o.pmpaddr[i] = '{
          rdata:
          csr.pmpcfg_q[i].addr_mode[1]
          == 1'b1 ?
          {{CVA6Cfg.XLEN - (CVA6Cfg.PLEN - 2) {1'b0}}, csr.pmpaddr_q[i][CVA6Cfg.PLEN-3:0]}
          : {
          {CVA6Cfg.XLEN - (CVA6Cfg.PLEN - 2) {1'b0}}
          ,
          csr.pmpaddr_q[i][CVA6Cfg.PLEN-3:1]
          ,
          1'b0
          },
          wdata:
          csr.pmpcfg_q[i].addr_mode[1]
          == 1'b1 ?
          {{CVA6Cfg.XLEN - (CVA6Cfg.PLEN - 2) {1'b0}}, csr.pmpaddr_q[i][CVA6Cfg.PLEN-3:0]}
          : {
          {CVA6Cfg.XLEN - (CVA6Cfg.PLEN - 2) {1'b0}}
          ,
          csr.pmpaddr_q[i][CVA6Cfg.PLEN-3:1]
          ,
          1'b0
          },
          rmask: '1,
          wmask: '1
      };
    end
    ;

  end


endmodule
