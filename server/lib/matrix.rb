module Lib

  class Matrix

    attr_reader :data

    def initialize(rows)
      unless rows.length > 0 and rows.all? {|row| row.length === rows[0].length}
        raise 'Invalid matrix, rows must be the same size'
      end
      @data = rows.map{|row| row.map {|n| n.to_f}}
    end

    def self.zero(width, height)
      Matrix.new Array.new(height) { Array.new(width) { 0 }}
    end


    def self.identity(size)
      matrix = Matrix.zero size, size
      size.times do |i|
        matrix.data[i][i] = 1
      end
      matrix
    end

    def _zero_row?(row)
      row.all? {|n| n == 0}
    end

    def _no_solution_row?(row)
      return false unless self._zero_row? row[0..-2]
      return row.last != 0
    end

    def value_at(x, y)
      return self.data[y][x]
    end

    def set_value_at(x, y, value)
      self.data[y][x] = value
      self
    end

    def copy
      Matrix.new self.data.dup.map {|r| r.dup}
    end

    def equals(other)
      other.data == self.data
    end

    def height
      self.data.length
    end

    def width
      self.data.first.length
    end

    def size
      {
        height: self.height,
        width: self.width,
      }
    end

    def size_equal(other)
      self.size == other.size
    end

    def scaled(scale)
      Matrix.new self.data.map {|row| row.map {|n| n * scale}}
    end

    def negated
      self.scaled(-1)
    end

    def added(other)
      raise 'Cannot add matrices of different size' unless self.size == other.size
      Matrix.new self.data.map.with_index { |row, i|
        row.map.with_index { |n, j| self.data[i][j] + other.data[i][j] }
      }
    end

    def subbed(other)
      self.added(other.negated)
    end

    def square?
      self.height == self.width
    end

    # from https://rosettacode.org/wiki/Reduced_row_echelon_form
    # temp until I rewrite the original recursive function
    def rref
      lead = 0
      rows = self.height
      cols = self.width
      output = self.copy.data
      catch :done  do
        rows.times do |r|
          throw :done  if cols <= lead
          ri = r
          while output[ri][lead] == 0
            ri += 1
            if rows == ri
              ri = r
              lead += 1
              throw :done  if cols == lead
            end
          end
          # swap rows i and r
          output[ri], output[r] = output[r], output[ri]
          # normalize row r
          v = output[r][lead]
          output[r].collect! {|x| x / v}
          # reduce other rows
          rows.times do |i|
            next if i == r
            v = output[i][lead]
            output[i].each_index {|j| output[i][j] -= v * output[r][j]}
          end
          lead += 1
        end
      end
      Matrix.new output
    end

    def augmented
      Matrix.new self.data.map {|row| [*row, 0]}
    end

    def row_equivalent?(other)
      return false unless self.size == other.size
      self.rref.equals(other.rref)
    end

    def invertible?
      return false unless self.square?
      self.rref.equals(Matrix.identity self.height)
    end

    def concat_horizontal(other)
      return nil unless self.height == other.height
      Matrix.new self.data.map.with_index { |row, i| [*row, *other.data[i]] }
    end

    def determinant
      return nil unless self.square?

      return nil if self.height < 1

      return self.data[0][0] if self.height == 1

      return self.data[0][0] * self.data[1][1] - self.data[1][0] * self.data[0][1] if self.height == 2

      copy = self.copy
      next_sub = nil
      det = 0
      for y in 0..(copy.height - 1)
        next_sub = Matrix.zero(copy.height - 1, copy.height - 1)
        for i in 1..(copy.height - 1)
          j2 = 0
          for j in 0..(copy.height - 1)
            next if j == y
            next_sub.data[i - 1][j2] = copy.data[i][j]
            j2 = j2 + 1
          end
        end

        switch = ((2.0 + y) % 2.0 == 1.0) ? -1.0 : 1.0
        det = det + (switch * copy.data[0][y] * next_sub.determinant)
      end
      det
    end

    def inverse
      return nil unless self.invertible?
      size = self.height
      comp = self.copy
      ident = Matrix.identity(self.height)
      result = comp.concat_horizontal(ident)
      Matrix.new result.rref.data.map { |row| row[size..-1]}
    end

    def number_of_solutions
      reduced = self.rref
      return 0 if reduced.data.find {|row| reduced._no_solution_row? row}
      return Float::INFINITY if reduced.data.select{|row| reduced._zero_row? row}.length > (self.height - (self.width - 1))
      return 1
    end

    def linearly_independent?
      return [nil, 'R_MISMATCH'] if self.width > self.height
      reduced = self.rref

      if reduced.square?
        return [1, nil] if reduced.equals Matrix.identity(reduced.height)
        return [nil, 'DUPLICATE_VECTORS'];
      end

      return [nil, 'DUPLICATE_VECTORS'] if reduced.data.select{|row| reduced._zero_row? row}.length > (reduced.height - self.width)
      return [1, nil];
    end
  end # Class Matrix
end # Module Lib
