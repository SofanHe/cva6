module custom_inst_cva6_with_reg_warp (
    input  clk_i,
    input  rst_ni,

    input   [31:0] src_width,
    input   [31:0] src_height,
    input   [31:0] src_offset_addr,
    input   [31:0] src_image_size,
    input   [31:0] dst_width,
    input   [31:0] dst_height,
    input   [31:0] dst_offset_addr,
    input   [31:0] dst_image_size,
    input          start,
    output         idle,
    output  [31:0] exit_code,

    // IdWidthSlave = 4
    // AddrWidth = 64
    // DataWidth = 64
    // ref to core/include/rv64imc_config_pkg

    output  [           4-1:0] m_axi_arid,
    output  [          64-1:0] m_axi_araddr,
    output  [             7:0] m_axi_arlen,
    output  [             2:0] m_axi_arsize,
    output  [             1:0] m_axi_arburst,
    output                     m_axi_arvalid,
    input                      m_axi_arready,
    // R channel
    input   [           4-1:0] m_axi_rid,
    input   [          64-1:0] m_axi_rdata,
    input                      m_axi_rlast,
    input   [             1:0] m_axi_rresp,
    input                      m_axi_rvalid,
    output                     m_axi_rready,
    // AW channel
    output  [           4-1:0] m_axi_awid,
    output  [          64-1:0] m_axi_awaddr,
    output  [             7:0] m_axi_awlen,
    output  [             2:0] m_axi_awsize,
    output  [             1:0] m_axi_awburst,
    output                     m_axi_awvalid,
    input                      m_axi_awready,
    // W channel
    output  [        64/8-1:0] m_axi_wstrb,
    output  [          64-1:0] m_axi_wdata,
    output                     m_axi_wlast,
    output                     m_axi_wvalid,
    input                      m_axi_wready,
    // B channel
    input   [           4-1:0] m_axi_bid,
    input   [             1:0] m_axi_bresp,
    input                      m_axi_bvalid,
    output                     m_axi_bready
);


  custom_inst_cva6_with_reg cva6 (
    .clk_i  (clk_i ),
    .rst_ni (rst_ni),

    .src_width       (src_width      ),
    .src_height      (src_height     ),
    .src_offset_addr (src_offset_addr),
    .src_image_size  (src_image_size ),
    .dst_width       (dst_width      ),
    .dst_height      (dst_height     ),
    .dst_offset_addr (dst_offset_addr),
    .dst_image_size  (dst_image_size ),
    .start           (start          ),
    .idle            (idle           ),
    .exit            (exit_code      ),

    .m_axi_arid    (m_axi_arid   ),
    .m_axi_araddr  (m_axi_araddr ),
    .m_axi_arlen   (m_axi_arlen  ),
    .m_axi_arsize  (m_axi_arsize ),
    .m_axi_arburst (m_axi_arburst),
    .m_axi_arvalid (m_axi_arvalid),
    .m_axi_arready (m_axi_arready),
    // R channel
    .m_axi_rid    (m_axi_rid   ),
    .m_axi_rdata  (m_axi_rdata ),
    .m_axi_rlast  (m_axi_rlast ),
    .m_axi_rresp  (m_axi_rresp ),
    .m_axi_rvalid (m_axi_rvalid),
    .m_axi_rready (m_axi_rready),
    // AW channel
    .m_axi_awid    (m_axi_awid   ),
    .m_axi_awaddr  (m_axi_awaddr ),
    .m_axi_awlen   (m_axi_awlen  ),
    .m_axi_awsize  (m_axi_awsize ),
    .m_axi_awburst (m_axi_awburst),
    .m_axi_awvalid (m_axi_awvalid),
    .m_axi_awready (m_axi_awready),
    // W channel
    .m_axi_wstrb  (m_axi_wstrb ),
    .m_axi_wdata  (m_axi_wdata ),
    .m_axi_wlast  (m_axi_wlast ),
    .m_axi_wvalid (m_axi_wvalid),
    .m_axi_wready (m_axi_wready),
    // B channel
    .m_axi_bid    (m_axi_bid   ),
    .m_axi_bresp  (m_axi_bresp ),
    .m_axi_bvalid (m_axi_bvalid),
    .m_axi_bready (m_axi_bready)
  );


endmodule