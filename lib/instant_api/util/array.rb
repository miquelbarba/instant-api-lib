
class Array
  # [a]       -> a
  # [a, b, c] -> { a => { b => c } }
  def array_to_hash
    head, *tail = *self
    if tail.empty?
      head
    elsif tail.size == 1
      {head => tail.first}
    else
      {head => tail.array_to_hash}
    end
  end
end