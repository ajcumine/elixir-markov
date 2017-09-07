defmodule Markov do
  @moduledoc """
  Documentation for Markov.
  """

  @doc """
  create_chain/2 returns the Markov chain for a provided text and order

  ## Examples
      iex> text = ["a", "cat", "in", "a", "hat"]
      iex> order = 1
      iex> Markov.create_chain(text, order)
      %{
        "a" => ["cat", "hat"],
        "cat" => ["in"],
        "in" => ["a"],
        "hat" => [],
      }

  """
  def create_chain(text_list, order) do
    Enum.chunk_every(text_list, order + 1, 1)
    |> Enum.reduce(%{}, fn(x, acc) ->
      if Map.has_key?(acc, hd(x)) do
        Map.merge(acc, %{hd(x) => tl(x)}, fn _k, v1, v2 ->
          v1 ++ v2
        end)
      else
        Map.put(acc, hd(x), tl(x))
      end
    end)
  end
end
