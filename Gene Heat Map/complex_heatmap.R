library(devtools)
library(ComplexHeatmap)
library(circlize)
library(RColorBrewer)
library(readxl)


###################################################################
#########               Heat Map Data Prep                ######### 
###################################################################

# Excel file is read and converted into tibble data form
# Selects on of the following files:
NCHIP_cleaned_coverage_data <- read_excel("Desktop/Coverage/final_pg1.xlsx")
#NCHIP_cleaned_coverage_data <- read_excel("Desktop/Coverage/final_pg2.xlsx")

# Tibble converted into dataframe (data frame can then be converted in matrix)
NCHIP_cleaned_coverage_data <- as.data.frame(NCHIP_cleaned_coverage_data)

# Removes first column, which contains row numbering and blocks complexheatmap from being drawn
rownames(NCHIP_cleaned_coverage_data) <- NCHIP_cleaned_coverage_data[, 1]
NCHIP_cleaned_coverage_data <- NCHIP_cleaned_coverage_data[, -1]

# Dataframes are spliced and defined into smaller variables
coverage_percentages <- data.matrix(NCHIP_cleaned_coverage_data[1:7])
target_size <- data.matrix(NCHIP_cleaned_coverage_data[8])
total_bp <- data.matrix(NCHIP_cleaned_coverage_data[9])
coverage <- data.matrix(NCHIP_cleaned_coverage_data[10])
cluster_group <- NCHIP_cleaned_coverage_data[11]

# Defines formatting for heatmap
ht_opt(
  legend_title_gp = gpar(fontsize = 8, fontface = "bold"), 
  legend_labels_gp = gpar(fontsize = 8), 
  heatmap_column_names_gp = gpar(fontsize = 8),
  heatmap_column_title_gp = gpar(fontsize = 10),
  heatmap_row_title_gp = gpar(fontsize = 8)
)



###################################################################
#########               Heat Map Parameters               ######### 
###################################################################

# 1st panel: Configures clustering (could be configured for ontologies)
left_annotation = rowAnnotation(df = cluster_group, col = list(cluster_group = c("Group 1" = "red", "Group 2" = "blue", "Group 3" = "green")), width = unit(1, "cm"))

# 2nd panel: Configures main heat map displaying percent coverage for each gene at 1x, 5x, 10x, 20x, 50x, 100x, and 200x
ht1 = Heatmap(coverage_percentages,
              row_split = cluster_group,
              name = "Coverage Percentage",
              col = colorRamp2(c(0, 25, 50, 75, 100), c("red2", "orange", "lightyellow", "lightskyblue1", "dodgerblue4")),
              rect_gp = gpar(col = "gray12", lty = 1, lwd = 0.2),
              cluster_columns = FALSE,
              cluster_rows = FALSE,
              width = unit(8, "cm")
              )

# 3rd panel: Configures bar plots displaying avg coverage data
ha2 = rowAnnotation(
  Coverage = anno_barplot( 
    coverage, ylim = c(0, 400),
    bar_width = 1, 
    gp = gpar(col = "white", fill = "#FFE200"), 
    border = TRUE,
    axis_param = list(
      side = "bottom",
      at = c(0, 100, 200, 300, 400),
      labels = c("0", "100", "200", "300", "400"),
      labels_rot = 45),
    width = unit(1.5, "cm")
  ), show_annotation_name = FALSE)

# 4th panel: Configures one column heat map displaying target size for each gene
ht2 = Heatmap(target_size, 
              name = "Target Size", 
              col = colorRamp2(c(0, 13000), c("white", "orange")), 
              width = unit(1, "cm"),
              rect_gp = gpar(col = "gray12", lty = 1, lwd = 0.2))

# 5th panel: Configures one column heat map displaying total bp for each gene
ht3 = Heatmap(total_bp, 
              name = "Total BP", 
              col = colorRamp2(c(0, 2100000), c("white", "black")), 
              width = unit(1, "cm"),
              rect_gp = gpar(col = "gray12", lty = 1, lwd = 0.2))



###################################################################
#########                 Drawing Heat Map                ######### 
###################################################################

# Sets up PDF parameters
pdf("heatmap_png.pdf", width = 8, height = 16)

# Creates a heat map in the User directory and adjusts gaps between rows and columns
draw(left_annotation + ht1 + ha2 + ht2 + ht3,
     ht_gap = unit(5, "mm"),
     row_gap = unit(5, "mm"),
     newpage = FALSE,
     #column_title = "Comprehensive correspondence between methylation, expression and other genomic features", 
     #column_title_gp = gpar(fontsize = 12, fontface = "bold"),
     heatmap_legend_side = "right")
dev.off()


