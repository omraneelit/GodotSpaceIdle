extends Node

func spawn_poof(pos: Vector3, color: Color = Color.WHITE):
    # Procedurally generate a 3D Particle Explosion
    var p = GPUParticles3D.new()
    p.emitting = true
    p.one_shot = true
    p.explosiveness = 1.0
    p.amount = 15
    p.lifetime = 0.6
    
    # Material for the chunks
    var mat = StandardMaterial3D.new()
    mat.albedo_color = color
    mat.emission_enabled = true
    mat.emission = color
    
    # Mesh (Little cubes)
    var mesh = BoxMesh.new()
    mesh.size = Vector3(0.3, 0.3, 0.3)
    mesh.material = mat
    p.draw_pass_1 = mesh
    
    # Physics/Movement of particles
    var proc_mat = ParticleProcessMaterial.new()
    proc_mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
    proc_mat.emission_sphere_radius = 0.5
    proc_mat.direction = Vector3(0, 1, 0)
    proc_mat.initial_velocity_min = 4.0
    proc_mat.initial_velocity_max = 8.0
    proc_mat.gravity = Vector3(0, -12.0, 0)
    proc_mat.scale_curve = _create_scale_curve()
    
    p.process_material = proc_mat
    p.position = pos
    
    get_tree().get_root().add_child(p)
    
    # Auto-cleanup after the explosion is done
    var timer = get_tree().create_timer(1.0)
    timer.timeout.connect(p.queue_free)

func _create_scale_curve() -> CurveTexture:
    var curve = Curve.new()
    curve.add_point(Vector2(0, 1))
    curve.add_point(Vector2(1, 0)) # Shrink to nothing over time
    var tex = CurveTexture.new()
    tex.curve = curve
    return tex
