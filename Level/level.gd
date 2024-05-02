class_name Level
extends Node2D

@export var laser: PackedScene
@export var asteroid: PackedScene
@export var particles_effect: PackedScene

var score: int = 0

@onready var spawn_points: Array[Node] = $SpawnPoints.get_children()
@onready var spawn_timer: Timer = $Timers/SpawnTimer
@onready var player: Player = $Player
@onready var asteroids: Node2D = $Asteroids
@onready var screen_size: Vector2 = get_viewport_rect().size
@onready var particles: Node2D = $Particles
@onready var projectiles: Node2D = $Projectiles
@onready var player_destroyed_audio: AudioStreamPlayer2D = $Audio/PlayerDestroyedAudio

func _ready():
	_setup_signals()
	spawn_timer.start(randi_range(1, 3))
	$UI/Label.text = str(score)
	
	
func _spawn_asteroid(pos = spawn_points[randi_range(0, spawn_points.size() - 1)].global_position, 
						asteroid_size = randi_range(0, Globals.Size.size()-1) as Globals.Size):
	var new_asteroid: Asteroid = asteroid.instantiate() as Asteroid
	call_deferred("_add_child", new_asteroid)
	new_asteroid.global_position = pos
	new_asteroid.size = asteroid_size
	new_asteroid.asteroid_destroyed.connect(_on_asteroid_destroyed)

	new_asteroid.setup(Vector2(randf_range(screen_size.x, 0), randf_range(0, screen_size.y)))

func _add_child(new_asteroid: Asteroid):
	asteroids.add_child(new_asteroid)
	
	
func _on_asteroid_destroyed(pos: Vector2, size: Globals.Size):
	var new_particle = particles_effect.instantiate()
	particles.add_child(new_particle)
	new_particle.global_position = pos
	new_particle.emitting = true
	
	match size:
		Globals.Size.LARGE:
			for i in 2:
				_spawn_asteroid(pos, Globals.Size.MEDIUM)
		Globals.Size.MEDIUM:
			for i in 4:
				_spawn_asteroid(pos, Globals.Size.SMALL)
				
	score += 1
	$UI/Label.text = str(score)

	
func _setup_signals():
	if player:
		player.weapon_fired.connect(_on_player_weapon_fired)
		player.destroyed.connect(_on_player_destroyed)
	else:
		push_error("Missing Player")
	
	
func _on_player_weapon_fired(laser_position: Vector2, laser_rotation: float):
	var new_laser: Laser = laser.instantiate()
	new_laser.setup(laser_position, laser_rotation)
	projectiles.add_child(new_laser)
	

func _on_player_destroyed():
	player_destroyed_audio.play()
	var new_particle = particles_effect.instantiate()
	particles.add_child(new_particle)
	new_particle.global_position = player.global_position
	new_particle.emitting = true
	$UI/Button.visible = true


func _on_spawn_timer_timeout():
	_spawn_asteroid()
	spawn_timer.start(randi_range(1, 3))


func _on_button_pressed():
	get_tree().reload_current_scene()
