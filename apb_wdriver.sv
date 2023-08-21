class apb_wdriver extends uvm_driver#(apb_transaction);
  `uvm_component_utils(apb_wdriver)
  
  virtual apb_if vif; 
  
  //Constructor
  function new(string name ="apb_wdriver", uvm_component parent = null);
    super.new(name, parent);
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
   
    apb_transaction trans;
    trans = apb_transaction::type_id::create("trans");
        
    forever begin
      wait(!vif.PRESET);
      @(posedge vif.PCLK) begin  
        seq_item_port.get_next_item(trans);
        if(trans.PWRITE) begin
          `uvm_info("WDRIVER",$sformatf("Driving Write Transaction: PRESET =%0d, PSEL =%0d, PWRITE =%0d, PENABLE =%0d, PSTRB =%0b, ADDR =%0d,PWDATA =%0d ",trans.PRESET,trans.PSEL,trans.PWRITE,trans.PENABLE,trans.PSTRB,trans.PADDR,trans.PWDATA),UVM_LOW)
          
        vif.PWRITE = trans.PWRITE;
        vif.PSEL = trans.PSEL;
        vif.PADDR = trans.PADDR;
        vif.PWDATA = trans.PWDATA;
        vif.PSTRB  = trans.PWDATA;

        @(posedge vif.PCLK)
        vif.PENABLE = trans.PENABLE;
       
          //wait for ready signal
          while(!vif.PREADY) begin
          @(posedge vif.PCLK);
            `uvm_info("WDRIVER",$sformatf("Wating for ready signal"),UVM_LOW)
             end
       
          
          if(vif.PSLVERR)
            `uvm_info("WDRIVER",$sformatf("write operation UNSUCCESSFUL"),UVM_LOW)
          else
            `uvm_info("WDRIVER",$sformatf("write operation SUCCESSFUL"),UVM_LOW)
         
           @(posedge vif.PCLK);
          vif.PENABLE = 0;
          vif.PSEL = 0; 
          end  
         
        else begin
          `uvm_info("WDRIVER",$sformatf("Driving Read Transaction: PRESET =%0d, PSEL =%0d, PWRITE =%0d, PENABLE =%0d, ADDR =%0d", trans.PRESET,trans.PSEL,trans.PWRITE,trans.PENABLE,trans.PADDR),UVM_LOW)
        vif.PWRITE = trans.PWRITE;
        vif.PSEL = trans.PSEL;
        vif.PADDR = trans.PADDR;
          
          @(posedge vif.PCLK)
        vif.PENABLE = trans.PENABLE;
           //wait for ready signal
          while(!vif.PREADY) begin
            @(posedge vif.PCLK); 
            `uvm_info("WDRIVER",$sformatf("Ready signal is not high"),UVM_LOW)
            end
           
          if(vif.PSLVERR)
            `uvm_info("WDRIVER",$sformatf("read operation UNSUCCESSFUL"),UVM_LOW)
          else
            `uvm_info("WDRIVER",$sformatf("read operation SUCCESSFUL"),UVM_LOW)
          
           @(posedge vif.PCLK);
          vif.PENABLE = 0;
          vif.PSEL = 0;   
        end 
       
       seq_item_port.item_done();
        `uvm_info("WDRIVER",$sformatf("Transaction Done"),UVM_LOW)
        
        end
      end
    
      endtask
endclass  
