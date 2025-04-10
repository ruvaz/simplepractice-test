FROM ruby:3.2

# Install dependencies for Chrome
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    curl \
    unzip \
    xvfb \
    libxi6 \
    libnss3 \
    libgdk-pixbuf2.0-0 \
    libgtk-3-0 \
    libxss1 \
    libasound2 \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    fonts-freefont-ttf \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install specific version of Google Chrome for stability
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Configure working directory
WORKDIR /app

# Copy only Gemfile and Gemfile.lock first to leverage Docker cache
COPY Gemfile Gemfile.lock ./

# Install gems with explicit bundler version
RUN gem install bundler -v 2.4.22 && \
    bundle config set --local without development test && \
    bundle install --jobs 4 --retry 3

# Copy source code
COPY . .

# Add healthcheck to verify Chrome installation
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD google-chrome --version || exit 1

# Command to run tests
CMD ["bundle", "exec", "rspec"]