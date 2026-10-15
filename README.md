# 🌌 Archydre's Hyprland Dotfiles

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://archlinux.org/)
[![Hyprland](https://img.shields.io/badge/Hyprland-00A98F?style=for-the-badge&logo=hyprland&logoColor=white)](https://hyprland.org/)
[![Lua Config](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://lua.org/)
[![Theme](https://img.shields.io/badge/Catppuccin-Mocha-CBA6F7?style=for-the-badge&logo=catppuccin&logoColor=white)](https://github.com/catppuccin/catppuccin)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

Ambiente de trabalho completo, moderno e altamente otimizado para **Arch Linux** baseado no compositor Wayland **Hyprland** (utilizando a nova sintaxe nativa em **Lua**), integrado ao ecossistema Catppuccin Mocha.

Destaque especial para o sistema dinâmico de workspaces estilo **GNOME**: compactação em tempo real sem pulo de câmera (*zero-bounce*), bloqueio inteligente de workspaces vazios no final e navegação intuitiva via scroll do mouse.

---

## ⚡ Instalação em 1 Comando

Para instalar automaticamente em uma máquina com Arch Linux limpa ou existente:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/archydre/dotfiles/main/install.sh)
```

> [!TIP]
> O instalador detecta automaticamente se pacotes oficiais ou AUR já estão presentes, instala dependências faltantes, cria um backup seguro de suas configurações atuais (`~/.config/dotfiles_backup_*`), instala os scripts utilitários em `~/.local/bin`, copia os papéis de parede e configura as variáveis de ambiente necessárias.

### Instalação Manual

Se preferir clonar e inspecionar o código antes de rodar:

```bash
git clone https://github.com/archydre/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

---

## 🎨 O que está incluso no Setup

| Componente | Ferramenta | Detalhes |
|---|---|---|
| **Compositor** | `hyprland` | Configuração nativa em Lua, blur dual-kawase, bordas com gradiente animado e transição suave de workspace em `fade`. |
| **Barra Superior** | `waybar` | Tema Catppuccin Mocha flutuante com suporte a scroll para mudar de workspace/volume, controles multimídia MPRIS, monitor de CPU/RAM e botões de atalho. |
| **Lançador de Apps** | `wofi` | Menu centralizado com cantos arredondados, backdrop blur e campo de busca rápida. |
| **Terminal** | `alacritty` | Configuração com paleta Catppuccin Mocha e fonte JetBrains Mono Nerd Font. |
| **Notificações** | `dunst` | Notificações minimalistas com suporte a ações, ícones e cores temáticas. |
| **Tela de Bloqueio** | `hyprlock` | Lockscreen elegante com relógio central tipográfico, data e blur do wallpaper atual. |
| **Gerenciador de Wallpaper** | `hyprpaper` | Suporte multimonitor automático com seletor interativo em Wofi (`Super + Shift + W`). |
| **Clipboard** | `cliphist` + `wl-clipboard` | Histórico completo de texto e imagens acessível via `Super + V`. |
| **Captura de Tela** | `grim` + `slurp` + `swappy` + `loupe` | Captura de região, tela inteira ou janela com atalho para edição instantânea. |
| **Áudio e Mídia** | `wireplumber` + `playerctl` + `pavucontrol` | Controle de volume nativo com feedback via notificação e atalhos de mídia. |
| **Cursor** | `Bibata-Modern-Classic` | Cursor moderno e fluido em 24px. |

---

## ⌨️ Tabela de Atalhos de Teclado (Cheat Sheet)

A tecla **`Super`** (`Mod4` / tecla Windows) é o modificador principal:

### 🚀 Aplicativos e Sistema
| Atalho | Ação |
|---|---|
| `Super + Return` / `Ctrl + Alt + T` | Abrir Terminal (`alacritty`) |
| `Super + D` / `Alt + Space` | Lançador de Aplicativos (`wofi`) |
| `Super + E` | Gerenciador de Arquivos (`nautilus`) |
| `Super + B` | Navegador Web Padrão |
| `Super + V` | Histórico da Área de Transferência (`cliphist`) |
| `Super + L` | Bloquear tela (`hyprlock`) |
| `Super + Shift + Q` | Menu de Energia / Desligamento (`hypr-powermenu`) |
| `Super + Shift + W` | Seletor Gráfico de Wallpapers (`hypr-wallpaper-picker`) |
| `Super + Shift + M` | Encerrar sessão do Hyprland |

### 🪟 Gerenciamento de Janelas
| Atalho | Ação |
|---|---|
| `Super + Q` / `Super + C` | Fechar janela focada |
| `Super + F` | Alternar Tela Cheia (*Fullscreen*) |
| `Super + Shift + Space` | Alternar Janela Flutuante (*Float*) |
| `Super + P` | Alternar divisão pseudo-tiling |
| `Super + J` | Alternar divisão horizontal/vertical (*toggle split*) |
| `Super + Setas` / `Super + H/J/K/L` | Mover foco entre janelas |
| `Super + Botão Esquerdo (Arrastar)` | Mover janela |
| `Super + Botão Direito (Arrastar)` | Redimensionar janela |

### 🌀 Workspaces Dinâmicos Estilo GNOME
| Atalho | Ação |
|---|---|
| `Super + Scroll Baixo` | Ir para o próximo workspace (`1 ➔ 2 ➔ 3...`) |
| `Super + Scroll Cima` | Ir para o workspace anterior (`3 ➔ 2 ➔ 1`) |
| `Super + Botões Laterais Mouse (276 / 275)` | Avançar / Voltar workspace |
| `Super + Shift + Scroll Baixo / Cima` | Mover janela atual para o próximo/anterior workspace |
| `Super + 1..9` | Mudar diretamente para o workspace correspondente |
| `Super + Shift + 1..9` | Mover janela focada para o workspace correspondente |
| `Super + S` | Alternar workspace especial / Scratchpad |
| `Super + Shift + S` | Mover janela focada para o scratchpad |

> [!NOTE]
> **Comportamento dos Workspaces:**
> 1. Se você estiver no workspace vazio do final (ex: workspace 3 vazio), rolar para baixo é bloqueado automaticamente para não criar workspaces fantasmas desnecessários.
> 2. Ao fechar todas as aplicações de um workspace anterior (ex: workspace 1), os workspaces subsequentes são renumerados e compactados automaticamente em segundo plano via eventos nativos do Hyprland sem nenhum efeito rebote na tela.

### 📸 Captura de Tela e Mídia
| Atalho | Ação |
|---|---|
| `Print` / `Super + Shift + S` / `Ctrl + Shift + Z` | Capturar área selecionada com cópia direta para o clipboard |
| `Shift + Print` | Capturar tela inteira |
| `Super + Print` | Capturar apenas a janela ativa |
| `Super + Shift + Print` | Capturar área e abrir instantaneamente no editor de anotações **Swappy** |
| `Fn / Teclas Multimídia Volume` | Aumentar, diminuir ou mutar áudio com notificação na tela |
| `Fn / Teclas Multimídia Play/Pause` | Play/Pause, Próxima e Faixa Anterior via `playerctl` |

---

## 📂 Estrutura do Repositório

```text
dotfiles/
├── .config/
│   ├── alacritty/           # Configuração de terminal GPU acelerado
│   ├── dunst/               # Daemon de notificações temático
│   ├── hypr/
│   │   ├── hyprland.lua     # Configuração principal nativa do Hyprland em Lua
│   │   ├── hyprlock.conf    # Tela de bloqueio personalizada
│   │   └── hyprpaper.conf   # Gerenciador de papel de parede
│   ├── swappy/              # Ferramenta de anotação de screenshots
│   ├── waybar/              # Barra superior (JSONC + CSS)
│   └── wofi/                # Launcher de aplicativos estilizado
├── .local/
│   └── bin/                 # Scripts utilitários e automações Hyprland
│       ├── hypr-gnome-workspaces
│       ├── hypr-move-window-menu
│       ├── hypr-powermenu
│       ├── hypr-screenshot
│       ├── hypr-suspend
│       ├── hypr-volume
│       ├── hypr-wallpaper-picker
│       └── hypr-workspace-scroll
├── wallpapers/              # Coleção curada de wallpapers de alta definição
├── install.sh               # Script de instalação e configuração automatizada
└── README.md
```

---

## 🛠️ Requisitos de Sistema

- Distribuição: **Arch Linux** ou derivados (EndeavourOS, CachyOS, Manjaro, etc.)
- GPU: Suporta Intel, AMD e NVIDIA (drivers apropriados com suporte a Wayland instalados)
- Fontes recomendadas: `ttf-jetbrains-mono-nerd` e `noto-fonts-emoji` (instaladas automaticamente pelo script)

---

## 👤 Autor

Desenvolvido e mantido por **archydre**  
GitHub: [@archydre](https://github.com/archydre)

Sinta-se à vontade para abrir uma *Issue* ou enviar um *Pull Request* com sugestões e melhorias!
