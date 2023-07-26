defmodule PostandcommentWeb.HandleFlash do
  use Phoenix.LiveView
  alias Phoenix.Flash


  def render(assigns) do
    ~L"""
    <div><%= Flash.get(@flash, :info) %></div>
    <div><%= Flash.get(@flash, :error) %></div>
    """
  end
end
