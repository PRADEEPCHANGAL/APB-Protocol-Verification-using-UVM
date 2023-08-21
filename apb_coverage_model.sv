class apb_coverage_model extends uvm_subscriber #(apb_transaction);
`uvm_component_utils(apb_coverage_model)

`uvm_analysis_imp_decl(_W)
`uvm_analysis_imp_decl(_R)

  uvm_analysis_imp_W #(apb_transaction, apb_coverage_model) cm_export_write;
  uvm_analysis_imp_R #(apb_transaction, apb_coverage_model) cm_export_read;
  
  apb_transaction tr;

//Define the coverage group and bins
covergroup cg;
//Address range bins
coverpoint tr.PADDR{
      bins addr_min = {[0:0]};
	  bins addr_max = {[32:32]};
	  bins addr_range = {[1:32]};
	  bins addr_invalid = {[32:$]};
	  }

//Data width bins
coverpoint tr.PRDATA{
      bins rdata_min = {[0:0]};
	  bins rdata_max = {32'hFFFFFFFF};
	  bins rdata_8bit_range = {[0:(2**8)-1]};
	  bins rdata_16bit_range = {[(2**8):(2**16)-1]};
      bins rdata_24bit_range = {[(2**16):(2**24)-1]};
      bins rdata_32bit_range = {[(2**24):$]};
	  }

coverpoint tr.PWDATA{
      bins wdata_min = {[0:0]};
	  bins wdata_max = {32'hFFFFFFFF};
	  bins wdata_8bit_range = {[0:(2**8)-1]};
	  bins wdata_16bit_range = {[(2**8):(2**16)-1]};
      bins wdata_24bit_range = {[(2**16):(2**24)-1]};
      bins wdata_32bit_range = {[(2**24):$]};
	  }


//Read and Write bins
coverpoint tr.PWRITE{
      bins write = {1};
	  bins read  = {0};
	  }

//Error condition bins
coverpoint tr.PSLVERR{
     bins pslverr_assert = {1};
	 bins pslverr_not_assert = {0};
	 }

//Ready condition bins
coverpoint tr.PREADY{
     bins pready_assert = {1};
	 bins pready_not_assert = {0};
	 }


//Psel and Penable condition bins
coverpoint tr.PSEL{
     bins psel_assert = {1};
	 }
coverpoint tr.PENABLE{
     bins penable_assert = {1};
	 }

//Cross coverage 
cross  tr.PWRITE, tr.PENABLE;

endgroup

  
  function new(string name ="apb_coverage_model", uvm_component parent);
  super.new(name,parent);
  cg =new;
  endfunction

  //Build Phase
  function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    cm_export_write = new("cm_export_write", this);
    cm_export_read = new("cm_export_read", this);
  endfunction

  virtual function void write(apb_transaction tr);
  endfunction 

  virtual function void write_W(apb_transaction tr1);
  tr =tr1;
  `uvm_info("COVERAGE",$sformatf("Got write transaction for coverage"),UVM_LOW)
  cg.sample();
  endfunction 

  virtual function void write_R(apb_transaction tr2);
  tr = tr2;
  `uvm_info("COVERAGE",$sformatf("Got read transaction for coverage"),UVM_LOW)

  cg.sample();
  endfunction


  endclass
