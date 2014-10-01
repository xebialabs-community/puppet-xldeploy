require 'open-uri'
require 'net/http'

#based on http://stanislavvitvitskiy.blogspot.fr/2008/12/multipart-post-in-ruby.html

class StreamPart
  def initialize(stream, size)
    @stream, @size = stream, size
  end

  def size
    @size
  end

  def read (offset, how_much)
    @stream.read(how_much)
  end
end

class StringPart
  def initialize (str)
    @str = str
  end

  def size
    @str.length
  end

  def read (offset, how_much)
    @str[offset, how_much]
  end
end

class MultipartStream
  def initialize(parts)
    @parts = parts
    @part_no = 0;
    @part_offset = 0;
  end

  def size
    total = 0
    @parts.each do |part|
      total += part.size
    end
    total
  end

  def read (how_much)

    if @part_no >= @parts.size
      return nil;
    end

    how_much_current_part = @parts[@part_no].size - @part_offset

    how_much_current_part = if how_much_current_part > how_much
                              how_much
                            else
                              how_much_current_part
                            end

    how_much_next_part = how_much - how_much_current_part

    current_part = @parts[@part_no].read(@part_offset, how_much_current_part)

    if how_much_next_part > 0
      @part_no += 1
      @part_offset = 0
      next_part = read(how_much_next_part)
      current_part + if next_part
                       next_part
                     else
                       ''
                     end
    else
      @part_offset += how_much_current_part
      current_part
    end
  end
end
