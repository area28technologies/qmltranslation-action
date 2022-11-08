FROM fstlx/qt5:ubuntu18

RUN apt update
RUN apt-get install -y diffutils \
    zsh \
    qttools5-dev-tools \
    qt5-default

COPY qt.sh /usr/local/bin/qt
RUN chmod +x /usr/local/bin/qt

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
