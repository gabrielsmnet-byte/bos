# Como gerar a ISO do BOS

A ISO e um Linux (Debian) que liga direto no BOS, em tela cheia, sem login.
Ela precisa ser montada por um Linux com internet (baixa uns 1,5 GB). O caminho mais facil no Windows e o GitHub, que monta tudo de graca nos servidores deles.

## CAMINHO A (recomendado): GitHub monta a ISO por voce, sem Linux
1. Crie uma conta gratis em https://github.com/signup (se ja tiver, entre).
2. Clique em **+** (canto superior direito) > **New repository**. Nome: `bos-iso`. Marque **Public** (assim nao ha limite de minutos). Clique **Create repository**.
3. Na pagina do repositorio clique em **uploading an existing file**. Extraia este zip no seu PC e **arraste para a pagina o conteudo da pasta `webos-iso`**: os arquivos `bos`, `construir-iso.sh`, `webos.html`, `LEIA-ME.md` **e a pasta `.github`** (se o Windows nao mostrar a pasta `.github`, ative "Itens ocultos" no Explorer, aba Exibir). Clique **Commit changes**.
   - Se a pasta `.github` nao subir: clique **Add file > Create new file**, no nome digite `.github/workflows/gerar-iso.yml` (as barras criam as pastas) e cole o conteudo do arquivo `gerar-iso.yml` desta pasta. Clique **Commit changes**.
4. Clique na aba **Actions**. Se aparecer um botao verde "I understand my workflows, go ahead and enable them", clique nele.
5. No menu da esquerda clique **Gerar ISO do BOS** > botao **Run workflow** > **Run workflow**.
6. Espere de 20 a 40 minutos (a bolinha amarela vira um check verde). Se ficar vermelho, clique nele, abra a etapa que falhou e me mande o texto das ultimas linhas.
7. Clique no trabalho concluido, role ate **Artifacts** e baixe **BOS-iso**. Extraia o .zip: dentro esta `WebOS.iso`.

## CAMINHO B: Ubuntu no Windows (WSL)
1. PowerShell como administrador: `wsl --install -d Ubuntu`. Reinicie o PC, abra o app Ubuntu e crie usuario/senha.
2. Copie a pasta: `cp -r /mnt/c/Users/SEU_USUARIO/Downloads/webos-iso ~/` e entre: `cd ~/webos-iso`
3. `sudo bash construir-iso.sh` (leva 20-40 min e usa uns 10 GB).
4. Traga para o Windows: `cp ~/webos-iso/WebOS.iso /mnt/c/Users/SEU_USUARIO/Downloads/`
Para desfazer depois: `wsl --unregister Ubuntu`. Se o WSL der erro de "mount", use o Caminho A.

## Como usar a ISO
- **Maquina virtual (VirtualBox):** Nova > Tipo Linux, Debian 64-bit, 2 GB de RAM (4 GB e melhor), disco 8 GB. Em Armazenamento, escolha a `WebOS.iso` no leitor optico. Em Sistema, ligue "Habilitar EFI" apenas se quiser testar UEFI. Inicie.
- **Pendrive:** baixe o Rufus (rufus.ie), escolha a ISO e, quando perguntar, o modo **Gravar em modo imagem DD**. Depois inicie o PC pelo pendrive (F12, F9 ou Esc na hora de ligar).
- O sistema abre direto no BOS. Para sair: botao de energia ou menu BOS > Desligar (desliga o computador de verdade).

## O que ja vem funcionando e o que nao
- Funciona: todos os programas do BOS, internet por cabo (em maquina virtual funciona sozinha), YouTube e sites no navegador do BOS.
- Os arquivos ficam na memoria da ISO e **somem ao desligar** (e um sistema "live"). Para guardar, use um pendrive extra ou salve na nuvem. Persistencia pode ser adicionada depois.
- Wi-Fi ainda nao tem tela de conexao no BOS (cabo funciona).
