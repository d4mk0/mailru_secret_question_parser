class ParserController < ApplicationController
  
  def start_import
    Import.new.from_file(params[:import][:file])
    redirect_to root_path
  end
  
  def parsing
    Parser.new.start
  end
end
