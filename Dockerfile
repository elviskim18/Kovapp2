FROM ruby:2.7.3
RUN apt-get update -qq \
&& apt-get install -y nodejs postgresql-client
# YARN repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Convention to use update and install on same line to actually install new packages
# We also use the line separation to make this easier to change
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  yarn \
  wkhtmltopdf

COPY Gemfile* /usr/src/app/
# COPY package.json /usr/src/app/

WORKDIR /usr/src/app
RUN bundle install
RUN yarn install
COPY yarn.lock /usr/src/app/
COPY . /usr/src/app/

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
