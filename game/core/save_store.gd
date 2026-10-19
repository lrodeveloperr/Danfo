class_name SaveStore
extends RefCounted
## Crash- and power-cut-tolerant save file.
##
## File layout: line 1 is a JSON header {schema, sha256}; line 2 is the payload
## JSON exactly as hashed. A save is written to a temporary file, verified,
## the previous good save is copied to a rotating backup, and only then is the
## temporary file moved into place. Loading falls back through the backups.

const SCHEMA_VERSION := 1
const BACKUP_COUNT := 2

var path: String
## Which file the last successful load came from ("" if none).
var last_load_source := ""


func _init(save_path := "user://save.dat") -> void:
	path = save_path


func save(payload: Dictionary) -> Error:
	var body := JSON.stringify(payload)
	var header := JSON.stringify({"schema": SCHEMA_VERSION, "sha256": body.sha256_text()})
	var tmp := path + ".tmp"
	var file := FileAccess.open(tmp, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(header + "\n" + body)
	file.flush()
	file.close()
	if read_valid(tmp) == null:
		DirAccess.remove_absolute(tmp)
		return ERR_FILE_CORRUPT
	_rotate_backups()
	var err := DirAccess.rename_absolute(tmp, path)
	if err != OK:
		DirAccess.remove_absolute(path)
		err = DirAccess.rename_absolute(tmp, path)
	return err


## Returns the newest valid payload, or an empty Dictionary when none exists.
func load_payload() -> Dictionary:
	last_load_source = ""
	for candidate in candidates():
		var data: Variant = read_valid(candidate)
		if data != null:
			last_load_source = candidate
			return data
	return {}


func candidates() -> PackedStringArray:
	var list := PackedStringArray([path])
	for i in range(1, BACKUP_COUNT + 1):
		list.append("%s.bak%d" % [path, i])
	return list


func delete_all() -> void:
	for candidate in candidates():
		if FileAccess.file_exists(candidate):
			DirAccess.remove_absolute(candidate)
	if FileAccess.file_exists(path + ".tmp"):
		DirAccess.remove_absolute(path + ".tmp")


## Parses and verifies one file. Returns the migrated payload or null.
static func read_valid(file_path: String) -> Variant:
	if not FileAccess.file_exists(file_path):
		return null
	var text := FileAccess.get_file_as_string(file_path)
	var split := text.find("\n")
	if split < 0:
		return null
	var header: Variant = JSON.parse_string(text.substr(0, split))
	var body := text.substr(split + 1)
	if typeof(header) != TYPE_DICTIONARY:
		return null
	if str(header.get("sha256", "")) != body.sha256_text():
		return null
	var schema := int(header.get("schema", -1))
	if schema < 0 or schema > SCHEMA_VERSION:
		return null
	var payload: Variant = JSON.parse_string(body)
	if typeof(payload) != TYPE_DICTIONARY:
		return null
	return migrate(payload, schema)


## Upgrades a payload one schema step at a time.
static func migrate(payload: Dictionary, from_schema: int) -> Dictionary:
	var data := payload
	var schema := from_schema
	while schema < SCHEMA_VERSION:
		match schema:
			0:
				# Schema 0 prototypes kept naira under "money".
				if data.has("money") and not data.has("naira"):
					data["naira"] = data["money"]
					data.erase("money")
		schema += 1
	return data


func _rotate_backups() -> void:
	if not FileAccess.file_exists(path):
		return
	for i in range(BACKUP_COUNT, 1, -1):
		var older := "%s.bak%d" % [path, i - 1]
		if FileAccess.file_exists(older):
			DirAccess.copy_absolute(older, "%s.bak%d" % [path, i])
	# Only rotate a main file that is itself valid, so a corrupt file never
	# overwrites the last good backup.
	if read_valid(path) != null:
		DirAccess.copy_absolute(path, path + ".bak1")
