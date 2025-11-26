# SPDX-License-Identifier: BSD-3-Clause
# SPDX-FileCopyrightText: 2025 Erlang Ecosystem Foundation

defmodule SBoM.Fetcher.MixFileTest do
  use SBoM.FixtureCase, async: false

  alias Mix.SCM.Git
  alias SBoM.Fetcher.MixFile
  alias SBoM.Util

  doctest MixFile

  describe inspect(&MixFile.fetch/1) do
    @tag :tmp_dir
    @tag fixture_app: "app_locked"
    test "generates valid manifest for 'app_locked' fixture", %{app_name: app_name, app_path: app_path} do
      Util.in_project(app_path, fn _mix_module ->
        assert %{
                 ^app_name => %{
                   runtime: true,
                   optional: false,
                   targets: :*,
                   only: :*,
                   licenses: ["MIT"],
                   dependencies: [:logger, :elixir, :public_key, :credo, :mime, :os_mon, :expo, :heroicons],
                   root: true,
                   source_url: "https://github.com/example/app"
                 },
                 :credo => %{
                   scm: Hex.SCM,
                   mix_dep:
                     {:credo, "~> 1.7",
                      [hex: "credo", build: _credo_build, dest: _credo_dest, runtime: false, only: [:dev], repo: "hexpm"]},
                   runtime: false,
                   optional: false,
                   only: [:dev],
                   targets: :*
                 },
                 :expo => %{
                   scm: Git,
                   mix_dep:
                     {:expo, nil,
                      [
                        git: "https://github.com/elixir-gettext/expo.git",
                        checkout: _expo_checkout,
                        build: _expo_build,
                        dest: _expo_dest
                      ]},
                   runtime: true,
                   optional: false,
                   only: :*,
                   targets: :*
                 },
                 :mime => %{
                   scm: Hex.SCM,
                   mix_dep: {:mime, "~> 2.0", [hex: "mime", build: _mime_build, dest: _mime_dest, repo: "hexpm"]},
                   runtime: true,
                   optional: false,
                   only: :*,
                   targets: :*
                 },
                 :heroicons => %{
                   scm: Git,
                   mix_dep:
                     {:heroicons, nil,
                      [
                        git: "https://github.com/tailwindlabs/heroicons.git",
                        dest: _heroicons_dest,
                        checkout: _heroicons_checkout,
                        build: _heroicons_build,
                        tag: "v2.1.5",
                        sparse: "optimized",
                        app: false,
                        compile: false,
                        depth: 1
                      ]},
                   runtime: false,
                   optional: false,
                   only: :*,
                   targets: :*
                 },
                 :elixir => %{
                   scm: SBoM.SCM.System,
                   mix_dep: {:elixir, "1.18.4", [app: :elixir, build: _elixir_build, dest: _elixir_dest]},
                   runtime: true,
                   optional: false,
                   only: :*,
                   targets: :*
                 },
                 :logger => %{
                   scm: SBoM.SCM.System,
                   mix_dep: {:logger, nil, [app: :logger, build: _logger_build, dest: _logger_dest]},
                   runtime: true,
                   optional: false,
                   only: :*,
                   targets: :*
                 },
                 :public_key => %{
                   scm: SBoM.SCM.System,
                   mix_dep: {:public_key, nil, [app: :public_key, build: _public_key_build, dest: _public_key_dest]},
                   runtime: true,
                   optional: false,
                   only: :*,
                   targets: :*
                 }
               } = MixFile.fetch()
      end)
    end

    @tag :tmp_dir
    @tag fixture_app: "app_library"
    test "generates valid manifest for 'app_library' fixture", %{app_path: app_path} do
      Util.in_project(app_path, fn _mix_module ->
        assert %{
                 credo: %{
                   mix_dep: {:credo, "~> 1.7", [hex: "credo", build: _credo_build, dest: _credo_dest, repo: "hexpm"]},
                   scm: Hex.SCM,
                   runtime: true,
                   optional: false,
                   only: :*,
                   targets: :*
                 },
                 path_dep: %{
                   scm: Mix.SCM.Path,
                   mix_dep: {:path_dep, nil, [dest: "/tmp", build: _path_dep_build, path: "/tmp"]},
                   runtime: true,
                   optional: false,
                   only: :*,
                   targets: :*
                 }
               } = MixFile.fetch()
      end)
    end

    @tag :tmp_dir
    @tag fixture_app: "app_atom_links"
    test "generates valid manifest for 'app_atom_links' fixture", %{app_path: app_path} do
      Util.in_project(app_path, fn _mix_module ->
        assert %{
                 app_atom_links: %{
                   runtime: true,
                   optional: false,
                   targets: :*,
                   only: :*,
                   dependencies: [:elixir, :phoenix, :phoenix_html, :phoenix_html_helpers],
                   root: true,
                   source_url: "https://github.com/app_atom_links"
                 },
                 phoenix: %{
                   mix_dep:
                     {:phoenix, "~> 1.6", [hex: "phoenix", build: _phoenix_build, dest: _phoenix_dest, repo: "hexpm"]},
                   scm: Hex.SCM,
                   runtime: true,
                   optional: false,
                   only: :*,
                   targets: :*
                 },
                 phoenix_html: %{
                   mix_dep:
                     {:phoenix_html, "~> 4.0",
                      [hex: "phoenix_html", build: _phoenix_html_build, dest: _phoenix_html_dest, repo: "hexpm"]},
                   scm: Hex.SCM,
                   runtime: true,
                   optional: false,
                   only: :*,
                   targets: :*
                 },
                 phoenix_html_helpers: %{
                   mix_dep:
                     {:phoenix_html_helpers, "~> 1.0",
                      [
                        hex: "phoenix_html_helpers",
                        build: _phoenix_html_helpers_build,
                        dest: _phoenix_html_helpers_dest,
                        repo: "hexpm"
                      ]},
                   scm: Hex.SCM,
                   runtime: true,
                   optional: false,
                   only: :*,
                   targets: :*
                 }
               } = MixFile.fetch()
      end)
    end

    @tag :tmp_dir
    test "skips manifest for project without mix.exs", %{tmp_dir: tmp_dir} do
      Util.in_project(tmp_dir, fn _mix_module ->
        assert nil == MixFile.fetch()
      end)
    end
  end
end
