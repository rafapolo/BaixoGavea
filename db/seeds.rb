polo = User.find_or_create_by!(username: "polo") do |u|
  u.email = "polo@mostre.me"
  u.info = "aways over here"
  u.password = "polopolo"
  u.confirmado = true
end

banda = Banda.find_or_create_by!(nome: "Raimundos") { |b| b.user = polo }
Album.find_or_create_by!(nome: "Lapadas do Povo", banda: banda) { |a| a.user = polo; a.ano = 1996 }
