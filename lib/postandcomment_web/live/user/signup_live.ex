defmodule PostandcommentWeb.User.SignupLive do
  use Phoenix.LiveView
  alias Postandcomment.Context.Users
  alias Postandcomment.VerifyEmail
  alias Postandcomment.Mailer


  def render(assigns) do
    ~L"""
    <form phx-submit="save">
      <div class="bg-grey-lighter min-h-screen flex flex-col">
        <div class="container max-w-sm mx-auto flex-1 flex flex-col items-center justify-center px-2">
          <div class="bg-white px-6 py-8 rounded shadow-md text-black w-full">
            <h1 class="mb-8 text-3xl text-center">Sign up</h1>
              <input
              type="email"
              class="block border border-grey-light w-full p-3 rounded mb-4"
              name="current_user[email]" required
              placeholder="Email" />

              <input
              type="text"
              class="block border border-grey-light w-full p-3 rounded mb-4"
              name="current_user[profession]" required
              placeholder="Profession" />
              <input
              type="text"
              class="block border border-grey-light w-full p-3 rounded mb-4"
              name="current_user[phone_number]" required
              placeholder="Phone Number" />

              <input
              type="date"
              class="block border border-grey-light w-full p-3 rounded mb-4"
              name="current_user[date_of_birth]" required
              placeholder="Date Of Birth" />

              <p>
                <label>
                  <input type="radio" value="male" name="current_user[gender]">
                  <span>Male</span>
                </label>
              </p>
              <p>
                <label>
                  <input type="radio" value="female" name="current_user[gender]">
                  <span>Female</span>
                </label>
              </p>

              <input
              type="password"
              class="block border border-grey-light w-full p-3 rounded mb-4"
              name="current_user[password]" required
              placeholder="Password" />
              <%= PostandcommentWeb.HandleError.render(assigns) %>
              <button
                type="submit"
                class="btn btn--primary center w-full"
              >Create Account</button>
          </div>

          <div class="text-grey-dark mt-6">
              Already have an account?
              <a class="no-underline border-b border-blue text-blue" href="/login">
                Log in
              </a>.
          </div>
        </div>
      </div>
    </form>
    """
  end

  def mount(_params, %{"auth_key" => _token}, socket) do
    {:ok, socket |> redirect(to: "/")}
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(errors: [])}
  end

  def handle_event("save", %{"current_user" => %{"date_of_birth" => date_of_birth} = user}, socket) do
    [year, month, day] = date_of_birth |> String.split("-", trim: true)
    {:ok, dob} = Date.new(String.to_integer(year), String.to_integer(month), String.to_integer(day))

    Map.put(user, "date_of_birth", dob)
    |> Users.create()
    |> case do
      {:ok, user} ->
        spawn(fn -> do_send_email(user) end)
        {:noreply, socket |> put_flash(:info, "User created. Verify Email") |> redirect(to: "/login")}
      {:error, changeset} ->
        IO.inspect(changeset)
        errors = changeset.errors |> Enum.map(fn {key, {msg, _}} -> to_string(key) <> " " <> msg end)
        {:noreply, socket |> assign(errors: errors)}
    end
  end

  defp do_send_email(user) do
    VerifyEmail.verify(user) |> Mailer.deliver()
  end
end
