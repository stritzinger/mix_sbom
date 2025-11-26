defmodule AppNameToReplace.MixProject do
  use Mix.Project

  def project do
    [
      app: :app_atom_links,
      version: "0.0.0-dev",
      deps: [
        {:phoenix, "~> 1.6"},
        {:phoenix_html, "~> 4.0"},
        {:phoenix_html_helpers, "~> 1.0"}
      ],
      package: [
        links: %{
          Github: "https://github.com/app_atom_links",
          Changelog: "https://hexdocs.pm/app_atom_links/changelog.html"
        }
      ]
    ]
  end
end
