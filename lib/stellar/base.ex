defmodule Stellar.Base do
  @moduledoc false

  def get(endpoint, headers \\ %{}) do
    network = Application.get_env(:stellar, :network, :public)
    url = get_url(network)

    HTTPoison.get(url <> endpoint, headers)
    |> process_response()
  end

  defp get_url(:test) do
    "https://horizon-testnet.stellar.org"
  end

  defp get_url(:public) do
    "https://horizon.stellar.org"
  end

  def process_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}}
      when status_code >= 200 and status_code < 300 ->
        {:ok, Poison.decode!(body)}

      {:ok, %HTTPoison.Response{body: body}} ->
        {:error, Poison.decode!(body)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{"detail" => reason}}
    end
  end
end
