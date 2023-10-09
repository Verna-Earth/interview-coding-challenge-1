defmodule Bullet.Env do
  # CubDB data Directory
  def cubdb_data_dir, do: get_env(:cubdb)[:data_dir]

  # BulletWeb.Endpoint
  def endpoint_secret, do: get_env(BulletWeb.Endpoint)[:secret_key_base]

  # Compile Env
  def compile_env, do: get_env(:compile_env)

  defp get_env(app \\ :bullet, env_name), do: Application.get_env(app, env_name)
end
