# danger_zone.gd 
#TODO ANIMATION AND BETTER INCREASING LOGIC
class_name DangerZone
extends Area2D

signal player_caught

@export var initial_speed: float = 100.0  # Początkowa prędkość w pikselach/sekundę
@export var max_speed: float = 250.0 # Maksymalna prędkość

var current_speed: float

func _ready() -> void:
	current_speed = initial_speed
	# Upewnij się, że DangerZone jest na odpowiedniej warstwie kolizji,
	# aby mogła wykrywać gracza, ale nie inne obiekty (chyba że chcesz inaczej).
	# Ustaw też odpowiednią maskę kolizji.
	# Np. collision_layer = 0 (nic), collision_mask = 1 (warstwa gracza)
	# Gracz powinien być na warstwie 1.

	# Podłącz sygnał body_entered, aby wykryć kolizję z graczem
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	# Przesuwaj DangerZone w górę
	position.y -= current_speed * delta

	# Opcjonalnie: stopniowo zwiększaj prędkość
	# Możesz to zrobić w _process lub np. gdy gracz osiągnie nowy poziom trudności
	# current_speed = min(current_speed + speed_increase_rate * delta, max_speed)

func _on_body_entered(body: Node2D) -> void:
	if body is Player: # Upewnij się, że to gracz (użyj swojej nazwy klasy Player)
		print("Gracz złapany przez DangerZone!")
		player_caught.emit()
		# Tutaj możesz zatrzymać grę, wyświetlić ekran "Game Over" itp.
		# Na przykład, możesz wyemitować sygnał do głównej sceny.

func start_moving(start_position_y: float) -> void:
	position.y = start_position_y
	current_speed = initial_speed
	set_process(true)

func stop_moving() -> void:
	set_process(false)

func increase_difficulty_speed(new_base_speed: float) -> void:
	# needs better logic
	initial_speed = new_base_speed # Możesz chcieć inaczej zarządzać prędkością
	current_speed = min(initial_speed, max_speed) # Przykład bardziej złożonego skalowania
