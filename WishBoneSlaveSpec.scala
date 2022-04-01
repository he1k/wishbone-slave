import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
/*
val clk, rst, stb, cyc, we = Input(Bool())
  val sel = Input(UInt(4.W))
  val din, addr = Input(UInt(32.W))
  val ack = Output(Bool())
  val dout = Output(UInt(32.W))
*/

class WishBoneSlaveSpec extends AnyFlatSpec with ChiselScalatestTester {
  val baseAddr = 0x3000000
  "WishBoneSlave" should "pass" in {
    test(new WishboneSlave(baseAddr)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      println("DEPRECATED TEST")
      assert(false==true)
      def step(steps: Int = 1):Unit={
        dut.clock.step(steps)
      }
      def idle(steps: Int = 1):Unit={
        dut.io.wb.stb.poke(0)
        dut.io.wb.cyc.poke(0)
        dut.io.wb.din.poke(0)
        dut.io.wb.we.poke(0)
        step(steps)
      }
      def masterWrite(sel: Int, data: Int):Unit={
        dut.io.wb.stb.poke(1)
        dut.io.wb.cyc.poke(1)
        dut.io.wb.din.poke(data)
        dut.io.wb.we.poke(1)
        dut.io.wb.addr.poke(baseAddr)
        dut.io.wb.sel.poke(sel)
        step(1)
      }
      def masterRead(sel: Int, data: Int):Unit={
        dut.io.wb.stb.poke(1)
        dut.io.wb.cyc.poke(1)
        dut.io.wb.we.poke(0)
        dut.io.wb.sel.poke(sel)
        dut.io.wb.addr.poke(baseAddr + 4)
        step(1)
        dut.io.wb.dout.expect(data)
      }
      def patmosWrite(data: Int):Unit={
        dut.io.patmos.we.poke(1)
        dut.io.patmos.din.poke(data)
        step(1)
      }
      def patmosRead(data: Int):Unit={
        dut.io.patmos.dout.expect(data)
      }
      step()
      masterWrite(0, 0x69)                   // Write to byte 0
      patmosRead(0x69)                       // Patmos reads
      idle(5)                                // Idle WB bus
      masterWrite(1, 0x42)                   // Write byte 1
      masterWrite(2, 0x14)                   // Write byte 2
      masterWrite(3, 0x19)                   // Write byte 3
      patmosRead(0x19144269)                 // Patmos reads
      masterWrite(4, 0x9283)                 // Write lower half word
      patmosRead(0x19149283)                 // Patmos reads
      masterWrite(5, 0x3523)                 // Write upper half word
      patmosRead(0x35239283)                 // Patmos reads
      masterWrite(6, 0x12345678)             // Writes whole word
      patmosRead(0x12345678)                 // Patmos reads
      idle(10)                               // Idle WB bus
      patmosWrite(0x4da30dfe)                // Patmos writes
      masterRead(0, 0xfe)                    // Master reads byte 0
      masterRead(1, 0x0d)                    // Master reads byte 1
      masterRead(2, 0xa3)                    // Master reads byte 2
      masterRead(3, 0x4d)                    // Master reads byte 3
      masterRead(4, 0x0dfe)                  // Master reads lower half word
      masterRead(5, 0x4da3)                  // Master reads upper half word
      masterRead(6, 0x4da30dfe)              // Master reads whole word
    }
  }
}

