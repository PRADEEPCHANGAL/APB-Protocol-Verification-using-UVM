class apb_sb extends uvm_scoreboard;
  `uvm_component_utils(apb_sb)
   
`uvm_analysis_imp_decl(_W)
`uvm_analysis_imp_decl(_R)

  virtual apb_if vif;
  
  apb_transaction trans_write;
  apb_transaction trans_read;
  
  uvm_analysis_imp_W #(apb_transaction, apb_sb) sb_export_write;
  uvm_analysis_imp_R #(apb_transaction, apb_sb) sb_export_read;
  
  bit   WPSLVERR, RPSLVERR;
  bit [31:0]    read_q[$];
  bit [31:0]    write_q[$];
  bit [31:0]   write,read;
  int compare_pass =0, compare_fail =0;
  
 // uvm_tlm_analysis_fifo #(apb_transaction) write_fifo;
 // uvm_tlm_analysis_fifo #(apb_transaction) read_fifo;
  
  function new (string name ="apb_sb", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export_write = new("sb_export_write", this);
    sb_export_read = new("sb_export_read", this);
        if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif)) begin
      `uvm_error("build_phase","driver virtual interface failed")
    end
 //   write_fifo = new("write_fifo", this);
 //   read_fifo = new("read_fifo", this);
  endfunction
  
 /* function void connect_phase(uvm_phase phase);
    sb_export_write.connect(write_fifo.analysis_export);
    sb_export_read.connect(read_fifo.analysis_export);
 endfunction: connect_phase */
  
  virtual function void write_W (input apb_transaction trans);
    write_q.push_back(trans.PWDATA);
    WPSLVERR = trans.PSLVERR;
    `uvm_info("SB",$sformatf("Got Write Transaction: write queue size =%0d PRESET =%0d, PSEL =%0d, PWRITE =%0d, PENABLE =%0d, ADDR =%0d, PWDATA =%0d PSLVERR = %0d", write_q.size(),trans.PRESET,trans.PSEL,trans.PWRITE,trans.PENABLE,trans.PADDR,trans.PWDATA,trans.PSLVERR),UVM_LOW)
  endfunction
 
  virtual function void write_R (input apb_transaction trans);
    read_q.push_back(trans.PRDATA);
    RPSLVERR = trans.PSLVERR;
    `uvm_info("SB",$sformatf("Got Read Transaction: read q size =%0d PRESET =%0d, PSEL =%0d, PWRITE =%0d, PENABLE =%0d, ADDR =%0d, PWDATA =%0d PSLVERR = %0d",read_q.size(), trans.PRESET,trans.PSEL,trans.PWRITE,trans.PENABLE,trans.PADDR,trans.PRDATA,trans.PSLVERR),UVM_LOW)
  endfunction
  
  task run_phase(uvm_phase phase);

  forever begin
      @(posedge vif.PCLK) begin 
      if(WPSLVERR || RPSLVERR) begin
	    if(WPSLVERR) begin
		`uvm_info("SB",$sformatf("We are in RUN PHASE: We got PSLVERR"),UVM_LOW) 
		write = write_q.pop_front(); end //when error is present we don't want to comapre read and write data
		if(RPSLVERR) begin
		`uvm_info("SB",$sformatf("We are in RUN PHASE: We got PSLVERR"),UVM_LOW) 
		read =  read_q.pop_front(); end
		end
	  else begin
      if(write_q.size() >0 && read_q.size() >0) begin 
         write = write_q.pop_front();
         read  = read_q.pop_front();
      `uvm_info("SB",$sformatf("We are in RUN PHASE: Wdata =%0d Rdata =%0d",write,read),UVM_LOW) 
         compare();
     end
	 end
  end
  end
  endtask
  
   
  virtual function void compare();
    if(write == read) begin
      `uvm_info("compare", $sformatf("Test: OK! Write Data = %0d Read Data = %0d",write,read), UVM_LOW);
      compare_pass++;
      end else begin
        `uvm_info("compare", $sformatf("Test: Fail! Write Data = %0d Read Data = %0d",write,read), UVM_LOW);
        compare_fail++;
      end
  endfunction: compare 
    
     //Report Phase 
  	function void report_phase(uvm_phase phase);
   		super.report_phase(phase);
 
      if(compare_fail>0) 
		begin
     			`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
          `uvm_info(get_type_name(), $sformatf("----       TEST FAIL COUNTS  %0d     ----",compare_fail), UVM_NONE)
     			`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    		end
      if(compare_pass>0)
		begin
     			`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
          `uvm_info(get_type_name(), $sformatf("----       TEST PASS COUNTS  %0d     ----",compare_pass), UVM_NONE)
     			`uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    		end
  	endfunction : report_phase  
endclass
