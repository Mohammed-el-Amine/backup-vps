#!/bin/bash

# -----------------------------
# Couleurs
# -----------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Pas de couleur

# -----------------------------
# Variables (à personnaliser)
# -----------------------------
VPS_USER="votre_utilisateur"          # utilisateur SSH sur le VPS
VPS_IP="adresse_ip_du_vps"            # IP publique du VPS
LOCAL_DIR="$HOME/VPS_Backups"         # dossier local pour stocker les sauvegardes
DATE=$(date +%F)                       # date du jour
REMOTE_FILE="/tmp/vps_backup_$DATE.tar.gz"

echo -e "${BLUE}---------------------------------------------${NC}"
echo -e "${BLUE}Sauvegarde du VPS démarrée : $DATE${NC}"
echo -e "${BLUE}---------------------------------------------${NC}"

# -----------------------------
# Créer le dossier local si inexistant
# -----------------------------
mkdir -p "$LOCAL_DIR/$DATE"
echo -e "${YELLOW}Dossier local créé ou existant : $LOCAL_DIR/$DATE${NC}"

# -----------------------------
# Créer une archive sur le VPS
# -----------------------------
echo -e "${YELLOW}Création de l'archive sur le VPS...${NC}"
ssh "$VPS_USER@$VPS_IP" "sudo tar -czpf $REMOTE_FILE --exclude=/tmp --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/run /"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Archive créée avec succès sur le VPS : $REMOTE_FILE${NC}"
else
    echo -e "${RED}Erreur lors de la création de l'archive sur le VPS${NC}"
    exit 1
fi

# -----------------------------
# Récupérer l'archive sur la machine locale
# -----------------------------
echo -e "${YELLOW}Transfert de l'archive vers la machine locale...${NC}"
scp "$VPS_USER@$VPS_IP:$REMOTE_FILE" "$LOCAL_DIR/$DATE/"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Transfert réussi vers : $LOCAL_DIR/$DATE/${NC}"
else
    echo -e "${RED}Erreur lors du transfert de l'archive${NC}"
    exit 1
fi

# -----------------------------
# Supprimer l'archive temporaire sur le VPS
# -----------------------------
echo -e "${YELLOW}Suppression de l'archive temporaire sur le VPS...${NC}"
ssh "$VPS_USER@$VPS_IP" "rm $REMOTE_FILE"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Archive temporaire supprimée sur le VPS${NC}"
else
    echo -e "${RED}Erreur lors de la suppression de l'archive sur le VPS${NC}"
fi

echo -e "${BLUE}---------------------------------------------${NC}"
echo -e "${GREEN}Sauvegarde terminée avec succès !${NC}"
echo -e "${BLUE}---------------------------------------------${NC}"

