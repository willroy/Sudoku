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
        if zeros == 0 
            return board_rows
        else
            for i in 0..1
                print board_rows
                puts ""
                board_rows = row_checks(board_rows)
                board_rows = column_checks(board_rows)
                board_rows = block_checks(board_rows)
                print board_rows
            end
        end
    end
    def inp_out_tracker(board_rows)
#         board_rows =
        to_check_tracker(board_rows) #<< put on last line
        return board_rows
    end
    def row_checks(board_rows)
        for i in 0..8
#             print "i: " + i.to_s
            zeros = 0
#             puts ""
#             print "board_rows[0]: " + board_rows[0].to_s
#             puts ""
#             print "board_rows[i]: " + board_rows[i].to_s
#             puts ""
            zeros = board_rows[i].count(0)
            if zeros == 1
                miss_value = find_miss_num(board_rows[i])
#                 print miss_value
#                 puts ""
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
        #first three values of the first three is the first row
        #second three values of the first three is the second row
        #third three values of the first three is the third row
        #first three values of the first three is the fourth row
        #second three values of the first three is the fifth row
        #third three values of the first three is the sixth row
        return board_blocks
    end
    def block_revert
        
    end
    def block_checks(board_rows)
        board_blocks = block_make(board_rows)
        for i in 0..8
            zeros = 0
            zeros = board_blocks[i].count(0)
            if zeros == 1
                miss_value = find_miss_num(board_blocks[i])
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