use elasticsearch_dsl::*;

fn main() {
    corp_query("小米科技");
}


fn corp_query(corp_name: &str) {
    let search = Search::new()
        .source(["name", "name_st", "name_max_word_ik", "credit_no", "reg_cap", "reg_cap_type", "reg_cat_desc"])
        .from(0)
        .size(10)
        .sort(FieldSort::ascending("_score"))
        .track_total_hits(true)
        // .highlight(Highlight::new().field().)
        .query(
            Query::bool()
                .must([Query::bool().should([
                    Query::match_phrase("name_max_word_ik", corp_name).boost(1.2).slop(20),
                    Query::match_phrase("name_st", corp_name).boost(0.8).slop(20),
                    Query::match_phrase("name", corp_name).boost(2).slop(20)
                ])])
                .must_not(Query::term("deprecated", "D"))
                .boost(1),
        )
        .rescore([
            Rescore::new(Query::function_score()
                .function(Function::script(Script::source("doc['reg_cap'.empty ? 0 : Math.log10(doc['reg_cap'].value + 2)]")))
                .query(Query::match_all())
                .score_mode(FunctionScoreMode::Multiply)
            ).score_mode(ScoreMode::Multiply).window_size(1000),
            Rescore::new(Query::function_score()
                .function(Function::random_score().seed("asdfasdf"))
                .query(Query::match_all())
                .score_mode(FunctionScoreMode::Multiply)
            ).score_mode(ScoreMode::Multiply).window_size(1000),
            Rescore::new(Query::function_score()
                .function(Function::script(Script::source("doc['score'.empty ? 0 : Math.log10(doc['score'].value + 2)]")))
                .query(Query::match_all()).score_mode(FunctionScoreMode::Multiply)
            ).score_mode(ScoreMode::Multiply).window_size(1000),
            Rescore::new(Query::bool().must(Query::term("business_status_code", "1")))
                .query_weight(1)
                .rescore_query_weight(10)
                .score_mode(ScoreMode::Total)
                .window_size(1000),
            Rescore::new(Query::bool().must(Query::term("executives", corp_name)))
                .query_weight(1)
                .rescore_query_weight(1)
                .score_mode(ScoreMode::Total)
                .window_size(1000),
            Rescore::new(Query::bool().must(Query::term("oper_name", corp_name)))
                .query_weight(1)
                .rescore_query_weight(1.5)
                .score_mode(ScoreMode::Total)
                .window_size(1000),
        ]);

    println!("{}", serde_json::to_string_pretty(&search).unwrap());
}


fn corp_query2(corp_name: &str) {
    let search = Search::new()
        .source(["name", "name_st", "name_max_word_ik", "credit_no", "reg_cap", "reg_cap_type", "reg_cat_desc"])
        .from(0)
        .size(10)
        .sort(FieldSort::ascending("_score"))
        .track_total_hits(true)
        // .highlight(Highlight::new().field().)
        .query(
            Query::r#match("name_max_word_ik", corp_name).boost(1.2).fuzziness(Fuzziness::Distance(5))
                .minimum_should_match("85%").zero_terms_query(ZeroTermsQuery::None).prefix_length(10)
                .auto_generate_synonyms_phrase_query(false)
        );

    println!("{}", serde_json::to_string_pretty(&search).unwrap());
}