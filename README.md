# Backup VPS

Script automatisé pour sauvegarder un serveur VPS (Virtual Private Server) vers une machine locale.

## Description

Ce script Bash permet de créer une sauvegarde complète d'un VPS en :
1. Créant une archive tar.gz compressée sur le serveur distant
2. Transférant cette archive vers la machine locale
3. Nettoyant les fichiers temporaires sur le serveur

## Fonctionnalités

- ✅ Sauvegarde complète du système de fichiers
- ✅ Exclusion automatique des dossiers système sensibles (`/tmp`, `/proc`, `/sys`, `/dev`, `/run`)
- ✅ Organisation par date des sauvegardes locales
- ✅ Interface colorée avec messages d'état
- ✅ Gestion d'erreurs avec codes de sortie
- ✅ Nettoyage automatique des fichiers temporaires

## Prérequis

### Sur la machine locale
- Bash installé
- SSH client configuré
- Espace disque suffisant pour la sauvegarde

### Sur le VPS
- Accès SSH configuré avec clés publiques (recommandé)
- Droits sudo pour l'utilisateur
- Espace disque temporaire suffisant dans `/tmp`

## Configuration

Avant d'utiliser le script, modifiez les variables dans la section de configuration :

```bash
VPS_USER="votre_utilisateur"          # Nom d'utilisateur SSH sur le VPS
VPS_IP="adresse_ip_du_vps"            # Adresse IP publique du VPS
LOCAL_DIR="$HOME/VPS_Backups"         # Dossier local pour stocker les sauvegardes
```

## Installation

1. Clonez ce dépôt :
```bash
git clone https://github.com/Mohammed-el-Amine/backup-vps.git
cd backup-vps
```

2. Rendez le script exécutable :
```bash
chmod +x backup-vps.sh
```

3. Configurez les variables dans le script selon votre environnement

## Utilisation

### Exécution manuelle
```bash
./backup-vps.sh
```

### Automatisation avec cron
Pour automatiser les sauvegardes, ajoutez une entrée cron :
```bash
# Éditer le crontab
crontab -e

# Exemple : sauvegarde quotidienne à 3h du matin
0 3 * * * /chemin/vers/backup-vps.sh
```

## Structure des sauvegardes

Les sauvegardes sont organisées par date dans le dossier local :
```
~/VPS_Backups/
├── 2025-10-22/
│   └── vps_backup_2025-10-22.tar.gz
├── 2025-10-23/
│   └── vps_backup_2025-10-23.tar.gz
└── ...
```

## Sécurité

### Recommandations
- Utilisez l'authentification par clés SSH plutôt que par mot de passe
- Limitez les permissions sudo de l'utilisateur aux commandes nécessaires
- Chiffrez les sauvegardes si elles contiennent des données sensibles
- Stockez les sauvegardes sur un support séparé du VPS

### Configuration SSH recommandée
```bash
# Sur votre machine locale, générez une paire de clés si nécessaire
ssh-keygen -t rsa -b 4096

# Copiez la clé publique sur le VPS
ssh-copy-id utilisateur@ip_du_vps
```

## Dépannage

### Erreurs courantes

**Erreur de connexion SSH :**
- Vérifiez que le VPS est accessible
- Vérifiez les identifiants (utilisateur, IP)
- Testez la connexion : `ssh utilisateur@ip_du_vps`

**Espace disque insuffisant :**
- Vérifiez l'espace disponible sur le VPS : `df -h`
- Vérifiez l'espace local : `df -h $HOME`

**Permissions insuffisantes :**
- Vérifiez que l'utilisateur a les droits sudo
- Testez : `ssh utilisateur@ip_du_vps sudo ls /`

## Personnalisation

### Exclusions supplémentaires
Pour exclure d'autres dossiers, modifiez la ligne tar :
```bash
tar -czpf $REMOTE_FILE --exclude=/tmp --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/run --exclude=/votre/dossier /
```

### Compression différente
Pour changer le type de compression :
```bash
# gzip (par défaut) : -z
# bzip2 : -j
# xz : -J
tar -cjpf $REMOTE_FILE ...  # pour bzip2
```

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Signaler des bugs
- Proposer des améliorations
- Soumettre des pull requests

## Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

## Auteur

Mohammed el Amine

---

**⚠️ Avertissement :** Testez toujours le script dans un environnement non-critique avant de l'utiliser en production. Assurez-vous d'avoir des sauvegardes de test pour vérifier l'intégrité des données sauvegardées.