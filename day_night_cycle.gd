extends DirectionalLight3D

@export var day_speed: float = 10.0 # Degrees rotated per second

func _process(delta):
    # Rotate the sun continuously on the X axis
    rotation_degrees.x -= day_speed * delta
    
    # Wrap rotation between 0 and 360 to prevent massive numbers
    if rotation_degrees.x < -360:
        rotation_degrees.x += 360
        
    # Calculate angle to determine if it's day or night
    var angle = wrapf(rotation_degrees.x, -180, 180)
    
    if angle > 0 and angle < 180:
        # Sun is below the horizon (Night Time)
        light_energy = lerp(light_energy, 0.1, delta * 3.0)
        # Add a slight blue tint for night
        light_color = light_color.lerp(Color(0.2, 0.2, 0.5), delta * 2.0)
    else:
        # Sun is above the horizon (Day Time)
        light_energy = lerp(light_energy, 1.2, delta * 3.0)
        # Return to normal sunlight
        light_color = light_color.lerp(Color(1.0, 1.0, 1.0), delta * 2.0)
