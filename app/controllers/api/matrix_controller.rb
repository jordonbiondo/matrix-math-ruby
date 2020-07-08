class Api::MatrixController < ApplicationController


  def compute
    render json: {:a => 3, :b => 4};
  end

end
