defmodule ChatWeb.TopicLive do
  use ChatWeb, :live_view

  require Logger

  def mount(params = %{"topic_name" => topic_name}, _session, socket) do
    Logger.info(params: params)

    username = AnonymousNameGenerator.generate_random()

    {:ok, assign(socket, topic_name: topic_name, username: username, message: "")}
  end

  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    Logger.info(submit_message: message)

    {:noreply, assign(socket, message: "")}
  end

  def handle_event("message_change", %{"chat" => %{"message" => message}}, socket) do
    {:noreply, assign(socket, message: message)}
  end
end
