defmodule ChatWeb.TopicLive do
  use ChatWeb, :live_view

  require Logger

  def mount(params = %{"topic_name" => topic_name}, _session, socket) do
    Logger.info(params: params)

    username = AnonymousNameGenerator.generate_random()

    {:ok, assign(socket, topic_name: topic_name, username: username)}
  end
end
