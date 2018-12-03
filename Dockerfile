FROM node:9

ENV CHROME_VERSION=67.0.3396.87-1
ENV ALLOWED_DOMAINS=www.uwai.com,uwai.com,www.uwai.io,uwai.io,www.app.uwai.com,app.uwai.com,www.app.uwai.io,app.uwai.io,zh.uwai.com,www.uwai.cn,example.com

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
  gnupg \
	--no-install-recommends \
	&& curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
	&& apt-get update && apt-get install -y \
	google-chrome-stable=$CHROME_VERSION \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

# Add Chrome as a user
RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome \
    && mkdir -p /home/chrome && chown -R chrome:chrome /home/chrome

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force
COPY . /usr/src/app

USER chrome

CMD [ "npm", "start" ]

EXPOSE 3000
