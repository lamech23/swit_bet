defmodule SwiftBetWeb.Admin.AnalyticsLive do
  use SwiftBetWeb, :live_view
  use Phoenix.LiveView, layout: {SwiftBetWeb.Layouts, :admin}
  alias SwiftBet.Bets

  def render(assigns) do
    ~H"""
    <div class="flex flex-row justify-center item-center gap-10 w-full mt-10 ">
      <article class="flex items-end justify-between  rounded-lg border w-1/3 border-gray-100 bg-white p-6">
        <div class="flex items-center gap-4">
          <span class="hidden rounded-full bg-gray-100 p-2 text-gray-600 sm:block">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="2"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"
              />
            </svg>
          </span>

          <div>
            <p class="text-sm text-gray-500">Placed Bets</p>

            <p class="text-2xl font-medium text-gray-900">Placed Bet</p>
          </div>
        </div>

        <div class="inline-flex gap-2 rounded bg-green-100 p-1 text-green-600">
          <span class="text-2xl font-medium"><%= @bets %></span>
        </div>
      </article>
      <article class="flex items-end justify-between  rounded-lg border w-1/3 border-gray-100 bg-white p-6">
        <div class="flex items-center gap-4">
          <span class="hidden rounded-full bg-gray-100 p-2 text-gray-600 sm:block">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="2"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"
              />
            </svg>
          </span>

          <div>
            <p class="text-sm text-gray-500">Profit</p>

            <p class="text-2xl font-medium text-gray-900">ksh <%= @profit %></p>
          </div>
        </div>

        <div class="inline-flex gap-2 rounded bg-green-100 p-1 text-green-600">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"
            />
          </svg>

          <span class="text-xs font-medium"> 67.81% </span>
        </div>
      </article>

      <article class="flex items-end justify-between w-1/3 rounded-lg border border-gray-100 bg-white p-6">
        <div class="flex items-center gap-4">
          <span class="hidden rounded-full bg-gray-100 p-2 text-gray-600 sm:block">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="2"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"
              />
            </svg>
          </span>

          <div>
            <p class="text-sm text-gray-500">lose</p>

            <p class="text-2xl font-medium text-gray-900">ksh <%= @lose %></p>
          </div>
        </div>

        <div class="inline-flex gap-2 rounded bg-red-100 p-1 text-red-600">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-4 w-4"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M13 17h8m0 0V9m0 8l-8-8-4 4-6-6"
            />
          </svg>

          <span class="text-xs font-medium"> 67.81% </span>
        </div>
      </article>
    </div>

    <div class="grid  mt-20  gap-4 bg-gray-100 p-8 rounded-lg shadow-lg">
      <!-- Active Bets -->
      <div class="flex items-center justify-between">
        <span class="text-xl font-semibold">Active Bets</span>
        <span class="text-4xl font-bold text-blue-500"><%= @open %></span>
      </div>
      <!-- Lost Bets -->
      <div class="flex items-center justify-between">
        <span class="text-xl font-semibold">Lost Bets</span>
        <span class="text-4xl font-bold text-red-500"><%= @lost %></span>
      </div>
      <!-- Won Bets -->
      <div class="flex items-center justify-between">
        <span class="text-xl font-semibold">Won Bets</span>
        <span class="text-4xl font-bold text-green-500"><%= @won %></span>
      </div>
      <!-- Canceled Bets -->
      <div class="flex items-center justify-between">
        <span class="text-xl font-semibold">Canceled Bets</span>
        <span class="text-4xl font-bold text-gray-500"><%= @cancled %></span>
      </div>
    </div>
    """
  end

  def mount(_session, _params, socket) do
    profit = Bets.lost_bets()
    lose = Bets.won_bets()

    all_bets =
      Bets.all_bets()
      |> Enum.count()

    lost =
      all =
      Bets.all_bets()
      |> Enum.filter(fn x -> x.status == "lose" end)
      |> Enum.count()

    open =
      all =
      Bets.all_bets()
      |> Enum.filter(fn x -> x.status == "open" end)
      |> Enum.count()

    won =
      all =
      Bets.all_bets()
      |> Enum.filter(fn x -> x.status == "win" end)
      |> Enum.count()

    cancled =
      all =
      Bets.all_bets()
      |> Enum.filter(fn x -> x.status == "canceled" end)
      |> Enum.count()
      |> IO.inspect()

    {:ok,
     assign(socket,
       profit: profit,
       lose: lose,
       bets: all_bets,
       lost: lost,
       open: open,
       won: won,
       cancled: cancled
     )}
  end
end
