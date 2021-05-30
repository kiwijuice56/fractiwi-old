tool
extends EditorScript
class_name PsxImport

var psx_shader_path := load("res://main/environment/psx.shader")

func _run():
	for node in get_scene().get_children():
		var textures := []
		#get automatically imported textures
		for i in range(node.mesh.get_surface_count()):
			var material = node.mesh.surface_get_material(i)
			if material == null: continue
			textures.append(material.get_shader_param("texture_0"))
		#create shader materials and apply the textures with the psx shader
		for i in range(node.get_surface_material_count()):
			var shader_material = ShaderMaterial.new()
			shader_material.shader = psx_shader_path.duplicate()
			node.set_surface_material(i, shader_material)
			if textures[i] == null: continue
			node.get_surface_material(i).set_shader_param("albedoTex", textures[i])
		node.create_trimesh_collision()
