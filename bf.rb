# Ruby version of a Brainfuck interpreter
# written in the language Nim (http://nim-lang.org/)
#
# Source: http://howistart.org/posts/nim/1
class Brainfuck
  attr_reader :code, :tape, :io_out, :io_in

  def initialize(code)
    @code     = code
    @tape     = []
    @code_pos = 0
    @tape_pos = 0
    @io_out   = STDOUT
    @io_in    = STDIN
  end

  def self.run(code)
    new(code).run
  end

  def run(skip = false)
    while @tape_pos >= 0 && @code_pos < code.length
      tape.push(0) if @tape_pos >= tape.length

      if code[@code_pos] == '['
        @code_pos += 1
        old_pos  = @code_pos
        @code_pos = old_pos while run(tape[@tape_pos] == 0)
      elsif code[@code_pos] == ']'
        return tape[@tape_pos] != 0
      elsif !skip
        case code[@code_pos]
        when '+' then tape[@tape_pos] += 1
        when '-' then tape[@tape_pos] -= 1
        when '>' then @tape_pos += 1
        when '<' then @tape_pos -= 1
        when '.' then print_char(tape[@tape_pos])
        when ',' then tape[@tape_pos] = next_char_ord
        else
        end
      end
      @code_pos += 1
    end
  end

  private

  def print_char(char)
    io_out.print char.chr
  end

  def next_char_ord
    io_in.readchar.ord # Char ordinance
  end
end

puts 'Welcome to Brainfuck.'
puts "Running your code..."
puts

path = ARGV[0] or fail 'Requried argument: <file> missing'
fail 'Must be a Brainfuck source file' unless path.end_with?('.b')

code = File.read(path)
Brainfuck.run(code) and puts
