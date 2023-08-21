class apb_wmonitor extends uvm_monitor;
  `uvm_component_utils(apb_wmonitor)
   
  
  apb_transaction trans;
  virtual apb_if vif;
  uvm_analysis_port#(apb_transaction) wap;
  int pr_addr = 0, pa_addr = 0;
  integer pr_data, pa_data;
  int write_count =0;

  //Constructor 
  function new(string name ="apb_wmonitor", uvm_component parent = null);
    super.new(name, parent);
    wap = new("wap", this);
  endfunction
  
   //Build Phase 
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif)) begin
      `uvm_error("build_phase","driver virtual interface failed")
    end
    
  endfunction
  
  //Run Phase
  task run_phase(uvm_phase phase);
     //Creating new transaction object
     trans = apb_transaction::type_id::create("trans");
 
    forever begin
       //wait for rising edge of clock 
      @(posedge vif.PCLK) begin 
        
       
        while((!vif.PSEL && !vif.PENABLE) || !vif.PWRITE) begin // wait untill PSEL or PENABLE is not 1
        @(posedge vif.PCLK)
          `uvm_info("WMONITOR",$sformatf("Wating for write mode or PSEL or PENABLE is not high PSEL =%0d, PENABLE =%0d, PWRITE =%0d",vif.PSEL,vif.PENABLE,vif.PWRITE),UVM_LOW) 
      end
	     
         trans.PRESET = vif.PRESET;
         trans.PADDR = vif.PADDR;
         trans.PWDATA = vif.PWDATA;
         trans.PWRITE = vif.PWRITE;
         trans.PSEL = vif.PSEL;
         trans.PREADY = vif.PREADY;
         trans.PSLVERR = vif.PSLVERR;
		 trans.PENABLE = vif.PENABLE;

        
         pr_data = trans.PWDATA;
         pr_addr = trans.PADDR;
        if((pr_addr != pa_addr) || pr_data !== pa_data) begin
        //Pass the transaction to analysis port
        `uvm_info("WMONITOR",$sformatf("Sent Transaction to SB: PRESET =%0d, PSEL =%0d, PWRITE =%0d, PENABLE =%0d, ADDR =%0d, PWDATA =%0d, PREADY =%0d PSLERR = %0d", trans.PRESET,trans.PSEL,trans.PWRITE,trans.PENABLE,trans.PADDR,trans.PWDATA,trans.PREADY,trans.PSLVERR),UVM_LOW)
        wap.write(trans);
        pa_addr = pr_addr;
        pa_data = pr_data;
        end
        else
          `uvm_info("WMONITOR",$sformatf("Writing same data on same address"),UVM_LOW)
        //wait for the write transaction to complete   
        while(!vif.PREADY && write_count<=10) begin
            @(posedge vif.PCLK);
               `uvm_info("WMONITOR",$sformatf("Ready signal is not high"),UVM_LOW)
		  write_count++; end

		  if(write_count>10) begin
		  `uvm_error("WMONITOR", "Ready signal was not high since 10 clock cycle")
           write_count =0; end 

       end
	   #1;
     end
   endtask 
  endclass 
    
    
