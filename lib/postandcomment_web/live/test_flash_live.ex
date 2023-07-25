defmodule PostandcommentWeb.TestFlashLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <button phx-click="flashForLive">Flash For Live</button>
    <button phx-click="flashForCont">Flash For Cont</button>
    """
  end

  def mount(_, _, socket) do
    {:ok, socket}
  end

  def handle_event("flashForLive", _, socket) do
    {:noreply, put_flash(socket, :info, "FLASH FOR LIVE") |> redirect(to: "/")}
  end

  def handle_event("flashForCont", _, socket) do
    {:noreply, put_flash(socket, :info, "FLASH FOR CONT") |> redirect(to: "/test")}
  end
end
