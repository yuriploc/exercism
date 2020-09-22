defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> split
    |> Enum.filter(fn w -> String.length(w) > 0 end)
    |> count_words
  end

  defp split(sentence) do
    sentence
    |> String.split(~r/[^[:alnum:]-]/xiu, trim: true)
  end

  defp count_words(splitted_sentence) do
    splitted_sentence
    |> Enum.frequencies_by(&String.downcase/1)
  end
end
