class_name AnylandVisualBuilder
extends Node

func _ready() -> void:
	
	var file: FileAccess = FileAccess.open("res://assets/test/huntress-body-2022-08-04-22-40-27.json", FileAccess.READ);
	var content = file.get_as_text();
	
	var parse = JSON.parse_string(content);
	
	var resource_builder: AnylandJson2ResourceBuilder = AnylandJson2ResourceBuilder.new();
	resource_builder.name = "ResourceBuilder";
	self.add_child(resource_builder);
	
	var thing_resource = resource_builder.build_resource(parse);
	var visual = build_visual(thing_resource);
	
	self.add_child(visual);



func build_visual(thing_resource: AnylandThingResource) -> Node3D:
	var thing_object: Node3D = Node3D.new();
	
	thing_object.name = thing_resource.name;
	
	return thing_object;
