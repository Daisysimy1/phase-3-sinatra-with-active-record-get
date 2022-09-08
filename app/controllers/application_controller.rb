class ApplicationController < Sinatra::Base

  # change response header for all routes
  set :default_content_type, 'application/json'

  get '/' do
    { message: "Hello world" }.to_json
  end

  get '/games' do
    # get all the games from our database
    # return a json response with all data about our games
    # content_type :json
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  # get a specific game by id
  get '/games/:id' do
    # lookup game in the database making use of its id
    # send a JSON formatted response of the game data
    game = Game.find(params[:id])
    # game.to_json(include: { reviews: { include: :user} })

    # include associated reviews in the json response
    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name]}
      }}
    })
  end

end