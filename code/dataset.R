################################################################################
# CREATES DATASETS FROM RAW DATA
# called by main.R
################################################################################

setwd(path_raw)

# Patent Data
patent <- read_dta('patent_raw.dta')

# Remove irrelevant variables
patent <- patent %>%
  select(-age, -gender, -edu, -minority, -govrevenueg_cls, -govrevenueg_cls_nosd, -govrevenueg_rank)

# Add city names based on city codes from another dataset
patent <- patent %>%
  mutate(citycode = as.character(citycode)) %>%
  left_join(
    read_excel("China_city_codes.xlsx") %>%
      mutate(city_code = as.character(city_code)),
    by = c("citycode" = "city_code")
  ) %>% 
  mutate(citycode = as.numeric(citycode)) %>% 
  select(-province_code)

# Add a dummy variable indicating treatment status
patent <- patent %>% mutate(treated = ifelse(city_name %in% 
                          c("Lincang", "Tacheng", "Xining", 
                            "Chengdu", "Chongqing", "Bijie", 
                            "Liuzhou", "Wuhai", "Hohhot", "Jinzhong",
                            "Zhengzhou", "Wuhan", "Xiangtan", "Jian",
                            "Nanchang", "Guangzhou", "Shenzhen", "Beijing", 
                            "Langfang", "Tianjin", "Jinan", "Qingdao", 
                            "Hefei", "Wuhu", "Nanjing", "Nantong", 
                            "Jiaxing", "Ningbo", "Wenzhou", "Fuzhou", 
                            "Daqing", "Shuangyashan", "Benxi"), 1, 0))
# Add a dummy variable indicating pre/post - year of treatment
patent <- patent %>% mutate(post = ifelse(year >= 2005, 1, 0))

# Add a variable indicating the year an observation is treated, 0 if never treated
patent <- patent %>% mutate(treated_year = ifelse(treated ==1, 2005, 2010))


# Final file
write.csv(patent, file = paste0(path_trans, '/patent_data.csv'), sep = ',', na = '', row.names = FALSE)
