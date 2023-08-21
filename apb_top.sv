`include "uvm_macros.svh"
import uvm_pkg::*;
//Include all files
`include "apb_if.sv"
`include "apb_transaction.sv"
`include "apb_write_read_sequence.sv"
`include "apb_write_read_b2b_sequence.sv"
`include "apb_error_addr_sequence.sv"
`include "apb_error_write_sequence.sv"
`include "apb_error_read_sequence.sv"
`include "apb_burst_write_read_sequence.sv"
`include "apb_burst_diff_data_sequence.sv"
`include "apb_max_wr_addr_sequence.sv"
`include "apb_max_burst_sequence.sv"
`include "apb_sequencer.sv"
`include "apb_wdriver.sv"
`include "apb_wmonitor.sv"
`include "apb_rmonitor.sv" 
`include "apb_wagent.sv"
`include "apb_ragent.sv"
`include "apb_scoreboard.sv"
`include "apb_coverge_model.sv"
`include "apb_env.sv"
`include "apb_test_wr.sv" 
`include "apb_test_wrb2b.sv" 
`include "apb_test_bwr.sv"
`include "apb_test_bdd.sv"
`include "apb_test_mbwr.sv"
`include "apb_test_ea.sv"
`include "apb_test_ew.sv"
`include "apb_test_er.sv"
`include "apb_test_mma.sv"
`include "apb_base_test.sv" 
module apb_top(); 
    
  apb_if vif();
  
  AMBA_APB dut(.PCLK(vif.PCLK),
               .PRESET(vif.PRESET), .PADDR(vif.PADDR), .PWRITE(vif.PWRITE), .PSEL(vif.PSEL), .PENABLE(vif.PENABLE), .PWDATA(vif.PWDATA), .PRDATA(vif.PRDATA), .PREADY(vif.PREADY)); 
  
    initial
      begin
         vif.PCLK = 1'b0; 
         forever 
          #5 vif.PCLK = ~vif.PCLK;
        end
     initial
      begin
         vif.PRESET = 1'b1;
        `uvm_info("APB TOP", $sformatf("RESET is applied"), UVM_LOW);
        #15;
          vif.PRESET = 1'b0;
        `uvm_info("APB TOP", $sformatf("RESET is released"), UVM_LOW);
        end
  
  
initial begin  
  uvm_config_db#(virtual apb_if) :: set(null,"*","vif",vif);
  
  run_test("apb_base_test");

end
   initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  #100000;
    $finish;
end
  
endmodule
