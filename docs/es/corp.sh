

curl -XPUT -H 'Content-Type: application/json; charset=UTF-8' -H "Authorization: ${BASIC_AUTH}" "${ES_SERVER_URL}/${INDEX_NAME_PREFIX}corp_v${DATE}" -d '
{
  "mappings": {
    "dynamic": false,
    "properties": {
      "name": {
        "type": "keyword"
      },
      "name_st": {
        "type": "text",
        "analyzer": "standard"
      },
      "name_smart_ik": {
        "type": "text",
        "analyzer": "ik_smart_ts"
      },
      "name_max_word_ik": {
        "type": "text",
        "analyzer": "ik_max_word_ts",
        "search_analyzer": "ik_smart_ts"
      },
      "credit_no": {
        "type": "keyword"
      },
      "credit_no_ik": {
        "type": "text",
        "analyzer": "ik_max_word_ts",
        "search_analyzer": "ik_smart_ts"
      },
      "org_no": {
        "type": "keyword"
      },
      "org_no_ik": {
        "type": "text",
        "analyzer": "ik_max_word_ts",
        "search_analyzer": "ik_smart_ts"
      },
      "oper_name": {
        "type": "keyword"
      },
      "oper_name_id": {
        "type": "keyword"
      }
    }
  },
  "settings": {
    "index": {
      "max_result_window": 30000,
      "indexing.slowlog.level": "info",
      "indexing.slowlog.threshold.index.debug": "1s",
      "indexing.slowlog.threshold.index.info": "5s",
      "indexing.slowlog.threshold.index.warn": "30s",
      "indexing.slowlog.threshold.index.error": "1m",
      "indexing.slowlog.threshold.index.trace": "250ms",
      "search.slowlog.level": "info",
      "search.slowlog.threshold.query.debug": "1s",
      "search.slowlog.threshold.query.info": "5s",
      "search.slowlog.threshold.query.warn": "30s",
      "search.slowlog.threshold.query.error": "1m",
      "search.slowlog.threshold.query.trace": "250ms",
      "routing.rebalance.enable": "replicas",
      "refresh_interval": "120s",
      "number_of_shards": 21,
      "number_of_replicas": "'${REPLICAS}'",
      "analysis": {
        "char_filter": {
          "punctuation_filter": {
            "type": "mapping",
            "mappings": [
              ",=> ;",
              ".=> ;",
              "[=> ;",
              "]=> ;",
              "{=> ;",
              "}=> ;",
              "(=> ;",
              ")=> ;",
              "!=> ;",
              ":=> ;",
              "：=> ;",
              "@=> ;",
              "#=> ;",
              "$=> ;",
              "%=> ;",
              "^=> ;",
              "&=> ;",
              "*=> ;",
              "-=> ;",
              "\"=> ;",
              "===> ;",
              "+==> ;",
              "/==> ;",
              "\\\\=> ;",
              "_=> ;",
              "。=> ;",
              "，=> ;",
              "；=> ;",
              "*=> ;",
              "！=> ;",
              "？=> ;",
              "“=> ;",
              "”=> ;",
              "‘=> ;",
              "’=> ;",
              "【=> ;",
              "】=> ;",
              "《=> ;",
              "》=> ;",
              "（=> ;",
              "）=> ;",
              "、=> ;",
              "：=> ;",
              "；=> ;",
              "——=> ;",
              "……=> ;",
              "¥=> ;",
              "·=> ;",
            ]
          },
          "tsconvert": {
            "type": "stconvert",
            "convert_type": "t2s"
          }
        },
        "analyzer": {
          "ik_smart_ts": {
            "char_filter": "tsconvert",
            "tokenizer": "ik_smart"
          },
          "ik_max_word_ts": {
            "type": "tsconvert",
            "tokenizer": "ik_max_word",
            "filter": [
              "ts_filter"
            ]
          },
          "space": {
            "filter": [
              "lowercase",
              "word_delimiter",
              "unique"
            ],
            "char_filter": [
              "punctuation_filter"
            ],
            "type": "custom",
            "tokenizer": "whitespace"
          }
        }
      }
    }
  },
  "aliases": {
    "corp": {}
  }
}
'