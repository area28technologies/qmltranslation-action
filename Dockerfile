FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y diffutils \
zsh \
qttools5-dev-tools

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]