library(ggplot2)
library(dplyr)
library(tidyr)
library(readxl)
library(caret)
library(scales)
library(openxlsx)

足球数据统计A <- read_excel("足球数据统计A.xlsx", sheet = 2)

足球数据统计A <- 足球数据统计A[, !(names(足球数据统计A) %in% "Tipstrike")]
足球数据统计A <- na.omit(足球数据统计A)

num_cols <- c("主队XG","客队XG","主队xGA","客队xGA",
              "主队进球","客队进球","主队丢球","客队丢球",
              "主队身价","客队身价")

for(col in num_cols){
  足球数据统计A[[col]] <- as.numeric(as.character(足球数据统计A[[col]]))}

# name

colnames(足球数据统计A)[colnames(足球数据统计A) == "DeepSeek（中文，普通）"] <- "DeepSeek_C_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "DeepSeek（中文，专业）"] <- "DeepSeek_C_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "DeepSeek（英文，普通）"] <- "DeepSeek_E_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "DeepSeek（英文，专业）"] <- "DeepSeek_E_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "豆包（中文，普通）"] <- "Doubao_C_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "豆包（中文，专业）"] <- "Doubao_C_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "豆包（英文，普通）"] <- "Doubao_E_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "豆包（英文，专业）"] <- "Doubao_E_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "混元（中文，普通）"] <- "Hunyuan_C_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "混元（中文，专业）"] <- "Hunyuan_C_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "混元（英文，普通）"] <- "Hunyuan_E_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "混元（英文，专业）"] <- "Hunyuan_E_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Qwen（中文，普通）"] <- "Qwen_C_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Qwen（中文，专业）"] <- "Qwen_C_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Qwen（英文，普通）"] <- "Qwen_E_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Qwen（英文，专业）"] <- "Qwen_E_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Claude（中文，普通）"] <- "Claude_C_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Claude（中文，专业）"] <- "Claude_C_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Claude（英文，普通）"] <- "Claude_E_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Claude（英文，专业）"] <- "Claude_E_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "GPT（中文，普通）"] <- "GPT_C_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "GPT（中文，专业）"] <- "GPT_C_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "GPT（英文，普通）"] <- "GPT_E_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "GPT（英文，专业）"] <- "GPT_E_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Grok（中文，普通）"] <- "Grok_C_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Grok（中文，专业）"] <- "Grok_C_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Grok（英文，普通）"] <- "Grok_E_Bsc"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Grok（英文，专业）"] <- "Grok_E_Pro"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Bet365"] <- "Bet365"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Forebet"] <- "Forebet"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Theyscored"] <- "Theyscored"
colnames(足球数据统计A)[colnames(足球数据统计A) == "Avg_WDL"] <- "Avg"

actual_label <- ifelse(
  足球数据统计A$真实结果 > 0, "win",
  ifelse(足球数据统计A$真实结果 < 0, "loss", "draw"))

predict_cols <- c(
  "DeepSeek_C_Bsc","DeepSeek_C_Pro","DeepSeek_E_Bsc","DeepSeek_E_Pro",
  "Doubao_C_Bsc","Doubao_C_Pro","Doubao_E_Bsc","Doubao_E_Pro",
  "Hunyuan_C_Bsc","Hunyuan_C_Pro","Hunyuan_E_Bsc","Hunyuan_E_Pro",
  "Qwen_C_Bsc","Qwen_C_Pro","Qwen_E_Bsc","Qwen_E_Pro",
  "Claude_C_Bsc","Claude_C_Pro","Claude_E_Bsc","Claude_E_Pro",
  "GPT_C_Bsc","GPT_C_Pro","GPT_E_Bsc","GPT_E_Pro",
  "Grok_C_Bsc","Grok_C_Pro","Grok_E_Bsc","Grok_E_Pro",
  "Theyscored","Forebet","Bet365","Avg")

pred_label <- lapply(predict_cols, function(col){
  ifelse(足球数据统计A[[col]] > 0, "win",
         ifelse(足球数据统计A[[col]] < 0, "loss", "draw"))})

names(pred_label) <- predict_cols

