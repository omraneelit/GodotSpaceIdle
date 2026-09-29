extends Label3D

var float_speed: float = 3.0
var lifetime: float = 1.0
var timer: float = 0.0

func _ready():
    # Make the text always face the camera and look sharp
    billboard = BaseMaterial3D.BILLBOARD_ENABLED
    font_size = 72
    outline_size = 16
    modulate = Color.GREEN

func _process(delta):
    # Float upward
    position.y += float_speed * delta
    timer += delta
    
    # Fade out transparency
    modulate.a = 1.0 - (timer / lifetime)
    
    if timer >= lifetime:
        queue_free()
