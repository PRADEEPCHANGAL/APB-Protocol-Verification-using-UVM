class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  
  apb_wagent wagent;
  apb_ragent ragent;
  apb_sb     sb;
  apb_coverage_model cm;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wagent = apb_wagent :: type_id :: create ("wagent", this);
    ragent = apb_ragent :: type_id :: create ("ragent", this);
    sb = apb_sb:: type_id :: create("sb",this);
    cm = apb_coverage_model:: type_id :: create("cm",this);

endfunction
  
   function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     wagent.wmon.wap.connect(sb.sb_export_write);
     ragent.rmon.rap.connect(sb.sb_export_read);
     `uvm_info("ENV",$sformatf("Connected Monitor to SB"),UVM_LOW)
     wagent.wmon.wap.connect(cm.cm_export_write);
     ragent.rmon.rap.connect(cm.cm_export_read);
     `uvm_info("ENV",$sformatf("Connected Monitor to CM"),UVM_LOW)

   endfunction
endclass
