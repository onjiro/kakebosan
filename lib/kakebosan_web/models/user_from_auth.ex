defmodule UserFromAuth do
  @moduledoc """
  Retrieve the user information from an auth request
  @see https://github.com/ueberauth/ueberauth_example
  """
  require Logger
  require Jason

  alias Ueberauth.Auth
  alias Kakebosan.User
  alias Kakebosan.Accounting

  @type t :: %__MODULE__{
          provider: String.t() | atom,
          uid: String.t(),
          name: String.t(),
          avatar: String.t()
        }

  defstruct provider: nil,
            uid: nil,
            name: nil,
            avatar: nil

  def find_or_create(%Auth{provider: :identity} = auth) do
    case validate_pass(auth.credentials) do
      :ok ->
        find_or_create(basic_info(auth))

      {:error, reason} ->
        {:error, reason}
    end
  end

  def find_or_create(%Auth{} = auth) do
    find_or_create(basic_info(auth))
  end

  def find_or_create(%UserFromAuth{} = auth) do
    case User.find_or_create(auth) do
      {:created, user} ->
        Accounting.Item.create_from_seeds(user)
        {:ok, user}

      {_, user} ->
        {:ok, user}
    end
  end

  # github does it this way
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  # facebook does it this way
  defp avatar_from_auth(%{info: %{image: image}}), do: image

  # default case if nothing matches
  defp avatar_from_auth(auth) do
    Logger.warn("#{auth.provider} needs to find an avatar URL!")
    Logger.debug(Jason.encode!(auth))
    nil
  end

  defp basic_info(auth) do
    %UserFromAuth{
      provider: auth.provider,
      uid: auth.uid,
      name: name_from_auth(auth),
      avatar: avatar_from_auth(auth)
    }
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if Enum.empty?(name) do
        auth.info.nickname
      else
        Enum.join(name, " ")
      end
    end
  end

  defp validate_pass(%{other: %{password: ""}}) do
    {:error, "Password required"}
  end

  defp validate_pass(%{other: %{password: pw, password_confirmation: pw}}) do
    :ok
  end

  defp validate_pass(%{other: %{password: _}}) do
    {:error, "Passwords do not match"}
  end

  defp validate_pass(_), do: {:error, "Password Required"}
end
