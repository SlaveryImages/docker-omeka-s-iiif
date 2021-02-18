docker run -d --name slaveryimages -p 80:80 \
-v /home/slaveryimages/database.ini:/var/www/html/config/database.ini  \
-v /home/slaveryimages/omeka_files:/var/www/html/files \
-v /home/slaveryimages/omeka_logs:/var/www/html/logs  \
-v /home/slaveryimages/omeka-s-theme-slavery-images:/var/www/html/themes/omeka-s-theme-slavery-images \
-v /home/slaveryimages/omeka-s-theme-yoruba-diaspora:/var/www/html/themes/omeka-s-theme-yoruba-diaspora \
-v /home/slaveryimages/image_upload:/var/www/html/sideload_images \
-v /home/slaveryimages/Mirador:/var/www/html/modules/Mirador \
-v /home/slaveryimages/Mapping:/var/www/html/modules/Mapping \
--restart unless-stopped \
slaveryimages --net="host"
