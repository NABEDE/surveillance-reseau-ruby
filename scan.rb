require 'socket'
require 'timeout'

# Fonction pour scanner une adresse IP
def ping_ip(ip)
  begin
    Timeout.timeout(1) do
      TCPSocket.new(ip, 80).close
      return true
    end
  rescue
    return false
  end
end

# Obtenir l'adresse IP locale de l'interface Wi-Fi
local_ip = Socket.ip_address_list.detect(&:ipv4_private?).ip_address
puts "Votre adresse IP locale est : #{local_ip}"

# Extraire le préfixe de l'adresse IP (par exemple, 192.168.1.)
base_ip = local_ip.split('.')[0..2].join('.') + '.'

# Fichier de sortie
output_file = 'adresses_ip_wifi.txt'

# Ouvrir le fichier en mode écriture
File.open(output_file, 'w') do |file|
  # Scanner les adresses IP de 1 à 254
  (1..254).each do |i|
    ip = "#{base_ip}#{i}"
    if ping_ip(ip)
      puts "#{ip} est actif !"
      file.puts(ip)  # Écrire l'adresse IP active dans le fichier
    else
      puts "#{ip} n'est pas actif."
    end
  end
end

puts "Les adresses IP actives ont été sauvegardées dans #{output_file}."
