class Log
  attr_accessor :file#, :filename
  
  def initialize
    #@filename = Time.now
	@file = File.open("log.txt", "w")
  end
  
  def write text
	@file.puts("#{text}")
  end
  
  def pwrite text
	@file.print("#{text}")
  end
  
  def close
    @file.close
  end

end