defmodule Stellar.Base.Test do
  use ExUnit.Case, async: true
  alias Stellar.Base

  setup do
    bypass = Bypass.open
    url = "http://localhost:#{bypass.port}"
    Application.put_env(:stellar, :network, url)
    {:ok, bypass: bypass}
  end

  describe "get_network_url" do
    test "returns test network when :test specified" do
      assert Base.get_network_url(:test) == "https://horizon-testnet.stellar.org"
    end

    test "returns public network when :public specified" do
      assert Base.get_network_url(:public) == "https://horizon.stellar.org"
    end

    test "returns url when a string is specified" do
      assert Base.get_network_url("http://example.com") == "http://example.com"
    end
  end

  describe "process_query_params" do
    test "returns empty string when params is empty" do
      assert Base.process_query_params([]) == ""
    end

    test "returns query string when params is not empty" do
      assert Base.process_query_params([asset_code: "USD"]) == "?asset_code=USD"
    end
  end

  describe "general error responses" do
    test "Handles error response", %{bypass: bypass} do
      Bypass.expect_once bypass, "GET", "/accounts/unknown_id", fn conn ->
        Plug.Conn.resp(conn, 404, ~s<{"status": 404, "type": "https://stellar.org/horizon-errors/not_found", "title": "Resource Missing"}>)
      end

      assert {:error, %{"status" => 404}} = Base.get("/accounts/unknown_id")
    end

    test "Handles http client error", %{bypass: bypass} do
      Bypass.expect bypass, fn conn ->
        Plug.Conn.resp(conn, 200, "{}")
      end

      assert {:ok, _} = Base.get("/accounts/unknown_id")

      Bypass.down(bypass)

      assert {:error, %{"detail" => :econnrefused}} = Base.get("/accounts/unknown_id")
    end
  end
end
