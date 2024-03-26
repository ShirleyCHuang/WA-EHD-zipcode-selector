library(shiny)
library(bslib)
library(tmap)
library(dplyr)
library(DT)
library(sf)
library(rsconnect)
library(sass)
library(htmltools)



rsconnect::setAccountInfo(name='shirley-c-huang',
                          token='7BED19123D3F7DEE937463DA35D067A3',
                          secret='dqXQ2CjwfyUbtcktIVIwd0h5o94YadHoct5AHN5p')

# Setup -------------------------------------------------------------------
ehd_var = read.csv("data/EHD_var.csv")
ehd_wa=readRDS("data/ehd_wa_simp.rda")
wa_zcta = readRDS("data/wa_zcta_simp.rda")
#wa_zcta <- st_transform(wa_zcta_temp, crs = st_crs(ehd_wa))


#bs_theme_preview(light)
#Add bootswatch = "bootstrap" to allow correct themeing on the shinyapp.io server.
#
theme_uw <- bs_theme(
  version = 5,  
  bootswatch = "bootstrap",
  bg = "#FFFFFF",
  fg = "#4B2E83",
  primary = "#E8E3D3",
  secondary = "#4B2E83",
  success = "#38FF12",
  info = "#00F5FB",
  warning = "#FFF100",
  danger = "#FF00E3",
  base_font   = font_google("Open Sans"),
  heading_font = font_google("Open Sans"))


ui <-
  page_sidebar(
    title = "Washington State Environmental Health Disparities Map Zipcode Selector",
    titlePanel("") ,
    theme = theme_uw,
    sidebar = sidebar(
      h1('The Washington State Environmental Health Disparities (WA EHD) Map Zipcode Selector tool allows you to pinpoint the census tract(s) that intersect your desired zipcode area and to download the relevant EHD data.'),
      h1('Simply selecting one or more zipcodes and EHD variables, the Zipcode Selector will then generate a color-coded map displaying the selected EHD variables as layers over the census tracts that intersect with the specified zipcode area.'),
      width=500,
      h1("\n"),
      h1("\n"),
      selectInput('var', 'Please select or type in one or more zipcodes:',
                  choices = wa_zcta$ZCTA5CE10,
                  selected = "98195", multiple = TRUE),
      h1("\n"),
      selectInput('var2', '...and select one or more EHD outcomes:',
                  choices = ehd_var$csv_label,
                  selected = ehd_var$csv_label[1], multiple = TRUE),
      h1("\n"),
      p('Use the ', strong('toggle layer button'), ' on the map to view different selected EHD outcomes.'),
      h1("\n"),
      h1("\n"),
      downloadButton("downloadData", "Download EHD data for the selected tracts"),
      tags$a("Click here to download the EHD metadata", href="EHD_var.pdf"),
      h1("\n"),
      h1("\n"),
      h1("\n"),
      h1("\n"),
      h1("\n"),
      h1("\n"),
      h1("\n"),
      h2("Please visit the official WA EHD website for detailed data methodology and description."),
      tags$a(href="https://doh.wa.gov/data-and-statistical-reports/washington-tracking-network-wtn/washington-environmental-health-disparities-map", "WA EHD website"),
      img(src="CTR ENV Health Equity_UW.png",height="72%", width="120%", align="right"),
      div(tags$script(src = "https://cdn.tailwindcss.com"))
    ),
    layout_columns(
      card(
        full_screen = TRUE,
        card_header("Map (hover mouse over to see census tract ID)"),
        tmapOutput('map')
      )
    ),
    layout_columns(
      card(
        full_screen = TRUE,
        card_header("EHD data of the selected tracts (scroll horizontally to view more columns)"),
        DTOutput('tbl')
      )
    )
  )
