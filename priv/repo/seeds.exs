# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kakebosan.Repo.insert!(%Kakebosan.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Kakebosan.Repo.insert!(%KakebosanWeb.Accounting.Side{name: "借方"})
Kakebosan.Repo.insert!(%KakebosanWeb.Accounting.Side{name: "貸方"})

Kakebosan.Repo.insert!(%KakebosanWeb.Accounting.Type{name: "資産", side_id: 1 })
Kakebosan.Repo.insert!(%KakebosanWeb.Accounting.Type{name: "費用", side_id: 1 })
Kakebosan.Repo.insert!(%KakebosanWeb.Accounting.Type{name: "負債", side_id: 1 })
Kakebosan.Repo.insert!(%KakebosanWeb.Accounting.Type{name: "資本", side_id: 2 })
Kakebosan.Repo.insert!(%KakebosanWeb.Accounting.Type{name: "収益", side_id: 2 })
