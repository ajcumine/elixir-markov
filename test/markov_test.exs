defmodule MarkovTest do
  use ExUnit.Case
  doctest Markov

  describe "create_chain/2" do
    test "creates a markov chain from the text provided of order 1" do
      text = ["a", "cat", "in", "a", "hat"]
      order = 1
      expected_chain = %{
        "a" => ["cat", "hat"],
        "cat" => ["in"],
        "in" => ["a"],
        "hat" => [],
      }

      assert Markov.create_chain(text, order) === expected_chain
    end

    test "creates a markov chain from the text provided of order 2" do
      text = ["a", "cat", "in", "a", "hat"]
      order = 2
      expected_chain = %{
        "a cat" => ["in"],
        "cat in" => ["a"],
        "in a" => ["hat"],
        "a hat" => [],
      }
      assert Markov.create_chain(text, order) === expected_chain
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
end
