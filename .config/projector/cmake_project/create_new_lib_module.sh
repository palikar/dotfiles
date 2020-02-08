#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")

MODULE_NAME=$1
project_name=$(grep "project(\w*" CMakeLists.txt -o | grep "(.*" -o | cut -c 2-)

if [ -d $DIR/${project_name}/${MODULE_NAME} ]; then
    echo "The module already exists"
    exit 1
fi



cp -r $DIR/templates/template_lib_module/ $DIR/src/

mv $DIR/src/template_lib_module/ $DIR/src/${MODULE_NAME}
mv $DIR/src/${MODULE_NAME}/include/PROJECT/MODULE_NAME $DIR/src/${MODULE_NAME}/include/PROJECT/${MODULE_NAME}

mv $DIR/src/${MODULE_NAME}/include/PROJECT $DIR/src/${MODULE_NAME}/include/${project_name}

find $DIR/src/${MODULE_NAME} -type f -exec sed -i "s/MODULE_NAME/${MODULE_NAME}/g" {} \;
find $DIR/src/${MODULE_NAME} -type f -exec sed -i "s/PROJECT_NAME/${project_name}/g" {} \;


LINE="add_subdirectory(${MODULE_NAME})"
if [ ! $(grep $LINE $DIR/src/CMakeLists.txt) ]; then
    echo ${LINE} >> $DIR/src/CMakeLists.txt
fi




