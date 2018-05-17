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
            for x in i
                count += 1
                if count == 1
                    print "|"
                end
                if x == @num_hl
                    print x.to_s.red
                else
                    print x
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

class Simple_calcs
    def to_check_tracker(board_rows)
        zeros = 0
        board_rows.each {|i| zeros += i.count(0)} 
        board_rows_copy = board_rows
        for i in 0..10
            board_rows = row_checks(board_rows)
            board_rows = column_checks(board_rows)
            board_rows = block_checks(board_rows)
        end
        return board_rows
    end
    def main(board_rows)
        board_rows = to_check_tracker(board_rows) 
        return board_rows
    end
    def row_checks(board_rows)
        for i in 0..8
            zeros = 0
            zeros = board_rows[i].count(0)
            if zeros == 1
                miss_value = find_miss_num(board_rows[i])          
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
        for i in 0..8
            column_to_check = []
            for x in board_rows
                column_to_check.push(x[i].to_i)
            end 
            amount = column_to_check.count(0)
            if amount == 1
                miss_value = find_miss_num(column_to_check)
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
        grid_row_range = [0, 1, 2] if block >= 0 && block <= 2
        grid_row_range = [3, 4, 5] if block >= 3 && block <= 5
        grid_row_range = [6, 7, 8] if block >= 6 && block <= 8
        in_block_row = 0 if in_block >= 0 && in_block <= 2
        in_block_row = 1 if in_block >= 3 && in_block <= 5
        in_block_row = 2 if in_block >= 6 && in_block <= 8
        grid_col_range = [0, 1, 2] if block == 0 || block == 3 || block == 6
        grid_col_range = [3, 4, 5] if block == 1 || block == 4 || block == 7
        grid_col_range = [6, 7, 8] if block == 2 || block == 5 || block == 8
        in_block_col = 0 if in_block == 0 || in_block == 3 || in_block == 6
        in_block_col = 1 if in_block == 1 || in_block == 4 || in_block == 7
        in_block_col = 2 if in_block == 2 || in_block == 5 || in_block == 8
        return grid_row_range[in_block_row], grid_col_range[in_block_col]
    end
    def block_checks(board_rows)
        row_index = nil
        col_index = nil
        board_blocks = block_make(board_rows)
        for i in 0..8
            zeros = 0
            zeros = board_blocks[i].count(0)
            if zeros == 1
                board_blocks[i].find_index(0)
                miss_value = find_miss_num(board_blocks[i])
                row_index, col_index = block_find_location(board_blocks, i, board_blocks[i].find_index(0))
                board_rows[row_index][col_index] = miss_value if board_rows[row_index][col_index] == 0
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

class Array
    #finds the index of multiple elements in an array (if they fit a criteria)
    def select_indice &p; map.with_index{|x, i| i if p.call(x)}.compact; end
    #swaps two elements in an array
    def swap!(a, b) self[a], self[b] = self[b], self[a]; self; end
end

class Cross_meet
    def main(board_rows)
        row_checks(board_rows)
    end
    def row_checks(board_rows) 
        for i in 0..8
            zeros = 0
            zeros = board_rows[i].count(0)
            if zeros == 2
                miss_value, col = find_miss_nums(board_rows[i])
                cross_cols(i, board_rows, col, miss_value)
            end
        end
    end
    def cross_cols(row, board_rows, col, miss_value)
        column_to_check = []
        for i in board_rows
            column_to_check.push(i[col[0]])
        end
        clash = false
        for i in column_to_check
            for x in miss_value
                if i == x
                    clash = true
                    print "Swap?: " + (i == miss_value[0]).to_s
                    puts ""
                    miss_value.swap!(0,1) if i == miss_value[0]
                end
            end
        end
        for i in board_rows
            column_to_check.push(i[col[1]])
        end
        for i in column_to_check
            for x in miss_value
                if i == x
                    clash = true
                    print "Swap?: " + (i == miss_value[0]).to_s
                    puts ""
                    miss_value.swap!(0,1) if i == miss_value[1]
                end
            end
        end
        if clash == true
            print "Clash!"
            num = 0
            for i in board_rows[row]
                if i == 0
                    board_rows[row][board_rows[row].find_index(i)] = miss_value[num]
                    num += 1
                end
            end
            return board_rows
        end
    end
    def find_miss_nums(list)
        temp = list.dup
        cols = []
        cols = temp.select_indice{|x| x == 0}
        test_ag = (1..9).to_a
#          print "temp: " + temp.to_s
#         puts ""
        num = 0
        temp.delete(0)
        miss_value = test_ag - temp
#         print miss_value
#         puts ""
#         
#         print cols
#         puts ""
        return miss_value, cols
    end
end

def n; puts "\n"; end

board_rows = [[9,5,4,2,8,6,3,1,0],
              [2,1,7,9,4,3,6,8,5],
              [8,0,3,0,5,0,0,2,9],
              [4,8,5,6,3,7,0,9,0],
              [1,3,2,5,9,0,7,4,0],
              [6,7,9,4,0,2,5,3,8],
              [7,9,0,1,6,4,0,5,0],
              [5,0,1,0,0,9,8,6,0],
              [0,0,6,8,0,5,9,7,1]]

display = Display_Board.new
first_calcs = Simple_calcs.new
second_calcs = Cross_meet.new
display.num_highlight()
n()
display.display_board(board_rows)
board_rows = first_calcs.main(board_rows)
second_calcs.main(board_rows)
board_rows = first_calcs.main(board_rows)
n()
display.display_board(board_rows)
n()