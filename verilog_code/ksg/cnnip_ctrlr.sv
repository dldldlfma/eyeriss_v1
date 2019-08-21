/*
 *  cnnip_ctrlr.sv -- CNN IP controller
 *  ETRI <SW-SoC AI Deep Learning HW Accelerator RTL Design> course material
 *
 *  first draft by Junyoung Park
 */

module cnnip_ctrlr
(
  // clock and reset signals from domain a
  input wire clk_a,
  input wire arstz_aq,

  // internal memories
  cnnip_mem_if.master to_input_mem,
  cnnip_mem_if.master to_weight_mem,
  cnnip_mem_if.master to_feature_mem,

  // configuration registers
  input wire         CMD_START,
  input wire   [7:0] MODE_KERNEL_SIZE,
  input wire   [7:0] MODE_KERNEL_NUMS,
  input wire   [1:0] MODE_STRIDE,
  input wire         MODE_PADDING,

  output wire        CMD_DONE,
  output wire        CMD_DONE_VALID

);

  // sample FSM
  enum { IDLE, WAIT, DONE } state_aq, state_next;

  // internal registers
  reg [15:0] cnt_aq;

  always @(posedge clk_a, negedge arstz_aq)
    if (arstz_aq == 1'b0) cnt_aq <= 16'b0;
    else if (state_aq == WAIT) cnt_aq <= cnt_aq + 1'b1;
    else cnt_aq <= 16'b0;

  // use wires as shortcuts
  wire wait_done = (cnt_aq == 16'b1000_1111_0000_0000);

  // state transition
  always @(posedge clk_a, negedge arstz_aq)
    if (arstz_aq == 1'b0) state_aq <= IDLE;
    else state_aq <= state_next;

  // state transition condition
  always @(*)
  begin
    state_next = state_aq;
    case (state_aq)
      IDLE:
        if (CMD_START) state_next = WAIT;

      WAIT:
        if (wait_done) state_next = DONE;

      DONE:
        state_next = IDLE;
    endcase
  end

  // output signals
  assign CMD_DONE = (state_aq == DONE);
  assign CMD_DONE_VALID = (state_aq == DONE);

  // control signals
  assign to_input_mem.en   = 0;
  assign to_input_mem.we   = 'b0;
  assign to_input_mem.addr = 'b0;
  assign to_input_mem.din  = 'b0;

  assign to_weight_mem.en   = 0;
  assign to_weight_mem.we   = 'b0;
  assign to_weight_mem.addr = 'b0;
  assign to_weight_mem.din  = 'b0;

  assign to_feature_mem.en   = 0;
  assign to_feature_mem.we   = 'b0;
  assign to_feature_mem.addr = 'b0;
  assign to_feature_mem.din  = 'b0;

endmodule // cnnip_ctrlr
