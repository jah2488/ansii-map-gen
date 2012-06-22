#!/usr/bin/env ruby

require 'rubygems'
require 'pry'
require 'colored'

class MapMaker


  def initialize()
    @mapArray   = Hash.new
    @randomSeed = 0.447
    @mapCols    = 0
    @mapRows    = 0
    @wall       = '#'
    @floor      = '.'
  end

  def make_map ( height = 40, width = 60)

    @mapCols  = width
    @mapRows = height
    i = 0

    while i < width do
      j = 0
      new_array = []
      while j < width do
        @mapArray[[i,j]] = random_placement
        j+=1
      end
      i+=1
    end
  end

  def random_placement
    num = rand()
    if num < @randomSeed
      @floor
    else
      @wall
    end
  end

  def evolve_map
    row = 0
    while row < @mapRows
      col = 0
      while col < @mapCols
        @mapArray[[row, col]] = check_neighbors(row, col)
      col += 1
      end
    row += 1
    end
    print_map
  end

  def get_wall_count(row,col)
    wall_count = 0
    backrow = row - 1
    backcol = col - 1
    uprow   = row + 1
    upcol   = col + 1

    wall_count += 1 if @mapArray[[backrow, backcol]]  == @wall
    wall_count += 1 if @mapArray[[backrow,   col  ]]  == @wall
    wall_count += 1 if @mapArray[[backrow,  upcol ]]  == @wall

    wall_count += 1 if @mapArray[[ row  , backcol]]  == @wall
    wall_count += 1 if @mapArray[[ row  ,   col  ]]  == @wall
    wall_count += 1 if @mapArray[[ row  ,   upcol]]  == @wall

    wall_count += 1 if @mapArray[[ uprow, backcol]]  == @wall
    wall_count += 1 if @mapArray[[ uprow,   col  ]]  == @wall
    wall_count += 1 if @mapArray[[ uprow,   upcol]]  == @wall

    #puts "---- [ #{ row }, #{ col } ] ----"
    #puts "#{@mapArray[[row-1, col-1]]} #{@mapArray[[row-1, col+1]]} #{@mapArray[[row-1, col+1]]}"
    #puts "#{@mapArray[[row, col-1]]} #{@mapArray[[row, col]]} #{@mapArray[[row, col+1]]}"
    #puts "#{@mapArray[[row+1, col-1]]} #{@mapArray[[row+1, col]]} #{@mapArray[[row+1, col+1]]}"
    #puts "---- Wall Count : #{ wall_count } ----"
    #puts
    return wall_count
  end

  def get_neighbors_wall_count(row,col, count)
    n_wc = 0
    around = [-1,0,1]
    count.times do |x|
      around.each do |col_mod|
        around.each do |row_mod|
          n_wc += get_wall_count( (row + (x * row_mod)), (col + (x * col_mod)) )
        end
      end
    end
    return n_wc
  end

  def check_neighbors(row,col)
    wall_count = get_wall_count(row,col)
    if wall_count >= 5
      @wall
    else
      @floor
    end
  end

  def print_map
    system('clear')
    row = 0
    while row < @mapRows
      col = 0
      while col < @mapCols
        #get_floor count as well to smooth colors fix errors
        case get_wall_count(row,col)
        when 0   then print @mapArray[[row,col]].blue
        when 1   then print @mapArray[[row,col]].cyan
        when 2   then print @mapArray[[row,col]].cyan
        when 3   then print @mapArray[[row,col]].yellow
        when 4   then print @mapArray[[row,col]].yellow
        when 5   then print @mapArray[[row,col]].yellow
        when 6   then print @mapArray[[row,col]].yellow
        when 7   then print @mapArray[[row,col]].yellow
        when 8   then print @mapArray[[row,col]].yellow
        else
          if (get_neighbors_wall_count(row,col, 3) / 27) > 8
            print @mapArray[[row,col]].red
          else
            print @mapArray[[row,col]].green
          end
        end
      col += 1
      end
    row += 1
    puts
    end
  end

end

if __FILE__ == $0
  map = MapMaker.new
  puts "====== Map Generator ======"
  puts "= Press 1 to Generate Map ="
  puts "= Press 2 to Evolve Map   ="
  puts "==========================="
  loop do
    print "-> "
    case gets.chomp
    when "1" then map.make_map; map.print_map
    when "2" then map.evolve_map
    when "exit" then exit
    when "pry" then binding.pry
    end
  end
end