calc_metrics <- function(pred, actual, target_class){
  pred <- factor(pred, levels = c("win","draw","loss"))
  actual <- factor(actual, levels = c("win","draw","loss"))
  TP <- sum(pred == target_class & actual == target_class)
  FP <- sum(pred == target_class & actual != target_class)
  FN <- sum(pred != target_class & actual == target_class)
  precision <- ifelse(TP + FP == 0, 0, TP / (TP + FP))
  recall    <- ifelse(TP + FN == 0, 0, TP / (TP + FN))
  f1 <- ifelse((precision + recall) == 0,
  0, 2 * precision * recall / (precision + recall))
  return(c(precision, recall, f1))}

metrics_list <- lapply(predict_cols, function(m){
  p <- pred_label[[m]]
  win  <- calc_metrics(p, actual_label, "win")
  draw <- calc_metrics(p, actual_label, "draw")
  loss <- calc_metrics(p, actual_label, "loss")
  data.frame(Model = m, F1_win = win[3],
    F1_draw = draw[3], F1_loss = loss[3])})

metrics_df <- do.call(rbind, metrics_list)

benchmark_models <- c("Theyscored","Forebet","Bet365","Avg")

metrics_df$Group <- ifelse(
  metrics_df$Model %in% benchmark_models,
  "Benchmark", "LLM")

llm_models <- setdiff(metrics_df$Model, benchmark_models)

metrics_df$Model <- factor(metrics_df$Model,
  levels = c(llm_models, benchmark_models))

# colors
my_colors <- c(
  "DeepSeek_C_Bsc" = "#FFB6B6", "DeepSeek_C_Pro" = "#FF0000",
  "DeepSeek_E_Bsc" = "#ADD8E6", "DeepSeek_E_Pro" = "#0000FF",
  
  "Doubao_C_Bsc" = "#FFB6B6", "Doubao_C_Pro" = "#FF0000",
  "Doubao_E_Bsc" = "#ADD8E6", "Doubao_E_Pro" = "#0000FF",
  
  "Hunyuan_C_Bsc" = "#FFB6B6", "Hunyuan_C_Pro" = "#FF0000",
  "Hunyuan_E_Bsc" = "#ADD8E6", "Hunyuan_E_Pro" = "#0000FF",
  
  "Qwen_C_Bsc" = "#FFB6B6", "Qwen_C_Pro" = "#FF0000",
  "Qwen_E_Bsc" = "#ADD8E6", "Qwen_E_Pro" = "#0000FF",
  
  "Claude_C_Bsc" = "#FFB6B6", "Claude_C_Pro" = "#FF0000",
  "Claude_E_Bsc" = "#ADD8E6", "Claude_E_Pro" = "#0000FF",
  
  "GPT_C_Bsc" = "#FFB6B6", "GPT_C_Pro" = "#FF0000",
  "GPT_E_Bsc" = "#ADD8E6", "GPT_E_Pro" = "#0000FF",
  
  "Grok_C_Bsc" = "#FFB6B6", "Grok_C_Pro" = "#FF0000",
  "Grok_E_Bsc" = "#ADD8E6", "Grok_E_Pro" = "#0000FF",
  
  "Theyscored" = "orange", "Forebet" = "orange", 
  "Bet365" = "orange", "Avg" = "orange")

# precision

calc_precision <- function(pred, actual, target_class){
  pred <- factor(pred, levels = c("win","draw","loss"))
  actual <- factor(actual, levels = c("win","draw","loss"))
  TP <- sum(pred == target_class & actual == target_class)
  FP <- sum(pred == target_class & actual != target_class)
  precision <- ifelse(TP + FP == 0, 0, TP / (TP + FP))
  return(precision)}

precision_list <- lapply(predict_cols, function(m){
  p <- pred_label[[m]]
  win  <- calc_precision(p, actual_label, "win")
  draw <- calc_precision(p, actual_label, "draw")
  loss <- calc_precision(p, actual_label, "loss")
  data.frame(Model = m, Prec_win = win,
             Prec_draw = draw, Prec_loss = loss)})

precision_df <- do.call(rbind, precision_list)

benchmark_models <- c("Theyscored","Forebet","Bet365","Avg")
precision_df$Group <- ifelse(precision_df$Model %in% benchmark_models, "Benchmark", "LLM")
llm_models <- setdiff(precision_df$Model, benchmark_models)
precision_df$Model <- factor(precision_df$Model, levels = c(llm_models, benchmark_models))

