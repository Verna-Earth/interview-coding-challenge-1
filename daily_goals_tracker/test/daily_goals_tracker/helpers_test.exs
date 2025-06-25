defmodule DailyGoalsTracker.HelpersTest do
  use DailyGoalsTracker.DataCase, async: true

  alias DailyGoalsTracker.Helpers

  describe "as_percentage/1" do
    test "it should calc percentage and return a whole number" do
      assert Helpers.as_percentage(2, 4) == 50
    end

    test "it should calc percentage and return fraction rounded to two decimal places" do
      assert Helpers.as_percentage(1, 3) == 33.33
    end
  end
end
