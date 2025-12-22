query = case System.argv() do
  [q | _] -> q
  _ -> "name=Alice&city=New%20York&age=30"
end

map = URI.decode_query(query)

# Выводим результат в удобном виде.
IO.inspect(map, label: "parsed")


