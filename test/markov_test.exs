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
end
