defmodule LinkedList do
  @opaque t :: map()
  @empty_list %{value: nil, next: nil}
  @empty_list_error {:error, :empty_list}

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new(), do: @empty_list

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem), do: %{value: elem, next: list}

  @doc """
  Calculate the length of a LinkedList
  """
  @spec length(t) :: non_neg_integer()
  def length(list), do: length(list.next, 0)

  defp length(nil, counter), do: counter
  defp length(list, counter), do: length(list.next, counter + 1)

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?(list) do
    case list.next do
      nil -> true
      _ -> false
    end
  end

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek(list) do
    case empty?(list) do
      true -> @empty_list_error
      _ -> {:ok, list.value}
    end
  end

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail(list), do: tail(list.value, list.next)

  defp tail(nil, _next), do: @empty_list_error
  defp tail(_value, next), do: {:ok, next}

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop(list), do: pop(list.value, list.next, list)

  @spec pop(any, any, any) ::
          {:error, :empty_list} | {:ok, any, {:error, :empty_list} | {:ok, any}}
  defp pop(nil, _next, _list), do: @empty_list_error
  defp pop(value, _next, list), do: {:ok, value, list.next}

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list([]), do: new()
  def from_list(list), do: Enum.reverse(list) |> from_list(new())

  defp from_list([head | tail], llist), do: push(llist, head) |> (&from_list(tail, &1)).()
  defp from_list([], llist), do: llist

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(llist) do
    to_list(llist.value, llist.next, []) |> Enum.reverse()
  end

  defp to_list(nil, _next, acc), do: acc
  defp to_list(value, next, acc), do: to_list(next.value, next.next, [value | acc])

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list) do
    reverse(list, new())
  end

  defp reverse(list, acc) do
    case empty?(list) do
      true ->
        acc

      _ ->
        {:ok, last, rest} = pop(list)
        push(acc, last) |> (&reverse(rest, &1)).()
    end
  end
end
