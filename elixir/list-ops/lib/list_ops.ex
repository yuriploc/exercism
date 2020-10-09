defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: count(0, l)
  defp count(counter, []), do: counter
  defp count(counter, [_h | t]), do: count(counter + 1, t)

  @spec reverse(list) :: list
  def reverse(l), do: reverse(l, [])
  defp reverse([], acc), do: acc
  defp reverse([h | t], acc), do: reverse(t, [h | acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    map(l, f, [])
  end

  defp map([], _f, acc), do: reverse(acc)
  defp map([h | t], f, n), do: map(t, f, [f.(h) | n])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    filter(l, f, [])
    |> reverse()
  end

  def filter([], _f, acc) do
    acc
  end

  def filter([h | t], f, acc) do
    if f.(h) do
      filter(t, f, [h | acc])
    else
      filter(t, f, acc)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _f), do: acc
  def reduce([h | t], acc, f), do: reduce(t, f.(h, acc), f)

  @spec append(list, list) :: list
  def append(a, b) do
    reduce(reverse(a), b, fn item, acc -> [item | acc] end)
  end

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    reduce(reverse(ll), [], &append/2)
  end
end
