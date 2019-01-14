docker run -d --rm --name slaveryimages -p 80:80 \
-v /home/slaveryimages/database.ini:/var/www/html/config/database.ini  \
-v /home/slaveryimages/omeka_files:/var/www/html/files \
-v /home/slaveryimages/omeka_logs:/var/www/html/logs  \
-v /home/slaveryimages/omeka-s-theme-slavery-images:/var/www/html/themes/omeka-s-theme-slavery-images \
-v /home/slaveryimages/image_upload:/var/www/html/sideload_images \
slaveryimages --net="host"
