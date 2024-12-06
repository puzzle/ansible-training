FROM node

ENV NPM_CONFIG_CACHE=/tmp/.npm

WORKDIR /app

RUN git clone https://github.com/hakimel/reveal.js.git reveal

WORKDIR reveal

COPY slides/ansible-techlab ./ansible-techlab
COPY slides/index.html.patch .

RUN patch --forward --strip=1 index.html --input=index.html.patch \
  && npm install

RUN chgrp -R 0 ${NPM_CONFIG_CACHE} \
 && chmod -R g=u ${NPM_CONFIG_CACHE}

EXPOSE 8000
CMD ["npm", "start", "--", "--host=0.0.0.0"]
