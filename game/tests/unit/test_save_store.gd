extends GutTest

const PATH := "user://test_save_store.dat"
var store: SaveStore


func before_each():
	store = SaveStore.new(PATH)
	store.delete_all()


func after_each():
	store.delete_all()


func test_round_trip():
	assert_eq(store.save({"naira": 1500, "name": "Ọmọ"}), OK)
	var data := store.load_payload()
	assert_eq(int(data["naira"]), 1500)
	assert_eq(data["name"], "Ọmọ", "UTF-8 text survives")
	assert_eq(store.last_load_source, PATH)
	assert_false(FileAccess.file_exists(PATH + ".tmp"), "temporary file removed")


func test_missing_file_gives_empty():
	assert_eq(store.load_payload(), {})


func test_corrupt_main_falls_back_to_backup():
	store.save({"naira": 1})
	store.save({"naira": 2})
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	f.store_string("{\"schema\":1,\"sha256\":\"x\"}\n{\"naira\": 999}")
	f.close()
	var data := store.load_payload()
	assert_eq(int(data["naira"]), 1, "previous good save restored")
	assert_eq(store.last_load_source, PATH + ".bak1")


func test_truncated_file_rejected():
	store.save({"naira": 5})
	var text := FileAccess.get_file_as_string(PATH)
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	f.store_string(text.substr(0, text.length() - 4))
	f.close()
	assert_null(SaveStore.read_valid(PATH))


func test_corrupt_main_does_not_overwrite_good_backup():
	store.save({"naira": 1})
	store.save({"naira": 2})
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	f.store_string("garbage")
	f.close()
	store.save({"naira": 3})
	assert_eq(int(SaveStore.read_valid(PATH + ".bak1")["naira"]), 1)
	assert_eq(int(store.load_payload()["naira"]), 3)


func test_future_schema_rejected():
	var body := JSON.stringify({"naira": 1})
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify({"schema": 99, "sha256": body.sha256_text()}) + "\n" + body)
	f.close()
	assert_null(SaveStore.read_valid(PATH))


func test_schema_zero_migrates_money_to_naira():
	var body := JSON.stringify({"money": 700})
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify({"schema": 0, "sha256": body.sha256_text()}) + "\n" + body)
	f.close()
	var data: Dictionary = SaveStore.read_valid(PATH)
	assert_eq(int(data["naira"]), 700)
	assert_false(data.has("money"))
