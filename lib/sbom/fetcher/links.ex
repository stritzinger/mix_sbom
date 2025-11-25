defmodule SBoM.Fetcher.Links do
  @moduledoc false

  @type t() :: %{optional(String.t()) => String.t()}

  @source_url_names [
    "github",
    "gitlab",
    "git",
    "source",
    "repository",
    "bitbucket"
  ]

  @type links_map() :: %{atom() => String.t()} | %{String.t() => String.t()}
  @spec source_url(links :: links_map()) :: String.t() | nil
  def source_url(links) when is_map(links) do
    links
    |> normalize_keys()
    |> do_source_url()
  end

  @spec normalize_keys(links :: links_map()) :: %{String.t() => String.t()}
  def normalize_keys(links) do
    Enum.into(links, %{}, fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      {key, value} when is_binary(key) -> {key, value}
    end)
  end

  defp do_source_url(links) do
    Enum.find_value(links, fn {name, url} ->
      if String.downcase(name) in @source_url_names do
        url
      end
    end)
  end

end
