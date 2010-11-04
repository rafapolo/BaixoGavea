class StatsController < ApplicationController

  def stats    
    bandas_count = Banda.count
    albuns_count = Album.count
    users_count = User.confirmado.count
    stats = {
      "users_count"=> users_count,
      "bandas_count"=> bandas_count,
      "albuns_count"=>albuns_count
      }
    headers["Content-Type"] = "application/json"
    render :json => stats.to_json
  end

end
