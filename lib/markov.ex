defmodule Markov do
  @moduledoc """
  Documentation for Markov.
  """

  @doc """
  get_chain/2
  returns the Markov chain for a provided list and order

  ## Examples
      iex> list = ["the", "cat", "in", "the", "hat"]
      iex> Markov.get_chain(list, 1)
      %{
        "the" => ["cat", "hat"],
        "cat" => ["in"],
        "in" => ["the"],
        "hat" => [],
      }
      iex> Markov.get_chain(list, 2)
      %{
        "the cat" => ["in"],
        "cat in" => ["the"],
        "in the" => ["hat"],
        "the hat" => [],
      }
  """
  def get_chain(list, order) do
    list
    |> Enum.chunk_every(order + 1, 1)
    |> Enum.reduce(%{}, fn(x, chain) ->
      s = Enum.split(x, order)
      key = s |> elem(0) |> Enum.join(" ")
      follower = elem(s, 1)
      if Map.has_key?(chain, key) do
        Map.merge(chain, %{key => follower}, fn(_k, v1, v2) ->
          v1 ++ v2
        end)
      else
        Map.put(chain, key, follower)
      end
    end)
  end

  @doc """
  get_random_follower/2
  returns a random follower from Markov chain based on the key

  ## Examples
      iex> chain = %{"the cat" => ["in"], "cat in" => ["the"], "in the" => ["hat"], "the hat" => []}
      iex> Markov.get_random_follower(chain, "the cat")
      "in"
  """
  def get_random_follower(chain, key) do
    chain
    |> Map.get(key)
    |> Enum.take_random(1)
    |> List.first
  end

  @doc """
  get_key/2
  returns the next nth order key from a reversed list

  ## Examples
      iex> list = ["in", "cat", "the"]
      iex> Markov.get_key(list, 1)
      "in"
      iex> Markov.get_key(list, 2)
      "cat in"
  """
  def get_key(list, order) do
    list
    |> Enum.chunk_every(order)
    |> List.first()
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  @doc """
  get_initial_key/1
  returns a random key from the chain

  ## Examples
      iex> chain = %{ "the cat" => ["in"] }
      iex> Markov.get_initial_key(chain)
      "the cat"
  """
  def get_initial_key(chain) do
    chain
    |> Enum.take_random(1)
    |> hd()
    |> elem(0)
  end

  @doc """
  get_list_length/1
  returns the length of the list provided with whitepsace added

  ## Examples
      iex> list = ["the", "cat"]
      iex> Markov.get_list_length(list)
      7
  """
  def get_list_length(list) do
    list |> Enum.join(" ") |> String.length()
  end

  @doc """
  extend_list/5
  returns the list prepending a random key from the chain based on:
  the key, chain, order, and max_length

  ## Examples
      iex> chain = %{ "the cat" => ["in"], "cat in" => ["the"], "in the" => ["hat"], "the hat" => [] }
      iex> order = 2
      iex> config = %{ chain: chain, order: order }
      iex> max_length = 11
      iex> list = ["cat", "the"]
      iex> key = "the cat"
      iex> length = 5
      iex> Markov.extend_list(config, max_length, list, key, length)
      ["in", "cat", "the"]
  """
  def extend_list(_, max_length, list, _, length) when length > max_length do
    tl(list)
  end

  def extend_list(config, max_length, list, key, _) do
    follower = get_random_follower(config.chain, key)
    if follower do
      next_list = [follower | list]
      next_length = get_list_length(next_list)
      next_key = get_key(next_list, config.order)
      extend_list(config, max_length, next_list, next_key, next_length)
    else
      list
    end
  end

  @doc """
  generate_reverse_text_list/4
  returns a reversed list of strings from the chain
  using the provided order, max_length, and key

  ## Examples
      iex> chain = %{ "the cat" => ["in"], "cat in" => ["the"], "in the" => ["hat"], "the hat" => [] }
      iex> order = 2
      iex> config = %{ chain: chain, order: order }
      iex> max_length = 15
      iex> list = ["in", "cat", "the"]
      iex> key = "cat in"
      iex> Markov.generate_reverse_text_list(config, max_length, list, key)
      ["the", "in", "cat", "the"]
  """
  def generate_reverse_text_list(config, max_length, list, key) do
    length = get_list_length(list)
    extend_list(config, max_length, list, key, length)
  end

  @doc """
  generate_text/1-4
  returns a string of text generated by a
  Markov chain from the source text passed to it

  default arguments:
  order = 1
  max_length = 140

  ## Examples
      iex> body = "cat in the hat"
      iex> Markov.generate_text(body, 1, 10, "cat")
      "cat in the"
  """
  def generate_text(source_text, order \\ 1, max_length \\ 140, focus \\ nil) do
    text_list = String.split(source_text)
    chain = get_chain(text_list, order)
    initial_key = if focus, do: focus, else: get_initial_key(chain)
    initial_list = initial_key |> String.split() |> Enum.reverse
    %{
      chain: chain,
      order: order,
    }
    |> generate_reverse_text_list(max_length, initial_list, initial_key)
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  @doc """
  generate_text_with_word/2
  returns a string of text generated by a
  Markov chain from the source text passed to it
  with the starting word passed in

  ## Examples
      iex> body = "the quick brown fox jumps over a lazy dog"
      iex> Markov.generate_text_with_word(body, "fox")
      "fox jumps over a lazy dog"
  """
  def generate_text_with_word(source_text, focus) do
    generate_text(source_text, 1, 140, focus)
  end
end
