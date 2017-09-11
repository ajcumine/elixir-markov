defmodule MarkovTest do
  use ExUnit.Case
  doctest Markov

  describe "get_chain/2" do
    test "creates a markov chain from the list provided of order 1" do
      list = ["a", "cat", "in", "a", "hat"]
      order = 1
      expected_chain = %{
        "a" => ["cat", "hat"],
        "cat" => ["in"],
        "in" => ["a"],
        "hat" => [],
      }

      assert Markov.get_chain(list, order) === expected_chain
    end

    test "creates a markov chain from the list provided of order 2" do
      list = ["a", "cat", "in", "a", "hat"]
      order = 2
      expected_chain = %{
        "a cat" => ["in"],
        "cat in" => ["a"],
        "in a" => ["hat"],
        "a hat" => [],
      }
      assert Markov.get_chain(list, order) === expected_chain
    end
  end

  describe "get_random_follower/2" do
    test "returns a random follower from Markov chain based on the gram" do
      chain = %{
        "a cat" => ["in"],
        "cat in" => ["a"],
        "in a" => ["hat"],
        "a hat" => [],
      }
      gram = "a cat"
      expected_result = "in"
      assert Markov.get_random_follower(chain, gram) === expected_result
    end
  end

  describe "get_gram/2" do
    test "returns the next 1st order gram from a reversed list" do
      list = ["in", "cat", "a"]
      order = 1
      assert Markov.get_gram(list, order) === "in"
    end

    test "returns the next 2nd order gram from a reversed list" do
      list = ["in", "cat", "a"]
      order = 2
      assert Markov.get_gram(list, order) === "cat in"
    end
  end

  describe "get_initial_gram/2" do
    test "returns the 1st order initial gram from the text_list" do
      list = ["a", "cat", "in", "a", "hat"]
      order = 1
      assert Markov.get_initial_gram(list, order) === "a"
    end

    test "returns the 2nd order initial gram from the text_list" do
      list = ["a", "cat", "in", "a", "hat"]
      order = 2
      assert Markov.get_initial_gram(list, order) === "a cat"
    end
  end

  describe "extend_list" do
    test "returns an extended text list if the length is less than the max_length" do
      chain = %{
        "a cat" => ["in"],
        "cat in" => ["a"],
        "in a" => ["hat"],
        "a hat" => [],
      }
      order = 2
      max_length = 9
      list = ["cat", "a"]
      gram = "a cat"
      length = 5
      expected_list = ["in", "cat", "a"]
      assert Markov.extend_list(chain, order, max_length, list, gram, length) === expected_list
    end

    test "returns an extended text list if the length is equal to the max_length" do
      chain = %{
        "a cat" => ["in"],
        "cat in" => ["a"],
        "in a" => ["hat"],
        "a hat" => [],
      }
      order = 2
      max_length = 5
      list = ["cat", "a"]
      gram = "a cat"
      length = 5
      expected_list = ["cat", "a"]
      assert Markov.extend_list(chain, order, max_length, list, gram, length) === expected_list
    end

    test "returns the text list tail if the length is greater than the max_length" do
      max_length = 5
      list = ["in", "cat", "a"]
      length = 8
      expected_list = ["cat", "a"]
      assert Markov.extend_list(0, 0, max_length, list, 0, length) === expected_list
    end
  end

  describe "generate_reverse_text_list/5" do
    test "returns a reversed list of strings from the chain using the provided order, max_length, and gram" do
      chain = %{
        "a" => ["cat", "hat"],
        "cat" => ["in"],
        "in" => ["a"],
        "hat" => [],
      }
      order = 1
      max_length = 11
      list = ["cat", "a"]
      gram = "cat"
      expected_list = ["a", "in", "cat", "a"]
      assert Markov.generate_reverse_text_list(chain, order, max_length, list, gram) === expected_list
    end
  end
end
