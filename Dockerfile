FROM ubuntu:latest
LABEL maintainer="Isaac Huffman <isaacphuffman@gmail.com>"
RUN apt-get update
RUN apt-get install -y sudo curl git-core gnupg locales wget binutils nasm gcc make software-properties-common gh
RUN apt-get install -y neofetch net-tools neovim
RUN apt-get install -y python3 npm python3.10-venv
RUN apt-get install -y zip unzip tar

RUN locale-gen en_US.UTF-8
RUN adduser --quiet --disabled-password \
    --shell /bin/bash --home /home/devuser \
    --gecos "User" devuser
RUN echo "devuser:placeholderpassword" | chpasswd
RUN usermod -aG sudo devuser

# need unstable debian repository's nvim
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-get update

# configure NVIM as devuser
RUN sudo -H -u devuser mkdir -p /home/devuser/.local/share/nvim/site/pack/packer/start/packer.nvim
RUN sudo -H -u devuser git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    /home/devuser/.local/share/nvim/site/pack/packer/start/packer.nvim
RUN sudo -H -u devuser mkdir -p /home/devuser/.config/nvim
RUN sudo -H -u devuser git clone --depth 1 https://github.com/isaacph/nvim-config /home/devuser/.config/nvim
RUN sudo -H -u devuser INITNVIM=1 nvim --headless -c 'autocmd User PackerComplete quitall' --noplugin

# start in HOME as devuser using bash
RUN sudo -H -u devuser echo "cd ~" >> /home/devuser/.bashrc
USER devuser
ENV TERM xterm
ENV DISPLAY host.docker.internal:0.0
CMD ["bash"]
