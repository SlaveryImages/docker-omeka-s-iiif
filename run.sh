docker run -d --rm --name slaveryimages -p 80:80 \
-v /c/Users/Brumfield/docker-omeka-s-iiif/database.ini:/var/www/html/config/database.ini  \
-v /c/Users/Brumfield/omeka_files:/var/www/html/files \
-v /c/Users/Brumfield/omeka_logs:/var/www/html/logs  \
-v /c/Users/Brumfield/omeka-s-theme-slavery-images:/var/www/html/themes/omeka-s-theme-slavery-images \
-v /c/Users/Brumfield/sideload_images:/var/www/html/sideload_images \
-v /c/Users/Brumfield/Mirador:/var/www/html/modules/Mirador \
-v /c/Users/Brumfield/Mapping:/var/www/html/modules/Mapping \
slaveryimages --net="host"
# test http://192.168.99.100/s/slaveryimages/item/132#?c=0&m=0&s=0&cv=0&xywh=-568%2C-110%2C3749%2C2086