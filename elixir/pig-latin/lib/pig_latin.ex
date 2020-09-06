defmodule PigLatin do
  @vowels ["a", "e", "i", "o", "u"]

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split(" ", trim: true)
    |> Enum.map(&pigalize/1)
    |> Enum.join(" ")
  end

  defp pigalize(word) do
    cond do
      starts_with_vowel?(word) || is_xy_vowel?(word) ->
        vowel_behavior(word)

      is_qu_consonant?(word) ->
        consonant_behavior(word, qu_index(word) + 1)

      true ->
        consonant_behavior(word, find_vowel_index(word))
    end
  end

  defp vowel_behavior(word), do: word <> "ay"

  defp starts_with_vowel?(word), do: String.starts_with?(word, @vowels)

  defp is_xy_vowel?(word) do
    String.starts_with?(word, ["x", "y"]) and not is_xy_consonant?(word)
  end

  # The combination "x"+vowel or "y"+vowel means the phrase has a
  # consonant behavior
  defp is_xy_consonant?(word) do
    xys = for vowel <- @vowels, do: ["x" <> vowel | ["y" <> vowel | []]]
    cons_behavior = xys |> List.flatten()

    word |> String.slice(0..1) |> String.contains?(cons_behavior)
  end

  defp is_qu_consonant?(word) do
    word |> String.slice(0..2) |> String.contains?("qu")
  end

  defp qu_index(word), do: word |> find_vowel_index("u")

  # Gets the index of the first vowel it finds
  defp find_vowel_index(phrase, vowel \\ @vowels) do
    phrase
    |> String.split("", trim: true)
    |> Enum.find_index(fn char -> String.contains?(char, vowel) end)
  end

  defp consonant_behavior(phrase, index) do
    {prefix, suffix} = phrase |> String.split_at(index)
    vowel_behavior(suffix <> prefix)
  end
end
