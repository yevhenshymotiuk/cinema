halls =
  [50, 40, 50, 30]
  |> Enum.with_index()
  |> Enum.map(fn {x, i} -> Cinema.Halls.create_hall!(%{number: i + 1, seats_count: x}) end)

halls
|> Enum.each(fn h ->
  Enum.each(1..h.seats_count, &Cinema.Seats.create_seat!(%{number: &1}, h))
end)
