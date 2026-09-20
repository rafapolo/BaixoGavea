class StatsController < ApplicationController
  def show
    render json: {
      users_count: User.confirmado.count,
      bandas_count: Banda.count,
      albuns_count: Album.count
    }
  end
end
