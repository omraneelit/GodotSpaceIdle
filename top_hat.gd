extends Node3D

func _ready():
    var hat = CSGCylinder3D.new()
    hat.radius = 0.3
    hat.height = 0.6
    hat.position = Vector3(0, 0.8, 0) # Place on top of player's head
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color.BLACK
    hat.material = mat
    add_child(hat)
    
    var brim = CSGCylinder3D.new()
    brim.radius = 0.5
    brim.height = 0.1
    brim.position = Vector3(0, -0.25, 0)
    brim.material = mat
    hat.add_child(brim)
