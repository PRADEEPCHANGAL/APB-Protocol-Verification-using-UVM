class apb_wagent extends uvm_agent;
  `uvm_component_utils(apb_wagent)
  
  apb_sequencer sqr;
  apb_wdriver   wdrv;
  apb_wmonitor  wmon;
  
  
  
  //constructor
  function new(string name = "apb_wagent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr = apb_sequencer::type_id::create("sqr",this);
    wdrv = apb_wdriver::type_id::create("wdrv",this);
    wmon = apb_wmonitor::type_id::create("wmon",this);
  endfunction
  
  //connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    wdrv.seq_item_port.connect(sqr.seq_item_export);
    `uvm_info("WAGENT",$sformatf("Connected Sequencer to Driver"),UVM_LOW)
  endfunction
endclass

    
