# TODO ANIMATION AND BETTER INCREASING LOGIC
class_name DangerZone

extends Area2D

signal player_caught(reason: String)

@export var initial_speed: float = 100.0
@export var max_speed: float = 250.0

var current_speed: float = initial_speed

func _ready() -> void:
	pass
	# Upewnij się, że DangerZone jest na odpowiedniej warstwie kolizji,
	# aby mogła wykrywać gracza, ale nie inne obiekty (chyba że chcesz inaczej).
	# Ustaw też odpowiednią maskę kolizji.
	# Np. collision_layer = 0 (nic), collision_mask = 1 (warstwa gracza)
	# Gracz powinien być na warstwie 1.


func _process(delta: float) -> void:
	position.y -= current_speed * delta
	
	# Opcjonalnie: stopniowo zwiększaj prędkość
	# Możesz to zrobić w _process lub np. gdy gracz osiągnie nowy poziom trudności
	# current_speed = min(current_speed + speed_increase_rate * delta, max_speed)


func _on_body_entered(body: Node2D) -> void:
	assert(body is Player)
	print("Player caught by the danger zone!")
	player_caught.emit("danger zone")
	# TODO: game over screen


func initialize(start_position_y: float) -> void:
	position.y = start_position_y


func increase_difficulty_speed(new_base_speed: float) -> void:
	# needs better logic
	initial_speed = new_base_speed
	current_speed = min(initial_speed, max_speed) # Przykład bardziej złożonego skalowania
