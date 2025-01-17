@icon("res://assets/icons/Stevens/Godot Editor Icons/Gear.png")
const OWNED_PLAYER_CIRCLE_COLOR = Color.GREEN
const ADVERSARY_PLAYER_CIRCLE_COLOR = Color.RED
const RESOURCE_CIRCLE_COLOR = Color.YELLOW
const DEFAULT_CIRCLE_COLOR = Color.WHITE
const MAPS = {
	"res://source/match/maps/PlainAndSimple.tscn":
	{
		"name": "Plain & Simple",
		"players": 4,
		"size": Vector2i(50, 50),
	},
	"res://source/match/maps/BigArena.tscn":
	{
		"name": "Big Arena",
		"players": 8,
		"size": Vector2i(100, 100),
	},
}


class Navigation:
	enum Domain { AIR, TERRAIN }

	const DOMAIN_TO_GROUP_MAPPING = {
		Domain.AIR: "air_navigation_input",
		Domain.TERRAIN: "terrain_navigation_input",
	}


class Air:
	const Y = 1.5
	const PLANE = Plane(Vector3.UP, Y)

	class Navmesh:
		const CELL_SIZE = 0.4
		const CELL_HEIGHT = 0.4
		const MAX_AGENT_RADIUS = 0.8


class Terrain:
	const PLANE = Plane(Vector3.UP, 0)

	class Navmesh:
		const CELL_SIZE = 0.3
		const CELL_HEIGHT = 0.3
		const MAX_AGENT_RADIUS = 0.9  # max radius of movable units


class Resources:
	class A:
		const COLOR = Color.BLUE
		const MATERIAL_PATH = "res://source/match/resources/materials/resource_a.material.tres"
		const COLLECTING_TIME_S = 1.0

	class B:
		const COLOR = Color.RED
		const MATERIAL_PATH = "res://source/match/resources/materials/resource_b.material.tres"
		const COLLECTING_TIME_S = 2.0

class Items:
	class Minimap:
			const COLOR = Color.YELLOW
			const MATERIAL_PATH = "res://source/match/resources/materials/resource_a.material.tres"

