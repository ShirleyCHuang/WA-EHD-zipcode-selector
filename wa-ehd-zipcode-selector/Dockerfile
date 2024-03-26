FROM rocker/r-ubuntu


# system libraries of general use
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    pandoc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl3 \
    libgdal-dev \
    libproj-dev \
    libgeos-dev \
    libudunits2-dev \
    netcdf-bin \
    libharfbuzz-dev \ 
    libfribidi-dev \
    && rm -rf /var/lib/apt/lists/*

# basic shiny functionality
RUN R -e "install.packages(c('shiny', 'rmarkdown'), dependencies = TRUE, repos='https://cloud.r-project.org/')"

# install dependencies of the superzip app
RUN R -e "install.packages(c('shiny', 'bslib', 'tmap', 'dplyr', 'DT', 'sf', 'rsconnect', 'sass', 'htmltools'), repos='https://cloud.r-project.org/')"

# copy the app to the image
RUN mkdir /root/wa-ehd-zipcode-selector
COPY wa-ehd-zipcode-selector /root/wa-ehd-zipcode-selector

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e shiny::runApp('/root/wa-ehd-zipcode-selector')"]
