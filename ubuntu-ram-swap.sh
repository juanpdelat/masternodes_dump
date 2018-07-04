#/bin/bash
NONE='\033[00m'
RED=' 🛑  '
GREEN=' ✅  '
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
MAX=7

checkForUbuntuVersion() {
   echo "[1/${MAX}] Checking Ubuntu version..."
    if [[ `cat /etc/issue.net`  == *16.04* ]]; then
        echo -e "${GREEN}You are running `cat /etc/issue.net`. Setup will continue.${NONE}";
    else
        echo -e "${RED}You are not running Ubuntu 16.04.X. You are running `cat /etc/issue.net` ${NONE}";
        echo && echo "Installation cancelled" && echo;
        exit;
    fi
}

checkExistingSwapFiles() {
  echo
  echo "[2/${MAX}] Checking if the system has any configured swap. Please wait..."
  sudo DEBIAN_FRONTEND=noninteractive swapon --show > /dev/null 2>&1
  sudo DEBIAN_FRONTEND=noninteractive free -h > /dev/null 2>&1
  echo -e "${GREEN}* Done${NONE}";
}

createSwapFile() {
  echo
  echo "[3/${MAX}] Creating swap file. Please wait..."
  sudo DEBIAN_FRONTEND=noninteractive sudo fallocate -l 2G /swapfile > /dev/null 2>&1
  # sudo DEBIAN_FRONTEND=noninteractive ls -lh /swapfile > /dev/null 2>&1
  echo -e "${GREEN}* Done${NONE}";
}

enableSwapFile() {
  echo
  echo "[4/${MAX}] Enabling swap file. Please wait..."
  sudo DEBIAN_FRONTEND=noninteractive sudo chmod 600 /swapfile > /dev/null 2>&1
  # sudo DEBIAN_FRONTEND=noninteractive ls -lh /swapfile > /dev/null 2>&1
  sudo DEBIAN_FRONTEND=noninteractive sudo mkswap /swapfile > /dev/null 2>&1
  sudo DEBIAN_FRONTEND=noninteractive sudo swapon /swapfile > /dev/null 2>&1
  echo -e "${GREEN}* Done${NONE}";
}

makeSwapPermanent() {
  echo
  echo "[5/${MAX}] Making swap file permanent. Please wait..."
  sudo DEBIAN_FRONTEND=noninteractive sudo cp /etc/fstab /etc/fstab.bak > /dev/null 2>&1
  sudo DEBIAN_FRONTEND=noninteractive echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab > /dev/null 2>&1
  echo -e "${GREEN}* Done${NONE}";
}

adjustSwappiness() {
  echo
  echo "[6/${MAX}] Adjusting swappiness. Please wait..."
  sudo DEBIAN_FRONTEND=noninteractive sudo sysctl vm.swappiness=10 > /dev/null 2>&1
  sudo DEBIAN_FRONTEND=noninteractive echo "vm.swappiness=10" >> /etc/sysctl.conf  > /dev/null 2>&1
  echo -e "${GREEN}* Done${NONE}";
}

adjustCachePressure() {
  echo
  echo "[7/${MAX}] Adjusting cache pressure. Please wait..."
  sudo DEBIAN_FRONTEND=noninteractive sudo sysctl vm.vfs_cache_pressure=50 > /dev/null 2>&1
  sudo DEBIAN_FRONTEND=noninteractive echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf  > /dev/null 2>&1
  echo -e "${GREEN}* Done${NONE}";
}

clear
cd

echo
echo -e "--------------------------------------------------------------------"
echo -e "|                                                                  |"
echo -e "|                      ${BOLD}----- Memory SWAP -----${NONE}                     |"
echo -e "|                                                                  |"
echo -e "--------------------------------------------------------------------"

echo -e "${BOLD}This script will create  a swap file to an Ubuntu 16.04 server.${NONE}"
echo
echo -e "Although swap is generally recommended for systems utilizing traditional spinning hard drives, using swap with SSDs can cause issues with hardware degradation over time. Due to this consideration, we do not recommend enabling swap on DigitalOcean or any other provider that utilizes SSD storage. Doing so can impact the reliability of the underlying hardware for you and your neighbors. This guide is provided as reference for users who may have spinning disk systems elsewhere."
echo
echo -e "If you need to improve the performance of your server on DigitalOcean, we recommend upgrading your Droplet. This will lead to better results in general and will decrease the likelihood of contributing to hardware issues that can affect your service."
echo
echo -e "${BOLD}"
read -p "Do you wish to continue? (y/n)? " response
echo -e "${NONE}"

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
  checkForUbuntuVersion
  checkExistingSwapFiles
  createSwapFile
  enableSwapFile
  makeSwapPermanent
  adjustSwappiness
  adjustCachePressure

  echo -e "🎉 🎉 🎉  ${BOLD}Swap file creation successfully finished!!!${NONE} 🙌 🙌 🙌"
else
  clear
  echo && echo "${RED}Installation cancelled${RED}" && echo
fi