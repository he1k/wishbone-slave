import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class WishboneSlaveSpec extends AnyFlatSpec with ChiselScalatestTester {
  val baseAddr = 0x3000000
  "WishboneSlave" should "pass" in {
    test(new WishboneSlave(baseAddr)).withAnnotations(Seq(WriteVcdAnnotation)) { dut =>
      def step(steps: Int = 1):Unit={
        dut.clock.step(steps)
      }
      def idle(steps: Int = 1):Unit={
        dut.io.wb.stb.poke(0)
        dut.io.wb.cyc.poke(0)
        dut.io.wb.din.poke(0)
        dut.io.wb.addr.poke(0)
        dut.io.wb.we.poke(0)
        step(steps)
      }
      def masterWrite(data: Int, addr: Int):Unit={
        dut.io.wb.stb.poke(1)
        dut.io.wb.cyc.poke(1)
        dut.io.wb.we.poke(1)
        dut.io.wb.din.poke(data)
        dut.io.wb.addr.poke(addr)
        step(2)

      }
      def masterRead(data: Int, addr: Int):Unit={
        dut.io.wb.stb.poke(1)
        dut.io.wb.cyc.poke(1)
        dut.io.wb.we.poke(0)
        dut.io.wb.addr.poke(addr)
        step(1) // Now slave will acknowledge
        dut.io.wb.dout.expect(data)
      }

      masterWrite(0x4FEED, baseAddr + 4) // dataOdd
      masterWrite(0x12, baseAddr + 8) // addrOdd
      masterWrite(0x1, baseAddr + 12) // enOdd
      masterWrite(0x2BABE, baseAddr + 16) // dataEven
      masterWrite(0x69, baseAddr + 20) // addrEven
      masterWrite(1, baseAddr + 24) // enEven
      masterWrite(0x12345678, baseAddr) // bootAddr, reset & stall
      masterRead(0x4Feed, baseAddr + 4) // dataOdd
      masterRead(0x12, baseAddr + 8) // addrOdd
      masterRead(0x1, baseAddr + 12) // enOdd
      masterRead(0x2BABE, baseAddr + 16) // dataEven
      masterRead(0x69, baseAddr + 20) // addrEven
      masterRead(0x1, baseAddr + 24) // enEven
      masterRead(0x12345678, baseAddr) // bootAddr, reset & stall

    }
  }
}

