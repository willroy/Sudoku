#!/usr/bin/env ruby
require 'colorize'

class Display_Board
    def initialize
        @num_hl = 10
    end
    def display_board(board_rows)
        for i in board_rows
            if board_rows.find_index(i) == 0
                print " _________________"
                puts ""
            end
            count = 0
            for y in i
                count += 1
                if count == 1
                    print "|"
                end
                if y == @num_hl
                    print y.to_s.red
                else
                    print y
                end 
                if count % 3 == 0 
                    print "|"
                else
                    print " "
                end
            end
            if (board_rows.find_index(i)+1) % 9 == 0 
                puts ""   
                print " ⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻"
            elsif (board_rows.find_index(i)+1) % 3 == 0 
               puts ""
               print "|―――――┼―――――┼―――――|"  
            end
            puts "\n"
        end
    end
    def num_highlight
        print "Number to Highlight: "
        @num_hl = gets.chomp.to_i
    end
end

class Array
    def select_indice &p; map.with_index{|x, i| i if p.call(x)}.compact end
end

class Calculations
    def to_check_tracker(board_rows)
        zeros = 0
        board_rows.each {|i| zeros += i.count(0)} 
        for i in 0..0
            board_rows = row_checks(board_rows)
            board_rows = column_checks(board_rows)
            board_rows = block_checks(board_rows)
        end
        return board_rows
    end
    def inp_out_tracker(board_rows)
        board_rows = to_check_tracker(board_rows) #<< put on last line
        return board_rows
    end
    def row_checks(board_rows)
        print "\nStarted row_checks"
        puts ""
        for i in 0..8
            zeros = 0
            zeros = board_rows[i].count(0)
            
            print "i: " + i.to_s.green + "\n"
            print "zeros: " + zeros.to_s.blue
            puts ""
            if zeros == 1
                miss_value = find_miss_num(board_rows[i])
                
                
                print "miss_value: " + miss_value.to_s.yellow
                puts ""
                num = 0
                for x in board_rows[i]
                    num += 1
                    if x == 0
                        board_rows[i][board_rows[i].find_index(x)] = miss_value
                    end
                end
            end
        end
        return board_rows
    end
    def column_checks(board_rows)
        print "\nStarted column_checks"
        puts ""
        for i in 0..8
            column_to_check = []
            for x in board_rows
                column_to_check.push(x[i].to_i)
            end 
            amount = column_to_check.count(0)
            
            print "i: " + i.to_s.green + "\n"
            print "zeros: " + amount.to_s.blue
            puts ""
            if amount == 1
                miss_value = find_miss_num(column_to_check)
                print "miss_value: " + miss_value.to_s.yellow
                puts ""
                num = 0
                for x in board_rows
                    num += 1
                    if x[i] == 0
                        board_rows[board_rows.find_index(x)][i] = miss_value 
                    end
                end
            end
        end
        return board_rows
    end
    def block_make(board_rows)
        board_blocks = [[],[],[],[],[],[],[],[],[]]
        for i in 0..8
            num = 0
            board_rows[i].each do |x| 
                num += 1
                board_blocks[0].push(x) if num <= 3 && i <= 2
                board_blocks[1].push(x) if num >= 4 && num <= 6 && i <= 2
                board_blocks[2].push(x) if num >= 7 && num <= 9 && i <= 2
                board_blocks[3].push(x) if num <= 3 && i >= 3 && i <= 5
                board_blocks[4].push(x) if num >= 4 && num <= 6 && i >= 3 && i <= 5
                board_blocks[5].push(x) if num >= 7 && num <= 9 && i >= 3 && i <= 5
                board_blocks[6].push(x) if num <= 3 && i >= 6 && i <= 8
                board_blocks[7].push(x) if num >= 4 && num <= 6 && i >= 6 && i <= 8
                board_blocks[8].push(x) if num >= 7 && num <= 9  && i >= 6 && i <= 8
            end
        end
        return board_blocks
    end
    def block_find_location(board_blocks, block, in_block)
        location = [0, 0]
        grid_range = [0, 0]
        grid_range = [0, 1, 2] if block >= 0 && block <= 2
        grid_range = [3, 4, 5] if block >= 3 && block <= 5
        grid_range = [6, 7, 8] if block >= 6 && block <= 8
        in_block_row = 1 if in_block >= 0 && in_block <= 2
        in_block_row = 2 if in_block >= 3 && in_block <= 5
        in_block_row = 3 if in_block >= 6 && in_block <= 8
        return grid_range[in_block_row-1]
    end
    def block_checks(board_rows)
        print "\nStarted block_checks"
        puts ""
        row_index = nil
        col_index = nil
        board_blocks = block_make(board_rows)
        for i in 0..8
            zeros = 0
            zeros = board_blocks[i].count(0)
            print "i: " + i.to_s.green + "\n"
            print "zeros: " + zeros.to_s.blue
            puts ""
            if zeros == 1
                board_blocks[i].find_index(0)
                miss_value = find_miss_num(board_blocks[i])
                row_index = block_find_location(board_blocks, i, board_blocks[i].find_index(0))
                print "miss_value: " + miss_value.to_s.yellow
                puts ""
                for i in board_rows[row_index]
                    if i == 0
                       board_rows[row_index][board_rows[row_index].find_index(i)] = miss_value 
                       break
                    end
                end
            end
        end
        return board_rows
    end
    def find_miss_num(list)
        temp = list.dup
        test_ag = (1..9).to_a
        temp.delete(0)
        miss = test_ag - temp
        miss_value = miss[0]
    end
end

board_rows = [[0,0,2,4,8,0,3,7,6],
[7,3,9,2,0,6,8,4,1],
[4,6,8,3,7,1,2,9,5],
[3,8,0,1,2,4,0,5,9],
[5,0,0,7,6,3,4,0,8],
[2,4,6,8,9,5,7,1,3],
[9,1,4,6,0,0,5,8,2],
[6,2,5,0,4,8,0,3,7],
[0,7,3,5,1,2,0,6,4]] 

# board_rows = [[1,0,2,4,8,0,0,7,6],
# [7,3,9,2,5,6,8,4,1],
# [4,6,8,3,7,1,2,9,5],
# [3,8,7,1,2,4,6,0,9],
# [5,0,1,7,6,3,4,2,8],
# [2,4,6,8,9,0,7,1,3],
# [9,1,4,6,3,7,5,8,2],
# [6,2,5,9,4,8,0,3,7],
# [8,0,3,0,1,2,9,6,4]] 


display = Display_Board.new
calculate = Calculations.new
display.num_highlight()
puts "\n"
display.display_board(board_rows)

# for i in 1..1
    board_rows = calculate.inp_out_tracker(board_rows)
#     board_rows = calculate.column_checks(board_rows)
# end
puts "\n"
display.display_board(board_rows)
puts "\n"