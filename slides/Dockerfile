FROM node

WORKDIR /app

RUN --mount=type=secret,id=gitlab_pullsecret PULLSECRET=$(cat /run/secrets/gitlab_pullsecret) \
 && git clone https://github.com/hakimel/reveal.js.git reveal \
 && git clone https://:${PULLSECRET}@gitlab.puzzle.ch/pitc_members/pitc-revealjs-theme.git puzzle-theme \
 && mv puzzle-theme/css/theme/puzzle.css reveal/css/theme/ \
 && mv puzzle-theme/css/theme/source/puzzle.scss reveal/css/theme/source/ \
 && mv puzzle-theme/css/theme/source/puzzle-imgs reveal/css/theme/source/ \
 && rm -rf puzzle-theme

WORKDIR reveal

COPY slides/ansible-techlab ./ansible-techlab
COPY slides/index.html.patch .

RUN patch --forward --strip=1 index.html --input=index.html.patch \
 && npm install && npm run build -- css-themes \
 && chown -R 1002150000:0 "/root/.npm"

# Ensure the files are part of the Root-Group
#RUN chgrp -R 0 ${APP_ROOT} && \
#    chmod -R g=u ${APP_ROOT}

EXPOSE 8000

CMD ["npm", "start", "--", "--host=0.0.0.0"]
