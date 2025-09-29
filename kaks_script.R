library(tidyr)
library(dplyr)

# Read the CSV, don't set row.names
df <- read.csv("matrix.csv", header = TRUE, check.names = FALSE, stringsAsFactors = FALSE)

# Rename first column as Gene1
colnames(df)[1] <- "Gene1"

# Convert everything except Gene1 to character (to avoid mix issues)
df[,-1] <- lapply(df[,-1], as.character)

# Pivot longer
long_df <- df %>%
  pivot_longer(-Gene1, names_to = "Gene2", values_to = "Value")

# Remove missing / empty / "?" values
long_df <- long_df %>% filter(Value != "", Value != "?", !is.na(Value))

# Convert Value column back to numeric
long_df$Value <- as.numeric(long_df$Value)

# Keep only lower triangle (unique pairs)
result <- long_df %>%
  rowwise() %>%
  filter(match(Gene2, colnames(df)[-1]) < match(Gene1, df$Gene1)) %>%
  ungroup()

# Save
write.csv(result, "pairwise_list_2.csv", row.names = FALSE)

print(result)
