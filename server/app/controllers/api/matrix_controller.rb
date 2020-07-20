require_relative '../../../lib/matrix';
include Lib;

class Api::MatrixController < ApplicationController


  def compute
    matrix = Matrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
    rref = matrix.rref
    solutions = rref.number_of_solutions
    (is_lin_ind, reason) = matrix.linearly_independent?
    render json: {
      matrix: matrix.data,
      size: matrix.size,
      rref: {data: rref.data},
      det: matrix.determinant,
      inverse: matrix.invertible? ? {data: matrix.inverse.data} : nil,
      lin_ind: {
        is_linearly_independent: is_lin_ind,
        reason: reason,
      },
      solutions: {
        value: (solutions == Float::INFINITY ? -1 : solutions)
      }
    }
  end

end
