FROM fstlx/qt5:ubuntu18

RUN apt update
RUN apt-get install diffutils -y
RUN apt-get install zsh -y

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
