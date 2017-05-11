#!/bin/bash
rm -r swagger_files/SwaggerClient
java -jar swagger-codegen-cli-2.2.2.jar generate -i http://rasuldev-001-site28.btempurl.com/api-docs/v1 -l swift3 -o ./swagger_files
rm -r ../PlantTree/Swaggers
cp -r swagger_files/SwaggerClient/Classes/Swaggers ../PlantTree/Swaggers
