// ==============================================================
// Generated by Vitis HLS v2023.2
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// ==============================================================

`timescale 1 ns / 1 ps 

module t64_nv12toCAG444_k8_t64_nv12toCAG444_k8_Pipeline_VITIS_LOOP_17_1 (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        UVin128,
        Yin128,
        YUVout192_out,
        YUVout192_out_ap_vld
);

parameter    ap_ST_fsm_pp0_stage0 = 1'd1;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [127:0] UVin128;
input  [127:0] Yin128;
output  [191:0] YUVout192_out;
output   YUVout192_out_ap_vld;

reg ap_idle;
reg YUVout192_out_ap_vld;

(* fsm_encoding = "none" *) reg   [0:0] ap_CS_fsm;
wire    ap_CS_fsm_pp0_stage0;
wire    ap_enable_reg_pp0_iter0;
reg    ap_enable_reg_pp0_iter1;
reg    ap_idle_pp0;
wire    ap_block_pp0_stage0_subdone;
wire   [0:0] icmp_ln17_fu_118_p2;
reg    ap_condition_exit_pp0_iter1_stage0;
wire    ap_loop_exit_ready;
reg    ap_ready_int;
reg   [127:0] Yin128_1_fu_60;
wire   [127:0] zext_ln19_fu_153_p1;
wire    ap_block_pp0_stage0_11001;
wire    ap_loop_init;
wire    ap_block_pp0_stage0;
reg   [127:0] UVin128_1_fu_64;
wire   [127:0] zext_ln23_fu_181_p1;
reg   [191:0] YUVout192_fu_68;
wire   [191:0] YUVout192_1_fu_297_p2;
reg   [3:0] i_fu_72;
wire   [3:0] i_2_fu_124_p2;
wire    ap_block_pp0_stage0_01001;
wire   [111:0] Yin128_2_fu_143_p4;
wire   [111:0] UVin128_2_fu_171_p4;
wire   [7:0] y_fu_139_p1;
wire   [2:0] trunc_ln25_fu_189_p1;
wire   [7:0] shl_ln25_1_fu_193_p3;
wire   [5:0] shl_ln25_2_fu_205_p3;
wire   [8:0] zext_ln25_1_fu_201_p1;
wire   [8:0] zext_ln25_2_fu_213_p1;
wire  signed [8:0] sub_ln25_fu_217_p2;
wire  signed [31:0] sext_ln25_fu_223_p1;
wire   [191:0] zext_ln25_fu_185_p1;
wire   [191:0] zext_ln25_3_fu_227_p1;
wire   [7:0] u_fu_157_p1;
wire   [8:0] add_ln26_fu_241_p2;
wire  signed [31:0] sext_ln26_fu_247_p1;
wire   [191:0] zext_ln26_fu_237_p1;
wire   [191:0] zext_ln26_1_fu_251_p1;
wire   [7:0] UVin128_4_fu_161_p4;
wire   [8:0] add_ln27_fu_265_p2;
wire  signed [31:0] sext_ln27_fu_271_p1;
wire   [191:0] zext_ln27_fu_261_p1;
wire   [191:0] zext_ln27_1_fu_275_p1;
wire   [191:0] shl_ln25_fu_231_p2;
wire   [191:0] shl_ln27_fu_279_p2;
wire   [191:0] or_ln27_fu_285_p2;
wire   [191:0] shl_ln26_fu_255_p2;
wire   [191:0] or_ln27_1_fu_291_p2;
reg    ap_done_reg;
wire    ap_continue_int;
reg    ap_done_int;
reg   [0:0] ap_NS_fsm;
wire    ap_enable_pp0;
wire    ap_start_int;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 1'd1;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
#0 Yin128_1_fu_60 = 128'd0;
#0 UVin128_1_fu_64 = 128'd0;
#0 YUVout192_fu_68 = 192'd0;
#0 i_fu_72 = 4'd0;
#0 ap_done_reg = 1'b0;
end

t64_nv12toCAG444_k8_flow_control_loop_pipe_sequential_init flow_control_loop_pipe_sequential_init_U(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(ap_start),
    .ap_ready(ap_ready),
    .ap_done(ap_done),
    .ap_start_int(ap_start_int),
    .ap_loop_init(ap_loop_init),
    .ap_ready_int(ap_ready_int),
    .ap_loop_exit_ready(ap_condition_exit_pp0_iter1_stage0),
    .ap_loop_exit_done(ap_done_int),
    .ap_continue_int(ap_continue_int),
    .ap_done_int(ap_done_int)
);

always @ (posedge ap_rst or posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_pp0_stage0;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_rst or posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_done_reg <= 1'b0;
    end else begin
        if ((ap_continue_int == 1'b1)) begin
            ap_done_reg <= 1'b0;
        end else if (((ap_loop_exit_ready == 1'b1) & (1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_rst or posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter1 <= 1'b0;
    end else begin
        if ((1'b1 == ap_condition_exit_pp0_iter1_stage0)) begin
            ap_enable_reg_pp0_iter1 <= 1'b0;
        end else if (((1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
            ap_enable_reg_pp0_iter1 <= ap_start_int;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        if ((ap_loop_init == 1'b1)) begin
            UVin128_1_fu_64 <= UVin128;
        end else if (((icmp_ln17_fu_118_p2 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1))) begin
            UVin128_1_fu_64 <= zext_ln23_fu_181_p1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        if ((ap_loop_init == 1'b1)) begin
            YUVout192_fu_68 <= 192'd0;
        end else if (((icmp_ln17_fu_118_p2 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1))) begin
            YUVout192_fu_68 <= YUVout192_1_fu_297_p2;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        if ((ap_loop_init == 1'b1)) begin
            Yin128_1_fu_60 <= Yin128;
        end else if (((icmp_ln17_fu_118_p2 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1))) begin
            Yin128_1_fu_60 <= zext_ln19_fu_153_p1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        if ((ap_loop_init == 1'b1)) begin
            i_fu_72 <= 4'd0;
        end else if (((icmp_ln17_fu_118_p2 == 1'd0) & (ap_enable_reg_pp0_iter1 == 1'b1))) begin
            i_fu_72 <= i_2_fu_124_p2;
        end
    end
end

always @ (*) begin
    if (((icmp_ln17_fu_118_p2 == 1'd1) & (1'b0 == ap_block_pp0_stage0_11001) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        YUVout192_out_ap_vld = 1'b1;
    end else begin
        YUVout192_out_ap_vld = 1'b0;
    end
end

always @ (*) begin
    if (((icmp_ln17_fu_118_p2 == 1'd1) & (1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter1 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_condition_exit_pp0_iter1_stage0 = 1'b1;
    end else begin
        ap_condition_exit_pp0_iter1_stage0 = 1'b0;
    end
end

always @ (*) begin
    if (((ap_loop_exit_ready == 1'b1) & (1'b0 == ap_block_pp0_stage0_subdone) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_done_int = 1'b1;
    end else begin
        ap_done_int = ap_done_reg;
    end
end

always @ (*) begin
    if (((ap_idle_pp0 == 1'b1) & (ap_start_int == 1'b0) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((ap_enable_reg_pp0_iter1 == 1'b0) & (ap_enable_reg_pp0_iter0 == 1'b0))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_block_pp0_stage0_subdone) & (ap_enable_reg_pp0_iter0 == 1'b1) & (1'b1 == ap_CS_fsm_pp0_stage0))) begin
        ap_ready_int = 1'b1;
    end else begin
        ap_ready_int = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_pp0_stage0 : begin
            ap_NS_fsm = ap_ST_fsm_pp0_stage0;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign UVin128_2_fu_171_p4 = {{UVin128_1_fu_64[127:16]}};

assign UVin128_4_fu_161_p4 = {{UVin128_1_fu_64[15:8]}};

assign YUVout192_1_fu_297_p2 = (or_ln27_1_fu_291_p2 | YUVout192_fu_68);

assign YUVout192_out = YUVout192_fu_68;

assign Yin128_2_fu_143_p4 = {{Yin128_1_fu_60[127:16]}};

assign add_ln26_fu_241_p2 = ($signed(sub_ln25_fu_217_p2) + $signed(9'd8));

assign add_ln27_fu_265_p2 = ($signed(sub_ln25_fu_217_p2) + $signed(9'd16));

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd0];

assign ap_block_pp0_stage0 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_01001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_11001 = ~(1'b1 == 1'b1);

assign ap_block_pp0_stage0_subdone = ~(1'b1 == 1'b1);

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

assign ap_enable_reg_pp0_iter0 = ap_start_int;

assign ap_loop_exit_ready = ap_condition_exit_pp0_iter1_stage0;

assign i_2_fu_124_p2 = (i_fu_72 + 4'd1);

assign icmp_ln17_fu_118_p2 = ((i_fu_72 == 4'd8) ? 1'b1 : 1'b0);

assign or_ln27_1_fu_291_p2 = (shl_ln26_fu_255_p2 | or_ln27_fu_285_p2);

assign or_ln27_fu_285_p2 = (shl_ln27_fu_279_p2 | shl_ln25_fu_231_p2);

assign sext_ln25_fu_223_p1 = sub_ln25_fu_217_p2;

assign sext_ln26_fu_247_p1 = $signed(add_ln26_fu_241_p2);

assign sext_ln27_fu_271_p1 = $signed(add_ln27_fu_265_p2);

assign shl_ln25_1_fu_193_p3 = {{trunc_ln25_fu_189_p1}, {5'd0}};

assign shl_ln25_2_fu_205_p3 = {{trunc_ln25_fu_189_p1}, {3'd0}};

assign shl_ln25_fu_231_p2 = zext_ln25_fu_185_p1 << zext_ln25_3_fu_227_p1;

assign shl_ln26_fu_255_p2 = zext_ln26_fu_237_p1 << zext_ln26_1_fu_251_p1;

assign shl_ln27_fu_279_p2 = zext_ln27_fu_261_p1 << zext_ln27_1_fu_275_p1;

assign sub_ln25_fu_217_p2 = (zext_ln25_1_fu_201_p1 - zext_ln25_2_fu_213_p1);

assign trunc_ln25_fu_189_p1 = i_fu_72[2:0];

assign u_fu_157_p1 = UVin128_1_fu_64[7:0];

assign y_fu_139_p1 = Yin128_1_fu_60[7:0];

assign zext_ln19_fu_153_p1 = Yin128_2_fu_143_p4;

assign zext_ln23_fu_181_p1 = UVin128_2_fu_171_p4;

assign zext_ln25_1_fu_201_p1 = shl_ln25_1_fu_193_p3;

assign zext_ln25_2_fu_213_p1 = shl_ln25_2_fu_205_p3;

assign zext_ln25_3_fu_227_p1 = $unsigned(sext_ln25_fu_223_p1);

assign zext_ln25_fu_185_p1 = y_fu_139_p1;

assign zext_ln26_1_fu_251_p1 = $unsigned(sext_ln26_fu_247_p1);

assign zext_ln26_fu_237_p1 = u_fu_157_p1;

assign zext_ln27_1_fu_275_p1 = $unsigned(sext_ln27_fu_271_p1);

assign zext_ln27_fu_261_p1 = UVin128_4_fu_161_p4;

endmodule //t64_nv12toCAG444_k8_t64_nv12toCAG444_k8_Pipeline_VITIS_LOOP_17_1
