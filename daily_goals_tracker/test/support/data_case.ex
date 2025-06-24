defmodule DailyGoalsTracker.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
    end
  end

  setup _tags do
    :ok = DailyGoalsTracker.Store.clear()
    :ok
  end
end
