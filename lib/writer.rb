class Writer

  attr_accessor :csv_writer

  def initialize(file_path)
    self.csv_writer =  CSV.open(file_path, "w")
  end

  def push_data(data)
    csv_writer << data
  end

  def headers(data)
    push_data(data)
  end

  def close
    csv_writer.close
  end 

end