defmodule MarkovTest do
  use ExUnit.Case
  doctest Markov

  describe "get_chain/2" do
    test "creates a markov chain from the list provided of order 1" do
      list = ["the", "cat", "in", "the", "hat"]
      order = 1
      expected_chain = %{
        "the" => ["cat", "hat"],
        "cat" => ["in"],
        "in" => ["the"],
        "hat" => [],
      }

      assert Markov.get_chain(list, order) === expected_chain
    end

    test "creates a markov chain from the list provided of order 2" do
      list = ["the", "cat", "in", "the", "hat"]
      order = 2
      expected_chain = %{
        "the cat" => ["in"],
        "cat in" => ["the"],
        "in the" => ["hat"],
        "the hat" => [],
      }
      assert Markov.get_chain(list, order) === expected_chain
    end
  end

  describe "get_random_follower/2" do
    test "returns a follower from Markov chain based on the key" do
      chain = %{
        "the cat" => ["in"],
        "cat in" => ["the"],
        "in the" => ["hat"],
        "the hat" => [],
      }
      key = "the cat"
      expected_result = "in"
      assert Markov.get_random_follower(chain, key) === expected_result
    end

    test "returns a random follower from Markov chain based on the key" do
      chain = %{
        "the" => ["cat", "hat"]
      }
      key = "the"
      assert Markov.get_random_follower(chain, key) === "cat" || "hat"
    end

    test "returns nil for a case with no followers" do
      chain = %{
        "the hat" => [],
      }
      key = "the hat"
      expected_result = nil
      assert Markov.get_random_follower(chain, key) === expected_result
    end
  end

  describe "get_key/2" do
    test "returns the next 1st order key from a reversed list" do
      list = ["in", "cat", "the"]
      order = 1
      assert Markov.get_key(list, order) === "in"
    end

    test "returns the next 2nd order key from a reversed list" do
      list = ["in", "cat", "the"]
      order = 2
      assert Markov.get_key(list, order) === "cat in"
    end
  end

  describe "get_initial_key/2" do
    test "returns a random key from the chain" do
      chain = %{
        "the cat" => ["in"],
        "cat in" => ["the"]
      }
      assert Markov.get_initial_key(chain) === "the cat" || "cat in"
    end
  end

  describe "get_list_length/1" do
    test "returns the length of the list provided with whitepsace added" do
      list = ["the", "cat"]
      assert Markov.get_list_length(list) === 7
    end
  end

  describe "extend_list/5" do
    test "returns an extended text list if the length is less than the max_length" do
      chain = %{
        "the cat" => ["in"],
        "cat in" => ["the"],
        "in the" => ["hat"],
        "the hat" => [],
      }
      order = 2
      config = %{
        chain: chain,
        order: order,
      }
      max_length = 11
      list = ["cat", "the"]
      key = "the cat"
      length = 5
      expected_list = ["in", "cat", "the"]
      assert Markov.extend_list(config, max_length, list, key, length) === expected_list
    end

    test "returns an extended text list if the length is equal to the max_length" do
      chain = %{
        "the cat" => ["in"],
        "cat in" => ["the"],
        "in the" => ["hat"],
        "the hat" => [],
      }
      order = 2
      config = %{
        chain: chain,
        order: order,
      }
      max_length = 5
      list = ["cat", "the"]
      key = "the cat"
      length = 5
      expected_list = ["cat", "the"]
      assert Markov.extend_list(config, max_length, list, key, length) === expected_list
    end

    test "returns the original list if the chain has no followers" do
      chain = %{
        "the hat" => [],
      }
      order = 2
      config = %{
        chain: chain,
        order: order,
      }
      max_length = 10
      list = ["hat", "the"]
      key = "the hat"
      length = 5
      assert Markov.extend_list(config, max_length, list, key, length) === list
    end

    test "returns the text list tail if the length is greater than the max_length" do
      max_length = 5
      list = ["in", "cat", "the"]
      length = 8
      expected_list = ["cat", "the"]
      assert Markov.extend_list(%{}, max_length, list, 0, length) === expected_list
    end
  end

  describe "generate_reverse_text_list/4" do
    test "returns a reversed list of strings from the chain using the provided order, max_length, and key" do
      chain = %{
        "the" => ["cat", "hat"],
        "cat" => ["in"],
        "in" => ["the"],
        "hat" => [],
      }
      order = 1
      config = %{
        chain: chain,
        order: order,
      }
      max_length = 15
      list = ["cat", "the"]
      key = "cat"
      expected_list = ["the", "in", "cat", "the"]
      assert Markov.generate_reverse_text_list(config, max_length, list, key) === expected_list
    end
  end

  describe "generate_text/1-4" do
    test "returns a string" do
      source_text = "cat"
      assert Markov.generate_text(source_text) === "cat"
    end

    test "returns a string using a 2nd order Markov chain generated from the source text" do
      source_text = "the cat in the hat"
      assert Markov.generate_text(source_text, 2, 140, "the cat") === "the cat in the hat"
    end

    test "returns a string of max_length Markov chain generated from the source text" do
      source_text = "the cat in the hat"
      assert Markov.generate_text(source_text, 2, 14, "the cat") === "the cat in the"
    end
  end

  describe "generate_text_with_word/2" do
    test "returns a string of max_length 140 generated by a Marckov chain of order 1 with the staring text provided" do
      body = "the quick brown fox jumps over a lazy dog"
      expected_result = "fox jumps over a lazy dog"
      assert Markov.generate_text_with_word(body, "fox") === expected_result
    end
  end
end
