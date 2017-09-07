defmodule Markov do
  @moduledoc """
  Documentation for Markov.
  """

  @doc """
  create_chain/2 returns the Markov chain for a provided text and order

  ## Examples
      iex> text = ["a", "cat", "in", "a", "hat"]
      iex> Markov.create_chain(text, 1)
      %{
        "a" => ["cat", "hat"],
        "cat" => ["in"],
        "in" => ["a"],
        "hat" => [],
      }
      iex> Markov.create_chain(text, 2)
      %{
        "a cat" => ["in"],
        "cat in" => ["a"],
        "in a" => ["hat"],
        "a hat" => [],
      }
  """
  def create_chain(text, order) do
    Enum.chunk_every(text, order + 1, 1)
    |> Enum.reduce(%{}, fn(x, acc) ->
      s = Enum.split(x, order)
      g = Enum.join(elem(s, 0), " ")
      f = elem(s, 1)
      if Map.has_key?(acc, g) do
        Map.merge(acc, %{g => f}, fn _k, v1, v2 ->
          v1 ++ v2
        end)
      else
        Map.put(acc, g, f)
      end
    end)
  end
end
