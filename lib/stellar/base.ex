defmodule Stellar.Base do
  @moduledoc false

  def get(endpoint, headers \\ %{}) do
    network = Application.get_env(:stellar, :network, :public)
    url = get_network_url(network)

    HTTPoison.get(url <> endpoint, headers)
    |> process_response()
  end

  def get_network_url(:test), do: "https://horizon-testnet.stellar.org"
  def get_network_url(:public), do: "https://horizon.stellar.org"
  def get_network_url(url) when is_binary(url), do: url

  def process_query_params([]), do: ""
  def process_query_params(params), do: "?" <> URI.encode_query(params)

  defp process_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}}
      when status_code >= 200 and status_code < 300 ->
        {:ok, Jason.decode!(body)}

      {:ok, %HTTPoison.Response{body: body}} ->
        {:error, Jason.decode!(body)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{"detail" => reason}}
    end
  end
end