ggplot(precision_df, aes(x = Model, y = Prec_win * 100, fill = Model)) + geom_col() +
  geom_text(aes(label = round(Prec_win * 100, 2)), vjust = -0.3, size = 3) +
  scale_fill_manual(values = my_colors) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) +
  theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none") +
  coord_cartesian(ylim = c(50, 65)) +
  labs(x = "", y = "Precision Win (%)")

ggplot(precision_df, aes(x = Model, y = Prec_draw * 100, fill = Model)) + geom_col() +
  geom_text(aes(label = round(Prec_draw * 100, 2)), vjust = -0.3, size = 3) +
  scale_fill_manual(values = my_colors) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) + theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none") +
  coord_cartesian(ylim = c(0, 45)) +
  labs(x = "", y = "Precision Draw (%)")

ggplot(precision_df, aes(x = Model, y = Prec_loss * 100, fill = Model)) + geom_col() +
  geom_text(aes(label = round(Prec_loss * 100, 2)), vjust = -0.3, size = 3) +
  scale_fill_manual(values = my_colors) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) + theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none") +
  coord_cartesian(ylim = c(43, 58)) +
  labs(x = "", y = "Precision Loss  (%)")

write.xlsx(
  precision_df,
  file = "precision_df.xlsx",
  rowNames = FALSE)

# recall

calc_recall <- function(pred, actual, target_class){
  pred <- factor(pred, levels = c("win","draw","loss"))
  actual <- factor(actual, levels = c("win","draw","loss"))
  TP <- sum(pred == target_class & actual == target_class)
  FN <- sum(pred != target_class & actual == target_class)
  recall <- ifelse(TP + FN == 0, 0, TP / (TP + FN))
  return(recall)}

recall_list <- lapply(predict_cols, function(m){
  p <- pred_label[[m]]
  win  <- calc_recall(p, actual_label, "win")
  draw <- calc_recall(p, actual_label, "draw")
  loss <- calc_recall(p, actual_label, "loss")
  data.frame(Model = m, Rec_win = win,
             Rec_draw = draw, Rec_loss = loss)})

recall_df <- do.call(rbind, recall_list)

benchmark_models <- c("Theyscored","Forebet","Bet365","Avg")
recall_df$Group <- ifelse(recall_df$Model %in% benchmark_models, "Benchmark", "LLM")
llm_models <- setdiff(recall_df$Model, benchmark_models)
recall_df$Model <- factor(recall_df$Model, levels = c(llm_models, benchmark_models))

ggplot(recall_df, aes(x = Model, y = Rec_win * 100, fill = Model)) + geom_col() +
  geom_text(aes(label = round(Rec_win * 100, 2)), vjust = -0.3, size = 3) +
  scale_fill_manual(values = my_colors) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) + theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none") +
  coord_cartesian(ylim = c(37, 83)) +
  labs(x = "", y = "Recall Win (%)")

ggplot(recall_df, aes(x = Model, y = Rec_draw * 100, fill = Model)) + geom_col() +
  geom_text(aes(label = round(Rec_draw * 100, 2)), vjust = -0.3, size = 3) +
  scale_fill_manual(values = my_colors) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) + theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none") +
  coord_cartesian(ylim = c(0, 47)) +
  labs(x = "", y = "Recall Draw (%)")

ggplot(recall_df, aes(x = Model, y = Rec_loss * 100, fill = Model)) + geom_col() +
  geom_text(aes(label = round(Rec_loss * 100, 2)), vjust = -0.3, size = 3) +
  scale_fill_manual(values = my_colors) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) + theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none") +
  coord_cartesian(ylim = c(31, 68)) +
  labs(x = "", y = "Recall Loss (%)")

write.xlsx(
  recall_df,
  file = "recall_df.xlsx",
  rowNames = FALSE)

# F1

ggplot(metrics_df, aes(x = Model, y = F1_win, fill = Model)) +
  geom_col() + geom_text(aes(label = round(F1_win,3)), 
                         vjust = -0.3, size = 3) + scale_fill_manual(values = my_colors) +
  theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust = 1),
                     legend.position = "none") + coord_cartesian(ylim = c(0.45,0.65)) +
  labs(x = "", y = "F1 Win")

