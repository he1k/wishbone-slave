import chisel3._
import chisel3.util._

class WishBoneIO extends Bundle{
  val clk, rst, stb, cyc, we = Input(Bool())
  val sel = Input(UInt(4.W))
  val din, addr = Input(UInt(32.W))
  val ack = Output(Bool())
  val dout = Output(UInt(32.W))
}
class PatmosIO extends Bundle{
  val we = Input(Bool())
  val din = Input(UInt(32.W))
  val dout = Output(UInt(32.W))
}
class WishboneSlave(baseAddr : Int  = 0x3000000) extends Module{
  val io = IO(new Bundle{
    val wb = new WishBoneIO
    val patmos = new PatmosIO
  })
  val inputReg, outputReg = Reg(UInt(32.W))
  val inputAddr = baseAddr
  val outputAddr = baseAddr + 4
  val read = io.wb.stb & io.wb.cyc & !io.wb.we && (io.wb.addr === outputAddr.U) // read from registers
  val write = io.wb.stb & io.wb.cyc & io.wb.we && (io.wb.addr === inputAddr.U) // write to registers
  val dout = Wire(UInt(32.W))
  val din = Wire(UInt(32.W))
  din := io.wb.din
  io.wb.dout := dout 
  io.wb.ack := (read | write) 
  dout := 0.U
  when(io.wb.ack){
    switch(io.wb.sel){
      is(0.U){                                            // w/r byte 0
        when(write){
          inputReg := din(7, 0)
        } . elsewhen(read){
          dout := outputReg(7, 0)
        }
      }
      is(1.U){                                            // w/r byte 1
        when(write){
          inputReg := inputReg(31, 15) ## din(7, 0) ## inputReg(7, 0)
        } . elsewhen(read){
          dout := outputReg(15, 8)
        }
      }
      is(2.U){                                            // w/r byte 2
        when(write){
          inputReg := inputReg(31, 24) ## din(7, 0) ## inputReg(15, 0)
        } . elsewhen(read){
          dout := outputReg(23, 16)
        }
      }
      is(3.U){                                            // w/r byte 3
        when(write){
          inputReg := din(7, 0) ## inputReg(23, 0)
        } . elsewhen(read){
          dout := outputReg(31, 24)
        }
      }
      is(4.U){                                            // w/r hw lower
        when(write){
          inputReg := inputReg(31, 16) ## din(15, 0)
        } . elsewhen(read){
          dout := outputReg(15, 0)
        }
      }
      is(5.U){                                            // w/r hw upper
        when(write){
          inputReg := din(15, 0) ## inputReg(15, 0)
        } . elsewhen(read){
          dout := outputReg(31, 16)
        }
      }
      is(6.U){                                            // w/r word
        when(write){
          inputReg := din
        } . elsewhen(read){
          dout := outputReg
        }
      }
    }
  }
  io.patmos.dout := inputReg
  when(io.patmos.we){
    outputReg := io.patmos.din
  }
}
object WishboneSlaveMain extends App {
  emitVerilog(new WishboneSlave())
}