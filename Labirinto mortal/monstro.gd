extends CharacterBody3D

var player = null
var state_machine

const speed = 4
const DistanciaAtaque = 10

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"Correndo":
			#Perseguindo
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * speed
			look_at(Vector3(global_position.x + velocity.x, global_position.y, 
							global_position.z + velocity.z), Vector3.UP)
		"ataque":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			
	#condições
	anim_tree.set("parameters/conditions/ataque", _target_in_range())
	anim_tree.set("parameters/conditions/correr", !_target_in_range())
	
	
	move_and_slide()
	
func _target_in_range(): 
	return global_position.distance_to(player.global_position) < DistanciaAtaque


func _hit_finished():
	player.hit()
