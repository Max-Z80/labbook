class Message
attr_reader :core, :object, :sender, :who


def initialize (params,test) 
  @who = params[:who]
  @core = params[:core]
  @sender = params[:sender]
  @object = params[:object]
  
  if test == true 
    if (@who == '') or (@core=='') or (@sender=='') or (@object =='')
     raise
    end
  end

  rescue
  raise
  
  

  end



end