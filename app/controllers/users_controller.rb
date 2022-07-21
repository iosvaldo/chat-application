class UsersController < ApplicationController

  def index
    users = User.all
    render json: UserSerializer.new(users)
  end

  def create
    user = User.create!(user_params)
    if user
      room = Room.creaye(name: user.username, description: "This is the beginning of your new room")
      user_rooms = UserRooms.create(user_id: user.id, room_id: room.id)
      message = Message.create(body: "THis is the beginning of your new message", room_id: room.id, user_id: user.id)
      payload = {'user_id': user.id}
      token = encode(payload)
      render json: {
        user: UserSerializer.new(user),
        token: token,
        authenticated: true
      }
    else
      render json: {message: "the system ran into an error when creating your account"}
  end
end

def show
  token = request.headers['Authentication'].split('')[1]
  payload = decode(token)
  user = User.find(payload['user_id'])
  if user
    render json: UserSerializer.new(user)
  else
    render json: { message: "Error", autheticated: false }
  end
end

private

  def user_params
    params.permit(:username, :password)
  end

end