FROM ubuntu:latest
LABEL maintainer="Isaac Huffman <isaacphuffman@gmail.com>"
RUN apt-get update
RUN apt-get install -y sudo curl git-core gnupg locales wget binutils nasm gcc make software-properties-common

RUN locale-gen en_US.UTF-8
RUN adduser --quiet --disabled-password \
    --shell /bin/bash --home /home/devuser \
    --gecos "User" devuser
RUN echo "devuser:placeholderpassword" | chpasswd
RUN usermod -aG sudo devuser

# need unstable debian repository's nvim
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-get update
RUN apt-get install -y neovim

# configure NVIM as devuser
RUN sudo -H -u devuser mkdir -p /home/devuser/.local/share/nvim/site/pack/packer/start/packer.nvim
RUN sudo -H -u devuser git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    /home/devuser/.local/share/nvim/site/pack/packer/start/packer.nvim
RUN sudo -H -u devuser mkdir -p /home/devuser/.config/nvim
RUN sudo -H -u devuser git clone --depth 1 https://github.com/isaacph/nvim-config /home/devuser/.config/nvim
RUN sudo -H -u devuser INITNVIM=1 nvim --headless -c 'autocmd User PackerComplete quitall' --noplugin
RUN sudo -H -u devuser echo "cd ~" >> /home/devuser/.bashrc

# clone my dev repos
RUN sudo -H -u devuser git clone https://github.com/isaacph/osdev.git /home/devuser/osdev

USER devuser
ENV TERM xterm
CMD ["bash"]