class Units:
	const PRODUCTION_COSTS = {
		"res://source/match/units/Worker.tscn":
		{
			"resource_a": 2,
			"resource_b": 0,
		},
		"res://source/match/units/Helicopter.tscn":
		{
			"resource_a": 1,
			"resource_b": 3,
		},
		"res://source/match/units/Drone.tscn":
		{
			"resource_a": 2,
			"resource_b": 0,
		},
		"res://source/match/units/Tank.tscn":
		{
			"resource_a": 3,
			"resource_b": 1,
		},
	}
	const PRODUCTION_TIMES = {
		"res://source/match/units/Worker.tscn": 3.0,
		"res://source/match/units/Helicopter.tscn": 6.0,
		"res://source/match/units/Drone.tscn": 3.0,
		"res://source/match/units/Tank.tscn": 6.0,
	}
	const PRODUCTION_QUEUE_LIMIT = 5
	const STRUCTURE_BLUEPRINTS = {
		"res://source/match/units/CommandCenter.tscn":
		"res://source/match/units/structure-geometries/CommandCenter.tscn",
		"res://source/match/units/VehicleFactory.tscn":
		"res://source/match/units/structure-geometries/VehicleFactory.tscn",
		"res://source/match/units/AircraftFactory.tscn":
		"res://source/match/units/structure-geometries/AircraftFactory.tscn",
		"res://source/match/units/AntiGroundTurret.tscn":
		"res://source/match/units/structure-geometries/AntiGroundTurret.tscn",
		"res://source/match/units/AntiAirTurret.tscn":
		"res://source/match/units/structure-geometries/AntiAirTurret.tscn",
	}
	const CONSTRUCTION_COSTS = {
		"res://source/match/units/CommandCenter.tscn":
		{
			"resource_a": 8,
			"resource_b": 8,
		},
		"res://source/match/units/VehicleFactory.tscn":
		{
			"resource_a": 6,
			"resource_b": 0,
		},
		"res://source/match/units/AircraftFactory.tscn":
		{
			"resource_a": 4,
			"resource_b": 4,
		},
		"res://source/match/units/AntiGroundTurret.tscn":
		{
			"resource_a": 2,
			"resource_b": 2,
		},
		"res://source/match/units/AntiAirTurret.tscn":
		{
			"resource_a": 2,
			"resource_b": 2,
		},
	}
	const DEFAULT_TOOLTIP = {
		"res://source/match/units/unitUIAbilities/CancelAction.tres":
			{
				"format": "{0}",
				"content":
					[
					"CANCEL_CURRENT_ACTION"
					],
				"translate": 
				[
					true,
				],
			},
		"res://source/match/units/Drone.tscn":
		{
			"format": "{0} - {1}\n{2} HP\n{3}: {4}, {5}: {6}",
			"content": 
				[
					"DRONE",
					"DRONE_DESCRIPTION",
					DEFAULT_PROPERTIES["res://source/match/units/Drone.tscn"]["hp_max"],
					"RESOURCE_A",
					PRODUCTION_COSTS["res://source/match/units/Drone.tscn"]["resource_a"],
					"RESOURCE_B",
					PRODUCTION_COSTS["res://source/match/units/Drone.tscn"]["resource_b"]
				],
			"translate": 
				[
					true,
					true,
					false,
					true,
					false,
					true,
					false
				],
		},
		"res://source/match/units/Worker.tscn":
		{
			"format": "{0} - {1}\n{2} HP\n{3}: {4}, {5}: {6}",
			"content": 
				[
					"WORKER",
					"WORKER_DESCRIPTION",
					DEFAULT_PROPERTIES["res://source/match/units/Worker.tscn"]["hp_max"],
					"RESOURCE_A",
					PRODUCTION_COSTS["res://source/match/units/Worker.tscn"]["resource_a"],
					"RESOURCE_B",
					PRODUCTION_COSTS["res://source/match/units/Worker.tscn"]["resource_b"]
				],
			"translate": 
				[
					true,
					true,
					false,
					true,
					false,
					true,
					false
				],
		},
		"res://source/match/units/Helicopter.tscn":
		{
			"format": "{0} - {1}\n{2} HP, {3} DPS\n{4}: {5}, {6}: {7}",
			"content": 
				[
					"HELICOPTER",
					"HELICOPTER_DESCRIPTION",
					DEFAULT_PROPERTIES["res://source/match/units/Helicopter.tscn"]["hp_max"],
					DEFAULT_PROPERTIES["res://source/match/units/Helicopter.tscn"]["attack_damage"] * DEFAULT_PROPERTIES["res://source/match/units/Helicopter.tscn"]["attack_interval"],
					"RESOURCE_A",
					PRODUCTION_COSTS["res://source/match/units/Helicopter.tscn"]["resource_a"],
					"RESOURCE_B",
					PRODUCTION_COSTS["res://source/match/units/Helicopter.tscn"]["resource_b"]
				],
			"translate": 
				[
					true,
					true,
					false,
					false,
					true,
					false,
					true,
					false
				],
		},
		"res://source/match/units/Tank.tscn":
		{
			"format": "{0} - {1}\n{2} HP, {3} DPS\n{4}: {5}, {6}: {7}",
			"content": 
				[
					"TANK",
					"TANK_DESCRIPTION",
					DEFAULT_PROPERTIES["res://source/match/units/Tank.tscn"]["hp_max"],
					DEFAULT_PROPERTIES["res://source/match/units/Tank.tscn"]["attack_damage"] * DEFAULT_PROPERTIES["res://source/match/units/Tank.tscn"]["attack_interval"],
					"RESOURCE_A",
					PRODUCTION_COSTS["res://source/match/units/Tank.tscn"]["resource_a"],
					"RESOURCE_B",
					PRODUCTION_COSTS["res://source/match/units/Tank.tscn"]["resource_b"]
				],
			"translate": 
				[
					true,
					true,
					false,
					false,
					true,
					false,
					true,
					false
				],
		},
		"res://source/match/units/CommandCenter.tscn":
		{
			"format": "{0} - {1}\n{2} HP\n{3}: {4}, {5}: {6}",
			"content": 
				[
					"CC",
					"CC_DESCRIPTION",
					DEFAULT_PROPERTIES["res://source/match/units/CommandCenter.tscn"]["hp_max"],
					"RESOURCE_A",
					CONSTRUCTION_COSTS["res://source/match/units/CommandCenter.tscn"]["resource_a"],
					"RESOURCE_B",
					CONSTRUCTION_COSTS["res://source/match/units/CommandCenter.tscn"]["resource_b"]
				],
			"translate": 
				[
					true,
					true,
					false,
					true,
					false,
					true,
					false
				],
		},
		"res://source/match/units/VehicleFactory.tscn":
		{
			"format": "{0} - {1}\n{2} HP\n{3}: {4}, {5}: {6}",
			"content": 
				[
					"VEHICLE_FACTORY",
					"VEHICLE_FACTORY_DESCRIPTION",
					DEFAULT_PROPERTIES["res://source/match/units/VehicleFactory.tscn"]["hp_max"],
					"RESOURCE_A",
					CONSTRUCTION_COSTS["res://source/match/units/VehicleFactory.tscn"]["resource_a"],
					"RESOURCE_B",
					CONSTRUCTION_COSTS["res://source/match/units/VehicleFactory.tscn"]["resource_b"]
				],
			"translate": 
				[
					true,
					true,
					false,
					true,
					false,
					true,
					false,
				],
		},
		"res://source/match/units/AircraftFactory.tscn":
		{
			"format": "{0} - {1}\n{2} HP\n{3}: {4}, {5}: {6}",
			"content": 
				[
					"AIRCRAFT_FACTORY",
					"AIRCRAFT_FACTORY_DESCRIPTION",
					DEFAULT_PROPERTIES["res://source/match/units/AircraftFactory.tscn"]["hp_max"],
					"RESOURCE_A",
					CONSTRUCTION_COSTS["res://source/match/units/AircraftFactory.tscn"]["resource_a"],
					"RESOURCE_B",
					CONSTRUCTION_COSTS["res://source/match/units/AircraftFactory.tscn"]["resource_b"],
				],
			"translate": 
				[
					true,
					true,
					false,
					true,
					false,
					true,
					false,
				],
		},
		"res://source/match/units/AntiGroundTurret.tscn":
		{
			"format": "{0} - {1}\n{2} HP, {3} DPS\n{4}: {5}, {6}: {7}",
			"content": 
				[
					"AG_TURRET",
					"AG_TURRET_DESCRIPTION",
					DEFAULT_PROPERTIES["res://source/match/units/AntiGroundTurret.tscn"]["hp_max"],
					DEFAULT_PROPERTIES["res://source/match/units/AntiGroundTurret.tscn"]["attack_damage"] * DEFAULT_PROPERTIES["res://source/match/units/AntiGroundTurret.tscn"]["attack_interval"],
					"RESOURCE_A",
					CONSTRUCTION_COSTS["res://source/match/units/AntiGroundTurret.tscn"]["resource_a"],
					"RESOURCE_B",
					CONSTRUCTION_COSTS["res://source/match/units/AntiGroundTurret.tscn"]["resource_b"]
				],
			"translate": 
				[
					true,
					true,
					false,
					false,
					true,
					false,
					true,
					false
				],
		},
		"res://source/match/units/AntiAirTurret.tscn":
		{
			"format": "{0} - {1}\n{2} HP, {3} DPS\n{4}: {5}, {6}: {7}",
			"content": 
				[
					"AA_TURRET",
					"AA_TURRET_DESCRIPTION",
					DEFAULT_PROPERTIES["res://source/match/units/AntiAirTurret.tscn"]["hp_max"],
					(DEFAULT_PROPERTIES["res://source/match/units/AntiAirTurret.tscn"]["attack_damage"]) * (DEFAULT_PROPERTIES["res://source/match/units/AntiAirTurret.tscn"]["attack_interval"]),
					"RESOURCE_A",
					CONSTRUCTION_COSTS["res://source/match/units/AntiAirTurret.tscn"]["resource_a"],
					"RESOURCE_B",
					CONSTRUCTION_COSTS["res://source/match/units/AntiAirTurret.tscn"]["resource_b"]
				],
			"translate":
				[
					true,
					true,
					false,
					false,
					true,
					false,
					true,
					false
				],
		},
	}
	const DEFAULT_PROPERTIES = {
		"res://source/match/units/Drone.tscn":
		{
			"sight_range": 10.0,
			"hp": 6,
			"hp_max": 6,
			"icon":"res://assets/icons/Stevens/Black and White/D32 BW.png",
		},
		"res://source/match/units/Worker.tscn":
		{
			"sight_range": 5.0,
			"hp": 6,
			"hp_max": 6,
			"resources_max": 2,
			"icon":"res://assets/icons/Stevens/Black and White/W32 BW.png",
			"unitAbilities": [
				null, null, null, 
				"res://source/match/units/unitUIAbilities/CancelAction.tres", 
				null, null,null, null, 
				"res://source/match/units/unitUIAbilities/buildAntiGroundTurret.tres", 
				"res://source/match/units/unitUIAbilities/buildAntiAirTurret.tres", 
				null, null, 
				"res://source/match/units/unitUIAbilities/buildCommandCenter.tres", 
				"res://source/match/units/unitUIAbilities/buildVehicleFactory.tres",
				"res://source/match/units/unitUIAbilities/buildAircraftFactory.tres", 
				null
				],
		},
		"res://source/match/units/Helicopter.tscn":
		{
			"sight_range": 8.0,
			"hp": 10,
			"hp_max": 10,
			"attack_damage": 1,
			"attack_interval": 1.0,
			"attack_range": 5.0,
			"icon":"res://assets/icons/Stevens/Black and White/H32 BW.png",
			"attack_domains": [Navigation.Domain.TERRAIN, Navigation.Domain.AIR],
		},
		"res://source/match/units/Tank.tscn":
		{
			"sight_range": 8.0,
			"hp": 10,
			"hp_max": 10,
			"attack_damage": 2,
			"attack_interval": 0.75,
			"attack_range": 5.0,
			"icon":"res://assets/icons/Stevens/Black and White/T32 BW.png",
			"attack_domains": [Navigation.Domain.TERRAIN],
		},
		"res://source/match/units/CommandCenter.tscn":
		{
			"sight_range": 10.0,
			"hp": 20,
			"hp_max": 20,
			"icon":"res://assets/icons/Stevens/Black and White/CC32 BW.png",
			"unitAbilities": [
				null, null, null, 
				"res://source/match/units/unitUIAbilities/CancelAction.tres", 
				null, null, null, null, 
				null, null, null, null, 
				"res://source/match/units/unitUIAbilities/produceWorker.tres", 
				null, null, null
				],
		},
		"res://source/match/units/VehicleFactory.tscn":
		{
			"sight_range": 8.0,
			"hp": 16,
			"hp_max": 16,
			"icon":"res://assets/icons/Stevens/Black and White/VF32 BW.png",
			"unitAbilities": [
				null, null, null, 
				"res://source/match/units/unitUIAbilities/CancelAction.tres", 
				null, null, null, null, 
				null, null, null, null, 
				"res://source/match/units/unitUIAbilities/produceTank.tres", 
				null, null, null
				],
		},
		"res://source/match/units/AircraftFactory.tscn":
		{
			"sight_range": 8.0,
			"hp": 16,
			"hp_max": 16,
			"icon":"res://assets/icons/Stevens/Black and White/AF32 BW.png",
			"unitAbilities": [
				null, null, null, 
				"res://source/match/units/unitUIAbilities/CancelAction.tres", 
				null, null, null, null, 
				null, null, null, null, 
				"res://source/match/units/unitUIAbilities/produceHelicopter.tres", 
				"res://source/match/units/unitUIAbilities/produceDrone.tres", 
				null, null
				],
		},
		"res://source/match/units/AntiGroundTurret.tscn":
		{
			"sight_range": 8.0,
			"hp": 8,
			"hp_max": 8,
			"attack_damage": 2,
			"attack_interval": 1.0,
			"attack_range": 8.0,
			"icon":"res://assets/icons/Stevens/Black and White/AG32 BW.png",
			"attack_domains": [Navigation.Domain.TERRAIN],
			"unitAbilities": [
				null, null, null, null,
				null, null, null, null,
				null, null, null, null,
				null, null, null, null
				],
		},
		"res://source/match/units/AntiAirTurret.tscn":
		{
			"sight_range": 8.0,
			"hp": 8,
			"hp_max": 8,
			"attack_damage": 2,
			"attack_interval": 0.75,
			"attack_range": 8.0,
			"icon":"res://assets/icons/Stevens/Black and White/AA32 BW.png",
			"attack_domains": [Navigation.Domain.AIR],
		},
		"res://source/match/units/SpecialCharacter.tscn":
		{
			"sight_range": 8.0,
			"hp": 20,
			"hp_max": 20,
			"attack_damage": 2,
			"attack_interval": 1.0,
			"attack_range": 5.0,
			"movement_speed":4,
			"icon":"res://assets/icons/Stevens/Black and White/SC.png",
			"attack_domains": [Navigation.Domain.TERRAIN, Navigation.Domain.AIR],
		},
	}
	const PROJECTILES = {
		"res://source/match/units/Helicopter.tscn":
		"res://source/match/units/projectiles/Rocket.tscn",
		"res://source/match/units/Tank.tscn":
		"res://source/match/units/projectiles/CannonShell.tscn",
		"res://source/match/units/AntiGroundTurret.tscn":
		"res://source/match/units/projectiles/CannonShell.tscn",
		"res://source/match/units/AntiAirTurret.tscn":
		"res://source/match/units/projectiles/Rocket.tscn",
		"res://source/match/units/SpecialCharacter.tscn":
		"res://source/match/units/projectiles/Rocket.tscn"
	}
	const ADHERENCE_MARGIN_M = 0.3  # TODO: try lowering while fixing a 'push' problem
	const NEW_RESOURCE_SEARCH_RADIUS_M = 30
	const MOVING_UNIT_RADIUS_MAX_M = 1.0
	const EMPTY_SPACE_RADIUS_SURROUNDING_STRUCTURE_M = MOVING_UNIT_RADIUS_MAX_M * 2.5
	const STRUCTURE_CONSTRUCTING_SPEED = 0.3  # progress [0.0..1.0] per second


class VoiceNarrator:
	enum Events {
		MATCH_STARTED,
		MATCH_ABORTED,
		UNIT_LOST,
		UNIT_PRODUCTION_STARTED,
		NOT_ENOUGH_RESOURCES,
	}

	const EVENT_TO_ASSET_MAPPING = {
		Events.MATCH_STARTED: preload("res://assets/voice/english/battle_control_online.ogg"),
		Events.MATCH_ABORTED: preload("res://assets/voice/english/battle_control_offline.ogg"),
		Events.UNIT_LOST: preload("res://assets/voice/english/unit_lost.ogg"),
		Events.UNIT_PRODUCTION_STARTED: preload("res://assets/voice/english/training.ogg"),
		Events.NOT_ENOUGH_RESOURCES: preload("res://assets/voice/english/not_enough_resources.ogg"),
	}
