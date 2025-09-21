#!/bin/bash

# Colors
GREEN="\e[92m"
RESET="\e[0m"

if [ -d "/data/data/com.termux/files/usr" ]; then
    IS_TERMUX=true
    INSTALL_DIR="/data/data/com.termux/files/usr/share/admin0"
    PASS="/data/data/com.termux/files/usr/share/pass0"
    SHORTCUT_PATH="ZeroDark/server"
    PKG_MANAGER="pkg"
    NODE_CMD="pkg install nodejs -y"
    OPEN_CMD="termux-open-url"
else
    IS_TERMUX=false
    INSTALL_DIR="/ZeroDark/server"
    SHORTCUT_PATH="/usr/local/bin/admin0"
    PASS="/usr/local/bin/pass0"
    PKG_MANAGER="apt"
    NODE_CMD="apt install nodejs -y"
    OPEN_CMD="xdg-open"
fi

echo -e "${GREEN}[+] Updating Termux packages...${RESET}"
pkg update -y && pkg upgrade -y

echo -e "${GREEN}[+] Installing required packages...${RESET}"
pkg install -y proot wget nano nodejs yarn


# Setup project
if [ ! -d "$HOME/ZeroDark" ]; then
    echo -e "${GREEN}[+] Creating project folder...${RESET}"
    mkdir -p ~/ZeroDark
fi

if [ -d "server" ]; then
    cd server || exit
    echo -e "${GREEN}[+] Installing Node.js dependencies...${RESET}"
    npm install
    cd ~
fi

echo -e "#!/bin/bash\ncd \"$INSTALL_DIR\" && node index.js" > "$SHORTCUT_PATH"
chmod +x "$SHORTCUT_PATH"

echo -e "#!/bin/bash\ncd \"$PASS\" && node index.js" > "$SHORTCUT_PATH"
chmod +x "$SHORTCUT_PATH"

# Add aliases to .bashrc (avoid duplicates)
if ! grep -q "alias admin0=" ~/.bashrc; then
    echo "alias admin0='cd ZeroDark/server && node index.js'" >> ~/.bashrc
fi

if ! grep -q "alias pass0=" ~/.bashrc; then
    echo "alias pass0='bash ZeroDark/pass0'" >> ~/.bashrc
fi

# Final message
clear
echo -e "${GREEN}[✔] Installation complete!${RESET}"
echo -e "${GREEN}[✔] Type: admin0 to Start the Server${RESET}"
echo -e "${GREEN}[✔] Type: pass0 to Change password script${RESET}"
sleep 2
echo -e "${GREEN}Subscribe my YouTube channel – Thanks!${RESET}"


cd
rm ZeroDark/setup.sh
