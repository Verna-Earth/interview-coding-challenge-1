defmodule BulletWeb.ReportingLive.Index do
  use BulletWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div>To be implemented</div>
    """
  end
end
