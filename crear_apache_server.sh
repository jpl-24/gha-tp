#Actualiza lista de paquetes e instala apache
sudo apt update -y
sudo apt install -y apache2
sudo systemctl enable apache2 --now