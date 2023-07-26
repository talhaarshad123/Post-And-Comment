defmodule PostandcommentWeb.User.LoginLive do
  alias Postandcomment.Context.Users
  use Phoenix.LiveView
  import Argon2
  alias Postandcomment.Model.User
  alias Phoenix.Token


  def render(assigns) do
    ~L"""
    <%= PostandcommentWeb.HandleFlash.render(assigns) %>
    <form phx-submit="save">
      <div class="min-h-screen bg-gray-100 py-6 flex flex-col justify-center sm:py-12">
	      <div class="relative py-3 sm:max-w-xl sm:mx-auto">
		      <div class="absolute inset-0 bg-gradient-to-r from-blue-300 to-blue-600 shadow-lg transform -skew-y-6 sm:skew-y-0 sm:-rotate-6 sm:rounded-3xl"></div>
		        <div class="relative px-4 py-10 bg-white shadow-lg sm:rounded-3xl sm:p-20">
			        <div class="max-w-md mx-auto">
				        <div>
					        <h1 class="text-2xl font-semibold">Login</h1>
				        </div>
				        <div class="divide-y divide-gray-200">
              <div class="py-8 text-base leading-6 space-y-4 text-gray-700 sm:text-lg sm:leading-7">
                <div class="relative">
                  <input autocomplete="off" id="email" name="current_user[email]" type="text" class="peer placeholder-transparent h-10 w-full border-b-2 border-gray-300 text-gray-900 focus:outline-none focus:borer-rose-600" placeholder="Email address" />
                  <label for="email" class="absolute left-0 -top-3.5 text-gray-600 text-sm peer-placeholder-shown:text-base peer-placeholder-shown:text-gray-440 peer-placeholder-shown:top-2 transition-all peer-focus:-top-3.5 peer-focus:text-gray-600 peer-focus:text-sm">Email Address</label>
                </div>
                <div class="relative">
                  <input autocomplete="off" id="password" name="current_user[password]" type="password" class="peer placeholder-transparent h-10 w-full border-b-2 border-gray-300 text-gray-900 focus:outline-none focus:borer-rose-600" placeholder="Password" />
                  <label for="password" class="absolute left-0 -top-3.5 text-gray-600 text-sm peer-placeholder-shown:text-base peer-placeholder-shown:text-gray-440 peer-placeholder-shown:top-2 transition-all peer-focus:-top-3.5 peer-focus:text-gray-600 peer-focus:text-sm">Password</label>
                </div>
                <%= PostandcommentWeb.HandleError.render(assigns) %>
                    <div class="relative">
                      <button class="bg-blue-500 text-white rounded-md px-2 py-1" type="submit">Login</button>
                    </div>
                  </div>
				        </div>
			      </div>
		      </div>
	      </div>
      </div>
    </form>
    """
  end

  def mount(_params, %{"auth_key" => key}, socket) do
    with {:ok, _user_id} <- Token.verify(PostandcommentWeb.Endpoint, "somekey", key, max_age: 10800) do
      {:ok, socket |> put_flash(:error, "NOT ALLOWED") |> redirect(to: "/")}
    end

  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(errors: [])}
  end

  def handle_event("save", %{"current_user" => user}, socket) do
    case do_verify_user(user) do
      {:ok, valid_user} ->
        token = Token.sign(PostandcommentWeb.Endpoint, "somekey", valid_user.id)
         {:noreply, socket |> redirect(to: "/#{token}/login")}
      {:error, errors} -> {:noreply, socket |> assign(errors: errors)}
    end
  end


  defp do_verify_user(%{"email" => email, "password" => password}) do
    with %User{} = valid_user <- Users.get_user_by_email(email)
    do
      do_verify_pass(valid_user, password)
    else
      _ -> {:error, ["invalid email or password"]}
    end
  end

  defp do_verify_pass(user, plain_password) do
    with true <- verify_pass(plain_password, user.password),
    true <- is_verified_user?(user)
    do
      {:ok, user}
    else
      _ -> {:error, ["Please Verify Your Email"]}
    end
  end

  defp is_verified_user?(user), do: user.is_active


end
