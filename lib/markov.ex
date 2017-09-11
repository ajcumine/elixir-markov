defmodule Markov do
  @moduledoc """
  Documentation for Markov.
  """

  @doc """
  get_chain/2
  returns the Markov chain for a provided list and order

  ## Examples
      iex> list = ["a", "cat", "in", "a", "hat"]
      iex> Markov.get_chain(list, 1)
      %{
        "a" => ["cat", "hat"],
        "cat" => ["in"],
        "in" => ["a"],
        "hat" => [],
      }
      iex> Markov.get_chain(list, 2)
      %{
        "a cat" => ["in"],
        "cat in" => ["a"],
        "in a" => ["hat"],
        "a hat" => [],
      }
  """
  def get_chain(list, order) do
    Enum.chunk_every(list, order + 1, 1)
    |> Enum.reduce(%{}, fn(x, acc) ->
      s = Enum.split(x, order)
      g = elem(s, 0) |> Enum.join(" ")
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

  @doc """
  get_random_follower/2
  returns a random follower from Markov chain based on the gram

  ## Examples
      iex> chain = %{"a cat" => ["in"], "cat in" => ["a"], "in a" => ["hat"], "a hat" => []}
      iex> Markov.get_random_follower(chain, "a cat")
      "in"
  """

  def get_random_follower(chain, gram) do
    Map.get(chain, gram)
    |> Enum.take_random(1)
    |> List.first()
  end

  @doc """
  get_gram/2
  returns the next nth order gram from a reversed list

  ## Examples
      iex> list = ["in", "cat", "a"]
      iex> Markov.get_gram(list, 1)
      "in"
      iex> Markov.get_gram(list, 2)
      "cat in"
  """

  def get_gram(list, order) do
    Enum.chunk_every(list, order)
    |> List.first()
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  @doc """
  get_initial_gram/2
  returns the next nth order initial gram from a list

  ## Examples
      iex> list = ["a", "cat", "in", "a", "hat"]
      iex> Markov.get_initial_gram(list, 1)
      "a"
      iex> Markov.get_initial_gram(list, 2)
      "a cat"
  """

  def get_initial_gram(list, order) do
    Enum.chunk_every(list, order)
    |> List.first()
    |> Enum.join(" ")
  end

  @doc """
  build_text_list/4
  returns a tuple of the new text list and it's length

  ## Examples
      iex> list = ["in", "cat", "a"]
      iex> chain = %{ "a cat" => ["in"], "cat in" => ["a"], "in a" => ["hat"], "a hat" => [] }
      iex> gram = "cat in"
      iex> Markov.build_text_list(list, chain, gram)
      { ["a", "in", "cat", "a"],  10 }
  """
  def build_text_list(list, chain, gram) do
    new_list = [get_random_follower(chain, gram) | list]
    { new_list, Enum.join(new_list, " ") |> String.length() }
  end
end
