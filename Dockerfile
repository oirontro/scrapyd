FROM python:3.7

ENV TZ="Asia/Shanghai"

RUN sed -i "s@deb.debian.org@mirrors.aliyun.com@g" /etc/apt/sources.list \
    && sed -i "s@security.debian.org@mirrors.aliyun.com@g" /etc/apt/sources.list \
    && cat /etc/apt/sources.list \
    && mkdir ~/.pip \
    && bash -c 'echo -e "[global]\nindex-url = https://pypi.douban.com/simple/\n" > ~/.pip/pip.conf' \
    && cat ~/.pip/pip.conf

COPY requirements.txt /tmp/requirements.txt

RUN pip3 install --default-timeout=1000 --no-cache-dir -r /tmp/requirements.txt

COPY scrapyd.conf /etc/scrapyd/conf.d/scrapyd1.conf
COPY run.sh /usr/bin/run.sh

RUN mkdir -p /app

COPY scrapy.cfg /app/scrapy.cfg

EXPOSE 6800
WORKDIR /app

CMD ["run.sh"]
