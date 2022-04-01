module WishboneSlavePC(
  input         clock,
  input         reset,
  input         io_wb_stb,
  input         io_wb_cyc,
  input         io_wb_we,
  input  [31:0] io_wb_din,
  input  [31:0] io_wb_addr,
  output        io_wb_ack,
  output [31:0] io_wb_dout,
  output        io_pc_reset,
  output        io_pc_stall,
  output [29:0] io_pc_bootAddr
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg  resetReg; // @[WishboneSlave.scala 28:25]
  reg  stallReg; // @[WishboneSlave.scala 29:25]
  reg [29:0] bootAddrReg; // @[WishboneSlave.scala 30:28]
  wire  _write_T = io_wb_stb & io_wb_cyc; // @[WishboneSlave.scala 36:25]
  wire  _write_T_2 = io_wb_addr == 32'h30000000; // @[WishboneSlave.scala 36:63]
  wire  write = io_wb_stb & io_wb_cyc & io_wb_we & io_wb_addr == 32'h30000000; // @[WishboneSlave.scala 36:48]
  wire  read = _write_T & ~io_wb_we & _write_T_2; // @[WishboneSlave.scala 37:48]
  wire [31:0] _io_wb_dout_T_1 = {bootAddrReg,stallReg,resetReg}; // @[WishboneSlave.scala 46:45]
  wire [31:0] _GEN_0 = read ? _io_wb_dout_T_1 : 32'h0; // @[WishboneSlave.scala 39:14 45:23 46:18]
  wire  _GEN_1 = write ? io_wb_din[0] : resetReg; // @[WishboneSlave.scala 41:16 42:16 28:25]
  wire [31:0] _GEN_4 = write ? 32'h0 : _GEN_0; // @[WishboneSlave.scala 39:14 41:16]
  wire  _GEN_5 = io_wb_ack ? _GEN_1 : resetReg; // @[WishboneSlave.scala 40:18 28:25]
  assign io_wb_ack = io_wb_stb & _write_T_2; // @[WishboneSlave.scala 38:26]
  assign io_wb_dout = io_wb_ack ? _GEN_4 : 32'h0; // @[WishboneSlave.scala 39:14 40:18]
  assign io_pc_reset = resetReg; // @[WishboneSlave.scala 33:15]
  assign io_pc_stall = stallReg; // @[WishboneSlave.scala 34:15]
  assign io_pc_bootAddr = bootAddrReg; // @[WishboneSlave.scala 35:18]
  always @(posedge clock) begin
    resetReg <= reset | _GEN_5; // @[WishboneSlave.scala 28:{25,25}]
    if (reset) begin // @[WishboneSlave.scala 29:25]
      stallReg <= 1'h0; // @[WishboneSlave.scala 29:25]
    end else if (io_wb_ack) begin // @[WishboneSlave.scala 40:18]
      if (write) begin // @[WishboneSlave.scala 41:16]
        stallReg <= io_wb_din[1]; // @[WishboneSlave.scala 43:16]
      end
    end
    if (reset) begin // @[WishboneSlave.scala 30:28]
      bootAddrReg <= 30'h1; // @[WishboneSlave.scala 30:28]
    end else if (io_wb_ack) begin // @[WishboneSlave.scala 40:18]
      if (write) begin // @[WishboneSlave.scala 41:16]
        bootAddrReg <= io_wb_din[31:2]; // @[WishboneSlave.scala 44:19]
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  resetReg = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  stallReg = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  bootAddrReg = _RAND_2[29:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module WishboneSlaveROM(
  input         clock,
  input         reset,
  input         io_wb_stb,
  input         io_wb_cyc,
  input         io_wb_we,
  input  [31:0] io_wb_din,
  input  [31:0] io_wb_addr,
  output        io_wb_ack,
  output [31:0] io_wb_dout,
  output        io_rom_we,
  output [31:0] io_rom_data,
  output [31:0] io_rom_addr
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg  WBReg_we; // @[WishboneSlave.scala 55:22]
  reg [31:0] WBReg_data; // @[WishboneSlave.scala 55:22]
  reg [31:0] WBReg_addr; // @[WishboneSlave.scala 55:22]
  wire  _read_T = io_wb_stb & io_wb_cyc; // @[WishboneSlave.scala 60:24]
  wire  read = io_wb_stb & io_wb_cyc & ~io_wb_we; // @[WishboneSlave.scala 60:36]
  wire  write = _read_T & io_wb_we; // @[WishboneSlave.scala 61:37]
  wire  _GEN_0 = read & WBReg_we; // @[WishboneSlave.scala 63:14 69:27 70:22]
  wire  _GEN_2 = write ? 1'h0 : _GEN_0; // @[WishboneSlave.scala 63:14 67:20]
  wire [31:0] _GEN_3 = read ? WBReg_data : 32'h0; // @[WishboneSlave.scala 63:14 76:27 77:22]
  wire [31:0] _GEN_4 = write ? io_wb_din : WBReg_data; // @[WishboneSlave.scala 74:20 55:22 75:22]
  wire [31:0] _GEN_5 = write ? 32'h0 : _GEN_3; // @[WishboneSlave.scala 63:14 74:20]
  wire [31:0] _GEN_6 = read ? WBReg_addr : 32'h0; // @[WishboneSlave.scala 63:14 83:27 84:22]
  wire [31:0] _GEN_7 = write ? io_wb_din : WBReg_addr; // @[WishboneSlave.scala 81:20 55:22 82:22]
  wire [31:0] _GEN_8 = write ? 32'h0 : _GEN_6; // @[WishboneSlave.scala 63:14 81:20]
  wire [31:0] _GEN_9 = 32'h3000000c == io_wb_addr ? _GEN_7 : WBReg_addr; // @[WishboneSlave.scala 55:22 65:23]
  wire [31:0] _GEN_10 = 32'h3000000c == io_wb_addr ? _GEN_8 : 32'h0; // @[WishboneSlave.scala 63:14 65:23]
  wire [31:0] _GEN_12 = 32'h30000008 == io_wb_addr ? _GEN_5 : _GEN_10; // @[WishboneSlave.scala 65:23]
  wire [31:0] _GEN_15 = 32'h30000004 == io_wb_addr ? {{31'd0}, _GEN_2} : _GEN_12; // @[WishboneSlave.scala 65:23]
  assign io_wb_ack = io_wb_stb & (io_wb_addr == 32'h30000004 | io_wb_addr == 32'h30000008 | io_wb_addr == 32'h3000000c); // @[WishboneSlave.scala 62:26]
  assign io_wb_dout = io_wb_ack ? _GEN_15 : 32'h0; // @[WishboneSlave.scala 63:14 64:18]
  assign io_rom_we = WBReg_we; // @[WishboneSlave.scala 59:10]
  assign io_rom_data = WBReg_data; // @[WishboneSlave.scala 59:10]
  assign io_rom_addr = WBReg_addr; // @[WishboneSlave.scala 59:10]
  always @(posedge clock) begin
    if (reset) begin // @[WishboneSlave.scala 55:22]
      WBReg_we <= 1'h0; // @[WishboneSlave.scala 55:22]
    end else if (io_wb_ack) begin // @[WishboneSlave.scala 64:18]
      if (32'h30000004 == io_wb_addr) begin // @[WishboneSlave.scala 65:23]
        if (write) begin // @[WishboneSlave.scala 67:20]
          WBReg_we <= io_wb_din[0]; // @[WishboneSlave.scala 68:20]
        end
      end
    end
    if (reset) begin // @[WishboneSlave.scala 55:22]
      WBReg_data <= 32'h0; // @[WishboneSlave.scala 55:22]
    end else if (io_wb_ack) begin // @[WishboneSlave.scala 64:18]
      if (!(32'h30000004 == io_wb_addr)) begin // @[WishboneSlave.scala 65:23]
        if (32'h30000008 == io_wb_addr) begin // @[WishboneSlave.scala 65:23]
          WBReg_data <= _GEN_4;
        end
      end
    end
    if (reset) begin // @[WishboneSlave.scala 55:22]
      WBReg_addr <= 32'h0; // @[WishboneSlave.scala 55:22]
    end else if (io_wb_ack) begin // @[WishboneSlave.scala 64:18]
      if (!(32'h30000004 == io_wb_addr)) begin // @[WishboneSlave.scala 65:23]
        if (!(32'h30000008 == io_wb_addr)) begin // @[WishboneSlave.scala 65:23]
          WBReg_addr <= _GEN_9;
        end
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  WBReg_we = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  WBReg_data = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  WBReg_addr = _RAND_2[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module WishboneSlave(
  input         clock,
  input         reset,
  input         io_wb_stb,
  input         io_wb_cyc,
  input         io_wb_we,
  input  [3:0]  io_wb_sel,
  input  [31:0] io_wb_din,
  input  [31:0] io_wb_addr,
  output        io_wb_ack,
  output [31:0] io_wb_dout,
  output        io_patmos_pc_reset,
  output        io_patmos_pc_stall,
  output [29:0] io_patmos_pc_bootAddr,
  output        io_patmos_rom_we,
  output [31:0] io_patmos_rom_data,
  output [31:0] io_patmos_rom_addr
);
  wire  slavePC_clock; // @[WishboneSlave.scala 122:23]
  wire  slavePC_reset; // @[WishboneSlave.scala 122:23]
  wire  slavePC_io_wb_stb; // @[WishboneSlave.scala 122:23]
  wire  slavePC_io_wb_cyc; // @[WishboneSlave.scala 122:23]
  wire  slavePC_io_wb_we; // @[WishboneSlave.scala 122:23]
  wire [31:0] slavePC_io_wb_din; // @[WishboneSlave.scala 122:23]
  wire [31:0] slavePC_io_wb_addr; // @[WishboneSlave.scala 122:23]
  wire  slavePC_io_wb_ack; // @[WishboneSlave.scala 122:23]
  wire [31:0] slavePC_io_wb_dout; // @[WishboneSlave.scala 122:23]
  wire  slavePC_io_pc_reset; // @[WishboneSlave.scala 122:23]
  wire  slavePC_io_pc_stall; // @[WishboneSlave.scala 122:23]
  wire [29:0] slavePC_io_pc_bootAddr; // @[WishboneSlave.scala 122:23]
  wire  slaveROM_clock; // @[WishboneSlave.scala 123:24]
  wire  slaveROM_reset; // @[WishboneSlave.scala 123:24]
  wire  slaveROM_io_wb_stb; // @[WishboneSlave.scala 123:24]
  wire  slaveROM_io_wb_cyc; // @[WishboneSlave.scala 123:24]
  wire  slaveROM_io_wb_we; // @[WishboneSlave.scala 123:24]
  wire [31:0] slaveROM_io_wb_din; // @[WishboneSlave.scala 123:24]
  wire [31:0] slaveROM_io_wb_addr; // @[WishboneSlave.scala 123:24]
  wire  slaveROM_io_wb_ack; // @[WishboneSlave.scala 123:24]
  wire [31:0] slaveROM_io_wb_dout; // @[WishboneSlave.scala 123:24]
  wire  slaveROM_io_rom_we; // @[WishboneSlave.scala 123:24]
  wire [31:0] slaveROM_io_rom_data; // @[WishboneSlave.scala 123:24]
  wire [31:0] slaveROM_io_rom_addr; // @[WishboneSlave.scala 123:24]
  wire [31:0] _GEN_0 = slaveROM_io_wb_ack ? slaveROM_io_wb_dout : 32'h0; // @[WishboneSlave.scala 144:14 147:35 148:16]
  WishboneSlavePC slavePC ( // @[WishboneSlave.scala 122:23]
    .clock(slavePC_clock),
    .reset(slavePC_reset),
    .io_wb_stb(slavePC_io_wb_stb),
    .io_wb_cyc(slavePC_io_wb_cyc),
    .io_wb_we(slavePC_io_wb_we),
    .io_wb_din(slavePC_io_wb_din),
    .io_wb_addr(slavePC_io_wb_addr),
    .io_wb_ack(slavePC_io_wb_ack),
    .io_wb_dout(slavePC_io_wb_dout),
    .io_pc_reset(slavePC_io_pc_reset),
    .io_pc_stall(slavePC_io_pc_stall),
    .io_pc_bootAddr(slavePC_io_pc_bootAddr)
  );
  WishboneSlaveROM slaveROM ( // @[WishboneSlave.scala 123:24]
    .clock(slaveROM_clock),
    .reset(slaveROM_reset),
    .io_wb_stb(slaveROM_io_wb_stb),
    .io_wb_cyc(slaveROM_io_wb_cyc),
    .io_wb_we(slaveROM_io_wb_we),
    .io_wb_din(slaveROM_io_wb_din),
    .io_wb_addr(slaveROM_io_wb_addr),
    .io_wb_ack(slaveROM_io_wb_ack),
    .io_wb_dout(slaveROM_io_wb_dout),
    .io_rom_we(slaveROM_io_rom_we),
    .io_rom_data(slaveROM_io_rom_data),
    .io_rom_addr(slaveROM_io_rom_addr)
  );
  assign io_wb_ack = slavePC_io_wb_ack | slaveROM_io_wb_ack; // @[WishboneSlave.scala 142:34]
  assign io_wb_dout = slavePC_io_wb_ack ? slavePC_io_wb_dout : _GEN_0; // @[WishboneSlave.scala 145:26 146:16]
  assign io_patmos_pc_reset = slavePC_io_pc_reset; // @[WishboneSlave.scala 125:16]
  assign io_patmos_pc_stall = slavePC_io_pc_stall; // @[WishboneSlave.scala 125:16]
  assign io_patmos_pc_bootAddr = slavePC_io_pc_bootAddr; // @[WishboneSlave.scala 125:16]
  assign io_patmos_rom_we = slaveROM_io_rom_we; // @[WishboneSlave.scala 126:17]
  assign io_patmos_rom_data = slaveROM_io_rom_data; // @[WishboneSlave.scala 126:17]
  assign io_patmos_rom_addr = slaveROM_io_rom_addr; // @[WishboneSlave.scala 126:17]
  assign slavePC_clock = clock;
  assign slavePC_reset = reset;
  assign slavePC_io_wb_stb = io_wb_stb; // @[WishboneSlave.scala 128:21]
  assign slavePC_io_wb_cyc = io_wb_cyc; // @[WishboneSlave.scala 129:21]
  assign slavePC_io_wb_we = io_wb_we; // @[WishboneSlave.scala 130:20]
  assign slavePC_io_wb_din = io_wb_din; // @[WishboneSlave.scala 132:21]
  assign slavePC_io_wb_addr = io_wb_addr; // @[WishboneSlave.scala 133:22]
  assign slaveROM_clock = clock;
  assign slaveROM_reset = reset;
  assign slaveROM_io_wb_stb = io_wb_stb; // @[WishboneSlave.scala 135:22]
  assign slaveROM_io_wb_cyc = io_wb_cyc; // @[WishboneSlave.scala 136:22]
  assign slaveROM_io_wb_we = io_wb_we; // @[WishboneSlave.scala 137:21]
  assign slaveROM_io_wb_din = io_wb_din; // @[WishboneSlave.scala 139:22]
  assign slaveROM_io_wb_addr = io_wb_addr; // @[WishboneSlave.scala 140:23]
endmodule
