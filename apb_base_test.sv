class apb_base_test extends uvm_test;
  `uvm_component_utils(apb_base_test)
  
  apb_env env;
  apb_write_read_sequence wrs;
  apb_write_read_b2b_sequence wrbs;
  apb_burst_write_read_sequence bwrs;
  apb_max_burst_sequence mbwrs;
  apb_max_wr_addr_sequence mma;
  apb_burst_diff_data_sequence bdd;
  apb_error_addr_sequence ea;
  apb_error_read_sequence er;
  apb_error_write_sequence ew;


  function new(string name ="apb_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env",this);
	wrs = apb_write_read_sequence::type_id::create("wrs");
	wrbs = apb_write_read_b2b_sequence::type_id::create("wrbs");
	bwrs = apb_burst_write_read_sequence::type_id::create("bwrs");
	mbwrs = apb_max_burst_sequence::type_id::create("mbwrs");
	mma = apb_max_wr_addr_sequence::type_id::create("mma");
	bdd = apb_burst_diff_data_sequence::type_id::create("bdd");
	ea = apb_error_addr_sequence::type_id::create("ea");
	er = apb_error_read_sequence::type_id::create("er");
	ew = apb_error_write_sequence::type_id::create("ew");

       endfunction
    
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology;
    `uvm_info(get_full_name,$sformatf("In end of elaboration  phase"),UVM_HIGH)
  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection (this);
    
	repeat(10) begin
	randcase
	  2: begin `uvm_info("TEST WRITE READ",$sformatf("Starting Write read sequence"),UVM_LOW)
                wrs.start(env.wagent.sqr);
	           `uvm_info("TEST WRITE READ",$sformatf(" Write read sequence done"),UVM_LOW)
                #50; end

      1: begin `uvm_info("TEST WRITE READ B2B",$sformatf("Starting Write read sequence"),UVM_LOW)
                wrbs.start(env.wagent.sqr);
	           `uvm_info("TEST WRITE READ B2B",$sformatf("Write read sequence done"),UVM_LOW)
                #50; end

	  1: begin `uvm_info("TEST BURST WR",$sformatf("Starting Write read sequence"),UVM_LOW)
                bwrs.start(env.wagent.sqr);
	           `uvm_info("TEST BURST WR",$sformatf("Write read sequence done"),UVM_LOW)
                #50; end

	  1: begin `uvm_info("TEST MAX BURST",$sformatf("Starting Write read sequence"),UVM_LOW)
                mbwrs.start(env.wagent.sqr);
          	   `uvm_info("TEST MAX BURST",$sformatf("Write read sequence done"),UVM_LOW)
                #50; end

	  3: begin `uvm_info("TEST MAX MIN ADDR",$sformatf("Starting Write read sequence"),UVM_LOW)
                mma.start(env.wagent.sqr);
	           `uvm_info("TEST MAX MIN ADDR",$sformatf("Write read sequence done"),UVM_LOW)
                #50; end

	  2: begin `uvm_info("TEST DIFF DATA",$sformatf("Starting Write read sequence"),UVM_LOW)
                bdd.start(env.wagent.sqr);
	           `uvm_info("TEST DIFF DATA",$sformatf("Write read sequence done"),UVM_LOW)
                #50; end

	  2: begin `uvm_info("TEST ERROR ADDR",$sformatf("Starting Write read sequence"),UVM_LOW)
                ea.start(env.wagent.sqr);
	           `uvm_info("TEST ERROR ADDR",$sformatf("Write read sequence done"),UVM_LOW)
                #50; end

	  2: begin `uvm_info("TEST ERROR READ",$sformatf("Starting Write read sequence"),UVM_LOW)
                er.start(env.wagent.sqr);
	           `uvm_info("TEST ERROR READ",$sformatf("Write read sequence done"),UVM_LOW)
                #50; end

	  2: begin `uvm_info("TEST ERROR WRITE",$sformatf("Starting Write read sequence"),UVM_LOW)
                ew.start(env.wagent.sqr);
	           `uvm_info("TEST ERROR WRITE",$sformatf("Write read sequence done"),UVM_LOW)
                #50; end
     endcase
	end
	#50;
    phase.drop_objection(this);
	
  endtask
endclass
