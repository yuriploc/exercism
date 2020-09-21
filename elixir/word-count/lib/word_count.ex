defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    capture_words(sentence)
  end

  defp capture_words(words) do
    words
    |> String.downcase()
    |> (&Regex.split(~r{[\s_]}, &1)).()
    |> Enum.map(&clean_word/1)
    |> Enum.filter(fn word -> word != nil end)
    |> Enum.flat_map(fn word -> word end)
    |> Enum.reduce(%{}, fn x, acc ->
      with {:ok, value} <- Map.fetch(acc, x),
           true <- is_number(value) do
        {_, m} = Map.get_and_update(acc, x, fn v -> {v, v + 1} end)
        m
      else
        :error -> Map.put(acc, x, 1)
      end
    end)
  end

  # Removes unwanted symbols from the words
  defp clean_word(word) do
    Regex.run(~r/^[[:alnum:]]+[-]?[[:alpha:]]*/iu, word, trim: true)
  end
end
