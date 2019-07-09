defmodule IdeaPoolWeb.IdeaView do
  use IdeaPoolWeb, :view
  alias IdeaPoolWeb.IdeaView

  def render("index.json", %{ideas: ideas, page: page}) do
    {ideas, _} =
      Enum.map(ideas, &add_computed_fields/1)
      |> Enum.sort_by(&Map.fetch(&1, :average_score), &>=/2)
      |> Enum.chunk_every(10)
      |> List.pop_at(page)

    render_many(ideas || [], IdeaView, "idea.json")
  end

  def render("show.json", %{idea: idea}) do
    idea = add_computed_fields(idea)
    render_one(idea, IdeaView, "idea.json")
  end

  def render("idea.json", %{idea: idea}) do
    %{
      id: idea.id,
      content: idea.content,
      impact: idea.impact,
      ease: idea.ease,
      confidence: idea.confidence,
      average_score: idea.average_score,
      created_at: idea.created_at
    }
  end

  defp add_computed_fields(idea) do
    idea
    |> put_average_score
    |> put_created_at
  end

  defp put_average_score(idea) do
    average_score = Enum.sum([idea.impact, idea.confidence, idea.ease]) / 3
    Map.put(idea, :average_score, average_score)
  end

  defp put_created_at(idea) do
    created_at =
      idea.inserted_at
      |> NaiveDateTime.to_erl()
      |> :calendar.datetime_to_gregorian_seconds()
      |> Kernel.-(62_167_219_200)

    Map.put(idea, :created_at, created_at)
  end
end