ggplot(metrics_df, aes(x = Model, y = F1_draw, fill = Model)) +
  geom_col() + geom_text(aes(label = round(F1_draw,3)), 
                         vjust = -0.3, size = 3) + scale_fill_manual(values = my_colors) +
  theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust = 1),
                     legend.position = "none") + coord_cartesian(ylim = c(0.15,0.35)) +
  labs(x = "", y = "F1 Draw")

ggplot(metrics_df, aes(x = Model, y = F1_loss, fill = Model)) +
  geom_col() + geom_text(aes(label = round(F1_loss,3)), 
                         vjust = -0.3, size = 3) + scale_fill_manual(values = my_colors) +
  theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust = 1),
                     legend.position = "none") + coord_cartesian(ylim = c(0.4,0.55)) +
  labs(x = "", y = "F1 Loss")

f1_export <- metrics_df %>%
  mutate(
    F1_win  = round(F1_win, 4),
    F1_draw = round(F1_draw, 4),
    F1_loss = round(F1_loss, 4))

write.xlsx(
  metrics_df,
  file = "metrics_df.xlsx",
  rowNames = FALSE)

# Accuracy

accuracy_list <- lapply(predict_cols, function(m){
  p <- pred_label[[m]]
  overall_acc <- sum(p == actual_label) / length(actual_label)
  data.frame(Model = m, Acc_overall = overall_acc)})

accuracy_df <- do.call(rbind, accuracy_list)

benchmark_models <- c("Theyscored","Forebet","Bet365","Avg")
llm_models <- setdiff(accuracy_df$Model, benchmark_models)
accuracy_df$Model <- factor(accuracy_df$Model, levels = c(llm_models, benchmark_models))

ggplot(accuracy_df, aes(x = Model, y = Acc_overall * 100, fill = Model)) +
  geom_col(width = 0.8) + geom_text(
    aes(label = round(Acc_overall * 100, 2)), vjust = -0.3, size = 3) + 
  scale_fill_manual(values = my_colors) + scale_y_continuous(
    labels = function(x) paste0(round(x, 1), "%")
  ) + coord_cartesian(ylim = c(39, 54)) + theme_bw() + theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    axis.title.x = element_text(size = 11),
    axis.title.y = element_text(size = 11),
    legend.position = "none",
    panel.grid.minor = element_blank()) +
  labs(x = "", y = "Accuracy (%)")

write.xlsx(
  accuracy_df,
  file = "accuracy_df.xlsx",
  rowNames = FALSE)

p <- ggplot(
  accuracy_df,
  aes(x = Model, y = Acc_overall * 100, fill = Model)
) +
  geom_col(width = 0.8) +
  geom_text(
    aes(label = round(Acc_overall * 100, 2)),
    vjust = -0.3,
    size = 3,
    family = "Times New Roman"
  ) +
  scale_fill_manual(values = my_colors) +
  scale_y_continuous(
    labels = function(x) paste0(round(x, 1), "%")
  ) +
  coord_cartesian(ylim = c(39, 54)) +
  theme_bw() +
  theme(
    # 全局字体：Times New Roman，字号 10
    text = element_text(
      family = "Times New Roman",
      size = 10
    ),
    
    # 横坐标
    axis.text.x = element_text(
      angle = 45,
      hjust = 1,
      size = 10,
      family = "Times New Roman"
    ),
    
    # 纵坐标刻度
    axis.text.y = element_text(
      size = 10,
      family = "Times New Roman"
    ),
    
    # 坐标轴标题
    axis.title.x = element_text(
      size = 10,
      family = "Times New Roman"
    ),
    axis.title.y = element_text(
      size = 10,
      family = "Times New Roman"
    ),
    
    # 去掉图例和所有网格线
    legend.position = "none",
    panel.grid = element_blank()
  ) +
  labs(
    x = "",
    y = "Accuracy (%)"
  )

# 导出 PDF
ggsave(
  "Fig_Accuracy.pdf",
  plot = p,
  width = 10,
  height = 6,
  device = cairo_pdf
)