require 'test_helper'
require_relative '../../lib/matrix'

class MatrixTest < ActiveSupport::TestCase
  test 'can be initialized' do
    Lib::Matrix.new [[1, 2], [3, 4]]
  end

  test 'zero creates a zero filled matrix of the given sizes' do
    data = Lib::Matrix.zero(3, 3).data;
    assert_equal data.length, 3
    assert_equal data[0], [0, 0, 0]
    assert_equal data[1], [0, 0, 0]
    assert_equal data[2], [0, 0, 0]
  end

  test 'identiry creates an identiry matrix of the given size' do
    data = Lib::Matrix.identity(4).data;
    assert_equal data, [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]];
  end

  test '_no_solution_row?' do
    assert !Lib::Matrix.identity(4)._no_solution_row?([0, 0, 0])
    assert Lib::Matrix.identity(4)._no_solution_row?([0, 0, 0, 0, 9])
  end

  test 'added' do
    assert_equal Lib::Matrix.identity(4).added(Lib::Matrix.identity(4)).data, [
                    [2, 0, 0, 0],
                    [0, 2, 0, 0],
                    [0, 0, 2, 0],
                    [0, 0, 0, 2],
                  ]
  end

  test 'subbed' do
    assert_equal(
      Lib::Matrix.identity(4).subbed(
        Lib::Matrix.identity(4)
      ).data,
      Lib::Matrix.zero(4, 4).data
    )
  end

  test 'concat_horizontal' do
    assert_equal(
      Lib::Matrix.identity(2).concat_horizontal(
        Lib::Matrix.identity(2)
      ).data,
      [[1, 0, 1, 0], [0, 1, 0, 1]]
    )
  end

  test 'rref' do
    assert_equal(
      Lib::Matrix.new([[1, 2, 3], [2, 1, 1], [4, 9, 4]]).rref.data,
      [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
    )
  end

end
