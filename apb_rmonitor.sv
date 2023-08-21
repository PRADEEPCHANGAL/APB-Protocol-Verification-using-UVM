class apb_rmonitor extends uvm_monitor;
  `uvm_component_utils(apb_rmonitor)
  
  virtual apb_if vif;
  uvm_analysis_port #(apb_transaction) rap;
  apb_transaction trans;

  int pr_addr = 0,  pa_addr = 0;
  integer pr_data, pa_data;
  integer read_count =0;
  //Constructor 
  function new(string name ="apb_rmonitor", uvm_component parent = null);
    super.new(name, parent);
    rap = new("rap", this);
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
        
        while((!vif.PSEL && !vif.PENABLE) || vif.PWRITE) begin// wait untill PSEL or PENABLE is not 1
        @(posedge vif.PCLK)
          `uvm_info("RMONITOR",$sformatf("Wating for read mode or PSEL or PENABLE is not high PSEL =%0d, PENABLE =%0d, PWRITE =%0d",vif.PSEL,vif.PENABLE,vif.PWRITE),UVM_LOW) end
         
         trans.PRESET = vif.PRESET;
         trans.PADDR = vif.PADDR; 
         trans.PWRITE = vif.PWRITE;
         trans.PSEL = vif.PSEL;
         trans.PREADY = vif.PREADY;      
         trans.PSLVERR = vif.PSLVERR;
		 trans.PENABLE = vif.PENABLE;

        
        //wait for the ready signal to assert
        while(!vif.PREADY && read_count <=10) begin
          @(posedge vif.PCLK)
          `uvm_info("RMONITOR",$sformatf("Ready signal is not high"),UVM_LOW)
		   read_count++; end

		   if(read_count >10) begin
             `uvm_error("RMONITOR",$sformatf("Ready signal was not high since 10 clock cycle"))
		   read_count =0;end

         trans.PRDATA = vif.PRDATA;
        
        pr_data = trans.PRDATA;  
        pr_addr = trans.PADDR;
        if((pr_addr != pa_addr) || pr_data !== pa_data)begin
        //Pass the transaction to analysis port
        `uvm_info("RMONITOR",$sformatf("Sent Transaction to SB: PRESET =%0d, PSEL =%0d, PWRITE =%0d, PENABLE =%0d, ADDR =%0d, PRDATA =%0d ,PREADY =%0d PSLVERR =%0d", trans.PRESET,trans.PSEL,trans.PWRITE,trans.PENABLE,trans.PADDR,trans.PRDATA,trans.PREADY,trans.PSLVERR),UVM_LOW)
        rap.write(trans);
        pa_addr = pr_addr;
        pa_data = pr_data;
         end
          else
        `uvm_info("RMONITOR",$sformatf("Reading same data from same addrs"),UVM_LOW)

       end
	   #1;
     end
   endtask 
  endclass
