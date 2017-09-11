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
  extend_list/6
  returns the list prepending a random gram from the chain based on:
  the gram, chain, order, and max_length

  ## Examples
      iex> chain = %{ "a cat" => ["in"], "cat in" => ["a"], "in a" => ["hat"], "a hat" => [] }
      iex> order = 2
      iex> max_length = 9
      iex> list = ["cat", "a"]
      iex> gram = "a cat"
      iex> length = 5
      iex> Markov.extend_list(chain, order, max_length, list, gram, length)
      ["in", "cat", "a"]
  """
  def extend_list(_, _, max_length, list, _, length) when length > max_length do
    tl(list)
  end

  def extend_list(chain, order, max_length, list, gram, _) do
    next_list = [get_random_follower(chain, gram) | list]
    next_length = Enum.join(next_list, " ") |> String.length()
    next_gram = get_gram(next_list, order)
    extend_list(chain, order, max_length, next_list, next_gram, next_length)
  end

  @doc """
  generate_reverse_text_list/5
  returns a reversed list of strings from the chain
  using the provided order, max_length, and gram

  ## Examples
      iex> chain = %{ "a cat" => ["in"], "cat in" => ["a"], "in a" => ["hat"], "a hat" => [] }
      iex> order = 2
      iex> max_length = 11
      iex> list = ["in", "cat", "a"]
      iex> gram = "cat in"
      iex> Markov.generate_reverse_text_list(chain, order, max_length, list, gram)
      ["a", "in", "cat", "a"]
  """
  def generate_reverse_text_list(chain, order, max_length, list, gram) do
    length = Enum.join(list, " ") |> String.length()
    extend_list(chain, order, max_length, list, gram, length)
  end
end
