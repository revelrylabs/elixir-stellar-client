defmodule Stellar.API.Base do
  @moduledoc false

  def get(endpoint, headers \\ %{}) do
    url = get_url()

    HTTPoison.get(url <> endpoint, headers, options())
    |> process_response()
  end

  def post(endpoint, body, headers \\ %{}) do
    url = get_url()

    HTTPoison.post(url <> endpoint, body, headers, options())
    |> process_response()
  end

  defp options do
    default_options = [recv_timeout: 30_000, timeout: 30_000]
    override_options = Application.get_env(:stellar, :hackney_options, [])

    Keyword.merge(default_options, override_options)
  end

  defp get_url() do
    network = Application.get_env(:stellar, :network, :public)
    get_network_url(network)
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
