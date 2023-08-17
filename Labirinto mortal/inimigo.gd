extends CharacterBody3D


@onready var target = $"../Player"


func _physics_process(delta):
	if target == null: get_tree().get_nodes_in_group("player")[0]
	if target != null:
		velocity = position.direction_to(target.position) * speed 
		move_and_slide() 
		
	# gravidade.	 
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
		
 var player = target as Player
 var player_hitbox = player.get_node("playerhitbox")
	 if player_hitbox != null and is_colliding_with(player_hitbox):
			restart_game(

func restart_game():
	pass
