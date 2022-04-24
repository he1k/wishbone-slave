import chisel3._
import chisel3.util._
class WishboneSlaveIO extends Bundle{
  val stb, cyc, we = Input(Bool())
  val sel = Input(UInt(4.W))
  val din, addr = Input(UInt(32.W))
  val ack = Output(Bool())
  val dout = Output(UInt(32.W))
}
class Write(addrWidth : Int) extends Bundle{
  val enEven = UInt(1.W)
  val addrEven = UInt(addrWidth.W)
  val dataEven = UInt(30.W)
  val enOdd = UInt(1.W)
  val addrOdd = UInt(addrWidth.W)
  val dataOdd = UInt(30.W)

  override def cloneType() = {
    Write.this
  }
}
class ROMIO extends Bundle{
  val write = new Write(8)
}
class PCIO extends Bundle{
  val reset, stall = UInt(1.W)
  val bootAddr = UInt(30.W)
}
class PatmosIO extends Bundle{
  val pc = new PCIO
  val rom = new Write(8)
}
class WishboneSlavePC(baseAddr : Int) extends Module{
  val io = IO(new Bundle{
    val wb = new WishboneSlaveIO
    val pc = Output(new PCIO)
  })
  val resetReg = RegInit(true.B)
  val stallReg = RegInit(false.B)
  val bootAddrReg = RegInit(1.U(30.W))
  io.pc.reset := resetReg
  io.pc.stall := stallReg
  io.pc.bootAddr := bootAddrReg
  val write = io.wb.stb & io.wb.cyc & io.wb.we // write reset
  val read = io.wb.stb & io.wb.cyc & !io.wb.we // read reset
  io.wb.ack := RegNext(io.wb.stb && (io.wb.addr === baseAddr.U))
  io.wb.dout := 0.U
  when(io.wb.ack){
    when(write){
      resetReg := io.wb.din(0)
      stallReg := io.wb.din(1)
      bootAddrReg := io.wb.din(31, 2)
    } . elsewhen(read){
      io.wb.dout := bootAddrReg ## stallReg ## resetReg
    }
  }
}
class WishboneSlaveROM(baseAddr : Int) extends Module{
  val io = IO(new Bundle{
    val wb = new WishboneSlaveIO
    val rom = Output(new Write(8))
  })
  val WBReg = RegInit(0.U.asTypeOf(new ROMIO))
  io.rom <> WBReg.write
  io.wb.dout := 0.U
  var i = 0
  val validAddr = WireDefault(false.B)
  io.wb.ack := RegNext(io.wb.stb & validAddr)
  val read = io.wb.stb & io.wb.cyc & !io.wb.we
  val write = io.wb.stb & io.wb.cyc & io.wb.we
  for((id, reg) <- WBReg.write.elements){
    when(io.wb.addr === (baseAddr + 4*i).U){ // Check if current address input matches the given wb register
      validAddr := true.B
      when(io.wb.ack){ // Check for acknowledgement
        when(write){
          reg := io.wb.din // Write data from bus to wb register
        } . elsewhen(read){
          io.wb.dout := reg // Write data from wb register to bus
        }
      }
    }
    i+=1
  }
}
class WishboneSlave(baseAddr : Int  = 0x30000000) extends Module{
  val io = IO(new Bundle{
    val wb = new WishboneSlaveIO
    val patmos = Output(new PatmosIO)
  })
  val slavePC = Module(new WishboneSlavePC(baseAddr))
  val slaveROM = Module(new WishboneSlaveROM(baseAddr + 4))

  io.patmos.pc <> slavePC.io.pc
  io.patmos.rom <> slaveROM.io.rom
  
  slavePC.io.wb.stb := io.wb.stb
  slavePC.io.wb.cyc := io.wb.cyc
  slavePC.io.wb.we := io.wb.we
  slavePC.io.wb.sel := io.wb.sel
  slavePC.io.wb.din := io.wb.din
  slavePC.io.wb.addr := io.wb.addr

  slaveROM.io.wb.stb := io.wb.stb
  slaveROM.io.wb.cyc := io.wb.cyc
  slaveROM.io.wb.we := io.wb.we
  slaveROM.io.wb.sel := io.wb.sel
  slaveROM.io.wb.din := io.wb.din
  slaveROM.io.wb.addr := io.wb.addr

  io.wb.ack := slavePC.io.wb.ack | slaveROM.io.wb.ack

  io.wb.dout := 0.U
  when(slavePC.io.wb.ack){
    io.wb.dout := slavePC.io.wb.dout
  } . elsewhen(slaveROM.io.wb.ack){
    io.wb.dout := slaveROM.io.wb.dout
  }
}
