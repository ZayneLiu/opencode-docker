FROM debian:trixie

RUN apt update && apt install -y --no-install-recommends \
    zsh hx curl \
    ca-certificates \
    git unzip \
    && rm -rf /var/lib/apt/lists/*

# change default shell to zsh
RUN chsh -s /bin/zsh

WORKDIR /root

# install ohmyzsh without prompt
RUN rm -rf .oh-my-zsh && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

COPY .config/ /root/.config/

# isntall opencode
RUN curl -fsSL https://opencode.ai/install | bash
RUN echo "export PATH=/root/.local/bin:\$PATH" | tee -a .zshrc
RUN echo "export PATH=/root/.opencode/bin:\$PATH" | tee -a .zshrc

# install rtk
RUN curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh | sh
RUN zsh -c "source /root/.zshrc && rtk init --global --opencode"

RUN curl -fsSL https://fnm.vercel.app/install | bash

RUN zsh -c "source /root/.zshrc && fnm install --lts --use"
RUN zsh -c "source /root/.zshrc && npx skills@latest add mattpocock/skills --all"
# install find-skills
RUN zsh -c "source /root/.zshrc && npx skills@latest add vercel-labs/skills -y"

WORKDIR /root/workspace

# sleep infinity
CMD ["sleep", "infinity"]
