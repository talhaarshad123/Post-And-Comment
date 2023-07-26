defmodule PostandcommentWeb.HandleError do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <%= for error <- @errors do %>
      <div class="flex justify-start text-gray-700 rounded-md px-2 py-2 my-2">
        <span class="bg-gray-400 h-2 w-2 m-2 rounded-full"></span>
        <div class="flex-grow font-medium px-2"><%= error %></div>
      </div>
    <% end %>
    """
  end
end
