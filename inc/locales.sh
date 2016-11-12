# locales taken from www/settings.py

# install locales listed in MAP_LANGUAGES in settings.py

for a in ar ast by es ca ce da de en es gr hr id it ja fr nl no pl pt ru sk tr uk ca_AD ar_AE en_AG es_AR de_AT en_AU nl_BE fr_BE de_BE ar_BH be_BY es_BO pt_BR en_BW en_CA fr_CA de_CH fr_CH it_CH el_GR es_CL es_CR de_DE da_DK en_DK es_DO ar_DZ es_EC ar_EG es_ES ca_ES ast_ES fr_FR ca_FR en_GB es_GT en_HK es_HN hr_HR id_ID en_IE en_IN ar_IQ it_IT ar_JO ar_KW ar_LB ja_JP fr_LU de_LU ar_LY ar_MA es_MX en_NG es_NI nl_NL nb_NO nn_NO en_NZ ar_OM es_PA es_PE en_PH pl_PL pt_PT es_PR es_PY ar_QA ru_RU ar_SA ar_SD en_SG es_SV ar_SY ar_TN en_US es_US uk_UA es_UY es_VE ar_YE en_ZA en_ZW tr_TR sk_SK
do
  echo $a
  locale-gen --no-purge --lang $a
done
