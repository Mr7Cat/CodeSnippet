


# 中国用户可以用中科大源替换默认的 Debian 10 源，加速软件包安装过程
RUN echo "deb http://mirrors.ustc.edu.cn/debian/ buster main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/debian/ buster-backports main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list





# 中国用户可以用中科大源替换默认的 Debian 9 源，加速软件包安装过程
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb http://mirrors.ustc.edu.cn/debian/ buster main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/debian/ buster-backports main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list


