FROM node

RUN --mount=type=secret,id=gitlab_token PULLSECRET=$(cat /run/secrets/gitlab_token)

WORKDIR /app

RUN git clone https://github.com/hakimel/reveal.js.git reveal \
 && git clone https://${PULLSECRET}@gitlab.puzzle.ch/jinfanger/pitc-revealjs-theme.git puzzle-theme \
 && mv puzzle-theme/css/theme/puzzle.css reveal/css/theme/ \
 && mv puzzle-theme/css/theme/source/puzzle.scss reveal/css/theme/source/ \
 && mv puzzle-theme/css/theme/source/puzzle-imgs reveal/css/theme/source/ \
 && rm -rf puzzle-theme

WORKDIR reveal

COPY slides/ansible-techlab ./ansible-techlab
COPY slides/index.html.patch .

RUN patch --forward --strip=1 --input=index.html.patch \
 && npm install && npm run build -- css-themes

EXPOSE 8000

CMD ["npm", "start"]
