extends Camera3D

@export var target_path: NodePath = "../Player"
var target: Node3D
var offset: Vector3

var trauma: float = 0.0
var max_shake_offset: Vector3 = Vector3(1.0, 1.0, 0.0)

func _ready():
    if has_node(target_path):
        target = get_node(target_path)
        offset = position - target.position

func add_trauma(amount: float):
    trauma = clamp(trauma + amount, 0.0, 1.0)

func _process(delta):
    if target:
        var target_pos = target.position + offset
        position = position.lerp(target_pos, delta * 5.0)
        
    if trauma > 0.0:
        var shake = trauma * trauma # Quadratic falloff for snappy feel
        position += Vector3(
            randf_range(-max_shake_offset.x, max_shake_offset.x) * shake,
            randf_range(-max_shake_offset.y, max_shake_offset.y) * shake,
            0
        )
        trauma = max(trauma - delta * 1.5, 0.0)
