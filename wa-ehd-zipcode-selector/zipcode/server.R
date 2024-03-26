ehd_var = read.csv("data/EHD_var.csv")
ehd_wa=readRDS("data/ehd_wa_simp.rda")
wa_zcta = readRDS("data/wa_zcta_simp.rda")
#wa_zcta <- st_transform(wa_zcta_temp, crs = st_crs(ehd_wa))


server <- function(input, output, session) {
  output$map <- renderTmap({
    tm_shape(ehd_wa, bbox= st_bbox(result_select())) + tm_borders() +
      tm_shape(result_select())+tm_polygons(input$var2) +
      tm_facets(as.layers = TRUE)
  })
  
  result_select <- reactive({
    ehd_wa[ wa_zcta[wa_zcta$ZCTA5CE10 %in% input$var,],]
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("zip_ehd_", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(result_select() %>% 
                  select (-c(SHAPE_Length, SHAPE_Area)) %>%
                  st_drop_geometry(), file)
    })
  
  output$tbl = renderDT(
    result_select()%>% 
      select (-c(SHAPE_Length, SHAPE_Area)) %>%
      st_drop_geometry() , options = list(
        scrollX = TRUE,
        scrollY= "250px",
        lengthChange = FALSE,
        columnDefs = list(list(width = '10%', targets = c(2,3,4))))
  )
  
}

