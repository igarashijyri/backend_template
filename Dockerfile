FROM ruby:3.1.2
ARG RUBYGEMS_VERSION=3.3.20

ARG WORKDIR

# パッケージを永続使用/一時的使用の2つの変数にまとめる
ARG RUNTIME_PACKAGES="bash imagemagick nodejs yarn tzdata mysql-dev mysql-client git less"
ARG DEV_PACKAGES="build-base curl-dev"

ENV HOME=/${WORKDIR}
WORKDIR ${HOME}

COPY Gemfile* ./docke

# ホストのファイル一式をコンテナにコピーする
COPY . ./

RUN gem update --system ${RUBYGEMS_VERSION} && \
    bundle install

# CMD実行前にentrypoint.shを通す
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]


CMD ["rails", "server", "-b", "0.0.0.0"]
