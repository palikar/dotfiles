BUILD_RELEASE_DIR?=build_release
BUILD_DEBUG_DIR?=build_debug
BUILD_TEST_DIR?=build_test


update_debug:
	cd $(BUILD_DEBUG_DIR) && make -j4


update_release:
	cd $(BUILD_RELEASE_DIR) && make -j4


update:update_debug


build_release:
	mkdir -p $(BUILD_RELEASE_DIR)
	cd $(BUILD_RELEASE_DIR)
	cd $(BUILD_RELEASE_DIR) && conan install ..
	cd $(BUILD_RELEASE_DIR) && cmake .. -DCMAKE_BUILD_TYPE=Release
	cd $(BUILD_RELEASE_DIR) && make -j4


build_debug:
	mkdir -p $(BUILD_DEBUG_DIR)
	cd $(BUILD_DEBUG_DIR) && conan install ..
	cd $(BUILD_DEBUG_DIR) && cmake .. -DCMAKE_BUILD_TYPE=Debug
	cd $(BUILD_DEBUG_DIR) && make -j4


build:build_debug


build_test:
	mkdir $(BUILD_TEST_DIR)
	cd $(BUILD_TEST_DIR) && conan install ..
	cd $(BUILD_TEST_DIR) && cmake .. -DCMAKE_BUILD_TYPE=Debug -DENABLE_TESTING=ON
	cd $(BUILD_TEST_DIR) && make -j4


test_update:
	cd $(BUILD_TEST_DIR) && make -j4


test: test_update
	cd $(BUILD_TEST_DIR) && ctest


clean_release:	
	rm -rf $(BUILD_RELEASE_DIR)


clean_debug:
	rm -rf $(BUILD_DEBUG_DIR)


clean_test:
	rm -rf $(BUILD_TEST_DIR)


clean: clean_debug clean_release clean_test


run:
	./$(BUILD_DEBUG_DIR)/bin/alisp_main_app


all: build_debug build_release build_test
