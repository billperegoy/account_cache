# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

Enum.each(1..1000, fn _i ->
  name = "#{Faker.Name.first_name()} #{Faker.Name.last_name()}"
  AccountCache.Repo.insert!(%AccountCache.Customer.Account{name: name})
end)
